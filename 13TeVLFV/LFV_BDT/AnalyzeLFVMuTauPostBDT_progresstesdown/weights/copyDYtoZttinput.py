import subprocess
import shutil 

with open('samplelist.txt') as f:
   for lines in f:
      linesnew=lines.rstrip('\n')
      if "DY" in linesnew:
         subline=linesnew.split('DY',1)[-1]
         Ztautauline='ZTauTau'+subline
         print Ztautauline
         shutil.copy(linesnew,Ztautauline)


#lines = [line.rstrip('\n') for line in open('samplelist.txt')]
