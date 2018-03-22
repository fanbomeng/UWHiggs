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

def do_binbybinQCD(histo,lowBound,highBound): #fill empty bins and negtive content bins to a scaled number, but detail ?
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
                           #       histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,0.0)
                   else:
                           if histo.GetBinContent(i) < 0:
                                   histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                               #    histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
def do_binbybin(histo,file_str,lowBound,highBound): #fill empty bins and negtive content bins to a scaled number, but detail ?
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
                           #       histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                   else:
                           if histo.GetBinContent(i) < 0:
                                   histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                               #    histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
                                   histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
def make_histo(savedir,file_str, channel,var,lumidir,lumi,isData=False,):     #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): #calculate effective luminosity
                #metafile = lumidir + file_str+"_weight.log"
        	#f = open(metafile).read().splitlines()
                #nevents = float((f[0]).split(': ',1)[-1])
                #xsec = eval("XSecnew."+file_str.replace("-","_"))
		#efflumi = nevents/xsec
		#histo.Scale(lumi/efflumi) 
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

##Set up style
#JSONlumi = 2297.7
#JSONlumi =334.836434 
#JSONlumi =561.123523153 
#JSONlumi =3950.74 
#JSONlumi =20000.00 
#JSONlumi =12890.00 
#JSONlumi = 20076.26 
#JSONlumi = 16084876 
#JSONlumi = 36588.1373 
#JSONlumi =  35800.0000 
JSONlumi = 35861.6952851 #newest
#JSONlumi = 36809.8902 
#JSONlumi = 20100.00 
#JSONlumi = 20000.0 
#JSONlumi =12878.27 
#JSONlumi =15000.0 
#JSONlumi =218.042 
ROOT.gROOT.LoadMacro("tdrstyle.C")
#ROOT.gROOT.LoadMacro("Rtypes.h")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")
print "test"

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
savedir=argv[1]
var=argv[2]
channel=argv[3]
shift=argv[5]
shiftnormal=shift
#if "UESZTT" in shift:
#   shift=shift.split('ZTT',2)[0]+shift.split('ZTT',2)[1]
#if "UESothers" in shift:
#   shift=shift.split('others',2)[0]+shift.split('others',2)[1]
opcut=argv[6]
RUN_OPTIMIZATION=int(argv[7])
#RUN_OPTIMIZATION=1
if RUN_OPTIMIZATION==1:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg/"+opcut:"ggNotIso/"+opcut,"boost/"+opcut:"boostNotIso/"+opcut,"vbf/"+opcut:"vbfNotIso/"+opcut} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
else:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","IsoSS0Jet":"notIsoSS0Jet","IsoSS1Jet":"notIsoSS1Jet","IsoSS2Jet":"notIsoSS2Jet","IsoSS2Jet_gg":"notIsoSS2Jet_gg","IsoSS2Jet_vbf":"notIsoSS2Jet_vbf",'preslectionEnWjets':'notIsoEnWjets','preslectionEnWjets0Jet':'notIsoEnWjets0Jet','preslectionEnWjets1Jet':'notIsoEnWjets1Jet','preslectionEnWjets2Jet':'notIsoEnWjets2Jet','preslectionEnWjets2Jet_gg':'notIsoEnWjets2Jet_gg','preslectionEnWjets2Jet_vbf':'notIsoEnWjets2Jet_vbf','preslectionEnZtt':'notIsoEnZtt','preslectionEnZtt0Jet':'notIsoEnZtt0Jet','preslectionEnZtt1Jet':'notIsoEnZtt1Jet','preslectionEnZtt2Jet':'notIsoEnZtt2Jet','preslectionEnZtt2Jet_gg':'notIsoEnZtt2Jet_gg','preslectionEnZtt2Jet_vbf':'notIsoEnZtt2Jet_vbf','preslectionEnZmm':'notIsoEnZmm','preslectionEnZmm0Jet':'notIsoEnZmm0Jet','preslectionEnZmm1Jet':'notIsoEnZmm1Jet','preslectionEnZmm2Jet':'notIsoEnZmm2Jet','preslectionEnZmm2Jet_gg':'notIsoEnZmm2Jet_gg','preslectionEnZmm2Jet_vbf':'notIsoEnZmm2Jet_vbf',"notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","preselection2Jet_gg":"notIso2Jet_gg","preselection2Jet_vbf":"notIso2Jet_vbf","gg":"ggNotIso","gg125":"ggNotIso125","gg200":"ggNotIso200","gg300":"ggNotIso300","gg450":"ggNotIso450","gg600":"ggNotIso600","gg750":"ggNotIso750","gg900":"ggNotIso900","boost":"boostNotIso","boost125":"boostNotIso125","boost200":"boostNotIso200","boost300":"boostNotIso300","boost450":"boostNotIso450","boost600":"boostNotIso600","boost750":"boostNotIso750","boost900":"boostNotIso900","vbf":"vbfNotIso","vbf_gg":"vbf_ggNotIso","vbf_vbf":"vbf_vbfNotIso",'preslectionEnTTbar':'notIsoEnTTbar','preslectionEnTTbar0Jet':'notIsoEnTTbar0Jet','preslectionEnTTbar1Jet':'notIsoEnTTbar1Jet','preslectionEnTTbar2Jet':'notIsoEnTTbar2Jet','preslectionEnTTbar2Jet_gg':'notIsoEnTTbar2Jet_gg','preslectionEnTTbar2Jet_vbf':'notIsoEnTTbar2Jet_vbf'}

fakeMChannels = {"preselection":"notIsoM","preselectionSS":"notIsoSSM","notIso":"notIsoM","notIsoSS":"notIsoSSM","IsoSS0Jet":"notIsoSS0JetM","IsoSS1Jet":"notIsoSS1JetM",'preslectionEnWjets':'notIsoEnWjetsM','preslectionEnWjets0Jet':'notIsoEnWjets0JetM','preslectionEnWjets1Jet':'notIsoEnWjets1JetM','preslectionEnZtt':'notIsoEnZttM','preslectionEnZtt0Jet':'notIsoEnZtt0JetM','preslectionEnZtt1Jet':'notIsoEnZtt1JetM','preslectionEnZmm':'notIsoEnZmmM','preslectionEnZmm0Jet':'notIsoEnZmm0JetM','preslectionEnZmm1Jet':'notIsoEnZmm1JetM',"preselection0Jet":"notIso0JetM","preselection1Jet":"notIso1JetM","gg":"ggNotIsoM","gg125":"ggNotIsoM125","gg200":"ggNotIsoM200","gg300":"ggNotIsoM300","gg450":"ggNotIsoM450","gg600":"ggNotIsoM600","gg750":"ggNotIsoM750","gg900":"ggNotIsoM900","boost":"boostNotIsoM","boost125":"boostNotIsoM125","boost200":"boostNotIsoM200","boost300":"boostNotIsoM300","boost450":"boostNotIsoM450","boost600":"boostNotIsoM600","boost750":"boostNotIsoM750","boost900":"boostNotIsoM900","vbf":"vbfNotIsoM","vbf_gg":"vbf_ggNotIsoM","vbf_vbf":"vbf_vbfNotIsoM",'preslectionEnTTbar':'notIsoEnTTbarM','preslectionEnTTbar0Jet':'notIsoEnTTbar0JetM','preslectionEnTTbar1Jet':'notIsoEnTTbar1JetM'}
fakeMTChannels = {"preselection":"notIsoMT","preselectionSS":"notIsoSSMT","notIso":"notIsoMT","notIsoSS":"notIsoSSMT","IsoSS0Jet":"notIsoSS0JetMT","IsoSS1Jet":"notIsoSS1JetMT",'preslectionEnWjets':'notIsoEnWjetsMT','preslectionEnWjets0Jet':'notIsoEnWjets0JetMT','preslectionEnWjets1Jet':'notIsoEnWjets1JetMT','preslectionEnZtt':'notIsoEnZttMT','preslectionEnZtt0Jet':'notIsoEnZtt0JetMT','preslectionEnZtt1Jet':'notIsoEnZtt1JetMT','preslectionEnZmm':'notIsoEnZmmMT','preslectionEnZmm0Jet':'notIsoEnZmm0JetMT','preslectionEnZmm1Jet':'notIsoEnZmm1JetMT',"preselection0Jet":"notIso0JetMT","preselection1Jet":"notIso1JetMT","gg":"ggNotIsoMT","gg125":"ggNotIsoMT125","gg200":"ggNotIsoMT200","gg300":"ggNotIsoMT300","gg450":"ggNotIsoMT450","gg600":"ggNotIsoMT600","gg750":"ggNotIsoMT750","gg900":"ggNotIsoMT900","boost":"boostNotIsoMT","boost125":"boostNotIsoM125","boost200":"boostNotIsoMT200","boost300":"boostNotIsoMT300","boost450":"boostNotIsoMT450","boost600":"boostNotIsoMT600","boost750":"boostNotIsoMT750","boost900":"boostNotIsoMT900","vbf":"vbfNotIsoMT","vbf_gg":"vbf_ggNotIsoMT","vbf_vbf":"vbf_vbfNotIsoMT",'preslectionEnTTbar':'notIsoEnTTbarMT','preslectionEnTTbar0Jet':'notIsoEnTTbar0JetMT','preslectionEnTTbar1Jet':'notIsoEnTTbar1JetMT'}

if RUN_OPTIMIZATION==1: 
   tmpvariable=channel.split("/")[1]
   QCDChannels={"preselection0Jet":"IsoSS0Jet/","preselectionSS":"notIsoSS/","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS/"+tmpvariable,"boost":"boostIsoSS/"+tmpvariable,"vbf":"vbfIsoSS/"+tmpvariable,"vbf_gg":"vbf_ggIsoSS/"+tmpvariable,"vbf_vbf":"vbf_vbfIsoSS/"+tmpvariable}
else:
   QCDChannels={"preselection0Jet":"IsoSS0Jet","preselectionSS":"notIsoSS","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS","boost":"boostIsoSS","vbf":"vbfIsoSS","vbf_gg":"vbf_ggIsoSS","vbf_vbf":"vbf_vbfIsoSS",'IsoSS0Jet':'IsoSS0Jet'}
WmunufakeChannels={"preselection0Jet":"Wmunu_preselection0Jet","preselection1Jet":"Wmunu_preselection1Jet","preselection2Jet":"Wmunu_preselection2Jet","gg":"Wmunu_gg","boost":"Wmunu_boost","vbf_gg":"Wmunu_vbf_gg","vbf_vbf":"Wmunu_vbf_vbf"}
WtaunufakeChannels={"preselection0Jet":"Wtaunu_preselection0Jet","preselection1Jet":"Wtaunu_preselection1Jet","preselection2Jet":"Wtaunu_preselection2Jet","gg":"Wtaunu_gg","boost":"Wtaunu_boost","vbf_gg":"Wtaunu_vbf_gg","vbf_vbf":"Wtaunu_vbf_vbf"}
W2jetsfakeChannels={"preselection0Jet":"W2jets_preselection0Jet","preselection1Jet":"W2jets_preselection1Jet","preselection2Jet":"W2jets_preselection2Jet","gg":"W2jets_gg","boost":"W2jets_boost","vbf_gg":"W2jets_vbf_gg","vbf_vbf":"W2jets_vbf_vbf"}

ZmumufakeChannels={"preselection0Jet":"Zmumu_preselection0Jet","preselection1Jet":"Zmumu_preselection1Jet","preselection2Jet":"Zmumu_preselection2Jet","gg":"Zmumu_gg","boost":"Zmumu_boost","vbf_gg":"Zmumu_vbf_gg","vbf_vbf":"Zmumu_vbf_vbf"}
ZmumufakeChannelsnotIso={"preselection0Jet":"Zmumu_preselection0JetnotIso","preselection1Jet":"Zmumu_preselection1JetnotIso","preselection2Jet":"Zmumu_preselection2JetnotIso","gg":"Zmumu_ggnotIso","boost":"Zmumu_boostnotIso","vbf_gg":"Zmumu_vbf_ggnotIso","vbf_vbf":"Zmumu_vbf_vbfnotIso"}
ZllfakeChannelsnotIso={"preselection0Jet":"Zll_preselection0JetnotIso","preselection1Jet":"Zll_preselection1JetnotIso","preselection2Jet":"Zll_preselection2JetnotIso","gg":"Zll_ggnotIso","boost":"Zll_boostnotIso","vbf_gg":"Zll_vbf_ggnotIso","vbf_vbf":"Zll_vbf_vbfnotIso"}
ZllfakeChannels={"preselection0Jet":"Zll_preselection0Jet","preselection1Jet":"Zll_preselection1Jet","preselection2Jet":"Zll_preselection2Jet","gg":"Zll_gg","boost":"Zll_boost","vbf_gg":"Zll_vbf_gg","vbf_vbf":"Zll_vbf_vbf"}

poissonErrors=True
if "collMass_type1_1" in var:
	var = "collMass_type1"
if "none" in shift:
	shiftStr="" #Not JES,TES, etc.
#else:
#	if "FakesDown" in shift:
#		shiftStr = "_FakeShapeMuTauDown"
#	elif "FakesUp" in shift:
#		shiftStr = "_FakeShapeMuTauUp"
#	else:
#		shiftStr="_CMS_MET_"+shift #corresponds to name Daniel used in datacards
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
  #         if shift=='UESUpCheck':
  #	      shiftStr="_CMS_MET_"+"UESCheckUp" #corresponds to name Daniel used in datacards
  #         elif shift=='UESDownCheck':
 # 	      shiftStr="_CMS_MET_"+"UESCheckDown" #corresponds to name Daniel used in datacards
#	   else:
              shiftStr="_CMS_"+shift #corresponds to name Daniel used in datacards
rootdir = "mutau" #directory in datacard file
#rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau" #directory in datacard file

##########OPTIONS#########################
#blinded = True #not blinded
blinded = False #not blinded
#fillEmptyBins = True #empty bins filled
#fakeRate = False #apply fake rate method
fakeRate = True #apply fake rate method
QCDflag=False
fillEmptyBins = True #empty bins filled
shape_norm = False #normalize to 1 if True
#wjets_fakes=True
wjets_fakes=False
#DY_bin=True
DY_bin=False
#fakeallplot=True
fakeallplot=False
#drawdata=False
drawdata=True
highMass=True
Setlog=False
#Setlog=True
#highMass=False
#blinded = True #not blinded
#QCDflag=True

#directory names in datacard file
#if "preselection" in channel:
#	rootdir="mutau_preselection"
#if "vbf" in channel:
#	rootdir = "mutau_vbf"
#if "boost" in channel:
#	rootdir = "mutau_boost"
#if "gg" in channel:
#	rootdir = "mutau_gg"
channeltmp=channel.split("/")[0]
if channeltmp=="vbf":
	rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau"
if channeltmp=="vbf_gg":
	rootdir = "mutauh_2Jet_gg"
if channeltmp=="vbf_vbf":
	rootdir = "mutauh_2Jet_vbf"
if channeltmp=="boost":
	rootdir = "mutauh_1Jet"
if channeltmp=="gg":
	rootdir = "mutauh_0Jet"

canvas = ROOT.TCanvas("canvas","canvas",800,800)
canvas.cd()
#canvas.SetLogy()
if shape_norm == False:
        ynormlabel = " "
else:
        ynormlabel = "Normalized to 1 "

# Get parameters unique to each variable
getVarParams = "lfv_varsnew."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]

# binning for collinear mass
if ("collMass" in var or 'm_t_Mass' in var) and channel=='vbf_vbf':
	binwidth =25 
if ("collMass" in var or  'm_t_Mass' in var) and channel=='vbf_gg':
	binwidth =25 
if ("collMass" in var or  'm_t_Mass' in var) and channel=='gg':
	binwidth =10 
if ("collMass" in var or 'm_t_Mass' in var) and channel=='boost':
	binwidth =10 
#if "collMass" in var and "vbf" in channel:
#	binwidth = 20
if highMass and 'collMass_type1' in var:
        binwidth =array.array('d',[0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,230,250,270,300,330,360,390,425,460,500,540,580,630,690,750,810,900,1000,1200,1400])
#        binwidth =array.array('d',[0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,215,230,245,260,280,300,325,350,375,400,425,450,475,500,525,550,575,600,650,700,750,800,850,900,1000,1100,1200,1400])
elif "BDT" in var :
        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
elif ("collMass" or 'm_t_Mass' in var) in var and "preselection0Jet" in channel:
        binwidth = 10
elif ("collMass" in var or 'm_t_Mass' in var) and "preselection1Jet" in channel:
        binwidth = 10
elif ("collMass" in var or 'm_t_Mass' in var) and "preselection2Jet" in channel:
        binwidth = 25
elif ("collMass" in var or 'm_t_Mass' in var) and "preselection" in channel:
        binwidth =10 
#elif "BDT" in var and ("vbf_vbf"==channel or '2Jet_vbf' in channel):
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.28,-0.24,-0.20,-0.16,-0.12,-0.08,-0.04,0.0,0.04,0.08,0.12,0.16,0.20,0.24,0.30])
#elif "BDT" in var and ("vbf_gg"==channel or '2Jet' in channel):
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.28,-0.24,-0.20,-0.16,-0.12,-0.08,-0.04,0.0,0.04,0.08,0.12,0.16,0.20,0.24,0.30,])
#elif "BDT" in var and ("vbf"==channel or'2Jet_gg' in channel):
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.28,-0.24,-0.20,-0.16,-0.12,-0.08,-0.04,0.0,0.04,0.08,0.12,0.16,0.20,0.24,0.30])
#elif "BDT" in var and ("boost"==channel or '1Jet' in channel):
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.26,-0.20,-0.16,-0.12,-0.08,-0.04,0.0,0.04,0.08,0.12,0.16,0.22,0.30])
#elif "BDT" in var and ("gg"==channel or '0Jet' in channel) :
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.28,-0.22,-0.18,-0.14,-0.10,-0.06,-0.02,0.02,0.06,0.1,0.14,0.18,0.24,0.30])
#elif "BDT" in var and ("vbf_vbf"==channel or '2Jet_vbf' in channel):
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
#elif "BDT" in var and ("vbf_gg"==channel or '2Jet' in channel):
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
#elif "BDT" in var and ("vbf"==channel or'2Jet_gg' in channel):
#        binwidth =array.array('d',[-0.5,-0.42,-0.34,-0.28,-0.24,-0.20,-0.16,-0.12,-0.08,-0.04,0.0,0.04,0.08,0.12,0.16,0.20,0.24,0.30])
#elif "BDT" in var and ("boost"==channel or '1Jet' in channel):
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
#elif "BDT" in var and ("gg"==channel or '0Jet' in channel) :
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
#elif "BDT" in var and ("preselection" in channel) :
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])
#elif "BDT" in var and ("preslection" in channel) :
#        binwidth =array.array('d',[-0.5,-0.4,-0.3,-0.2,-0.1,-0.05,0.00,0.05,0.10,0.15,0.20,0.25,0.30])

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
#p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
#p_lfv.SetLeftMargin(0.2147651)
#p_lfv.SetRightMargin(0.06543624)
#p_lfv.SetTopMargin(0.04895105)
#p_lfv.SetBottomMargin(0.305)
#p_lfv.Draw()
#p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.295)
#p_ratio.SetLeftMargin(0.2147651)
#p_ratio.SetRightMargin(0.06543624)
#p_ratio.SetTopMargin(0.04895105)
#p_ratio.SetBottomMargin(0.295)
#p_ratio.SetGridy()
#p_ratio.Draw()
#p_lfv.cd()
#p_lfv.SetLogy()
lumidir = savedir+"weights/"
lumiScale = float(argv[4]) #lumi to scale to
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi

data2016B = make_histo(savedir,"data_SingleMuon_Run2016B", channel,var,lumidir,lumi,True,)
#data2016B.Sumw2()
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
#lowDataBin =1 
#highDataBin = data.GetNbinsX()#-1
#for i in range(1,data.GetNbinsX()+1):
#	if (data.GetBinContent(i) > 0):
#		lowDataBin = i
#		break
#for i in range(data.GetNbinsX(),0,-1):
#	if (data.GetBinContent(i) > 0):
#		highDataBin = i
#		break
channelNoral=channel
if ('13TeV' in shift) and not ('none' in shift) and not ('TauFakeRate' in shift):
   channelSys=channel+shift
   channel=channelSys
#if 'CMS' in shift:
#   channelSys=channel+'_'+shift
#   channel=channelSys
#print "line 423 %s " %channel
if 'scale_t' in shift:
  channel=channelNoral
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
zjetslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(zjets,lowDataBin,highDataBin)
z1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z1jets,lowDataBin,highDataBin)
z2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z2jets,lowDataBin,highDataBin)
z3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z3jets,lowDataBin,highDataBin)
z4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z4jets,lowDataBin,highDataBin)
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
vbfhmutau120 = make_histo(savedir,"VBF_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau120 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
vbfhmutau130 = make_histo(savedir,"VBF_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau130 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
vbfhmutau150 = make_histo(savedir,"VBF_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau150 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau200 = make_histo(savedir,"VBF_LFV_HToMuTau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
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
#print 'the number of tth is %f' %(smtthtt.Integral())
smhvbf.Add(smhwp)
smhvbf.Add(smhwm)
smhvbf.Add(smhzh)
smhvbf.Add(smtthtt)


#ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
#wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
#zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
#ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",channel,var,lumidir,lumi)
ttbar = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(ttbar,lowDataBin,highDataBin)
#ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",channel,var,lumidir,lumi)
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

if DY_bin:
   zmmjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannels[channel],var,lumidir,lumi)
   zmm1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannels[channel],var,lumidir,lumi)
   zmm2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannels[channel],var,lumidir,lumi)
   zmm3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannels[channel],var,lumidir,lumi)
   zmm4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannels[channel],var,lumidir,lumi)
   zmmjets.Add(zmm1jets)
   zmmjets.Add(zmm2jets)
   zmmjets.Add(zmm3jets)
   zmmjets.Add(zmm4jets)

#   print "before fakes the zmm number %f" %(zmmjets.Integral())
   zmmjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannelsnotIso[channel],var,lumidir,lumi)
   zmm1jetsfakes = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannelsnotIso[channel],var,lumidir,lumi)
   zmm2jetsfakes = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannelsnotIso[channel],var,lumidir,lumi)
   zmm3jetsfakes = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannelsnotIso[channel],var,lumidir,lumi)
   zmm4jetsfakes = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZmumufakeChannelsnotIso[channel],var,lumidir,lumi)
   zmmjetsfakes.Add(zmm1jetsfakes)
   zmmjetsfakes.Add(zmm2jetsfakes)
   zmmjetsfakes.Add(zmm3jetsfakes)
   zmmjetsfakes.Add(zmm4jetsfakes)
   zmmjetsfakes.Scale(-1)
   zmmjets.Add(zmmjetsfakes)
   
 #  print "after fakes the zmm number %f" %(zmmjets.Integral())

   zlljets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  ZllfakeChannels[channel],var,lumidir,lumi)
   zll1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannels[channel],var,lumidir,lumi)
   zll2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannels[channel],var,lumidir,lumi)
   zll3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannels[channel],var,lumidir,lumi)
   zll4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannels[channel],var,lumidir,lumi)
   zlljets.Add(zll1jets)
   zlljets.Add(zll2jets)
   zlljets.Add(zll3jets)
   zlljets.Add(zll4jets)
 #  print "before fakes the zll number %f" %(zlljets.Integral())
   zlljetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  ZllfakeChannelsnotIso[channel],var,lumidir,lumi)
   zll1jetsfakes = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannelsnotIso[channel],var,lumidir,lumi)
   zll2jetsfakes = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannelsnotIso[channel],var,lumidir,lumi)
   zll3jetsfakes = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannelsnotIso[channel],var,lumidir,lumi)
   zll4jetsfakes = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",ZllfakeChannelsnotIso[channel],var,lumidir,lumi)
   zlljetsfakes.Add(zll1jetsfakes)
   zlljetsfakes.Add(zll2jetsfakes)
   zlljetsfakes.Add(zll3jetsfakes)
   zlljetsfakes.Add(zll4jetsfakes)
   zlljetsfakes.Scale(-1)
   zlljets.Add(zlljetsfakes)
  # print "after fakes the zll number %f" %(zlljets.Integral())




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
  #do_binbybinQCD(wjetsQCDs,lowDataBin,highDataBin)
  w1jetsQCDs = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w1jetsQCDs,lowDataBin,highDataBin)
  w2jetsQCDs = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w2jetsQCDs,lowDataBin,highDataBin)
  w3jetsQCDs = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w3jetsQCDs,lowDataBin,highDataBin)
  w4jetsQCDs = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w4jetsQCDs,lowDataBin,highDataBin)
  wjetsQCDs.Add(w1jetsQCDs)
  wjetsQCDs.Add(w2jetsQCDs)
  wjetsQCDs.Add(w3jetsQCDs)
  wjetsQCDs.Add(w4jetsQCDs)
#  do_binbybinQCD(wjetsQCDs,lowDataBin,highDataBin)
  wjetsQCDs.Scale(-1)
  zjetsQCDs = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  zjetsQCDslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(zjetsQCDs,lowDataBin,highDataBin)
#  zjetsQCDs.Sumw2()
  z1jetsQCDs = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z1jetsQCDs,lowDataBin,highDataBin)
  z2jetsQCDs = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z2jetsQCDs,lowDataBin,highDataBin)
  z3jetsQCDs = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z3jetsQCDs,lowDataBin,highDataBin)
  z4jetsQCDs = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z4jetsQCDs,lowDataBin,highDataBin)
  zjetsQCDs.Add(z1jetsQCDs)
  zjetsQCDs.Add(z2jetsQCDs)
  zjetsQCDs.Add(z3jetsQCDs)
  zjetsQCDs.Add(z4jetsQCDs)
  zjetsQCDs.Add(zjetsQCDslow)
 # do_binbybinQCD(zjetsQCDs,lowDataBin,highDataBin)
  zjetsQCDs.Scale(-1)
  ztautauQCDs = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  ztautauQCDslow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
 # do_binbybinQCD(ztautauQCDs,lowDataBin,highDataBin)
  ztautau1QCDs = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
 # do_binbybinQCD(ztautau1QCDs,lowDataBin,highDataBin)
  ztautau2QCDs = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
 # do_binbybinQCD(ztautau2QCDs,lowDataBin,highDataBin)
  ztautau3QCDs = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
 # do_binbybinQCD(ztautau3QCDs,lowDataBin,highDataBin)
  ztautau4QCDs = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau4QCDs,lowDataBin,highDataBin)
  ztautauQCDs.Add(ztautau1QCDs)
  ztautauQCDs.Add(ztautau2QCDs)
  ztautauQCDs.Add(ztautau3QCDs)
  ztautauQCDs.Add(ztautau4QCDs)
  ztautauQCDs.Add(ztautauQCDslow)
 # do_binbybinQCD(ztautauQCDs,lowDataBin,highDataBin)
  ztautauQCDs.Scale(-1)
  #ttbarQCDs = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",QCDChannel,var,lumidir,lumi)
  #ttbarQCDs = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",QCDChannel,var,lumidir,lumi)
  ttbarQCDs = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ttbarQCDs,lowDataBin,highDataBin)
  ttbarQCDs.Scale(-1)
  vbfhmutau125QCDs = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(vbfhmutau125QCDs,lowDataBin,highDataBin)
  gghmutau125QCDs = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(gghmutau125QCDs,lowDataBin,highDataBin)
  vbfhmutau125QCDs.Scale(-0.01)
  gghmutau125QCDs.Scale(-0.01)
  smhvbfQCDs = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(smhvbfQCDs,lowDataBin,highDataBin)
  smhggQCDs = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(smhggQCDs,lowDataBin,highDataBin)
  smhwpQCDs = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhwmQCDs = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smhzhQCDs = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
  smtthttQCDs = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",QCDchannel,var,lumidir,lumi)
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
 # wwQCDs = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(wwQCDs,lowDataBin,highDataBin)
 # wzQCDs = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(wzQCDs,lowDataBin,highDataBin)
 # zzQCDs = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(zzQCDs,lowDataBin,highDataBin)

  St_tW_antiQCDs = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_tW_topQCDs = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_t_topQCDs = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
  St_t_antiQCDs = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
 # do_binbybinQCD(St_tW_topQCDs,lowDataBin,highDataBin)

  singletQCDs = St_tW_topQCDs.Clone()
  singletQCDs.Add(St_tW_antiQCDs)
  singletQCDs.Add(St_t_topQCDs)
  singletQCDs.Add(St_t_antiQCDs)
#  do_binbybinQCD(singletQCDs,lowDataBin,highDataBin)
  singletQCDs.Scale(-1)
  #dibosonQCDs = wwQCDs.Clone()
#  dibosonQCDs.Add(zzQCDs)
#  do_binbybinQCD(dibosonQCDs,lowDataBin,highDataBin)
  dibosonQCDs.Scale(-1)
  QCDs.Add(ttbarQCDs) #avoid double counting
  QCDs.Add(ztautauQCDs) #avoid double counting
  QCDs.Add(zjetsQCDs) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  QCDs.Add(wjetsQCDs) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  QCDs.Add(vbfhmutau125QCDs)
  QCDs.Add(gghmutau125QCDs)
  QCDs.Add(smhvbfQCDs)
  QCDs.Add(smhggQCDs)
  QCDs.Add(dibosonQCDs)
  QCDs.Add(singletQCDs)

#channelNoral=channel
#apply fake rate method
if (fakeRate == True):
  # change back to normal channels whatever
  channel=channelNoral
  fakechannel = fakeChannels[channel]
  fakechannelNoral=fakechannel
  print "fake channel at line 627 %s" %fakechannel
  if 'TauFakeRate' in shift:
     fakechannel=fakechannel+shift 
  #data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  #data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
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
 # wjets = data2015Cfakes.Clone()
 # wjets.Add(data2015Dfakes)
  wjets = data2016Bfakes.Clone()
 # if (not 'Jet' in shift) and not ('none' in shift) and  (not 'FakeshapeDM' in shift):
 #    fakechannelSys=fakechannel+shift
 #    fakechannel=fakechannelSys
 # if 'Jet' in shift:
 #    fakechannelSys=fakechannel+'_'+shift
 #    fakechannel=fakechannelSys
 # print "line 660 %s " %fakechannel
  zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  zjetsfakeslow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(zjetsfakes,lowDataBin,highDataBin)
  z1jetsfakes = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(z1jetsfakes,lowDataBin,highDataBin)
  z2jetsfakes = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(z2jetsfakes,lowDataBin,highDataBin)
  z3jetsfakes = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(z3jetsfakes,lowDataBin,highDataBin)
  z4jetsfakes = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(z4jetsfakes,lowDataBin,highDataBin)
  zjetsfakes.Add(z1jetsfakes) 
  zjetsfakes.Add(z2jetsfakes) 
  zjetsfakes.Add(z3jetsfakes) 
  zjetsfakes.Add(z4jetsfakes) 
  zjetsfakes.Add(zjetsfakeslow) 
  zjetsfakes.Scale(-1)
  ztautaufakes = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautaufakeslow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautaufakes,lowDataBin,highDataBin)
  ztautau1fakes = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau1fakes,lowDataBin,highDataBin)
  ztautau2fakes = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau2fakes,lowDataBin,highDataBin)
  ztautau3fakes = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau3fakes,lowDataBin,highDataBin)
  ztautau4fakes = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau4fakes,lowDataBin,highDataBin)
  ztautaufakes.Add(ztautau1fakes)
  ztautaufakes.Add(ztautau2fakes)
  ztautaufakes.Add(ztautau3fakes)
  ztautaufakes.Add(ztautau4fakes)
  ztautaufakes.Add(ztautaufakeslow)
  ztautaufakes.Scale(-1.)
 # ztautau.Add(ztautaufakes) #avoid double counting
  #ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
#  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",fakechannel,var,lumidir,lumi)
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
#  wwfakes = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",fakechannel,var,lumidir,lumi)
#  wzfakes = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",fakechannel,var,lumidir,lumi)
#  zzfakes = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",fakechannel,var,lumidir,lumi)
#  wwfakes.Add(wzfakes)
#  wwfakes.Add(zzfakes)
#  wwfakes.Scale(-1)
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
  wjets.Add(St_tW_antifakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(dibosonfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(smhvbffakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(zjetsfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(ztautaufakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(ttbarfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjets.Add(WGstarNMMfakes)
#  zjets.Add(zjetsfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
#  ttbar.Add(ttbarfakes) #avoid double counting



  fakeMchannel = fakeMChannels[channel]
  fakeMchannelNoral=fakeMchannel
  if 'TauFakeRate' in shift:
     fakeMchannel=fakeMchannel+shift 
  #data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  #data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  data2016BfakesM = make_histo(savedir,"data_SingleMuon_Run2016B", fakeMchannel,var,lumidir,lumi,True,)
  data2016CfakesM = make_histo(savedir,"data_SingleMuon_Run2016C", fakeMchannel,var,lumidir,lumi,True,)
  data2016DfakesM = make_histo(savedir,"data_SingleMuon_Run2016D", fakeMchannel,var,lumidir,lumi,True,)
  data2016EfakesM = make_histo(savedir,"data_SingleMuon_Run2016E", fakeMchannel,var,lumidir,lumi,True,)
  data2016FfakesM = make_histo(savedir,"data_SingleMuon_Run2016F", fakeMchannel,var,lumidir,lumi,True,)
  data2016GfakesM = make_histo(savedir,"data_SingleMuon_Run2016G", fakeMchannel,var,lumidir,lumi,True,)
  data2016HfakesM = make_histo(savedir,"data_SingleMuon_Run2016H", fakeMchannel,var,lumidir,lumi,True,)
  data2016BfakesM.Add(data2016CfakesM)
  data2016BfakesM.Add(data2016DfakesM)
  data2016BfakesM.Add(data2016EfakesM)
  data2016BfakesM.Add(data2016FfakesM)
  data2016BfakesM.Add(data2016GfakesM)
  data2016BfakesM.Add(data2016HfakesM)
 # wjets = data2015CfakesM.Clone()
 # wjets.Add(data2015DfakesM)
  wjetsM = data2016BfakesM.Clone()
#  print "fakeM line 736 %s" %fakeMchannel
#  if (not 'Jet' in shift) and not ('none' in shift) and (not 'FakeshapeDM' in shift):
#     fakeMchannelSys=fakeMchannel+shift
#     fakeMchannel=fakeMchannelSys
#  if 'Jet' in shift:
#     fakeMchannelSys=fakeMchannel+'_'+shift
#     fakeMchannel=fakeMchannelSys
#  print "fakeMchannel line 742 %s " %fakeMchannel
  zjetsfakesM = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMchannel,var,lumidir,lumi)
  zjetsfakesMlow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(zjetsfakesM,lowDataBin,highDataBin)
  z1jetsfakesM = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(z1jetsfakesM,lowDataBin,highDataBin)
  z2jetsfakesM = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(z2jetsfakesM,lowDataBin,highDataBin)
  z3jetsfakesM = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(z3jetsfakesM,lowDataBin,highDataBin)
  z4jetsfakesM = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(z4jetsfakesM,lowDataBin,highDataBin)
  zjetsfakesM.Add(z1jetsfakesM) 
  zjetsfakesM.Add(z2jetsfakesM) 
  zjetsfakesM.Add(z3jetsfakesM) 
  zjetsfakesM.Add(z4jetsfakesM) 
  zjetsfakesM.Add(zjetsfakesMlow) 
  zjetsfakesM.Scale(-1)
  ztautaufakesM = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
  ztautaufakesMlow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautaufakesM,lowDataBin,highDataBin)
  ztautau1fakesM = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau1fakesM,lowDataBin,highDataBin)
  ztautau2fakesM = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau2fakesM,lowDataBin,highDataBin)
  ztautau3fakesM = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau3fakesM,lowDataBin,highDataBin)
  ztautau4fakesM = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau4fakesM,lowDataBin,highDataBin)
  ztautaufakesM.Add(ztautau1fakesM)
  ztautaufakesM.Add(ztautau2fakesM)
  ztautaufakesM.Add(ztautau3fakesM)
  ztautaufakesM.Add(ztautau4fakesM)
  ztautaufakesM.Add(ztautaufakesMlow)
  ztautaufakesM.Scale(-1)
  #ztautau.Add(ztautaufakesM) #avoid double counting
  #ttbarfakesM = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakeMchannel,var,lumidir,lumi)
  ttbarfakesM = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakeMchannel,var,lumidir,lumi)
#  ttbarfakesM = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",fakechannel,var,lumidir,lumi)
  ttbarfakesM.Scale(-1)
  smhvbffakesM = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)  
  smhggfakesM = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  smhvbffakesM.Add(smhggfakesM)
  smhwpfakesM = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  smhwmfakesM = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  smhzhfakesM = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",fakeMchannel,var,lumidir,lumi)
  smtthttfakesM = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  smhvbffakesM.Add(smhwpfakesM)
  smhvbffakesM.Add(smhwmfakesM)
  smhvbffakesM.Add(smhzhfakesM)
  smhvbffakesM.Add(smtthttfakesM)
  smhvbffakesM.Scale(-1)

  WGstarNEEfakesM = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",fakeMchannel,var,lumidir,lumi)
  WGstarNMMfakesM = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",fakeMchannel,var,lumidir,lumi)
  WGLNGfakesM = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakeMchannel,var,lumidir,lumi)
  WGstarNMMfakesM.Add(WGstarNEEfakesM)
  WGstarNMMfakesM.Add(WGLNGfakesM)
  WGstarNMMfakesM.Scale(-1)

  vvfakesM=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  wwTo1L1Nu2QfakesM=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  wzJToLLLNufakesM=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",fakeMchannel,var,lumidir,lumi)
  wzTo1L1Nu2QfakesM=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  wzTo1L3NufakesM=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  wzTo2L2QfakesM=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  zzTo2L2QfakesM=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMchannel,var,lumidir,lumi)
  zzTo4LfakesM=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",fakeMchannel,var,lumidir,lumi)
  dibosonfakesM = vvfakesM.Clone()
  dibosonfakesM.Add(wwTo1L1Nu2QfakesM)
  dibosonfakesM.Add(wzJToLLLNufakesM)
  dibosonfakesM.Add(wzTo1L1Nu2QfakesM)
  dibosonfakesM.Add(wzTo1L3NufakesM)
  dibosonfakesM.Add(wzTo2L2QfakesM)
  dibosonfakesM.Add(zzTo2L2QfakesM)
  dibosonfakesM.Add(zzTo4LfakesM)
  dibosonfakesM.Scale(-1)
  #wwfakesM = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",fakeMchannel,var,lumidir,lumi)
  #wzfakesM = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",fakeMchannel,var,lumidir,lumi)
  #zzfakesM = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",fakeMchannel,var,lumidir,lumi)
  #wwfakesM.Add(wzfakesM)
  #wwfakesM.Add(zzfakesM)
  #wwfakesM.Scale(-1)
  St_tW_antifakesM = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  St_tW_topfakesM = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  St_t_topfakesM = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  St_t_antifakesM = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMchannel,var,lumidir,lumi)
  St_tW_antifakesM.Add(St_tW_topfakesM)
  St_tW_antifakesM.Add(St_t_topfakesM)
  St_tW_antifakesM.Add(St_t_antifakesM)
  St_tW_antifakesM.Scale(-1)
  wjetsM.Add(St_tW_antifakesM) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsM.Add(dibosonfakesM) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsM.Add(smhvbffakesM) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
#  ttbar.Add(ttbarfakesM) #avoid double counting
  wjetsM.Add(zjetsfakesM) #avoid double counting  say besides the fakesM from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsM.Add(ztautaufakesM) #avoid double counting  say besides the fakesM from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsM.Add(ttbarfakesM) #avoid double counting  say besides the fakesM from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsM.Add(WGstarNMMfakesM) #avoid double counting  say besides the fakesM from DY, and ztautau,ttbar, then the remainning is wjets
#  zjets.Add(zjetsfakesM) #avoid double counting  say besides the fakesM from DY, and ztautau,ttbar, then the remainning is wjets
  

  fakeMTchannel = fakeMTChannels[channel]
  fakeMTchannelNoral=fakeMTchannel
  if 'TauFakeRate' in shift:
     fakeMTchannel=fakeMTchannel+shift 
  #data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  #data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  data2016BfakesMT = make_histo(savedir,"data_SingleMuon_Run2016B", fakeMTchannel,var,lumidir,lumi,True,)
  data2016CfakesMT = make_histo(savedir,"data_SingleMuon_Run2016C", fakeMTchannel,var,lumidir,lumi,True,)
  data2016DfakesMT = make_histo(savedir,"data_SingleMuon_Run2016D", fakeMTchannel,var,lumidir,lumi,True,)
  data2016EfakesMT = make_histo(savedir,"data_SingleMuon_Run2016E", fakeMTchannel,var,lumidir,lumi,True,)
  data2016FfakesMT = make_histo(savedir,"data_SingleMuon_Run2016F", fakeMTchannel,var,lumidir,lumi,True,)
  data2016GfakesMT = make_histo(savedir,"data_SingleMuon_Run2016G", fakeMTchannel,var,lumidir,lumi,True,)
  data2016HfakesMT = make_histo(savedir,"data_SingleMuon_Run2016H", fakeMTchannel,var,lumidir,lumi,True,)
  data2016BfakesMT.Add(data2016CfakesMT)
  data2016BfakesMT.Add(data2016DfakesMT)
  data2016BfakesMT.Add(data2016EfakesMT)
  data2016BfakesMT.Add(data2016FfakesMT)
  data2016BfakesMT.Add(data2016GfakesMT)
  data2016BfakesMT.Add(data2016HfakesMT)
 # wjets = data2015CfakesMT.Clone()
 # wjets.Add(data2015DfakesMT)
  wjetsMT = data2016BfakesMT.Clone()
#  if (not 'Jet' in shift) and not ('none' in shift) and (not 'FakeshapeDM' in shift):
#     fakeMTchannelSys=fakeMTchannel+shift
#     fakeMTchannel=fakeMTchannelSys
#  if 'Jet' in shift:
#     fakeMTchannelSys=fakeMTchannel+'_'+shift
#     fakeMTchannel=fakeMTchannelSys
#  print "fakeMTchannel line 829 %s " %fakeMTchannel
  zjetsfakesMT = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMTchannel,var,lumidir,lumi)
  zjetsfakesMTlow = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",  fakeMTchannel,var,lumidir,lumi)
  z1jetsfakesMT = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(z1jetsfakesMT,lowDataBin,highDataBin)
  z2jetsfakesMT = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(z2jetsfakesMT,lowDataBin,highDataBin)
  z3jetsfakesMT = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(z3jetsfakesMT,lowDataBin,highDataBin)
  z4jetsfakesMT = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(z4jetsfakesMT,lowDataBin,highDataBin)
  zjetsfakesMT.Add(z1jetsfakesMT) 
  zjetsfakesMT.Add(z2jetsfakesMT) 
  zjetsfakesMT.Add(z3jetsfakesMT) 
  zjetsfakesMT.Add(z4jetsfakesMT)
  zjetsfakesMT.Add(zjetsfakesMTlow)
  zjetsfakesMT.Scale(-1) 
  ztautaufakesMT = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
  ztautaufakesMTlow = make_histo(savedir,"ZTauTauJetsToLL_M-10to50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautaufakesMT,lowDataBin,highDataBin)
  ztautau1fakesMT = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau1fakesMT,lowDataBin,highDataBin)
  ztautau2fakesMT = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau2fakesMT,lowDataBin,highDataBin)
  ztautau3fakesMT = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau3fakesMT,lowDataBin,highDataBin)
  ztautau4fakesMT = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakeMTchannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau4fakesMT,lowDataBin,highDataBin)
  ztautaufakesMT.Add(ztautau1fakesMT)
  ztautaufakesMT.Add(ztautau2fakesMT)
  ztautaufakesMT.Add(ztautau3fakesMT)
  ztautaufakesMT.Add(ztautau4fakesMT)
  ztautaufakesMT.Add(ztautaufakesMTlow)
  ztautaufakesMT.Scale(-1) 
 # ztautau.Add(ztautaufakesMT) #avoid double counting
  #ttbarfakesMT = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakeMTchannel,var,lumidir,lumi)
  ttbarfakesMT = make_histo(savedir,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",fakeMTchannel,var,lumidir,lumi)
  ttbarfakesMT.Scale(-1) 
  smhvbffakesMT = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)  
  smhggfakesMT = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  smhvbffakesMT.Add(smhggfakesMT)
  smhwpfakesMT = make_histo(savedir,"WplusHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  smhwmfakesMT = make_histo(savedir,"WminusHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  smhzhfakesMT = make_histo(savedir,"ZHToTauTau_M125_13TeV_powheg_pythia8",fakeMTchannel,var,lumidir,lumi)
  smtthttfakesMT = make_histo(savedir,"ttHJetToTT_M125_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  smhvbffakesMT.Add(smhwpfakesMT)
  smhvbffakesMT.Add(smhwmfakesMT)
  smhvbffakesMT.Add(smhzhfakesMT)
  smhvbffakesMT.Add(smtthttfakesMT)
  smhvbffakesMT.Scale(-1)

  WGstarNEEfakesMT = make_histo(savedir,"WGstarToLNuEE_13TeV-madgraph",fakeMTchannel,var,lumidir,lumi)
  WGstarNMMfakesMT = make_histo(savedir,"WGstarToLNuMuMu_13TeV-madgraph",fakeMTchannel,var,lumidir,lumi)
  WGLNGfakesMT = make_histo(savedir,"WGToLNuG_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakeMTchannel,var,lumidir,lumi)
  WGstarNMMfakesMT.Add(WGstarNEEfakesMT)
  WGstarNMMfakesMT.Add(WGLNGfakesMT)
  WGstarNMMfakesMT.Scale(-1)

  vvfakesMT=make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  wwTo1L1Nu2QfakesMT=make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  wzJToLLLNufakesMT=make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",fakeMTchannel,var,lumidir,lumi)
  wzTo1L1Nu2QfakesMT=make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  wzTo1L3NufakesMT=make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  wzTo2L2QfakesMT=make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  zzTo2L2QfakesMT=make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",fakeMTchannel,var,lumidir,lumi)
  zzTo4LfakesMT=make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",fakeMTchannel,var,lumidir,lumi)
  dibosonfakesMT = vvfakesMT.Clone()
  dibosonfakesMT.Add(wwTo1L1Nu2QfakesMT)
  dibosonfakesMT.Add(wzJToLLLNufakesMT)
  dibosonfakesMT.Add(wzTo1L1Nu2QfakesMT)
  dibosonfakesMT.Add(wzTo1L3NufakesMT)
  dibosonfakesMT.Add(wzTo2L2QfakesMT)
  dibosonfakesMT.Add(zzTo2L2QfakesMT)
  dibosonfakesMT.Add(zzTo4LfakesMT)
  dibosonfakesMT.Scale(-1)
#  wwfakesMT = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",fakeMTchannel,var,lumidir,lumi)
#  wzfakesMT = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",fakeMTchannel,var,lumidir,lumi)
#  zzfakesMT = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",fakeMTchannel,var,lumidir,lumi)
#  wwfakesMT.Add(wzfakesMT)
#  wwfakesMT.Add(zzfakesMT)
#  wwfakesMT.Scale(-1)
  St_tW_antifakesMT = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  St_tW_topfakesMT = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  St_t_topfakesMT = make_histo(savedir,"ST_t-channel_top_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  St_t_antifakesMT = make_histo(savedir,"ST_t-channel_antitop_4f_inclusiveDecays_13TeV-powhegV2-madspin-pythia8_TuneCUETP8M1",fakeMTchannel,var,lumidir,lumi)
  St_tW_antifakesMT.Add(St_tW_topfakesMT)
  St_tW_antifakesMT.Add(St_t_topfakesMT)
  St_tW_antifakesMT.Add(St_t_antifakesMT)
  St_tW_antifakesMT.Scale(-1)
  wjetsMT.Add(St_tW_antifakesMT) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsMT.Add(dibosonfakesMT) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsMT.Add(smhvbffakesMT) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
#  ttbarfakesMT = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",fakechannel,var,lumidir,lumi)
#  ttbar.Add(ttbarfakesMT) #avoid double counting
  wjetsMT.Add(zjetsfakesMT) #avoid double counting  say besides the fakesMT from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsMT.Add(ztautaufakesMT) #avoid double counting  say besides the fakesMT from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsMT.Add(ttbarfakesMT) #avoid double counting  say besides the fakesMT from DY, and ztautau,ttbar, then the remainning is wjets
  wjetsMT.Add(WGstarNMMfakesMT) #avoid double counting  say besides the fakesMT from DY, and ztautau,ttbar, then the remainning is wjets
#  zjets.Add(zjetsfakesMT) #avoid double counting  say besides the fakesMT from DY, and ztautau,ttbar, then the remainning is wjets
else: #if fakeRate==False
  #wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
  if wjets_fakes==False :
     wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#     wjets.Sumw2()
   #  do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     w1jets = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
   #  do_binbybin(w1jets,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     w2jets = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
   #  do_binbybin(w2jets,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     w3jets = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
   #  do_binbybin(w3jets,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     w4jets = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
   #  do_binbybin(w4jets,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     wjets.Add(w1jets)
     wjets.Add(w2jets)
     wjets.Add(w3jets)
     wjets.Add(w4jets)
     if QCDflag==True:
        QCDs.Scale(1.06)
#	do_binbybinQCD(QCDs,lowDataBin,highDataBin)
  else:
     wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     wjets.Sumw2()
     w1jets = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w2jets = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w3jets = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     w4jets = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     wjets.Add(w1jets)
     wjets.Add(w2jets)
     wjets.Add(w3jets)
     wjets.Add(w4jets)


     wjetsWmunu = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WmunufakeChannels[channel],var,lumidir,lumi)
     wjetsWmunu.Sumw2()
     w1jetsWmunu = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WmunufakeChannels[channel],var,lumidir,lumi)
     w2jetsWmunu = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WmunufakeChannels[channel],var,lumidir,lumi)
     w3jetsWmunu = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WmunufakeChannels[channel],var,lumidir,lumi)
     w4jetsWmunu = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WmunufakeChannels[channel],var,lumidir,lumi)
     wjetsWmunu.Add(w1jetsWmunu)
     wjetsWmunu.Add(w2jetsWmunu)
     wjetsWmunu.Add(w3jetsWmunu)
     wjetsWmunu.Add(w4jetsWmunu)
     
     wjetsWtaunu = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WtaunufakeChannels[channel],var,lumidir,lumi)
     wjetsWtaunu.Sumw2()
     w1jetsWtaunu = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WtaunufakeChannels[channel],var,lumidir,lumi)
     w2jetsWtaunu = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WtaunufakeChannels[channel],var,lumidir,lumi)
     w3jetsWtaunu = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WtaunufakeChannels[channel],var,lumidir,lumi)
     w4jetsWtaunu = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",WtaunufakeChannels[channel],var,lumidir,lumi)
     wjetsWtaunu.Add(w1jetsWtaunu)
     wjetsWtaunu.Add(w2jetsWtaunu)
     wjetsWtaunu.Add(w3jetsWtaunu)
     wjetsWtaunu.Add(w4jetsWtaunu)


     wjetsW2jets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",W2jetsfakeChannels[channel],var,lumidir,lumi)
     wjetsW2jets.Sumw2()
     w1jetsW2jets = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",W2jetsfakeChannels[channel],var,lumidir,lumi)
     w2jetsW2jets = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",W2jetsfakeChannels[channel],var,lumidir,lumi)
     w3jetsW2jets = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",W2jetsfakeChannels[channel],var,lumidir,lumi)
     w4jetsW2jets = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",W2jetsfakeChannels[channel],var,lumidir,lumi)
     wjetsW2jets.Add(w1jetsW2jets)
     wjetsW2jets.Add(w2jetsW2jets)
     wjetsW2jets.Add(w3jetsW2jets)
     wjetsW2jets.Add(w4jetsW2jets)
     if QCDflag==True:
        QCDs.Scale(1.06)
#     wjets.Add(QCDs)

#diboson = ww.Clone()
#diboson.Add(wz)
#diboson.Add(zz)

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
#Set bin widths
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
   data=data.Rebin(len(binwidth)-1,'',binwidth)
#   print binwidth
else:
   data.Rebin(binwidth)
#if (fakeRate == True):
if QCDflag==True:
   QCDs.Rebin(binwidth)
if (fakeRate ==False and wjets_fakes==True):
   wjetsWtaunu.Rebin(binwidth)
   wjetsWmunu.Rebin(binwidth)
   wjetsW2jets.Rebin(binwidth)
#fakerelated
if fakeallplot and fakeRate:
   wjetsMT.Scale(-1)
   print "in the middle Tau %f" %wjets.Integral()
#   wjets.Add(wjetsMT)
   print "in the middle Muonfake %f" %wjetsM.Integral()
   wjetsM.Add(wjetsMT)
   print "in the middle after -  Muonfake %f" %wjetsM.Integral()
   wjetsMT.Scale(-1)
   print "in the middle overlape %f" %wjetsMT.Integral()
   wjetsM.Rebin(binwidth)
   wjetsMT.Rebin(binwidth)
   wjets.Rebin(binwidth)
if (not fakeallplot) and fakeRate:
   wjetsMT.Scale(-1)
   #wjetsM.Scale(-1)
   wjetsM.Add(wjetsMT)
   do_binbybinQCD(wjetsM,lowDataBin,highDataBin)
   print 'the muons fakes contribtuion    %f'   %(wjetsM.Integral())
   print 'the overlap and tau fake contribution %f'   %(wjets.Integral())
   #wjets.Add(wjetsMT)
#   wjets.Add(wjetsM)
   print "the finally fake number %f" %wjets.Integral()
  # wjets=wjetsM
  # wjets.Add(wjetsMT)
   if ('BDT' in var) or (highMass and 'collMass_type1' in var) :
      wjets=wjets.Rebin(len(binwidth)-1,'',binwidth)
#   print binwidth
   else:
      wjets.Rebin(binwidth)
  # wjetsM.Rebin(binwidth)
   #wjetsMT.Rebin(binwidth)
if (not fakeallplot) and (not fakeRate):
   wjets.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    zjets=zjets.Rebin(len(binwidth)-1,'',binwidth)
else:
    zjets.Rebin(binwidth)
if DY_bin:
   zmmjets.Rebin(binwidth)
   zlljets.Rebin(binwidth)

if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    ztautau=ztautau.Rebin(len(binwidth)-1,'',binwidth)
else:
    ztautau.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    ttbar=ttbar.Rebin(len(binwidth)-1,'',binwidth)
else:
    ttbar.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    diboson=diboson.Rebin(len(binwidth)-1,'',binwidth)
else:
   diboson.Rebin(binwidth)
#if 'BDT' in var:
#    ww=ww.Rebin(len(binwidth)-1,'',binwidth)
#else:
#    ww.Rebin(binwidth)
#if 'BDT' in var:
#    wz=wz.Rebin(len(binwidth)-1,'',binwidth)
#else:
#    wz.Rebin(binwidth)
#if 'BDT' in var:
#    zz=zz.Rebin(len(binwidth)-1,'',binwidth)
#else:
#    zz.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    singlet=singlet.Rebin(len(binwidth)-1,'',binwidth)
else:
    singlet.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    smhgg=smhgg.Rebin(len(binwidth)-1,'',binwidth)
else:
    smhgg.Rebin(binwidth)
if ('BDT' in var) or (highMass and 'collMass_type1' in var):
    gghmutau125=gghmutau125.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau120=gghmutau120.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau130=gghmutau130.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau150=gghmutau150.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau200=gghmutau200.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau300=gghmutau300.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau450=gghmutau450.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau600=gghmutau600.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau750=gghmutau750.Rebin(len(binwidth)-1,'',binwidth)
    gghmutau900=gghmutau900.Rebin(len(binwidth)-1,'',binwidth)
    WGstarNMM=WGstarNMM.Rebin(len(binwidth)-1,'',binwidth)
else:
    gghmutau125.Rebin(binwidth)
    gghmutau120.Rebin(binwidth)
    gghmutau130.Rebin(binwidth)
    gghmutau150.Rebin(binwidth)
    gghmutau200.Rebin(binwidth)
    gghmutau300.Rebin(binwidth)
    gghmutau450.Rebin(binwidth)
    gghmutau600.Rebin(binwidth)
    gghmutau750.Rebin(binwidth)
    gghmutau900.Rebin(binwidth)
    WGstarNMM.Rebin(binwidth)
if 'BDT' in var or (highMass and 'collMass_type1' in var):
    smhvbf=smhvbf.Rebin(len(binwidth)-1,'',binwidth)
else:
    smhvbf.Rebin(binwidth)
if 'BDT' in var or (highMass and 'collMass_type1' in var):
    vbfhmutau125=vbfhmutau125.Rebin(len(binwidth)-1,'',binwidth)
    vbfhmutau120=vbfhmutau120.Rebin(len(binwidth)-1,'',binwidth)
    vbfhmutau130=vbfhmutau130.Rebin(len(binwidth)-1,'',binwidth)
    vbfhmutau150=vbfhmutau150.Rebin(len(binwidth)-1,'',binwidth)
#    vbfhmutau200=vbfhmutau200.Rebin(len(binwidth)-1,'',binwidth)
    #print '********************%f'  %(vbfhmutau125.GetNbinsX())
else:
    vbfhmutau125.Rebin(binwidth)
    vbfhmutau120.Rebin(binwidth)
    vbfhmutau130.Rebin(binwidth)
    vbfhmutau150.Rebin(binwidth)
 #   vbfhmutau200.Rebin(binwidth)

if RUN_OPTIMIZATION ==1:
   outfile_name = savedir+"LFV"+"_"+channel.split("/",1)[0]+channel.split("/",1)[1]+"_"+var+"_"+shiftStr
else:
   outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr
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
outfile = ROOT.TFile(outfile_name+".root","RECREATE")

outfile.mkdir(rootdir)
outfile.cd(rootdir+"/")
if blinded == False:
	#if not ("Jet" in savedir or "UES" in savedir or "TES" in savedir or "Fakes" in savedir or "Fakes" in shiftStr):
	if not ("Jet" in shift or "UES" in shift or "TES" in shift or 'MFT' in shift or "Fakes" in shift or "Fakes" in shift or "MES" in shift):
        	data.Write("data_obs")

if ("collMass" in var or "m_t_Mass" in var or 'type1_pfMetEtNormal' in var or 'type1_pfMetEt' in var):
  #binLow = data.FindBin(100)
  #binHigh = data.FindBin(150)+1
  binLow = data.FindBin(100)
  binHigh = data.FindBin(1400)+1
if ("BDT" in var):
  binLow1 = data.FindBin(-0.1)
  binHigh1 = data.FindBin(0.3)+1
#binLow = data.FindBin(100)
#binHigh = data.FindBin(150)+1
if blinded == True:
        #if not ("Jet" in shift or "MES" in shift or "UES" in shift or "TES" in shift or 'MFT' in shift  or "Fakes" in shift or ("preselection" in shift and "Jet" in shift) or "Fakes" in shift or 'Pileup' in shift):
        #        data.Write("data_obs")
        if 'none' in shift:
                data.Write("data_obs")
#enum EColor { kWhite =0,   kBlack =1,   kGray=920,
#              kRed   =632, kGreen =416, kBlue=600, kYellow=400, kMagenta=616, kCyan=432,
#              kOrange=800, kSpring=820, kTeal=840, kAzure =860, kViolet =880, kPink=900 };

#Plotting options (not to be used for final plots)
data.SetMarkerStyle(20)
data.SetMarkerSize(1)
#data.SetLineColor(ROOT.EColor.kBlack)
data.SetLineColor(1)
#gghmutau125.SetLineColor(ROOT.EColor.kRed)
gghmutau125.SetLineColor(632)
gghmutau125.SetLineWidth(3)
gghmutau120.SetLineColor(400+4)
gghmutau120.SetLineWidth(3)
gghmutau130.SetLineColor(416-5)
gghmutau130.SetLineWidth(3)
gghmutau150.SetLineColor(600-5)
gghmutau150.SetLineWidth(3)
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
#vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineColor(600)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(3)
#smhvbf.SetLineColor(ROOT.EColor.kMagenta)
#smhvbf.SetFillColor(ROOT.EColor.kMagenta)
smhvbf.SetLineColor(616)
smhvbf.SetFillColor(616)
smhgg.SetLineWidth(1)
smhgg.SetLineColor(1)
smhgg.SetMarkerSize(0)
smhgg.SetFillColor(880+1)
wjets.SetFillColor(616-10)
wjets.SetLineColor(1)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
if (QCDflag == True):
   QCDs.SetFillColor(221)
   QCDs.SetLineColor(221)
   QCDs.SetLineWidth(1)
   QCDs.SetMarkerSize(0)
if fakeallplot:
   wjetsM.SetFillColor(225)
   wjetsM.SetLineColor(225)
   wjetsM.SetLineWidth(1)
   wjetsM.SetMarkerSize(0)
   wjetsMT.SetFillColor(210)
   wjetsMT.SetLineColor(210)
   wjetsMT.SetLineWidth(1)
   wjetsMT.SetMarkerSize(0)
if (fakeRate ==False and wjets_fakes==True):
   wjetsWtaunu.SetFillColor(225)
   wjetsWtaunu.SetLineColor(225)
   wjetsWtaunu.SetLineWidth(1)
   wjetsWtaunu.SetMarkerSize(0)
   wjetsWmunu.SetFillColor(224)
   wjetsWmunu.SetLineColor(224)
   wjetsWmunu.SetLineWidth(1)
   wjetsWmunu.SetMarkerSize(0)
   wjetsW2jets.SetFillColor(212)
   wjetsW2jets.SetLineColor(212)
   wjetsW2jets.SetLineWidth(1)
   wjetsW2jets.SetMarkerSize(0)
if DY_bin:
   zmmjets.SetFillColor(600)
   zmmjets.SetLineColor(600)
   zmmjets.SetLineWidth(1)
   zmmjets.SetMarkerSize(0)
   do_binbybinQCD(zmmjets,lowDataBin,highDataBin)
   zlljets.SetFillColor(600+3)
   zlljets.SetLineColor(600+3)
   zlljets.SetLineWidth(1)
   zlljets.SetMarkerSize(0)
   do_binbybinQCD(zlljets,lowDataBin,highDataBin)
#ztautau.SetFillColor(ROOT.EColor.kOrange-4)
#ztautau.SetLineColor(ROOT.EColor.kOrange+4)
ztautau.SetFillColor(800-4)
ztautau.SetLineColor(1)
ztautau.SetLineWidth(1)
ztautau.SetMarkerSize(0)
#zjets.SetFillColor(ROOT.EColor.kAzure+3)
#zjets.SetLineColor(ROOT.EColor.kAzure+3)
#zjets should be kAzure+4?
zjets.SetFillColor(860+5)
zjets.SetLineColor(1)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
#ttbar.SetFillColor(ROOT.EColor.kGreen+3)
#ttbar.SetLineColor(ROOT.EColor.kBlack)
#TTbar new kblue -6
ttbar.SetFillColor(600-8)
ttbar.SetLineColor(1)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
#diboson.SetFillColor(ROOT.EColor.kRed+2)
#diboson.SetLineColor(ROOT.EColor.kRed+4)
#new diboson kXyan-7
diboson.SetFillColor(432-6)
diboson.SetLineColor(1)
diboson.SetLineWidth(1)
diboson.SetMarkerSize(0)
#singlet.SetFillColor(ROOT.EColor.kGreen+4)
#singlet.SetLineColor(ROOT.EColor.kBlack)
singlet.SetFillColor(416+4)
singlet.SetLineColor(1)
singlet.SetLineWidth(1)
singlet.SetMarkerSize(0)

#lowDataBin =1 
#highDataBin = data.GetNbinsX()#-1
#for i in range(1,data.GetNbinsX()+1):
#	if (data.GetBinContent(i) > 0):
#		lowDataBin = i
#		break
#for i in range(data.GetNbinsX(),0,-1):
#	if (data.GetBinContent(i) > 0):
#		highDataBin = i
#		break

#fill empty bins
if fakeallplot:
   do_binbybinQCD(wjetsMT,lowDataBin,highDataBin)
   do_binbybinQCD(wjetsM,lowDataBin,highDataBin)
if fakeRate == False:
	do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
	do_binbybinQCD(QCDs,lowDataBin,highDataBin)
else:

	do_binbybinQCD(wjets,lowDataBin,highDataBin)
#print "Before Bin by Bin"
##for i in range(1,ztautau.GetNbinsX()+1):
#print "Ztautau Bin content=%f; Bin error=%f" %(ztautau.GetBinContent(4),ztautau.GetBinError(4))
#print "Zjets Bin content=%f; Bin error=%f" %(zjets.GetBinContent(4),zjets.GetBinError(4))
#print "diboson Bin content=%f; Bin error=%f" %(diboson.GetBinContent(4),diboson.GetBinError(4))
#print "ttbar Bin content=%f; Bin error=%f" %(ttbar.GetBinContent(4),ttbar.GetBinError(4))
#print "smhgg Bin content=%f; Bin error=%f" %(smhgg.GetBinContent(4),smhgg.GetBinError(4))
#print "smhvbf Bin content=%f; Bin error=%f" %(smhvbf.GetBinContent(4),smhvbf.GetBinError(4))
#print "SingleT Bin content=%f; Bin error=%f" %(singlet.GetBinContent(4),singlet.GetBinError(4))
do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
#do_binbybin(diboson,"WW_TuneCUETP8M1_13TeV-pythia8",lowDataBin,highDataBin)
do_binbybin(diboson,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",lowDataBin,highDataBin)
#do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",lowDataBin,highDataBin)
do_binbybin(ttbar,"TT_TuneCUETP8M2T4_13TeV-powheg-pythia8",lowDataBin,highDataBin)
#do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",lowDataBin,highDataBin)
do_binbybin(smhgg,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(smhvbf,"VBFHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(WGstarNMM,"WGstarToLNuMuMu_13TeV-madgraph",lowDataBin,highDataBin)
do_binbybin(singlet,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",lowDataBin,highDataBin)
do_binbybin(vbfhmutau125,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau125,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(vbfhmutau120,"VBF_LFV_HToMuTau_M120_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau120,"GluGlu_LFV_HToMuTau_M120_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(vbfhmutau130,"VBF_LFV_HToMuTau_M130_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau130,"GluGlu_LFV_HToMuTau_M130_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(vbfhmutau150,"VBF_LFV_HToMuTau_M150_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau150,"GluGlu_LFV_HToMuTau_M150_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(vbfhmutau200,"VBF_LFV_HToMuTau_M200_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau200,"GluGlu_LFV_HToMuTau_M200_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau300,"GluGlu_LFV_HToMuTau_M300_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau450,"GluGlu_LFV_HToMuTau_M450_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau600,"GluGlu_LFV_HToMuTau_M600_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau750,"GluGlu_LFV_HToMuTau_M750_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau900,"GluGlu_LFV_HToMuTau_M900_13TeV_powheg_pythia8",lowDataBin,highDataBin)
binHigh=0
BLAND=0
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
#if "preselection" not in channel:
if blinded==False and binHigh!=0: 
  #for i in range(binLow,binHigh):
    for i in range(binLow,binHigh):
        data.SetBinContent(i,-1000000000)
#if blinded==False and ('BDT' in var):   #Fanbo
#    for i in range(binLow1,binHigh1):
#        data.SetBinContent(i,-100)
#Recommended by stats committee
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
if wjets_fakes==False:
   LFVStack.Add(wjets)
if fakeallplot:
   LFVStack.Add(wjetsM)
  # LFVStack.Add(wjetsMT)
if (QCDflag == True):
   LFVStack.Add(QCDs)
if (fakeRate ==False and wjets_fakes==True):
   LFVStack.Add(wjetsWmunu)
   LFVStack.Add(wjetsWtaunu)
   LFVStack.Add(wjetsW2jets)
LFVStack.Add(smh)
LFVStack.Add(diboson)
#LFVStack.Add(ttbar)
LFVStack.Add(ttbarP_t)
#LFVStack.Add(singlet)
LFVStack.Add(WGstarNMM)
if not  DY_bin:
   LFVStack.Add(zjets)
else:
   LFVStack.Add(zlljets)
   LFVStack.Add(zmmjets)
LFVStack.Add(ztautau)
binContent_2 = (LFVStack.GetStack().Last())
LFVStack.GetStack().Last().GetXaxis().SetLabelSize(0.)
#print 'total background nubmers are %f' %(binContent_2.Integral())
#if (QCDflag == True):
#   backgroundIntegral =QCDs.GetBinContent(7)+ wjets.GetBinContent(7) + zjets.GetBinContent(7) + ztautau.GetBinContent(7) + ttbar.GetBinContent(7) + diboson.GetBinContent(7)
#else:
#   backgroundIntegral = wjets.GetBinContent(7) + zjets.GetBinContent(7) + ztautau.GetBinContent(7) + ttbar.GetBinContent(7) + diboson.GetBinContent(7)
#if ("vbf" in channel):
#  signalIntegral = vbfhmutau125.GetBinContent(7)
#else:
#  signalIntegral = gghmutau125.GetBinContent(7)
#print str(signalIntegral) + "   "+ str(backgroundIntegral)
#print "Signal/sqrt(Background+Signal)!!!"
#print str(signalIntegral/(backgroundIntegral+signalIntegral))

#print "fw!!: " + str((yieldHisto(data2015B,50,200)-yieldHisto(diboson,50,200)-yieldHisto(zjets,50,200)-yieldHisto(ttbar,50,200)-yieldHisto(singlet,50,200)-yieldHisto(qcd,50,200))/(yieldHisto(wjets,50,200)))

#print channel + " data - MC: (low Mt) " + str(yieldHisto(data2015B,0,50)-yieldHisto(diboson,0,50)-yieldHisto(zjets,0,50)-yieldHisto(ttbar,0,50)-yieldHisto(singlet,0,50)-yieldHisto(wjets,0,50))

maxLFVStack = LFVStack.GetMaximum()
maxData=data.GetMaximum()
maxHist = max(maxLFVStack,maxData)
if not ('Phi' in var or 'Eta' in var) and Setlog:
   LFVStack.SetMaximum(maxData*2000)
#else:
#   LFVStack.SetMaximum(maxData*1.2)
LFVStack.SetMinimum(0.001)
#LFVStack.SetLogy()
LFVStack.Draw('hist')
#if drawdata:
#   if blinded==False :
     #if ("preselection" in channel) or (("preselection" not in channel) and ("collMass" in var or "m_t_Mass" in var or 'BDTcuts' in var)):
#       data.Draw("sames,E0")
#   else:
data.Draw("sames,E0")
lfvh = gghmutau125.Clone()
#lfvh.Add(vbfhmutau125)
lfvh.Scale(0.05)
#lfvh.Draw('hsames')
lfvh120 = gghmutau120.Clone()
lfvh120.Add(vbfhmutau120)
lfvh120.Scale(0.05)
#lfvh120.Draw('hsames')
lfvh130 = gghmutau130.Clone()
lfvh130.Add(vbfhmutau130)
lfvh130.Scale(0.05)
#lfvh130.Draw('hsames')
lfvh150 = gghmutau150.Clone()
lfvh150.Add(vbfhmutau150)
lfvh150.Scale(0.05)
#lfvh150.Draw('hsames')
lfvh200 = gghmutau200.Clone()
#lfvh200.Add(vbfhmutau200)
lfvh200.Scale(0.05)
lfvh200.Draw('hsames')
lfvh300 = gghmutau300.Clone()
lfvh300.Scale(0.05)
lfvh300.Draw('hsames')
lfvh450 = gghmutau450.Clone()
lfvh450.Scale(0.05)
lfvh450.Draw('hsames')
lfvh600 = gghmutau600.Clone()
lfvh600.Scale(0.05)
lfvh600.Draw('hsames')
lfvh750 = gghmutau750.Clone()
lfvh750.Scale(0.05)
lfvh750.Draw('hsames')
lfvh900 = gghmutau900.Clone()
lfvh900.Scale(0.05)
lfvh900.Draw('hsames')
#gghmutau125.Draw("hsames")
#vbfhmutau125.Scale(0.2)
#gghmutau125.Scale(0.2)
#vbfhmutau125.Draw("hsames")
#if blinded==False and (not "preselectionSS" in channel) : 
#   for ibin in range(1,wjets.GetNbinsX()):
#       binContent = (LFVStack.GetStack().Last()).GetBinContent(ibin)
##       Lfvh = lfvh.Clone()
#       Lfvh = lfvh200.Clone()
#       Lfvh.Add(lfvh)
#       Lfvh.Add(lfvh300)
#       Lfvh.Add(lfvh450)
#       Lfvh.Add(lfvh600)
#       Lfvh.Add(lfvh750)
#       Lfvh.Add(lfvh900)
##       Lfvh.Scale(0.2)
#       if binContent!=0:
#    #print Lfvh.GetBinContent(ibin)/(math.sqrt(binContent+(binContent*0.5)**2))
#         if Lfvh.GetBinContent(ibin)/(math.sqrt(binContent+(binContent*0.09)**2))>=0.5:
#            data.SetBinContent(ibin,-1000000000)
#
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
#widthOfBin = xbinLength

if isGeV and ("collMass_type1" in var or 'm_t_Mass' in var):
        ylabel = ynormlabel + " Events/bin"
else:
        ylabel = ynormlabel  + " Events/bin"

legend.Draw('sames')
LFVStack.GetXaxis().SetTitle(xlabel)
LFVStack.GetXaxis().SetNdivisions(510)
LFVStack.GetXaxis().SetLabelSize(0)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)
#LFVStack.GetYaxis().SetNdivisions(510)



pave = ROOT.TPave(100,0,150,maxHist*1.25,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
pave.SetFillColor(920+4)
#pave.SetFillStyle(3003)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
if (xRange!=0):
       	   LFVStack.GetXaxis().SetRangeUser(0,xRange)
if (xRange!=0):
        if "BDT" in var:
       	   LFVStack.GetXaxis().SetRangeUser(-0.5,xRange)
       	  # LFVStack.GetXaxis().SetRangeUser(-0.32,0.22)
          # print "the range!!!!!!!!!!!!!!!!"
        if ("BDT" in var) and "Zmm" in channel:
       	   LFVStack.GetXaxis().SetRangeUser(-0.3,0.2)

LFVStack.GetXaxis().SetTitle(xlabel)

xbinLength = wjets.GetBinWidth(1)
#if isGeV and ("collMass_type1" in var or 'm_t_Mass' in var):
#   widthOfBin = binwidth*xbinLength

size = wjets.GetNbinsX()
#build tgraph of systematic bands
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
           stackBinContent =QCDs.GetBinContent(i)+ wjets.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
        else:
           if fakeallplot:
              #stackBinContent = wjets.GetBinContent(i)+wjetsM.GetBinContent(i)+wjetsMT.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
              stackBinContent = wjets.GetBinContent(i)+wjetsM.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
           else:
              stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)+ztautau.GetBinContent(i)
     
        if fakeallplot:
           #wjetsBinContent = wjets.GetBinContent(i)+wjetsM.GetBinContent(i)+wjetsMT.GetBinContent(i)
           wjetsBinContent = wjets.GetBinContent(i)+wjetsM.GetBinContent(i)
        else:
           wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        xUncertRatio.append(wjets.GetBinCenter(i))
        yUncertRatio.append(1)
               
        exlUncert.append(wjets.GetBinWidth(i)/2)
        exhUncert.append(wjets.GetBinWidth(i)/2)
        exlUncertRatio.append(wjets.GetBinWidth(i)/2)
        exhUncertRatio.append(wjets.GetBinWidth(i)/2)
    #    exlUncert.append(binLength/2)
    #    exhUncert.append(binLength/2)
    #    exlUncertRatio.append(binLength/2)
    #    exhUncertRatio.append(binLength/2)
        if (fakeRate):
                if fakeallplot:
        	   #wjetsError = math.sqrt(((wjets.GetBinContent(i)+wjetsM.GetBinContent(i)+wjetsMT.GetBinContent(i))*0.3*(wjets.GetBinContent(i)+wjetsM.GetBinContent(i))*0.3+wjetsMT.GetBinContent(i))+((wjets.GetBinError(i)+wjetsM.GetBinError(i)+wjetsMT.GetBinError(i))*(wjets.GetBinError(i)+wjetsM.GetBinError(i)+wjetsMT.GetBinError(i))))  #here is different from others, why?
        	   wjetsError = math.sqrt(((wjets.GetBinContent(i)+wjetsM.GetBinContent(i))*0.3*(wjets.GetBinContent(i)+wjetsM.GetBinContent(i))*0.3)+((wjets.GetBinError(i)+wjetsM.GetBinError(i))*(wjets.GetBinError(i)+wjetsM.GetBinError(i))))  #here is different from others, why?
                else:
                   wjetsError = math.sqrt((wjets.GetBinContent(i)*0.30*wjets.GetBinContent(i)*0.30)+(wjets.GetBinError(i)*wjets.GetBinError(i))+ztautau.GetBinContent(i)*0.03*ztautau.GetBinContent(i)*0.03+ztautau.GetBinError(i)*ztautau.GetBinError(i)+ttbar.GetBinContent(i)*0.1*ttbar.GetBinContent(i)*0.1+ttbar.GetBinError(i)*ttbar.GetBinError(i)+diboson.GetBinContent(i)*0.05*diboson.GetBinContent(i)*0.05+diboson.GetBinError(i)*diboson.GetBinError(i)+zjets.GetBinContent(i)*0.1*zjets.GetBinContent(i)*0.1+zjets.GetBinError(i)*zjets.GetBinError(i)+singlet.GetBinContent(i)*0.1*singlet.GetBinContent(i)*0.1+singlet.GetBinError(i)*singlet.GetBinError(i)) 
                   #wjetsError = math.sqrt((wjets.GetBinError(i)*wjets.GetBinError(i))+ztautau.GetBinError(i)*ztautau.GetBinError(i)+ttbar.GetBinError(i)*ttbar.GetBinError(i)+diboson.GetBinError(i)*diboson.GetBinError(i)+zjets.GetBinError(i)*zjets.GetBinError(i)+singlet.GetBinError(i)*singlet.GetBinError(i)) 
        	   #wjetsError = math.sqrt(((wjets.GetBinContent(i))*0.3*(wjets.GetBinContent(i))*0.3)+((wjets.GetBinError(i))*(wjets.GetBinError(i))))  #here is different from others, why?
        else: 
                if (QCDflag == True):
        	    wjetsError = math.sqrt((QCDs.GetBinContent(i)*0.3*QCDs.GetBinContent(i)*0.3)+(wjets.GetBinContent(i)*0.25*wjets.GetBinContent(i)*0.25)+ztautau.GetBinContent(i)*0.03*ztautau.GetBinContent(i)*0.03+ttbar.GetBinContent(i)*0.1*ttbar.GetBinContent(i)*0.1+diboson.GetBinContent(i)*0.05*diboson.GetBinContent(i)*0.05+zjets.GetBinContent(i)*0.1*zjets.GetBinContent(i)*0.1+singlet.GetBinContent(i)*0.1*singlet.GetBinContent(i)*0.1)  #here is different from others, why?
                else:
                    wjetsError = math.sqrt((wjets.GetBinContent(i)*0.30*wjets.GetBinContent(i)*0.30)+(wjets.GetBinError(i)*wjets.GetBinError(i))+ttbar.GetBinContent(i)*0.1*ttbar.GetBinContent(i)*0.1+ttbar.GetBnError(i)*ttbar.GetBinError(i)+diboson.GetBinContent(i)*0.05*diboson.GetBinContent(i)*0.05+diboson.GetBinError(i)*diboson.GetBinError(i)+zjets.GetBinContent(i)*0.1*zjets.GetBinContent(i)*0.1+zjets.GetBinError(i)*zjets.GetBinError(i)+singlet.GetBinContent(i)*0.1*singlet.GetBinContent(i)*0.1+singlet.GetBinError(i)*singlet.GetBinError(i))
		#wjetsError = wjets.GetBinError(i)
        #eylUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        #eyhUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
    #    if (QCDflag == True):
    #       eylUncert.append(wjetsError)
    #       eyhUncert.append(wjetsError)
    #    else:
        #eylUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        #eyhUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        eylUncert.append(wjetsError)
        eyhUncert.append(wjetsError)
        if (stackBinContent==0):
        	eylUncertRatio.append(0)
                eyhUncertRatio.append(0)
	else:
        	#eylUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)
        	#eyhUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)

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

#latexStr = "2016, %.2f fb^{-1} (13 TeV)"%(lumi/1000)
latexStr = "2016, %.2f fb^{-1} (13 TeV)"%(lumi/1000)
latex.DrawLatex(0.95,0.915,latexStr)
latex.SetTextAlign(12)
latex.SetTextFont(61)
latex.SetTextSize(0.08)
latex.DrawLatex(0.17,0.785,"CMS")
latex.SetTextFont(52)
latex.SetTextSize(0.06)
#latex.DrawLatex(0.25,0.87,"Preliminary")
latex.DrawLatex(0.28,0.785,"Preliminary")
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
#systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrors.SetFillColorAlpha(920+2,0.35)
systErrors.SetMarkerSize(0)
systErrors.Draw('E2,sames')
legend.AddEntry(data, 'Observed','elp')
legend.AddEntry(systErrors,'Bkcg Uncertainty','f')
legend.AddEntry(smh, 'SM Higgs','f')
#legend.AddEntry(ztautau,'Z->#tau#tau (embedded)','f')
legend.AddEntry(ztautau,'Z->#tau#tau ','f')
legend.AddEntry(WGstarNMM,'WG','f')
if not  DY_bin:
   legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
else:
   legend.AddEntry(zlljets,'Z->e^{+}e^{-}','f')
   legend.AddEntry(zmmjets,'Z->#mu^{+}#mu^{-}','f')
legend.AddEntry(ttbar,'t#bar{t},t+jets','f')
#legend.AddEntry(singlet,'Single Top')
legend.AddEntry(diboson,'Diboson',"f")
if (QCDflag == True):
#   legend.AddEntry(wjets,'Wjets','f')
   legend.AddEntry(QCDs,'QCDs','f')
if (fakeRate ==False and wjets_fakes==True):
   legend.AddEntry(wjetsWmunu,'Wmunu','f')
   legend.AddEntry(wjetsWtaunu,'Wtaunu','f')
   legend.AddEntry(wjetsW2jets,'W2jets','f')

if fakeRate ==True :
   if fakeallplot:   
      legend.AddEntry(wjets,'TauFakes (jet #rightarrow #tau)','f')
      legend.AddEntry(wjetsM,'MuonFakes (jet #rightarrow #mu)','f')
#      legend.AddEntry(wjetsMT,'M&T Fakes (jet #rightarrow #mu or #tau)','f')
   else:
      #legend.AddEntry(wjets,'Fakes (jet #rightarrow #mu #tau)','f')
      legend.AddEntry(wjets,'Reducible','f')
if fakeRate ==False and wjets_fakes==False :
   legend.AddEntry(wjets,'Wjets','f')
#legend.AddEntry(lfvh,'H 125 #rightarrow #mu#tau (B=5%)')
#legend.AddEntry(lfvh120,'H 120 #rightarrow #mu#tau (B=5%)')
#legend.AddEntry(lfvh,'H 125 #rightarrow #mu#tau (B=5%)')
#legend.AddEntry(lfvh130,'H 130 #rightarrow #mu#tau (B=5%)')
#legend.AddEntry(lfvh150,'H 150 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh200,'H 200 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh300,'H 300 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh450,'H 450 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh600,'H 600 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh750,'H 750 #rightarrow #mu#tau (B=5%)')
legend.AddEntry(lfvh900,'H 900 #rightarrow #mu#tau (B=5%)')
#legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=20%)')
legend.SetNColumns(2)
#fill output root file
if fakeRate == True:
        if fakeallplot:
           wjets.Add(wjetsM)
#           wjets.Add(wjetsMT)
           wjets.Write("wjets"+shiftStr)
        else:
        #   wjets.Add(wjetsM)
           wjets.Write("Fakes"+shiftStr)
else:
  print "******************************   qcd???????????"
  if QCDflag==True:
     wjets.Add(QCDs)
#     do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
     wjets.Write("wjets"+shiftStr)
  else:
     wjets.Write("Fakes"+shiftStr)
zjets.Write("Zothers"+shiftStr)

p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ztautau)
mc.Add(ttbar)
mc.Add(diboson)
mc.Add(singlet)
mc.Add(smh)
mc.Add(WGstarNMM)
mc.Scale(-1)
#ratio.Add(mc)
mc.Scale(-1)
if drawdata:
   ratio.Divide(mc)
else:
   ratio.Divide(mc*100000)
#if drawdata:
ratio.Draw("E1")
#systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrorsRatio.SetFillColorAlpha(920+2,0.35)
systErrorsRatio.SetMarkerSize(0)
systErrorsRatio.Draw('E2,sames')
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
#ratio.GetYaxis().SetRangeUser(-1,1)
ratio.GetYaxis().SetRangeUser(0.6,1.4)
#ratio.GetYaxis().SetTitle("#frac{Data-MC}{MC}")
ratio.GetYaxis().SetTitle("Obs./Exp.")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.08)
ratio.SetTitle("")
canvas.cd()
p_lfv.RedrawAxis()
p_lfv.Draw()
ROOT.gPad.RedrawAxis()
canvas.Modified()
#paveratio = ROOT.TPave(100,-1,150,1,4,"br")
paveratio = ROOT.TPave(100,0.6,150,1.4,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
pave.SetFillColor(920+4)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
if (xRange!=0):
   ratio.GetXaxis().SetRangeUser(0,xRange) 
if (xRange!=0):
        if "BDT" in var:
           ratio.GetXaxis().SetRangeUser(-0.5,xRange)
        if ("BDT" in var) and "Zmm" in channel:
           ratio.GetXaxis().SetRangeUser(-0.3,0.2) 
          
canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
numberWjets=wjets.Integral()
numberzjets=zjets.Integral()
BLAND=0
#fill output root file
#if fakeRate == True:
#        wjets.Write("wjets"+shiftStr)
#else:
#  if QCDflag==True:
#     wjets.Add(QCDs)
#     do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
#     wjets.Write("wjets"+shiftStr)
#  else:
#     wjets.Write("wjets"+shiftStr)
ztautau.Write("ZTauTau"+shiftStr)
ttbar.Write("TT"+shiftStr)
vbfhmutau125.Scale(0.05)
gghmutau125.Scale(0.05)
vbfhmutau125.Write("LFVVBF125"+shiftStr)
gghmutau125.Write("LFVGG125"+shiftStr)
smhvbf.Write("qqH_htt"+shiftStr)
smhgg.Write("ggH_htt"+shiftStr)
WGstarNMM.Write("WG"+shiftStr)
print "Single Top Yield: " + str(singlet.Integral())
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
#print "After Bin by Bin"
#for i in range(1,ztautau.GetNbinsX()+1):
#print "Ztautau Bin content=%f; Bin error=%f" %(ztautau.GetBinContent(4),ztautau.GetBinError(4))
#print "Zjets Bin content=%f; Bin error=%f" %(zjets.GetBinContent(4),zjets.GetBinError(4))
#print "diboson Bin content=%f; Bin error=%f" %(diboson.GetBinContent(4),diboson.GetBinError(4))
#print "ttbar Bin content=%f; Bin error=%f" %(ttbar.GetBinContent(4),ttbar.GetBinError(4))
#print "smhgg Bin content=%f; Bin error=%f" %(smhgg.GetBinContent(4),smhgg.GetBinError(4))
#print "smhvbf Bin content=%f; Bin error=%f" %(smhvbf.GetBinContent(4),smhvbf.GetBinError(4))
#print "SingleT Bin content=%f; Bin error=%f" %(singlet.GetBinContent(4),singlet.GetBinError(4))
#    print "Bin content=%f; Bin error=%f" %(ztautau.GetBinContent(i),ztautau.GetBinError(i))
#print total yields
if wjets_fakes:
     print "wjetsWmunu: " + str(wjetsWmunu.Integral())
     print "wjetsWtaunu:" + str(wjetsWtaunu.Integral())
     print "wjetsW2jets:" + str(wjetsW2jets.Integral())
     print "ratio wjetsWmuno %f   wtaunu %f  w2jets %f" %(wjetsWmunu.Integral()/numberWjets,wjetsWtaunu.Integral()/numberWjets,wjetsW2jets.Integral()/numberWjets)

if DY_bin: 
     print "DY_zmumu: " + str(zmmjets.Integral())
     print "DY_zll: " + str(zlljets.Integral())
    # print "ratio zmumu %f   zll %f " %(zmmjets.Integral()/numberzjets,zlljets.Integral()/numberzjets)
     print "ratio zmumu %f   zll %f " %(zmmjets.Integral()/(zmmjets.Integral()+zlljets.Integral()),zlljets.Integral()/(zmmjets.Integral()+zlljets.Integral()))
if fakeallplot:
     #print "fakes component pure Tau %f ;   pure Muon %f  ;  Tau and Muon %f" %(numberWjets-wjetsM.Integral()-wjetsMT.Integral(),wjetsM.Integral(),wjetsMT.Integral())
#     print "fakes component Tau %f ;   pure Muon %f  ;  Tau and Muon %f" %(numberWjets-wjetsM.Integral(),wjetsM.Integral(),wjetsMT.Integral())
     #print "fakes component pure TauR %f ;   pure MuonR %f  ;  (Tau and Muon)R %f" %((numberWjets-wjetsM.Integral()-wjetsMT.Integral())/numberWjets,wjetsM.Integral()/numberWjets,wjetsMT.Integral()/numberWjets)
     print "fakes component pure TauR %f ;   pure MuonR %f  ;  (Tau and Muon)R %f" %((numberWjets-wjetsM.Integral())/numberWjets,wjetsM.Integral()/numberWjets,wjetsMT.Integral()/numberWjets)
print "Fakes Yield: " + str(wjets.Integral())
print "DY Yield:" +str(zjets.Integral())
print "ZTauTau Yield: " +str(ztautau.Integral())
print "ttbar Yield: " + str(ttbar.Integral())
print "DiBoson Yield: " + str(diboson.Integral())
print "SMHVBF Yield: " + str(smhvbf.Integral())
print "SMHGG Yield: " + str(smhgg.Integral())
print "WG Yield: " + str(WGstarNMM.Integral())
print "LFVVBF Yield scale 20 times: " +str(vbfhmutau125.Integral()*20)
print "LFVGG Yield scale 20 times: " +str(gghmutau125.Integral()*20)
print "Data Yield: " +str(data.Integral())
outfile.Write()
