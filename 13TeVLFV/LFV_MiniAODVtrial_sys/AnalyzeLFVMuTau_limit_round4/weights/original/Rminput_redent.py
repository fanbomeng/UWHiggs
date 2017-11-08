import subprocess
import shutil 

with open('samplelist.txt') as f:
   for lines in f:
         linesnew=lines.rstrip('\n')
         if "v6-v1" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
            newline=linesnew.split('_v6-v1',1)[0]+linesnew.split('_v6-v1',1)[1]
            print newline 
            shutil.copy(linesnew,'renamed/'+newline)

         elif "_v6_ext1-v2" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
            newline=linesnew.split('_v6_ext1-v2',1)[0]+linesnew.split('_v6_ext1-v2',1)[1]
            print newline 
            shutil.copy(linesnew,'renamed/'+newline)

         elif "_v6_ext1-v1" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
            newline=linesnew.split('_v6_ext1-v1',1)[0]+linesnew.split('_v6_ext1-v1',1)[1]
            print newline 
            shutil.copy(linesnew,'renamed/'+newline)
         elif "_v6_ext4-v1" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
            newline=linesnew.split('_v6_ext4-v1',1)[0]+linesnew.split('_v6_ext4-v1',1)[1]
            print newline 
            shutil.copy(linesnew,'renamed/'+newline)
#         if "_v6_ext2-v1" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
#            newline=linesnew.split('_v6_ext2-v1',1)[0]+linesnew.split('_v6_ext2-v1',1)[1]
#            print newline 
#            shutil.copy(linesnew,'renamed/'+newline)
         elif "_v6-v3" in linesnew:
#            subline=linesnew.split('_v6-v1',1)
            newline=linesnew.split('_v6-v3',1)[0]+linesnew.split('_v6-v3',1)[1]
            print newline 
            shutil.copy(linesnew,'renamed/'+newline)
         else:
            print linesnew
            shutil.copy(linesnew,'renamed/')
#lines = [line.rstrip('\n') for line in open('samplelist.txt')]
