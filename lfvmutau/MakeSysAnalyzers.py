from sys import argv

systematics = argv[1]

f = open('AnalyzeLFVMuTau.py','r')
g = open('AnalyzeLFVMuTau'+systematics+'.py','w')

for line in f:
	if 'AnalyzeLFVMuTau' in line:
		newline = line.replace('AnalyzeLFVMuTau','AnalyzeLFVMuTau'+systematics)
	else:
		newline = line
	g.write(newline)

f.close()
g.close()
