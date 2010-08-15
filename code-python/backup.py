#!/bin/env python

# backup.py - Brian Munroe <brian.e.munroe@gmail.com>
# last modified: 2010-04-01
#
# This script, which runs in jython (2.5.1), copies a
# given folder (in this case c:\mpn) into c:\backups\01,02,03, etc
# depending upon what day of the month it is.
#
# The c:\backups folder is a Mozy online backup monitored folder, 
# which is regularly backed up to cloud storage.

import time
import os
import os.path
import logging
import shutil
import zlib

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

DEBUG = False

# NOTE: If BACKUP_ROOT changes, be sure to update
# the 'slashify' list index, otherwise the CRC file
# namespace will be messed up.
BACKUP_ROOT="c:\\backups\\MPN"
MPN_FOLDER="c:\\mpn"
LOG_FILENAME = os.path.join(BACKUP_ROOT,"backup.log")
recipients = ""
smtp_server = "smarthost.coxmail.com"

if (DEBUG):
	recipients = ""
	smtp_server = "smarthost.coxmail.com"

current_crc = os.path.join(BACKUP_ROOT,"current_crc.txt")
previous_crc = os.path.join(BACKUP_ROOT,"previous_crc.txt")
backup_dir = os.path.join(BACKUP_ROOT,str(time.strftime('%d')))
current_dict = {}
previous_dict = {}
file_status_list = []
message_body = ""

# Configure Logging Meta
logger = logging.getLogger("backup_logger")
logger.setLevel(logging.INFO)
ch = logging.FileHandler(LOG_FILENAME)
#ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s - [%(levelname)s] - %(message)s")
ch.setFormatter(formatter)
logger.addHandler(ch)

# Always delete and then recreate the new backup directory.
if (os.path.exists(backup_dir)):
	logger.info("Removing old directory: " + backup_dir)
	shutil.rmtree(backup_dir)
	
logger.info("Starting copy of " + MPN_FOLDER + " to " + backup_dir)

try:
	shutil.copytree(MPN_FOLDER,backup_dir)
	logger.info("Finished copying " + MPN_FOLDER + " to " + backup_dir)
except:
	logger.info("Something went goofy during the backup of the MPN files")

logger.info("Moving current CRC to previous CRC")
shutil.move(current_crc,previous_crc)

logger.info("Loading previous CRC file.")
previous = open(previous_crc,"r")
for p in previous:
	(qualifiedfile,crc) = p.split(",")
	previous_dict[qualifiedfile] = crc.rstrip("\n")
	
previous.close()

def slashify(l):
	y = ""
	for x in l:
		y += str(x) + os.sep

	return y

logger.info("Building new (current) CRC file")
current = open(current_crc,"w")
for root, dirs, files in os.walk(backup_dir):
	for x in files:
		f = open(os.path.join(root,x),"r")
		l = root.split("\\")
		x  = slashify(l[4:]) + os.sep + x
		j = zlib.crc32(f.read())
		f.close()
		current_dict[x] = str(j)
		current.write(x + "," + str(j) + "\n")

current.close()

logger.info("Comparing current CRC with previous CRC.")
for k,v in current_dict.iteritems():
	for l,w in previous_dict.iteritems():
		if (k == l):
			if (v != w):
				logger.info("MOD - " + backup_dir + k)
				file_status_list.append("MOD - " + backup_dir + k)
				
for k,v in current_dict.iteritems():
	if k not in previous_dict:
		logger.info("ADD - " + backup_dir + k)
		file_status_list.append("ADD - " + backup_dir + k)

for k,v in previous_dict.iteritems():
	if k not in current_dict:
		logger.info("DEL - " + backup_dir + k)
		file_status_list.append("DEL - " + backup_dir + k)


message_body += "--------------------------------------\n"
message_body += "Backup Directory File Integrity Status\n"
message_body += "--------------------------------------\n\n"
message_body += "Backup Directory: " + backup_dir + "\n\n"

if len(file_status_list) > 0:
	for x in file_status_list:
		message_body += x + "\n"
else:
	message_body += "No Files Changed\n"

msgRoot = MIMEMultipart('related')
msgRoot['Subject'] = "Eclipse Backup Verification Email"
msgRoot['From'] = "Eclipse Backup Verification <dastella1@yahoo.com>"
msgRoot['To'] = ''.join(recipients)
msgRoot.preamble = 'This is a multi-part message in MIME format.'	

msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)

msgText = MIMEText("<pre>" + message_body + "</pre>", 'html')
msgAlternative.attach(msgText)
        
server = smtplib.SMTP(smtp_server)
if DEBUG: server.set_debuglevel(1)
server.sendmail("Eclipse Backup Verification <dastella1@yahoo.com>", recipients, msgRoot.as_string())
server.quit()
