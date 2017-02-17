import os

def deleteContent(pfile):
    pfile.seek(0)
    pfile.truncate()


files=[]
jobid = os.environ['jobid']
path = 'inputs/'+jobid+'/'

hasExt = False

for name in os.listdir(path):
    if 'weight' in name:
        if not '_ext1' in name: continue
        if os.path.isfile(os.path.join(path, name)):
            if  os.path.isfile(os.path.join(path, name.replace('_ext1', ''))):
                files.append((name.replace('_ext1', ''), name))
                print  name
#print files

for names in files:
    #print names
    weight0 = [line.rstrip('\n') for line in open(os.path.join(path, names[0]))][0].split(':')[1]
    
    weight1 = [line.rstrip('\n') for line in open(os.path.join(path, names[1]))][0].split(':')[1]

    weight_tot= float(weight0)+float(weight1)

    #outfile = open(names[0]+"sumtest.txt", "w")
    #outfile.write("test")
    outfile = open (os.path.join(path, names[0]), "w")
    deleteContent(outfile)
    outfile.write("Weights: "+ str(weight_tot))
    outfile.close()
    
    
    
    
    print float(weight0), float(weight1), weight_tot

for name in os.listdir(path):
    if 'txt' in name:
        if not '_ext1' in name: continue
        if os.path.isfile(os.path.join(path, name)):
            if  os.path.isfile(os.path.join(path, name.replace('_ext1', ''))):
                files.append((name.replace('_ext1', ''), name))


            
for names in files:

    outfile = open (os.path.join(path, names[0]), "a")
    
    lines = [line.strip() for line in open(os.path.join(path, names[1]))]

    for line in lines:
        outfile.write(line+'\n')

    outfile.close()
