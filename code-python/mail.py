import smtplib

fromaddr = "Brian Munroe <brian.munroe@ymp.gov>"
toaddrs = "Brian Munroe <brian.munroe@ymp.gov>"

msg = "From: Brian Munroe <brian.munroe@ymp.gov\r\nSubject:testing\r\nX-Notes-Item:Testing 1;name=Subject\r\nX-Notes-Item:Task;name=Form\r\n\r\n"

msg = "From: Brian Munroe <brian.munroe@ymp.gov\r\nSubject:testing\r\nx-notes-item:12/12/2004 11:20PM PST;type=307;name=StartDateTime\r\nX-Notes-Item:Information;name=AdminCode\r\nX-Notes-Item:Memo;name=Form\r\n\r\n"

server = smtplib.SMTP('smtp.ymp.gov')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

"""
NOTES:

x-notes-item: 12/12/2004 11:20PM PST; type=300;name=StartDateTime\r\n
X-Notes-Item: 12/12/2004 11:20PM PST; type=300;name=doc_length

type=300 = Number
type=500 = Text
type=501 = Text List


"""


