
a = ['YDLNDev1','Data','YDLNH1','Data','YMLN11','Data','YDNTBE1','\\YDLNDEV1\C: YDLNDev1','\\YDLNDEV1\E: Data','\\YDLNH1\C: YDLNH1','\\YDLNH1\E: Data','\\YMLN11\C: YMLN11','\\YMLN11\E: Data','C: YDNTBE1','YDNTBE1\BKUPEXEC']

import re

pat1 = re.compile('^\\\\(.*)\\\(.*)$')
pat2 = re.compile('^[A-Z]: (.*)$')

j = []

for x in a:
	if (pat1.match(x)):
		if pat1.match(x).group(1) not in j:
			j.append(pat1.match(x).group(1))
	else:
		if (pat2.match(x)):
			if pat2.match(x).group(1) not in j:
				j.append(pat2.match(x).group(1))
			
print j