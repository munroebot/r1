from win32com.client import Dispatch

import sys

session = Dispatch('Lotus.NotesSession')
session.Initialize('password')

fileCount = 0

hr5doe = 0
exchange = 0
exchangeArray = []
doe = 0
lnc = 0

f = open('addy_rw.csv','w')
f.write('"File Path",Exchange,DOE,HR5DOE,LNC,Offenders\n')

#dbdir = session.getDbDirectory('YDLN1')

dbdir = session.getDbDirectory('RWLN2')

db = dbdir.getFirstDatabase(1247)
while db != None:
	if (db.FilePath.find('roaming') >= 0 and db.FilePath.find('names.nsf') >= 0):
		try:
			fileCount += 1
			db.Open()
			notesCollection = db.Search('Form="Person"',None,0)
			d = notesCollection.getFirstDocument()
			while d != None:

				if (d.getItemValue('MailAddress')[0].find('Exchange') >= 0 or \
				    d.getItemValue('MailDomain')[0].find('Exchange') >= 0 or \
				    d.getItemValue('FullName')[0].find('@Exchange') >= 0):
				    
					exchangeArray.append(d.getItemValue('MailAddress')[0])
					exchange += 1

				if (d.getItemValue('MailDomain')[0].find('DOE') >= 0):
					doe += 1

				if (d.getItemValue('MailDomain')[0].find('HR5DOE') >= 0):
					hr5doe += 1

				if (d.getItemValue('MailDomain')[0].find('LNC') >= 0):
					lnc += 1

				d = notesCollection.getNextDocument(d)

			if (exchange + doe + hr5doe + lnc != 0):
				f.write("\"{0}\", {1}, {2}, {3}, {4},\"{5}\"\n".format(db.FilePath,exchange,doe,hr5doe,lnc,exchangeArray))

		except IndexError:
			pass

		except:
			print str(db.FilePath) + " - " + str(sys.exc_info()[0])

	exchange = 0
	exchangeArray = []
	doe = 0
	hr5doe = 0
	lnc = 0

	db = dbdir.getNextDatabase()

f.close()
print "\nQueried %s databases" % (fileCount)
