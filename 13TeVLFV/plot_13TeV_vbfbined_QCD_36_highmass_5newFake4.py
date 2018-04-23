from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_varsnew
import XSecnew
clearnoverflow=1
moveoverflow=0
def NoNegBins(histo):    #no negtive bin, if negtive then set Zero
	for i in range(1,histo.GetNbinsX()+1):
		if histo.GetBinContent(i) != 0:
			lowBound = i
			break
        for i in range(histo.GetNbinsX(),0,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break
	for i in range(lowBound, highBound+1):
		if histo.GetBinContent(i) <= 0:
			histo.SetBinContent(i,0)
def set_poissonerrors(histo):     #set bin errors from Poisson interval at 68.3%
	histo.SetBinErrorOption(ROOT.TH1.kPoisson)

	for i in range(1,histo.GetNbinsX()+1):
		errorLow = histo.GetBinErrorLow(i)
		errorUp = histo.GetBinErrorUp(i)			

def yieldHisto(histo,xmin,xmax):   # Find the bin number from the range of x axis, and then get the integrate event number of the histogram
        binmin = int(histo.FindBin(xmin))
        binwidth = histo.GetBinWidth(binmin)
        binmax = int(xmax/binwidth)
        signal = histo.Integral(binmin,binmax)
        return signal

def do_binbybinQCD(histo,lowBound,highBound): # This is first to used check QCDs events for data driven method, if there are empty bins, then set it to be zero
        if clearnoverflow: 
           histo.SetBinContent(histo.GetNbinsX()+1,0.0)
           histo.SetBinError(histo.GetNbinsX()+1,0.0)
           histo.SetBinContent(0,0.0)
           histo.SetBinError(0,0.0)
        if moveoverflow:
           histo.SetBinContent(histo.GetNbinsX(),histo.GetBinContent(histo.GetNbinsX()+1)) 
           histo.SetBinError(histo.GetNbinsX(),histo.GetBinError(histo.GetNbinsX()+1)) 
           histo.SetBinContent(histo.GetNbinsX()+1,0.0)
           histo.SetBinError(histo.GetNbinsX()+1,0.0)
           histo.SetBinContent(0,0.0)
           histo.SetBinError(0,0.0)
        for i in range(1,histo.GetNbinsX()+1):
                if histo.GetBinContent(i) != 0:
                        lowBound = i
                        break
        for i in range(histo.GetNbinsX(),0,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break
        if lowBound<=highBound:
           for i in range(lowBound, highBound+1):
                   if fillEmptyBins: #fill empty bins
                           if histo.GetBinContent(i) <= 0:
                                   histo.SetBinContent(i,0.0)
                                   histo.SetBinError(i,0.0)
                   else:
                           if histo.GetBinContent(i) < 0:
                                   histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
#This is the function fill the normal Mc sample empty bins with the scale from the expectation
def do_binbybin(histo,file_str,lowBound,highBound): 
        metafile = lumidir + file_str+"_weight.log"
        f = open(metafile).read().splitlines()
        nevents = float((f[0]).split(': ',1)[-1])
        xsec = eval("XSecnew."+file_str.replace("-","_"))
        if clearnoverflow:
           histo.SetBinContent(histo.GetNbinsX()+1,0.0)
           histo.SetBinError(histo.GetNbinsX()+1,0.0)
           histo.SetBinContent(0,0.0)
           histo.SetBinError(0,0.0)
        if moveoverflow:
           histo.SetBinContent(histo.GetNbinsX(),histo.GetBinContent(histo.GetNbinsX()+1))
           histo.SetBinError(histo.GetNbinsX(),histo.GetBinError(histo.GetNbinsX()+1))
           histo.SetBinContent(histo.GetNbinsX()+1,0.0)
           histo.SetBinError(histo.GetNbinsX()+1,0.0)
           histo.SetBinContent(0,0.0)
           histo.SetBinError(0,0.0)
        for i in range(1,histo.GetNbinsX()+1):
                if histo.GetBinContent(i) != 0:
                        lowBound = i
                        break
        for i in range(histo.GetNbinsX(),0,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break
        if lowBound<=highBound:
           for i in range(lowBound, highBound+1):
                   if fillEmptyBins: #fill empty bins
                           if histo.GetBinContent(i) <= 0:
                                   histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                   else:
                           if histo.GetBinContent(i) < 0:
                                   histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
def make_histo(savedir,file_str, channel,var,lumidir,lumi,isData=False,):     #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): 
		histo.Scale(lumi) 
	else:	
		histo.Scale(lumi/JSONlumi)
        if (shift in savedir and isData == False):  ##get normalization uncertainty
		savedirNoShift = savedir.strip("_"+shift+"/")
		histoNoShift = make_histo(savedirNoShift+"/",file_str, channel,var,lumidir,lumi,isData)
                if "Up" in shift:
			savedirOppShift = savedir.strip("Up/")+"Down"  
		elif "Down" in shift:
			savedirOppShift = savedir.strip("Down/")+"Up"
		histoOppShift = make_histo(savedirOppShift+"/",file_str, channel,var,lumidir,lumi,isData)
                if (histo.Integral() > 0.0):
 			scale = abs(histoNoShift.Integral()-histo.Integral())/histoNoShift.Integral()
 			scaleOppShift = abs(histoNoShift.Integral()-histoOppShift.Integral())/histoNoShift.Integral()
			if (scaleOppShift > scale):
				scale = scaleOppShift
			print savedir +": " + channel + ": " + file_str + ": " + str(scale+1)
		else:
			print savedir +": " + file_str + ": ---"
        return histo

##########OPTIONS#########################
#blinded = True #not blinded
blinded = False #not blinded
#fakeRate = False #apply fake rate method
fakeRate = True #apply fake rate method
QCDflag=False
QCDflag=True
fillEmptyBins = True #empty bins filled
#fillEmptyBins = True #empty bins filled
#drawdata=False
drawdata=True
highMass=True
#highMass=False
Setlog=False
#Setlog=True
#DrawallMass=False
DrawallMass=True
#DrawselectionLevel_2bin=True
DrawselectionLevel_2bin=False
#JSONlumi = 35861.6952851 #newest
#Ifrebin=True
Ifrebin=False


JSONlumi = 35858.4537506 #newest 50 trigger
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
savedir=argv[1]
var=argv[2]
channel=argv[3]
shift=argv[5]
shiftnormal=shift
opcut=argv[6]
RUN_OPTIMIZATION=int(argv[7])
Masspoint=str(argv[8])
# This part refer to the fake channels. From the command used in the plotter, an channel will be given, in the form like gg200, while to get the fake channel used later for the fake background, this is the dictinary refer to it
if RUN_OPTIMIZATION==1:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg/"+opcut:"ggNotIso/"+opcut,"boost/"+opcut:"boostNotIso/"+opcut,"vbf/"+opcut:"vbfNotIso/"+opcut} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
else:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","selectionSS200":"selectionnotIsoSS200","selectionSS450":"selectionnotIsoSS450","IsoSS0Jet":"notIsoSS0Jet","IsoSS1Jet":"notIsoSS1Jet",'preslectionEnWjets':'notIsoEnWjets','preslectionEnWjets0Jet':'notIsoEnWjets0Jet','preslectionEnWjets1Jet':'notIsoEnWjets1Jet','preslectionEnZtt':'notIsoEnZtt','preslectionEnZtt0Jet':'notIsoEnZtt0Jet','preslectionEnZtt1Jet':'notIsoEnZtt1Jet','preslectionEnZmm':'notIsoEnZmm','preslectionEnZmm0Jet':'notIsoEnZmm0Jet','preslectionEnZmm1Jet':'notIsoEnZmm1Jet',"notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","gg":"ggNotIso","gg125":"ggNotIso125","gg200":"ggNotIso200","gg300":"ggNotIso300","gg450":"ggNotIso450","gg600":"ggNotIso600","gg750":"ggNotIso750","gg900":"ggNotIso900","boost":"boostNotIso","boost125":"boostNotIso125","boost200":"boostNotIso200","boost300":"boostNotIso300","boost450":"boostNotIso450","boost600":"boostNotIso600","boost750":"boostNotIso750","boost900":"boostNotIso900","vbf":"vbfNotIso","vbf_gg":"vbf_ggNotIso","vbf_vbf":"vbf_vbfNotIso",'preslectionEnTTbar':'notIsoEnTTbar','preslectionEnTTbar0Jet':'notIsoEnTTbar0Jet','preslectionEnTTbar1Jet':'notIsoEnTTbar1Jet'}
fakeMChannels = {"preselection":"notIsoM","preselectionSS":"notIsoSSM","notIso":"notIsoM","notIsoSS":"notIsoSSM","IsoSS0Jet":"notIsoSS0JetM","IsoSS1Jet":"notIsoSS1JetM",'preslectionEnWjets':'notIsoEnWjetsM','preslectionEnWjets0Jet':'notIsoEnWjets0JetM','preslectionEnWjets1Jet':'notIsoEnWjets1JetM','preslectionEnZtt':'notIsoEnZttM','preslectionEnZtt0Jet':'notIsoEnZtt0JetM','preslectionEnZtt1Jet':'notIsoEnZtt1JetM','preslectionEnZmm':'notIsoEnZmmM','preslectionEnZmm0Jet':'notIsoEnZmm0JetM','preslectionEnZmm1Jet':'notIsoEnZmm1JetM',"preselection0Jet":"notIso0JetM","preselection1Jet":"notIso1JetM","gg":"ggNotIsoM","gg125":"ggNotIsoM125","gg200":"ggNotIsoM200","gg300":"ggNotIsoM300","gg450":"ggNotIsoM450","gg600":"ggNotIsoM600","gg750":"ggNotIsoM750","gg900":"ggNotIsoM900","boost":"boostNotIsoM","boost125":"boostNotIsoM125","boost200":"boostNotIsoM200","boost300":"boostNotIsoM300","boost450":"boostNotIsoM450","boost600":"boostNotIsoM600","boost750":"boostNotIsoM750","boost900":"boostNotIsoM900","vbf":"vbfNotIsoM","vbf_gg":"vbf_ggNotIsoM","vbf_vbf":"vbf_vbfNotIsoM",'preslectionEnTTbar':'notIsoEnTTbarM','preslectionEnTTbar0Jet':'notIsoEnTTbar0JetM','preslectionEnTTbar1Jet':'notIsoEnTTbar1JetM'} 
fakeMTChannels = {"preselection":"notIsoMT","preselectionSS":"notIsoSSMT","notIso":"notIsoMT","notIsoSS":"notIsoSSMT","IsoSS0Jet":"notIsoSS0JetMT","IsoSS1Jet":"notIsoSS1JetMT",'preslectionEnWjets':'notIsoEnWjetsMT','preslectionEnWjets0Jet':'notIsoEnWjets0JetMT','preslectionEnWjets1Jet':'notIsoEnWjets1JetMT','preslectionEnZtt':'notIsoEnZttMT','preslectionEnZtt0Jet':'notIsoEnZtt0JetMT','preslectionEnZtt1Jet':'notIsoEnZtt1JetMT','preslectionEnZmm':'notIsoEnZmmMT','preslectionEnZmm0Jet':'notIsoEnZmm0JetMT','preslectionEnZmm1Jet':'notIsoEnZmm1JetMT',"preselection0Jet":"notIso0JetMT","preselection1Jet":"notIso1JetMT","gg":"ggNotIsoMT","gg125":"ggNotIsoMT125","gg200":"ggNotIsoMT200","gg300":"ggNotIsoMT300","gg450":"ggNotIsoMT450","gg600":"ggNotIsoMT600","gg750":"ggNotIsoMT750","gg900":"ggNotIsoMT900","boost":"boostNotIsoMT","boost125":"boostNotIsoM125","boost200":"boostNotIsoMT200","boost300":"boostNotIsoMT300","boost450":"boostNotIsoMT450","boost600":"boostNotIsoMT600","boost750":"boostNotIsoMT750","boost900":"boostNotIsoMT900","vbf":"vbfNotIsoMT","vbf_gg":"vbf_ggNotIsoMT","vbf_vbf":"vbf_vbfNotIsoMT",'preslectionEnTTbar':'notIsoEnTTbarMT','preslectionEnTTbar0Jet':'notIsoEnTTbar0JetMT','preslectionEnTTbar1Jet':'notIsoEnTTbar1JetMT'} 
# This is for the semi data driven method, to refer to the notIsoSS for the QCDs estimation, if give a normal channel like gg200
if RUN_OPTIMIZATION==1: 
   tmpvariable=channel.split("/")[1]
   QCDChannels={"preselection0Jet":"IsoSS0Jet/","preselectionSS":"notIsoSS/","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS/"+tmpvariable,"boost":"boostIsoSS/"+tmpvariable,"gg200":"ggIsoSS200/"+tmpvariable,"boost200":"boostIsoSS200/"+tmpvariable,"gg450":"ggIsoSS450/"+tmpvariable,"boost450":"boostIsoSS450/"+tmpvariable,"vbf":"vbfIsoSS/"+tmpvariable,"vbf_gg":"vbf_ggIsoSS/"+tmpvariable,"vbf_vbf":"vbf_vbfIsoSS/"+tmpvariable}
else:
   QCDChannels={"preselection0Jet":"IsoSS0Jet/","preselection":"preselectionSS/","preselectionSS":"notIsoSS/","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS","boost":"boostIsoSS","gg200":"ggIsoSS200","boost200":"boostIsoSS200","gg450":"ggIsoSS450","boost450":"boostIsoSS450","vbf":"vbfIsoSS","vbf_gg":"vbf_ggIsoSS","vbf_vbf":"vbf_vbfIsoSS"}
  
poissonErrors=True
if "collMass_type1_1" in var:
	var = "collMass_type1"
if "none" in shift:
	shiftStr="" 
else:
	if "Fakes1stDown" in shift:
		shiftStr = "_FakeShapeMuTau1stDown"
	elif "Fakes1stUp" in shift:
		shiftStr = "_FakeShapeMuTau1stUp"
	elif "Fakes2ndDown" in shift:
		shiftStr = "_FakeShapeMuTau2ndDown"
	elif "Fakes2ndUp" in shift:
		shiftStr = "_FakeShapeMuTau2ndUp"
	else:
              shiftStr="_CMS_"+shift #corresponds to name Daniel used in datacards
rootdir = "mutau" #directory in datacard file


channeltmp=channel.split("/")[0]
if "boost" in channeltmp:
        rootdir = "mutauh_1Jet"+Masspoint
elif "gg" in channeltmp:
	rootdir = "mutauh_0Jet"+Masspoint
else:
	rootdir = "mutauh_0Jet"

canvas = ROOT.TCanvas("canvas","canvas",800,800)
canvas.cd()
# Get parameters unique to each variable
getVarParams = "lfv_varsnew."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]
if str(argv[8])=='None':
   MasspointNum=200
else:
   MasspointNum=int(argv[8])
# This the a set of binning, vari in mass. The guide line for the choice of current one is to have relative finner bins around the pick of each mass point considered
if (highMass and 'collMass_type1' in var and 'boost' in channel) or Ifrebin:
   if MasspointNum==200:
        binwidth =array.array('d',[0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,230,250,270,300,330,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
   elif MasspointNum==300:
        binwidth =array.array('d',[0,20,40,60,80,100,120,140,160,180,200,225,250,280,320,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
   elif MasspointNum==450:
        binwidth =array.array('d',[0,30,60,90,130,170,210,250,290,340,390,425,475,525,575,625,700,780,860,1000,1400])
   elif MasspointNum==600:
        binwidth =array.array('d',[0,50,100,150,200,260,320,390,460,550,630,750,900,1200,1400])
   elif MasspointNum==750:
        binwidth =array.array('d',[0,50,100,150,200,260,320,390,460,540,620,700,800,900,1200,1400])
   elif MasspointNum==900:
        binwidth =array.array('d',[0,60,130,215,325,460,630,800,1000,1200,1400])
elif highMass and 'collMass_type1' in var and 'gg' in channel:
   if MasspointNum==200:
        binwidth =array.array('d',[0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,230,250,270,300,330,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
   elif MasspointNum==300:
        binwidth =array.array('d',[0,50,100,120,140,160,180,200,225,250,280,320,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
   elif MasspointNum==450:
        binwidth =array.array('d',[0,75,150,170,215,265,325,375,425,475,520,570,620,700,780,860,1000,1400])
   elif MasspointNum==600:
        binwidth =array.array('d',[0,50,100,150,200,260,320,390,460,550,630,750,900,1200,1400])
   elif MasspointNum==750:
        binwidth =array.array('d',[0,50,100,150,200,260,320,390,460,540,620,700,800,900,1200,1400])
   elif MasspointNum==900:
        binwidth =array.array('d',[0,60,130,215,325,460,630,800,1000,1200,1400])
# this is ingeneral, if no bin above is spacified, then used this one, which actually is the 200GeV binning
elif highMass and 'collMass_type1' in var:
        #binwidth =array.array('d',[0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,230,250,270,300,330,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
        #binwidth =array.array('d',[0,30,60,90,120,150,180,210,250,300,360,425,500,580,690,810,900,1000,1200,1400])
        binwidth =array.array('d',[0,45,90,135,180,230,280,350,420,500,580,690,810,1000,1400])
if highMass and ('tPt' in var or 'mPt' in var):
        binwidth =array.array('d',[0,15,30,45,60,80,105,135,165,195,250,300,400,500])
if highMass and ('collMass_type1' in var and "selectionSS450" in channel):
        binwidth =array.array('d',[0,75,150,220,300,400,500,600,750,900,1400])
if highMass and ('collMass_type1' in var and "selectionSS200" in channel):
        binwidth =array.array('d',[0,30,60,100,150,200,250,300,375,450,525,630,750,900,1200,1400])
legend = eval(varParams[8])
isGeV = varParams[5]
xRange = varParams[6]

p_lfv = ROOT.TPad("p_lfv","p_lfv",0,0.35,1,1)
p_lfv.SetFillColor(0)
p_lfv.SetBorderMode(0)
p_lfv.SetBorderSize(10)
p_lfv.SetTickx(1)
p_lfv.SetTicky(1)
p_lfv.SetLeftMargin(0.14)
p_lfv.SetRightMargin(0.05)
p_lfv.SetTopMargin(0.122)
p_lfv.SetBottomMargin(0.026)
p_lfv.SetFrameFillStyle(0)
p_lfv.SetFrameLineStyle(0)
p_lfv.SetFrameLineWidth(3)
p_lfv.SetFrameBorderMode(0)
p_lfv.SetFrameBorderSize(10)
p_lfv.RedrawAxis()
if (not ('Phi' in var or 'Eta' in var)) and Setlog:
    p_lfv.SetLogy()
p_lfv.Draw()
p_ratio = ROOT.TPad("p_ratio","p_ratio",0,0,1,0.35);
p_ratio.SetTopMargin(0.05);
p_ratio.SetBottomMargin(0.35);
p_ratio.SetLeftMargin(0.14);
p_ratio.SetRightMargin(0.05);
p_ratio.SetTickx(1)
p_ratio.SetTicky(1)
p_ratio.SetFrameLineWidth(3)
p_ratio.SetGridx()
p_ratio.SetGridy()
p_ratio.Draw()
p_lfv.cd()
lumidir = savedir+"weights/"
lumiScale = float(argv[4]) #lumi to scale to
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi
# Starting from here, is to access the histogram in each of the data files
data2016B = make_histo(savedir,"data_SingleMuon_Run2016B", channel,var,lumidir,lumi,True,)
data2016C = make_histo(savedir,"data_SingleMuon_Run2016C", channel,var,lumidir,lumi,True,)
data2016D = make_histo(savedir,"data_SingleMuon_Run2016D", channel,var,lumidir,lumi,True,)
data2016E = make_histo(savedir,"data_SingleMuon_Run2016E", channel,var,lumidir,lumi,True,)
data2016F = make_histo(savedir,"data_SingleMuon_Run2016F", channel,var,lumidir,lumi,True,)
data2016G = make_histo(savedir,"data_SingleMuon_Run2016G", channel,var,lumidir,lumi,True,)
data2016H = make_histo(savedir,"data_SingleMuon_Run2016H", channel,var,lumidir,lumi,True,)
data2016B.Add(data2016C)
data2016B.Add(data2016D)
data2016B.Add(data2016E)
data2016B.Add(data2016F)
data2016B.Add(data2016G)
data2016B.Add(data2016H)
data=data2016B.Clone()
channelNoral=channel
if ('13TeV' in shift) and not ('none' in shift) and not ('TauFakeRate' in shift):
   channelSys=channel+shift
   channel=channelSys
if 'scale_t' in shift:
  channel=channelNoral
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
zjetslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
z1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
z2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
z3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
z4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
zjets.Add(z1jets)
zjets.Add(z2jets)
zjets.Add(z3jets)
zjets.Add(z4jets)
zjets.Add(zjetslow)
if 'scale_mfaketau' in shift:
    channel=channelNoral
if 'scale_t' in shift:
  channel=channelSys
ztautau = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautaulow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautau1Jets = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautau2Jets = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautau3Jets = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautau4Jets = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ztautau.Add(ztautau1Jets)
ztautau.Add(ztautau2Jets)
ztautau.Add(ztautau3Jets)
ztautau.Add(ztautau4Jets)
ztautau.Add(ztautaulow)
vbfhmutau125 = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau125 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau120 = make_histo(savedir,"VBF_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau120 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau130 = make_histo(savedir,"VBF_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau130 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau150 = make_histo(savedir,"VBF_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau150 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau200 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau300 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M300_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau450 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M450_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau600 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M600_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau750 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M750_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau900 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M900_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

smhvbf = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smhgg = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smhwp = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smhwm = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
WGstarNEE = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",channel,var,lumidir,lumi)
WGstarNMM = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",channel,var,lumidir,lumi)
WGLNG = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
WGstarNMM.Add(WGstarNEE)
WGstarNMM.Add(WGLNG)

smhzh = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smtthtt = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
smhvbf.Add(smhwp)
smhvbf.Add(smhwm)
smhvbf.Add(smhzh)
smhvbf.Add(smtthtt)

ttbar = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",channel,var,lumidir,lumi)
vv=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
wwTo1L1Nu2Q=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
wzJToLLLNu=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",channel,var,lumidir,lumi)
wzTo1L1Nu2Q=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
wzTo1L3Nu=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
wzTo2L2Q=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
zzTo2L2Q=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channel,var,lumidir,lumi)
zzTo4L=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
diboson = vv.Clone()
diboson.Add(wwTo1L1Nu2Q)
diboson.Add(wzJToLLLNu)
diboson.Add(wzTo1L1Nu2Q)
diboson.Add(wzTo1L3Nu)
diboson.Add(wzTo2L2Q)
diboson.Add(zzTo2L2Q)
diboson.Add(zzTo4L)

St_tW_anti = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
St_tW_top = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
St_t_top = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
St_t_anti = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

singlet = St_tW_top.Clone()
singlet.Add(St_tW_anti)
singlet.Add(St_t_top)
singlet.Add(St_t_anti)


# This part start to calculate the data diven QCDs 
if (QCDflag == True):
  #the channel need to change here
  QCDChannel = QCDChannels[channel.split("/")[0]]
  data2016BQCDs = make_histo(savedir,"data_SingleMuon_Run2016B", QCDChannel,var,lumidir,lumi,True,)
  data2016CQCDs = make_histo(savedir,"data_SingleMuon_Run2016C", QCDChannel,var,lumidir,lumi,True,)
  data2016DQCDs = make_histo(savedir,"data_SingleMuon_Run2016D", QCDChannel,var,lumidir,lumi,True,)
  data2016EQCDs = make_histo(savedir,"data_SingleMuon_Run2016E", QCDChannel,var,lumidir,lumi,True,)
  data2016FQCDs = make_histo(savedir,"data_SingleMuon_Run2016F", QCDChannel,var,lumidir,lumi,True,)
  data2016GQCDs = make_histo(savedir,"data_SingleMuon_Run2016G", QCDChannel,var,lumidir,lumi,True,)
  data2016HQCDs = make_histo(savedir,"data_SingleMuon_Run2016H", QCDChannel,var,lumidir,lumi,True,)
  data2016BQCDs.Add(data2016CQCDs)
  data2016BQCDs.Add(data2016DQCDs)
  data2016BQCDs.Add(data2016EQCDs)
  data2016BQCDs.Add(data2016FQCDs)
  data2016BQCDs.Add(data2016GQCDs)
  data2016BQCDs.Add(data2016HQCDs)
  QCDs = data2016BQCDs.Clone()
  wjetsQCDs = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  w1jetsQCDs = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  w2jetsQCDs = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  w3jetsQCDs = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  w4jetsQCDs = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  wjetsQCDs.Add(w1jetsQCDs)
  wjetsQCDs.Add(w2jetsQCDs)
  wjetsQCDs.Add(w3jetsQCDs)
  wjetsQCDs.Add(w4jetsQCDs)
  wjetsQCDs.Scale(-1)
  zjetsQCDs = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  zjetsQCDslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  z1jetsQCDs = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  z2jetsQCDs = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  z3jetsQCDs = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  z4jetsQCDs = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  zjetsQCDs.Add(z1jetsQCDs)
  zjetsQCDs.Add(z2jetsQCDs)
  zjetsQCDs.Add(z3jetsQCDs)
  zjetsQCDs.Add(z4jetsQCDs)
  zjetsQCDs.Add(zjetsQCDslow)
  zjetsQCDs.Scale(-1)
  ztautauQCDs = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautauQCDslow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautau1QCDs = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautau2QCDs = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautau3QCDs = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautau4QCDs = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautauQCDs.Add(ztautau1QCDs)
  ztautauQCDs.Add(ztautau2QCDs)
  ztautauQCDs.Add(ztautau3QCDs)
  ztautauQCDs.Add(ztautau4QCDs)
  ztautauQCDs.Add(ztautauQCDslow)
  ztautauQCDs.Scale(-1)
  ttbarQCDs = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",QCDChannel,var,lumidir,lumi)
  ttbarQCDs.Scale(-1)
  vbfhmutau125QCDs = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  gghmutau125QCDs = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  vbfhmutau125QCDs.Scale(-0.01)
  gghmutau125QCDs.Scale(-0.01)
  smhvbfQCDs = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhggQCDs = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhwpQCDs = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhwmQCDs = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhzhQCDs = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smtthttQCDs = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  smhvbfQCDs.Add(smhwpQCDs)
  smhvbfQCDs.Add(smhwmQCDs)
  smhvbfQCDs.Add(smhzhQCDs)
  smhvbfQCDs.Add(smtthttQCDs)
  smhvbfQCDs.Scale(-1)
  smhggQCDs.Scale(-1)
  vvQCDs=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  wwTo1L1Nu2QQCDs=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  wzJToLLLNuQCDs=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",QCDChannel,var,lumidir,lumi)
  wzTo1L1Nu2QQCDs=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  wzTo1L3NuQCDs=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  wzTo2L2QQCDs=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  zzTo2L2QQCDs=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",QCDChannel,var,lumidir,lumi)
  zzTo4LQCDs=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",QCDChannel,var,lumidir,lumi)
  dibosonQCDs = vvQCDs.Clone()
  dibosonQCDs.Add(wwTo1L1Nu2QQCDs)
  dibosonQCDs.Add(wzJToLLLNuQCDs)
  dibosonQCDs.Add(wzTo1L1Nu2QQCDs)
  dibosonQCDs.Add(wzTo1L3NuQCDs)
  dibosonQCDs.Add(wzTo2L2QQCDs)
  dibosonQCDs.Add(zzTo2L2QQCDs)
  dibosonQCDs.Add(zzTo4LQCDs)

  St_tW_antiQCDs = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_tW_topQCDs = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_t_topQCDs = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_t_antiQCDs = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  singletQCDs = St_tW_topQCDs.Clone()
  singletQCDs.Add(St_tW_antiQCDs)
  singletQCDs.Add(St_t_topQCDs)
  singletQCDs.Add(St_t_antiQCDs)
  singletQCDs.Scale(-1)
  dibosonQCDs.Scale(-1)
  QCDs.Add(ttbarQCDs) 
  QCDs.Add(ztautauQCDs) 
  QCDs.Add(zjetsQCDs) 
  QCDs.Add(wjetsQCDs) 
  QCDs.Add(vbfhmutau125QCDs)
  QCDs.Add(gghmutau125QCDs)
  QCDs.Add(smhvbfQCDs)
  QCDs.Add(smhggQCDs)
  QCDs.Add(dibosonQCDs)
  QCDs.Add(singletQCDs)
# This part starts to calcuate the full data driven Fake background estimation
if (fakeRate == True):
  channel=channelNoral
  fakechannel = fakeChannels[channel]
  fakechannelNoral=fakechannel
  if 'TauFakeRate' in shift:
     fakechannel=fakechannel+shift 
  data2016Bfakes = make_histo(savedir,"data_SingleMuon_Run2016B", fakechannel,var,lumidir,lumi,True,)
  data2016Cfakes = make_histo(savedir,"data_SingleMuon_Run2016C", fakechannel,var,lumidir,lumi,True,)
  data2016Dfakes = make_histo(savedir,"data_SingleMuon_Run2016D", fakechannel,var,lumidir,lumi,True,)
  data2016Efakes = make_histo(savedir,"data_SingleMuon_Run2016E", fakechannel,var,lumidir,lumi,True,)
  data2016Ffakes = make_histo(savedir,"data_SingleMuon_Run2016F", fakechannel,var,lumidir,lumi,True,)
  data2016Gfakes = make_histo(savedir,"data_SingleMuon_Run2016G", fakechannel,var,lumidir,lumi,True,)
  data2016Hfakes = make_histo(savedir,"data_SingleMuon_Run2016H", fakechannel,var,lumidir,lumi,True,)
  data2016Bfakes.Add(data2016Cfakes)
  data2016Bfakes.Add(data2016Dfakes)
  data2016Bfakes.Add(data2016Efakes)
  data2016Bfakes.Add(data2016Ffakes)
  data2016Bfakes.Add(data2016Gfakes)
  data2016Bfakes.Add(data2016Hfakes)
  wjets = data2016Bfakes.Clone()
  zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  zjetsfakeslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  z1jetsfakes = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  z2jetsfakes = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  z3jetsfakes = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  z4jetsfakes = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  zjetsfakes.Add(z1jetsfakes) 
  zjetsfakes.Add(z2jetsfakes) 
  zjetsfakes.Add(z3jetsfakes) 
  zjetsfakes.Add(z4jetsfakes) 
  zjetsfakes.Add(zjetsfakeslow) 
  zjetsfakes.Scale(-1)
  ztautaufakes = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautaufakeslow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautau1fakes = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautau2fakes = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautau3fakes = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautau4fakes = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautaufakes.Add(ztautau1fakes)
  ztautaufakes.Add(ztautau2fakes)
  ztautaufakes.Add(ztautau3fakes)
  ztautaufakes.Add(ztautau4fakes)
  ztautaufakes.Add(ztautaufakeslow)
  ztautaufakes.Scale(-1.)
  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
  ttbarfakes.Scale(-1)
  smhvbffakes = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",fakechannel,var,lumidir,lumi)  
  smhggfakes = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",fakechannel,var,lumidir,lumi)
  smhvbffakes.Add(smhggfakes)
  smhwpfakes = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",fakechannel,var,lumidir,lumi)
  smhwmfakes = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",fakechannel,var,lumidir,lumi)


  WGstarNEEfakes = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",fakechannel,var,lumidir,lumi)
  WGstarNMMfakes = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",fakechannel,var,lumidir,lumi)
  WGLNGfakes = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
  WGstarNMMfakes.Add(WGstarNEEfakes)
  WGstarNMMfakes.Add(WGLNGfakes)
  WGstarNMMfakes.Scale(-1)

  smhzhfakes = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",fakechannel,var,lumidir,lumi)
  smtthttfakes = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  smhvbffakes.Add(smhwpfakes)
  smhvbffakes.Add(smhwmfakes)
  smhvbffakes.Add(smhzhfakes)
  smhvbffakes.Add(smtthttfakes)
  smhvbffakes.Scale(-1)
  vvfakes=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  wwTo1L1Nu2Qfakes=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  wzJToLLLNufakes=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",fakechannel,var,lumidir,lumi)
  wzTo1L1Nu2Qfakes=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  wzTo1L3Nufakes=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  wzTo2L2Qfakes=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  zzTo2L2Qfakes=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakechannel,var,lumidir,lumi)
  zzTo4Lfakes=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
  dibosonfakes = vvfakes.Clone()
  dibosonfakes.Add(wwTo1L1Nu2Qfakes)
  dibosonfakes.Add(wzJToLLLNufakes)
  dibosonfakes.Add(wzTo1L1Nu2Qfakes)
  dibosonfakes.Add(wzTo1L3Nufakes)
  dibosonfakes.Add(wzTo2L2Qfakes)
  dibosonfakes.Add(zzTo2L2Qfakes)
  dibosonfakes.Add(zzTo4Lfakes)
  dibosonfakes.Scale(-1)
  St_tW_antifakes = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakechannel,var,lumidir,lumi)
  St_tW_topfakes = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakechannel,var,lumidir,lumi)
  St_t_topfakes = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakechannel,var,lumidir,lumi)
  St_t_antifakes = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakechannel,var,lumidir,lumi)
  St_tW_antifakes.Add(St_tW_topfakes)
  St_tW_antifakes.Add(St_t_topfakes)
  St_tW_antifakes.Add(St_t_antifakes)
  St_tW_antifakes.Scale(-1)
  wjets.Add(St_tW_antifakes) 
  wjets.Add(dibosonfakes) 
  wjets.Add(smhvbffakes) 
  wjets.Add(zjetsfakes) 
  wjets.Add(ztautaufakes) 
  wjets.Add(ttbarfakes) 
  wjets.Add(WGstarNMMfakes)


  wjets  = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", fakechannel,var,lumidir,lumi)
  w1jets = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  w2jets = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  w3jets = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  w4jets = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  wjets.Add(w1jets)
  wjets.Add(w2jets)
  wjets.Add(w3jets)
  wjets.Add(w4jets)
  #fakeMchannel = fakeMChannels[channel]
  #fakeMchannelNoral=fakeMchannel
  #if 'TauFakeRate' in shift:
  #   fakeMchannel=fakeMchannel+shift 
  #data2016BfakesM = make_histo(savedir,"data_SingleMuon_Run2016B", fakeMchannel,var,lumidir,lumi,True,)
  #data2016CfakesM = make_histo(savedir,"data_SingleMuon_Run2016C", fakeMchannel,var,lumidir,lumi,True,)
  #data2016DfakesM = make_histo(savedir,"data_SingleMuon_Run2016D", fakeMchannel,var,lumidir,lumi,True,)
  #data2016EfakesM = make_histo(savedir,"data_SingleMuon_Run2016E", fakeMchannel,var,lumidir,lumi,True,)
  #data2016FfakesM = make_histo(savedir,"data_SingleMuon_Run2016F", fakeMchannel,var,lumidir,lumi,True,)
  #data2016GfakesM = make_histo(savedir,"data_SingleMuon_Run2016G", fakeMchannel,var,lumidir,lumi,True,)
  #data2016HfakesM = make_histo(savedir,"data_SingleMuon_Run2016H", fakeMchannel,var,lumidir,lumi,True,)
  #data2016BfakesM.Add(data2016CfakesM)
  #data2016BfakesM.Add(data2016DfakesM)
  #data2016BfakesM.Add(data2016EfakesM)
  #data2016BfakesM.Add(data2016FfakesM)
  #data2016BfakesM.Add(data2016GfakesM)
  #data2016BfakesM.Add(data2016HfakesM)
  #wjetsM = data2016BfakesM.Clone()
  #zjetsfakesM = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMchannel,var,lumidir,lumi)
  #zjetsfakesMlow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMchannel,var,lumidir,lumi)
  #z1jetsfakesM = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #z2jetsfakesM = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #z3jetsfakesM = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #z4jetsfakesM = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #zjetsfakesM.Add(z1jetsfakesM) 
  #zjetsfakesM.Add(z2jetsfakesM) 
  #zjetsfakesM.Add(z3jetsfakesM) 
  #zjetsfakesM.Add(z4jetsfakesM) 
  #zjetsfakesM.Add(zjetsfakesMlow) 
  #zjetsfakesM.Scale(-1)
  #ztautaufakesM = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautaufakesMlow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautau1fakesM = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautau2fakesM = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautau3fakesM = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautau4fakesM = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  #ztautaufakesM.Add(ztautau1fakesM)
  #ztautaufakesM.Add(ztautau2fakesM)
  #ztautaufakesM.Add(ztautau3fakesM)
  #ztautaufakesM.Add(ztautau4fakesM)
  #ztautaufakesM.Add(ztautaufakesMlow)
  #ztautaufakesM.Scale(-1)
  #ttbarfakesM = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakeMchannel,var,lumidir,lumi)
  #ttbarfakesM.Scale(-1)
  #smhvbffakesM = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)  
  #smhggfakesM = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  #smhvbffakesM.Add(smhggfakesM)
  #smhwpfakesM = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  #smhwmfakesM = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  #smhzhfakesM = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  #smtthttfakesM = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #smhvbffakesM.Add(smhwpfakesM)
  #smhvbffakesM.Add(smhwmfakesM)
  #smhvbffakesM.Add(smhzhfakesM)
  #smhvbffakesM.Add(smtthttfakesM)
  #smhvbffakesM.Scale(-1)

  #WGstarNEEfakesM = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",fakeMchannel,var,lumidir,lumi)
  #WGstarNMMfakesM = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",fakeMchannel,var,lumidir,lumi)
  #WGLNGfakesM = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakeMchannel,var,lumidir,lumi)
  #WGstarNMMfakesM.Add(WGstarNEEfakesM)
  #WGstarNMMfakesM.Add(WGLNGfakesM)
  #WGstarNMMfakesM.Scale(-1)

  #vvfakesM=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #wwTo1L1Nu2QfakesM=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #wzJToLLLNufakesM=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",fakeMchannel,var,lumidir,lumi)
  #wzTo1L1Nu2QfakesM=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #wzTo1L3NufakesM=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #wzTo2L2QfakesM=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #zzTo2L2QfakesM=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  #zzTo4LfakesM=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",fakeMchannel,var,lumidir,lumi)
  #dibosonfakesM = vvfakesM.Clone()
  #dibosonfakesM.Add(wwTo1L1Nu2QfakesM)
  #dibosonfakesM.Add(wzJToLLLNufakesM)
  #dibosonfakesM.Add(wzTo1L1Nu2QfakesM)
  #dibosonfakesM.Add(wzTo1L3NufakesM)
  #dibosonfakesM.Add(wzTo2L2QfakesM)
  #dibosonfakesM.Add(zzTo2L2QfakesM)
  #dibosonfakesM.Add(zzTo4LfakesM)
  #dibosonfakesM.Scale(-1)
  #St_tW_antifakesM = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  #St_tW_topfakesM = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  #St_t_topfakesM = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  #St_t_antifakesM = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  #St_tW_antifakesM.Add(St_tW_topfakesM)
  #St_tW_antifakesM.Add(St_t_topfakesM)
  #St_tW_antifakesM.Add(St_t_antifakesM)
  #St_tW_antifakesM.Scale(-1)
  #wjetsM.Add(St_tW_antifakesM) 
  #wjetsM.Add(dibosonfakesM) 
  #wjetsM.Add(smhvbffakesM) 
  #wjetsM.Add(zjetsfakesM) 
  #wjetsM.Add(ztautaufakesM) 
  #wjetsM.Add(ttbarfakesM) 
  #wjetsM.Add(WGstarNMMfakesM) 
  #

  #fakeMTchannel = fakeMTChannels[channel]
  #fakeMTchannelNoral=fakeMTchannel
  #if 'TauFakeRate' in shift:
  #   fakeMTchannel=fakeMTchannel+shift 
  #data2016BfakesMT = make_histo(savedir,"data_SingleMuon_Run2016B", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016CfakesMT = make_histo(savedir,"data_SingleMuon_Run2016C", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016DfakesMT = make_histo(savedir,"data_SingleMuon_Run2016D", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016EfakesMT = make_histo(savedir,"data_SingleMuon_Run2016E", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016FfakesMT = make_histo(savedir,"data_SingleMuon_Run2016F", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016GfakesMT = make_histo(savedir,"data_SingleMuon_Run2016G", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016HfakesMT = make_histo(savedir,"data_SingleMuon_Run2016H", fakeMTchannel,var,lumidir,lumi,True,)
  #data2016BfakesMT.Add(data2016CfakesMT)
  #data2016BfakesMT.Add(data2016DfakesMT)
  #data2016BfakesMT.Add(data2016EfakesMT)
  #data2016BfakesMT.Add(data2016FfakesMT)
  #data2016BfakesMT.Add(data2016GfakesMT)
  #data2016BfakesMT.Add(data2016HfakesMT)
  #wjetsMT = data2016BfakesMT.Clone()
  #zjetsfakesMT = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMTchannel,var,lumidir,lumi)
  #zjetsfakesMTlow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMTchannel,var,lumidir,lumi)
  #z1jetsfakesMT = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #z2jetsfakesMT = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #z3jetsfakesMT = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #z4jetsfakesMT = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #zjetsfakesMT.Add(z1jetsfakesMT) 
  #zjetsfakesMT.Add(z2jetsfakesMT) 
  #zjetsfakesMT.Add(z3jetsfakesMT) 
  #zjetsfakesMT.Add(z4jetsfakesMT)
  #zjetsfakesMT.Add(zjetsfakesMTlow)
  #zjetsfakesMT.Scale(-1) 
  #ztautaufakesMT = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautaufakesMTlow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautau1fakesMT = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautau2fakesMT = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautau3fakesMT = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautau4fakesMT = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ztautaufakesMT.Add(ztautau1fakesMT)
  #ztautaufakesMT.Add(ztautau2fakesMT)
  #ztautaufakesMT.Add(ztautau3fakesMT)
  #ztautaufakesMT.Add(ztautau4fakesMT)
  #ztautaufakesMT.Add(ztautaufakesMTlow)
  #ztautaufakesMT.Scale(-1) 
  #ttbarfakesMT = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakeMTchannel,var,lumidir,lumi)
  #ttbarfakesMT.Scale(-1) 
  #smhvbffakesMT = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)  
  #smhggfakesMT = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  #smhvbffakesMT.Add(smhggfakesMT)
  #smhwpfakesMT = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  #smhwmfakesMT = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  #smhzhfakesMT = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  #smtthttfakesMT = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #smhvbffakesMT.Add(smhwpfakesMT)
  #smhvbffakesMT.Add(smhwmfakesMT)
  #smhvbffakesMT.Add(smhzhfakesMT)
  #smhvbffakesMT.Add(smtthttfakesMT)
  #smhvbffakesMT.Scale(-1)

  #WGstarNEEfakesMT = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",fakeMTchannel,var,lumidir,lumi)
  #WGstarNMMfakesMT = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",fakeMTchannel,var,lumidir,lumi)
  #WGLNGfakesMT = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakeMTchannel,var,lumidir,lumi)
  #WGstarNMMfakesMT.Add(WGstarNEEfakesMT)
  #WGstarNMMfakesMT.Add(WGLNGfakesMT)
  #WGstarNMMfakesMT.Scale(-1)

  #vvfakesMT=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #wwTo1L1Nu2QfakesMT=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #wzJToLLLNufakesMT=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",fakeMTchannel,var,lumidir,lumi)
  #wzTo1L1Nu2QfakesMT=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #wzTo1L3NufakesMT=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #wzTo2L2QfakesMT=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #zzTo2L2QfakesMT=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  #zzTo4LfakesMT=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",fakeMTchannel,var,lumidir,lumi)
  #dibosonfakesMT = vvfakesMT.Clone()
  #dibosonfakesMT.Add(wwTo1L1Nu2QfakesMT)
  #dibosonfakesMT.Add(wzJToLLLNufakesMT)
  #dibosonfakesMT.Add(wzTo1L1Nu2QfakesMT)
  #dibosonfakesMT.Add(wzTo1L3NufakesMT)
  #dibosonfakesMT.Add(wzTo2L2QfakesMT)
  #dibosonfakesMT.Add(zzTo2L2QfakesMT)
  #dibosonfakesMT.Add(zzTo4LfakesMT)
  #dibosonfakesMT.Scale(-1)
  #St_tW_antifakesMT = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  #St_tW_topfakesMT = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  #St_t_topfakesMT = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  #St_t_antifakesMT = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  #St_tW_antifakesMT.Add(St_tW_topfakesMT)
  #St_tW_antifakesMT.Add(St_t_topfakesMT)
  #St_tW_antifakesMT.Add(St_t_antifakesMT)
  #St_tW_antifakesMT.Scale(-1)
  #wjetsMT.Add(St_tW_antifakesMT) 
  #wjetsMT.Add(dibosonfakesMT) 
  #wjetsMT.Add(smhvbffakesMT) 
  #wjetsMT.Add(zjetsfakesMT) 
  #wjetsMT.Add(ztautaufakesMT) 
  #wjetsMT.Add(ttbarfakesMT) 
  #wjetsMT.Add(WGstarNMMfakesMT) 
else: #if fakeRate==False
     wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w1jets = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w2jets = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w3jets = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w4jets = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     wjets.Add(w1jets)
     wjets.Add(w2jets)
     wjets.Add(w3jets)
     wjets.Add(w4jets)
     if QCDflag==True:
        QCDs.Scale(1.06)
        #QCDs.Scale(2)
wjetsC = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
w1jetsC = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
w2jetsC = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
w3jetsC = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
w4jetsC = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
wjetsC.Add(w1jetsC)
wjetsC.Add(w2jetsC)
wjetsC.Add(w3jetsC)
wjetsC.Add(w4jetsC)

#channeltmp='preselectionSS'
#wjetsSC =  make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channeltmp,var,lumidir,lumi)
#w1jetsSC = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channeltmp,var,lumidir,lumi)
#w2jetsSC = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channeltmp,var,lumidir,lumi)
#w3jetsSC = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channeltmp,var,lumidir,lumi)
#w4jetsSC = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channeltmp,var,lumidir,lumi)
#wjetsSC.Add(w1jetsSC)
#wjetsSC.Add(w2jetsSC)
#wjetsSC.Add(w3jetsSC)
#wjetsSC.Add(w4jetsSC)
#

wjetsSC=wjets.Clone()
#wjetsC.SetBinContent(wjetsC.GetNbinsX()+1,0.0)
#wjetsC.SetBinContent(0,0.0)
#wjetsSC.SetBinContent(wjetsSC.GetNbinsX()+1,0.0)
#wjetsSC.SetBinContent(0,0.0)
scale1 =1/(wjetsC.Integral())
scale2 =1/(wjetsSC.Integral())
norm1=wjetsC.GetEntries()
norm2=wjetsSC.GetEntries()

#print 'the number of norm   %f'  %norm1


wjetsC.Scale(scale1)
wjetsSC.Scale(scale2)
#wjetsC.Scale(1/norm1)
#wjetsSC.Scale(1/norm2)
print "integral   %f " %wjetsC.Integral()
print "integral2   %f " %wjetsSC.Integral()

lowDataBin =1 
highDataBin = data.GetNbinsX()#-1
for i in range(1,data.GetNbinsX()+1):
	if (data.GetBinContent(i) > 0):
		lowDataBin = i
		break
for i in range(data.GetNbinsX(),0,-1):
	if (data.GetBinContent(i) > 0):
		highDataBin = i
		break
if (highMass and ('collMass_type1' in var) ) or Ifrebin:
   data=data.Rebin(len(binwidth)-1,'',binwidth)
else:
   data.Rebin(binwidth)
if QCDflag==True:
   if (highMass and 'collMass_type1' in var) or  Ifrebin:
       QCDs=QCDs.Rebin(len(binwidth)-1,'',binwidth)
       wjetsC=wjetsC.Rebin(len(binwidth)-1,'',binwidth)
       wjetsSC=wjetsSC.Rebin(len(binwidth)-1,'',binwidth)
   else:
       QCDs.Rebin(binwidth)
if QCDflag==True:
   #QCDs.Scale(1.06)
   QCDs.Scale(1)
   do_binbybinQCD(QCDs,lowDataBin,highDataBin)
   print 'the number of events in WJets %f and QCDs %f   ratio %f'  %(wjetsC.Integral(),QCDs.Integral(),QCDs.Integral()/(wjetsC.Integral()+QCDs.Integral()))
 #  wjetsC.Add(QCDs)
#fakerelated
if fakeRate:
  # wjetsMT.Scale(-1)
  #wjetsM.Scale(-1)
#   wjetsM.Add(wjetsMT)
#   do_binbybinQCD(wjetsM,lowDataBin,highDataBin)
# For now, the muon fakes is not consider, so the downward line is comment out for this reason
#   wjets.Add(wjetsM)
   if (highMass and 'collMass_type1' in var ) or  Ifrebin :
      wjets=wjets.Rebin(len(binwidth)-1,'',binwidth)
   else:
      wjets.Rebin(binwidth)
if (not fakeRate):
   if (highMass and 'collMass_type1' in var) or  Ifrebin :
      wjets=wjets.Rebin(len(binwidth)-1,'',binwidth)
   else:
      wjets.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    zjets=zjets.Rebin(len(binwidth)-1,'',binwidth)
else:
    zjets.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    ztautau=ztautau.Rebin(len(binwidth)-1,'',binwidth)
else:
    ztautau.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    ttbar=ttbar.Rebin(len(binwidth)-1,'',binwidth)
else:
    ttbar.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    diboson=diboson.Rebin(len(binwidth)-1,'',binwidth)
else:
   diboson.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    singlet=singlet.Rebin(len(binwidth)-1,'',binwidth)
else:
    singlet.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    smhgg=smhgg.Rebin(len(binwidth)-1,'',binwidth)
else:
    smhgg.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    gghmutau125=gghmutau125.Rebin(len(binwidth)-1,'',binwidth)
#    gghmutau120=gghmutau120.Rebin(len(binwidth)-1,'',binwidth)
#    gghmutau130=gghmutau130.Rebin(len(binwidth)-1,'',binwidth)
#    gghmutau150=gghmutau150.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau200=gghmutau200.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau300=gghmutau300.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau450=gghmutau450.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau600=gghmutau600.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau750=gghmutau750.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau900=gghmutau900.Rebin(len(binwidth)-1,'',binwidth)
    WGstarNMM=WGstarNMM.Rebin(len(binwidth)-1,'',binwidth)
else:
    gghmutau125.Rebin(binwidth)
#    gghmutau120.Rebin(binwidth)
#    gghmutau130.Rebin(binwidth)
#    gghmutau150.Rebin(binwidth)
    gghmutau200.Rebin(binwidth)
    gghmutau300.Rebin(binwidth)
    gghmutau450.Rebin(binwidth)
    gghmutau600.Rebin(binwidth)
    gghmutau750.Rebin(binwidth)
    gghmutau900.Rebin(binwidth)
    WGstarNMM.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    smhvbf=smhvbf.Rebin(len(binwidth)-1,'',binwidth)
else:
    smhvbf.Rebin(binwidth)
if (highMass and 'collMass_type1' in var) or  Ifrebin:
    vbfhmutau125=vbfhmutau125.Rebin(len(binwidth)-1,'',binwidth)
#    vbfhmutau120=vbfhmutau120.Rebin(len(binwidth)-1,'',binwidth)
#    vbfhmutau130=vbfhmutau130.Rebin(len(binwidth)-1,'',binwidth)
#    vbfhmutau150=vbfhmutau150.Rebin(len(binwidth)-1,'',binwidth)
else:
    vbfhmutau125.Rebin(binwidth)
#    vbfhmutau120.Rebin(binwidth)
#    vbfhmutau130.Rebin(binwidth)
#    vbfhmutau150.Rebin(binwidth)

if RUN_OPTIMIZATION ==1:
   outfile_name = savedir+"LFV"+"_"+channel.split("/",1)[0]+channel.split("/",1)[1]+"_"+var+"_"+shiftStr
else:
   outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])


   if '200' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"200LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '200' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"200HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   

   if '300' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"300LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '300' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"300HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   


   if '450' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"450LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '450' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"450HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   

   if '600' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"600LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '600' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"600HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   


   if '750' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"750LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '750' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"750HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   


   if '900' in str(argv[8]) and '200' in str(argv[3]): 
        outfile_name = savedir+"900LowLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   
   if '900' in str(argv[8]) and '450' in str(argv[3]): 
        outfile_name = savedir+"900HighLFV"+"_"+channel+"_"+var+"_"+shiftStr+str(argv[8])   

   #outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr


if (fakeRate == True):
  outfile_name = outfile_name+"Fakes"
if lumiScale != 0:
        outfile_name = outfile_name+"_Lumi"+str(lumi)
if blinded==True:
	outfile_name = outfile_name+"_Blinded"
if fillEmptyBins==False:
	outfile_name = outfile_name+"_EmptyBins"
if poissonErrors==True:
	outfile_name = outfile_name+"_PoissonErrors"
#if '450' in str(argv[8]) and '200' in str(argv[3]): 
#	outfile_name = outfile_name+"_PoissonErrors"+'_special450'
outfile = ROOT.TFile(outfile_name+".root","RECREATE")

outfile.mkdir(rootdir)
outfile.cd(rootdir+"/")
if blinded == False:
	if not ("Jet" in shift or "UES" in shift or "TES" in shift or 'MFT' in shift or "Fakes" in shift or "Fakes" in shift or "MES" in shift):
        	data.Write("data_obs")

if ("collMass" in var or "m_t_Mass" in var or 'type1_pfMetEtNormal' in var or 'type1_pfMetEt' in var):
  binLow = data.FindBin(100)
  binHigh = data.FindBin(1400)+1
if blinded == True:
        if 'none' in shift:
                data.Write("data_obs")
#enum EColor { kWhite =0,   kBlack =1,   kGray=920,
#              kRed   =632, kGreen =416, kBlue=600, kYellow=400, kMagenta=616, kCyan=432,
#              kOrange=800, kSpring=820, kTeal=840, kAzure =860, kViolet =880, kPink=900 };

#Plotting options (not to be used for final plots)
wjets=wjetsSC.Clone()
data.SetMarkerStyle(20)
data.SetMarkerSize(1)
data.SetLineColor(1)
gghmutau125.SetLineColor(632)
gghmutau125.SetLineWidth(3)
#gghmutau120.SetLineColor(400+4)
#gghmutau120.SetLineWidth(3)
#gghmutau130.SetLineColor(416-5)
#gghmutau130.SetLineWidth(3)
#gghmutau150.SetLineColor(600-5)
#gghmutau150.SetLineWidth(3)
gghmutau200.SetLineColor(616-7)
gghmutau200.SetLineWidth(3)
gghmutau300.SetLineColor(432-5)
gghmutau300.SetLineWidth(3)
gghmutau450.SetLineColor(800-4)
gghmutau450.SetLineWidth(3)
gghmutau600.SetLineColor(860+6)
gghmutau600.SetLineWidth(3)
gghmutau750.SetLineColor(880-3)
gghmutau750.SetLineWidth(3)
gghmutau900.SetLineColor(900-7)
gghmutau900.SetLineWidth(3)
WGstarNMM.SetLineColor(632-6)
WGstarNMM.SetLineWidth(1)
WGstarNMM.SetFillColor(632-6)
WGstarNMM.SetMarkerSize(0)
vbfhmutau125.SetLineColor(600)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(3)
smhvbf.SetLineColor(616)
smhvbf.SetFillColor(616)
smhgg.SetLineWidth(1)
smhgg.SetLineColor(1)
smhgg.SetMarkerSize(0)
smhgg.SetFillColor(880+1)
#wjets.SetFillColor(616-10)
wjets.SetLineColor(2)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
if (QCDflag == True):
   #wjetsC.SetFillColor(221)
   wjetsC.SetLineColor(1)
   wjetsC.SetLineWidth(1)
   wjetsC.SetMarkerSize(0)
ztautau.SetFillColor(800-4)
ztautau.SetLineColor(1)
ztautau.SetLineWidth(1)
ztautau.SetMarkerSize(0)
zjets.SetFillColor(860+5)
zjets.SetLineColor(1)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
ttbar.SetFillColor(600-8)
ttbar.SetLineColor(1)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
diboson.SetFillColor(432-6)
diboson.SetLineColor(1)
diboson.SetLineWidth(1)
diboson.SetMarkerSize(0)
singlet.SetFillColor(416+4)
singlet.SetLineColor(1)
singlet.SetLineWidth(1)
singlet.SetMarkerSize(0)

#fill empty bins
#do_binbybin(wjetsC,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
#do_binbybin(wjetsSC,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
if fakeRate == False:
	#do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
	do_binbybinQCD(QCDs,lowDataBin,highDataBin)
else:

	do_binbybinQCD(wjets,lowDataBin,highDataBin)
do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
do_binbybin(diboson,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",lowDataBin,highDataBin)
do_binbybin(ttbar,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",lowDataBin,highDataBin)
do_binbybin(smhgg,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(smhvbf,"VBFHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(WGstarNMM,"WGstarToLNuMuMu_13TeV-madgraph",lowDataBin,highDataBin)
do_binbybin(singlet,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",lowDataBin,highDataBin)
do_binbybin(vbfhmutau125,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau125,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(vbfhmutau120,"VBF_LFV_HToMuTau_M120_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(gghmutau120,"GluGlu_LFV_HToMuTau_M120_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(vbfhmutau130,"VBF_LFV_HToMuTau_M130_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(gghmutau130,"GluGlu_LFV_HToMuTau_M130_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(vbfhmutau150,"VBF_LFV_HToMuTau_M150_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(gghmutau150,"GluGlu_LFV_HToMuTau_M150_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau200,"GluGlu_LFV_HToMuTau_M200_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau300,"GluGlu_LFV_HToMuTau_M300_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau450,"GluGlu_LFV_HToMuTau_M450_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau600,"GluGlu_LFV_HToMuTau_M600_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau750,"GluGlu_LFV_HToMuTau_M750_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau900,"GluGlu_LFV_HToMuTau_M900_13TeV_powheg_pythia8",lowDataBin,highDataBin)
BLAND=0
ttbarP_t=ttbar.Clone()
ttbarP_t.Add(singlet)
ttbarP_t.SetFillColor(600-8)
ttbarP_t.SetLineColor(1)
ttbarP_t.SetLineWidth(1)
ttbarP_t.SetMarkerSize(0)
if(poissonErrors==True):
	set_poissonerrors(data)

smh = smhgg.Clone()
smh.Add(smhvbf)
smh.SetLineWidth(1)
smh.SetLineColor(1)
smh.SetMarkerSize(0)
smh.SetFillColor(880+1)
LFVStack = ROOT.THStack("stack","")
LFVStack.Add(wjetsC)
#LFVStack.Add(wjetsSC)
#LFVStack.Add(wjets)
#if (QCDflag == True):
#   LFVStack.Add(QCDs)
#LFVStack.Add(smh)
#LFVStack.Add(diboson)
#LFVStack.Add(ttbarP_t)
#LFVStack.Add(WGstarNMM)
#LFVStack.Add(zjets)
#LFVStack.Add(ztautau)
#binContent_2 = (LFVStack.GetStack().Last())
LFVStack.GetStack().Last().GetXaxis().SetLabelSize(0.)

maxLFVStack = LFVStack.GetMaximum()
maxData=data.GetMaximum()
maxHist = max(maxLFVStack,maxData)
if Setlog: 
  if not ('Phi' in var or 'Eta' in var):
     LFVStack.SetMaximum(maxLFVStack*2000)
LFVStack.SetMinimum(0)
LFVStack.Draw('hist')
binLow=data.FindBin(1)
binHigh=data.FindBin(-1)
if "collMass_type1" in var and "preselectionSS" not in channel :
    binLow = data.FindBin(160)
    binHigh = data.FindBin(1400)+1
if "tPt" in var  and "preselectionSS" not in channel:
    binLow = data.FindBin(60)
    binHigh = data.FindBin(1400)+1
if "tMtToPfMet_type1" in var  and "preselectionSS" not in channel:
    binLow =1
    binHigh = data.FindBin(80)+1
if "mPt" in var  and "preselectionSS" not in channel:
    binLow =data.FindBin(45)
    binHigh = data.FindBin(1400)+1
if 'preslectionEnWjets' in channel:
    binLow =data.FindBin(600)
    binHigh = data.FindBin(1400)+1
#if blinded==False :
#    for i in range(binLow,binHigh):
#        data.SetBinContent(i,-1000000000)
#if drawdata:
#    data.Draw("sames,E0")
lfvh = gghmutau125.Clone()
#lfvh.Add(vbfhmutau125)
lfvh.Scale(0.05)
#lfvh.Draw('hsames')
#lfvh120 = gghmutau120.Clone()
#lfvh120.Add(vbfhmutau120)
#lfvh120.Scale(0.05)
#lfvh120.Draw('hsames')
#lfvh130 = gghmutau130.Clone()
#lfvh130.Add(vbfhmutau130)
#lfvh130.Scale(0.05)
#lfvh130.Draw('hsames')
#lfvh150 = gghmutau150.Clone()
#lfvh150.Add(vbfhmutau150)
#lfvh150.Scale(0.05)
#lfvh150.Draw('hsames')
lfvh200 = gghmutau200.Clone()
#lfvh200.Add(vbfhmutau200)
lfvh200.Scale(0.05)
#lfvh200.Draw('hsames')
lfvh300 = gghmutau300.Clone()
lfvh300.Scale(0.05)
#lfvh300.Draw('hsames')
lfvh450 = gghmutau450.Clone()
lfvh450.Scale(0.05)
#lfvh450.Draw('hsames')
lfvh600 = gghmutau600.Clone()
lfvh600.Scale(0.05)
#lfvh600.Draw('hsames')
lfvh750 = gghmutau750.Clone()
lfvh750.Scale(0.05)
#lfvh750.Draw('hsames')
lfvh900 = gghmutau900.Clone()
lfvh900.Scale(0.05)
Masslist={'125':lfvh,'200':lfvh200,'300':lfvh300,'450':lfvh450,'600':lfvh600,'750':lfvh750,'900':lfvh900}
wjets.Draw('hist same')
#if not DrawallMass and not DrawselectionLevel_2bin:
#   Masslist[Masspoint].Draw("sames,E0")
#elif DrawallMass:
#   lfvh.Draw('hsames')
#   lfvh200.Draw('hsames')
#   lfvh300.Draw('hsames')
#   lfvh450.Draw('hsames')
#   lfvh600.Draw('hsames')
#   lfvh750.Draw('hsames')
#   lfvh900.Draw('hsames')
#elif DrawselectionLevel_2bin and Masspoint=='200':
#   lfvh200.Draw('hsames')
#   lfvh300.Draw('hsames')
#elif DrawselectionLevel_2bin and Masspoint=='450':
#   lfvh450.Draw('hsames')
#   lfvh600.Draw('hsames')
#   lfvh750.Draw('hsames')
#   lfvh900.Draw('hsames')
lfvh.Scale(0.2)
lfvh200.Scale(0.2)
lfvh300.Scale(0.2)
lfvh450.Scale(0.2)
lfvh600.Scale(0.2)
lfvh750.Scale(0.2)
lfvh900.Scale(0.2)
legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)
legend.SetBorderSize(0)
legend.SetTextFont(62)
xbinLength = wjets.GetBinWidth(1)
ylabel ="Events/bin"
legend.Draw('sames')
LFVStack.GetXaxis().SetTitle(xlabel)
LFVStack.GetXaxis().SetNdivisions(510)
LFVStack.GetXaxis().SetLabelSize(0)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)



pave = ROOT.TPave(100,0,150,maxHist*1.25,4,"br")
pave.SetFillColor(920+4)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
if (xRange!=0):
       	   LFVStack.GetXaxis().SetRangeUser(0,xRange)

LFVStack.GetXaxis().SetTitle(xlabel)

xbinLength = wjets.GetBinWidth(1)

size = wjets.GetNbinsX()
xUncert = array.array('f',[])
yUncert = array.array('f',[])
exlUncert = array.array('f',[])
exhUncert = array.array('f',[])
eylUncert = array.array('f',[])
eyhUncert = array.array('f',[])
xUncertRatio = array.array('f',[])
yUncertRatio = array.array('f',[])
exlUncertRatio = array.array('f',[])
exhUncertRatio = array.array('f',[])
eylUncertRatio = array.array('f',[])
eyhUncertRatio = array.array('f',[])
binLength = wjets.GetBinCenter(2)-wjets.GetBinCenter(1)

#build tgraph of errors   
for i in range(1,size+1):
        if (QCDflag == True):
           stackBinContent =wjets.GetBinContent(i)
        else:
              stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)+ztautau.GetBinContent(i)
     
        wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        xUncertRatio.append(wjets.GetBinCenter(i))
        yUncertRatio.append(1)
               
        exlUncert.append(wjets.GetBinWidth(i)/2)
        exhUncert.append(wjets.GetBinWidth(i)/2)
        exlUncertRatio.append(wjets.GetBinWidth(i)/2)
        exhUncertRatio.append(wjets.GetBinWidth(i)/2)
        if (fakeRate):
                   wjetsError = math.sqrt((wjets.GetBinContent(i)*0.30*wjets.GetBinContent(i)*0.30)+(wjets.GetBinError(i)*wjets.GetBinError(i))) 
        else: 
                if (QCDflag == True):
        	    wjetsError = math.sqrt((QCDs.GetBinContent(i)*0.3*QCDs.GetBinContent(i)*0.3)+(wjets.GetBinContent(i)*0.25*wjets.GetBinContent(i)*0.25)+ztautau.GetBinContent(i)*0.03*ztautau.GetBinContent(i)*0.03+ttbar.GetBinContent(i)*0.1*ttbar.GetBinContent(i)*0.1+diboson.GetBinContent(i)*0.05*diboson.GetBinContent(i)*0.05+zjets.GetBinContent(i)*0.1*zjets.GetBinContent(i)*0.1+singlet.GetBinContent(i)*0.1*singlet.GetBinContent(i)*0.1)  #here is different from others, why?
                else:
                    wjetsError = math.sqrt((wjets.GetBinContent(i)*0.30*wjets.GetBinContent(i)*0.30)+(wjets.GetBinError(i)*wjets.GetBinError(i))+ttbar.GetBinContent(i)*0.1*ttbar.GetBinContent(i)*0.1+ttbar.GetBnError(i)*ttbar.GetBinError(i)+diboson.GetBinContent(i)*0.05*diboson.GetBinContent(i)*0.05+diboson.GetBinError(i)*diboson.GetBinError(i)+zjets.GetBinContent(i)*0.1*zjets.GetBinContent(i)*0.1+zjets.GetBinError(i)*zjets.GetBinError(i)+singlet.GetBinContent(i)*0.1*singlet.GetBinContent(i)*0.1+singlet.GetBinError(i)*singlet.GetBinError(i))
        eylUncert.append(wjetsError)
        eyhUncert.append(wjetsError)
        if (stackBinContent==0):
        	eylUncertRatio.append(0)
                eyhUncertRatio.append(0)
	else:
        	eylUncertRatio.append((wjetsError)/stackBinContent)
        	eyhUncertRatio.append((wjetsError)/stackBinContent)
xUncertVec = ROOT.TVectorF(len(xUncert),xUncert)
yUncertVec = ROOT.TVectorF(len(yUncert),yUncert)
exlUncertVec = ROOT.TVectorF(len(exlUncert),exlUncert)
exhUncertVec = ROOT.TVectorF(len(exhUncert),exhUncert)
eylUncertVec = ROOT.TVectorF(len(eylUncert),eylUncert)
eyhUncertVec = ROOT.TVectorF(len(eyhUncert),eyhUncert)
systErrors = ROOT.TGraphAsymmErrors(xUncertVec,yUncertVec,exlUncertVec,exhUncertVec,eylUncertVec,eyhUncertVec)

xUncertVecRatio = ROOT.TVectorF(len(xUncertRatio),xUncertRatio)
yUncertVecRatio = ROOT.TVectorF(len(yUncertRatio),yUncertRatio)
exlUncertVecRatio = ROOT.TVectorF(len(exlUncertRatio),exlUncertRatio)
exhUncertVecRatio = ROOT.TVectorF(len(exhUncertRatio),exhUncertRatio)
eylUncertVecRatio = ROOT.TVectorF(len(eylUncertRatio),eylUncertRatio)
eyhUncertVecRatio = ROOT.TVectorF(len(eyhUncertRatio),eyhUncertRatio)
systErrorsRatio = ROOT.TGraphAsymmErrors(xUncertVecRatio,yUncertVecRatio,exlUncertVecRatio,exhUncertVecRatio,eylUncertVecRatio,eyhUncertVecRatio)

latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
print lumi

latexStr = "2016, %.2f fb^{-1} (13 TeV)"%(lumi/1000)
latex.DrawLatex(0.95,0.915,latexStr)
latex.SetTextAlign(12)
latex.SetTextFont(61)
latex.SetTextSize(0.08)
latex.DrawLatex(0.27,0.785,"CMS")
latex.SetTextFont(52)
latex.SetTextSize(0.06)
latex.DrawLatex(0.38,0.785,"Preliminary")
categ  = ROOT.TPaveText(0.16, 0.625, 0.44, 0.625+0.155, "NDC")
categ.SetBorderSize(   0 )
categ.SetFillStyle(    0 )
categ.SetTextAlign(   12 )
categ.SetTextSize ( 0.06 )
categ.SetTextColor(    1 )
categ.SetTextFont (   42 )
if channeltmp=="vbf_gg" or '2Jet_gg' in channel:
    categ.AddText("#mu#tau_{h}, 2 jets gg-enriched")
if channeltmp=="vbf_vbf" or '2Jet_vbf' in channel:
    categ.AddText("#mu#tau_{h}, 2 jets VBF-enriched")
if channeltmp=="boost" or '1Jet' in channel:
    categ.AddText("#mu#tau_{h}, 1 jet")
if channeltmp=="gg" or '0Jet' in channel:
    categ.AddText("#mu#tau_{h}, 0 jet")
categ.Draw("same")
systErrors.SetFillColorAlpha(920+2,0.35)
systErrors.SetMarkerSize(0)
#systErrors.Draw('E2,sames')
#legend.AddEntry(data, 'Observed','elp')
#legend.AddEntry(systErrors,'Bkcg Uncertainty','f')
#legend.AddEntry(smh, 'SM Higgs','f')
#legend.AddEntry(ztautau,'Z->#tau#tau ','f')
#legend.AddEntry(WGstarNMM,'WG','f')
#legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
#legend.AddEntry(ttbar,'t#bar{t},t+jets','f')
#legend.AddEntry(diboson,'Diboson',"f")
legend.AddEntry(wjetsC,'W+Jets MC',"f")
#if (QCDflag == True):
#   legend.AddEntry(QCDs,'QCDs','f')
if fakeRate ==True :
      legend.AddEntry(wjets,'W+Jets Data Driven','f')
#if fakeRate ==False :
#   legend.AddEntry(wjets,'Wjets','f')
#if not DrawallMass and not DrawselectionLevel_2bin:
#    legend.AddEntry(Masslist[Masspoint],'H '+Masspoint+'#rightarrow #mu#tau (B=5%)')
#elif DrawallMass:
    #legend.AddEntry(lfvh,'H 125 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh200,'H 200 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh300,'H 300 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh450,'H 450 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh600,'H 600 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh750,'H 750 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh900,'H 900 #rightarrow #mu#tau (B=5%)')
#elif DrawselectionLevel_2bin and Masspoint=='200': 
#    legend.AddEntry(lfvh200,'H 200 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh300,'H 300 #rightarrow #mu#tau (B=5%)')
#elif DrawselectionLevel_2bin and Masspoint=='450': 
#    legend.AddEntry(lfvh450,'H 450 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh600,'H 600 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh750,'H 750 #rightarrow #mu#tau (B=5%)')
#    legend.AddEntry(lfvh900,'H 900 #rightarrow #mu#tau (B=5%)')
legend.SetNColumns(2)
if fakeRate == True:
           wjets.Write("Fakes"+shiftStr)
else:
  if QCDflag==True:
    # wjets.Add(QCDs)
     wjets.Write("Fakes"+shiftStr)
  else:
     wjets.Write("Fakes"+shiftStr)
zjets.Write("Zothers"+shiftStr)

p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
#ratio = data.Clone()
ratio = wjetsC.Clone()
mc2=wjets.Clone()
#mc.Add(zjets)
#mc.Add(ztautau)
#mc.Add(ttbar)
#mc.Add(diboson)
#mc.Add(singlet)
#mc.Add(smh)
#mc.Add(WGstarNMM)
#mc.Scale(-1)
#mc.Scale(-1)
#if drawdata:
ratio.Divide(mc2)
#else:
#   ratio.Divide(mc*100000)
ratio.Draw("E1")
systErrorsRatio.SetFillColorAlpha(920+2,0.35)
systErrorsRatio.SetMarkerSize(0)
#systErrorsRatio.Draw('E2,sames')
if ("mMt" in var):
	ratio.GetXaxis().SetRangeUser(0,200)
ratio.GetXaxis().SetTitle(xlabel)
ratio.GetXaxis().SetTitleSize(0.12)
ratio.GetXaxis().SetNdivisions(510)
ratio.GetXaxis().SetTitleOffset(1.1)
ratio.GetXaxis().SetLabelSize(0.08)
ratio.GetXaxis().SetLabelFont(42)
ratio.GetYaxis().SetNdivisions(505)
ratio.GetYaxis().SetLabelFont(42)
ratio.GetYaxis().SetLabelSize(0.08)
ratio.GetYaxis().SetRangeUser(0,3)
ratio.GetYaxis().SetTitle("OS/SS")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.08)
ratio.SetTitle("")
canvas.cd()
p_lfv.RedrawAxis()
p_lfv.Draw()
ROOT.gPad.RedrawAxis()
canvas.Modified()
paveratio = ROOT.TPave(100,0.6,150,1.4,4,"br")
pave.SetFillColor(920+4)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
if (xRange!=0):
   ratio.GetXaxis().SetRangeUser(0,xRange) 
canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
numberWjets=wjets.Integral()
numberzjets=zjets.Integral()
BLAND=0
ztautau.Write("ZTauTau"+shiftStr)
ttbar.Write("TT"+shiftStr)
if not DrawallMass:
   Masslist[Masspoint].Write("LFV"+Masspoint+shiftStr)
smhvbf.Write("qqH_htt"+shiftStr)
smhgg.Write("ggH_htt"+shiftStr)
WGstarNMM.Write("WG"+shiftStr)
diboson.Write("Diboson"+shiftStr)
singlet.Write("T"+shiftStr)
full_bckg = wjets.Clone()
full_bckg.Add(zjets)
full_bckg.Add(ztautau)
full_bckg.Add(ttbar)
full_bckg.Add(diboson)
full_bckg.Add(smhvbf)
full_bckg.Add(smhgg)
full_bckg.Add(singlet)
print "Fakes Yield: " + str(wjets.Integral())
print "DY Yield:" +str(zjets.Integral())
print "ZTauTau Yield: " +str(ztautau.Integral())
print "ttbar Yield: " + str(ttbar.Integral())
print "DiBoson Yield: " + str(diboson.Integral())
print "SMHVBF Yield: " + str(smhvbf.Integral())
print "SMHGG Yield: " + str(smhgg.Integral())
print "WG Yield: " + str(WGstarNMM.Integral())
print "LFVVBF Yield scale 20 times: " +str(vbfhmutau125.Integral()*20)
print "LFV Yield scale 20 times: " +str(gghmutau125.Integral()*20)
print "Data Yield: " +str(data.Integral())
#print '200   %f'  %lfvh200.Integral()
#print '300   %f'  %lfvh300.Integral()
#print '450   %f'  %lfvh450.Integral()
#print '600   %f'  %lfvh600.Integral()
#print '750   %f'  %lfvh750.Integral()
#print '900   %f'  %lfvh900.Integral()
