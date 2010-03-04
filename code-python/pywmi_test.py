"""

import wmi

import wmi
c = wmi.WMI(find_classes=False)

for s in c.Win32_Service ():
	if s.State == 'Stopped':
		print s.Caption

"""

import win32com.client

#for os in win32com.client.GetObject("winmgmts:").InstancesOf("Win32_OperatingSystem"):
#	print os

for x in win32com.client.GetObject("winmgmts:\\.").ExecQuery('SELECT * FROM CIM_Datafile WHERE Name = "c:\\at_exchange.py"'):
	print x