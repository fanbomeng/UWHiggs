import subprocess
import shutil 

with open('samplelist.txt') as f:
   for lines in f:
      linesnew=lines.rstrip('\n')
      if "txt" in linesnew:
         file1 = open(linesnew.split('.',1)[0]+"new.txt", "w")
         with open(linesnew) as g:
            for lines1 in g:
                linesnew2=lines1.rstrip('\n')
                file1.write("caillol/"+linesnew2+"\n")
         file1.close()
         shutil.copy(linesnew.split('.',1)[0]+"new.txt",linesnew)


#lines = [line.rstrip('\n') for line in open('samplelist.txt')]
