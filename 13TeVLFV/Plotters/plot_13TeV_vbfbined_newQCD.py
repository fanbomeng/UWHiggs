from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

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
        for i in range(1,lowBound):
                if histo.GetBinContent(i) != 0:
                        lowBound = i
                        break
        for i in range(histo.GetNbinsX(),highBound,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break
        for i in range(lowBound, highBound+1):
		if fillEmptyBins: #fill empty bins
			if histo.GetBinContent(i) <= 0:
				histo.SetBinContent(i,0.0)   
				histo.SetBinError(i,0.0)
		else:
                        if histo.GetBinContent(i) < 0:
                                histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
def do_binbybin(histo,file_str,lowBound,highBound): #fill empty bins and negtive content bins to a scaled number, but detail ?
	metafile = lumidir + file_str+"_weight.log"
        f = open(metafile).read().splitlines()
        nevents = float((f[0]).split(': ',1)[-1])
        xsec = eval("XSec."+file_str.replace("-","_"))
        for i in range(1,lowBound):
                if histo.GetBinContent(i) != 0:
                        lowBound = i
                        break
        for i in range(histo.GetNbinsX(),highBound,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break

        for i in range(lowBound, highBound+1):
		if fillEmptyBins: #fill empty bins
			if histo.GetBinContent(i) <= 0:
				histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)   
			#	histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
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
                metafile = lumidir + file_str+"_weight.log"
        	f = open(metafile).read().splitlines()
                nevents = float((f[0]).split(': ',1)[-1])
                xsec = eval("XSec."+file_str.replace("-","_"))
		efflumi = nevents/xsec
		histo.Scale(lumi/efflumi) 
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
JSONlumi =12890.00 
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
opcut=argv[6]
RUN_OPTIMIZATION=int(argv[7])
#RUN_OPTIMIZATION=1
if RUN_OPTIMIZATION==1:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg/"+opcut:"ggNotIso/"+opcut,"boost/"+opcut:"boostNotIso/"+opcut,"vbf/"+opcut:"vbfNotIso/"+opcut} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
elif shift=="Fakes1stDown":
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso1stDown","boost":"boostNotIso1stDown","vbf":"vbfNotIso1stDown","vbf_gg":"vbf_ggNotIso1stDown","vbf_vbf":"vbf_vbfNotIso1stDown"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
elif shift=="Fakes1stUp":
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso1stUp","boost":"boostNotIso1stUp","vbf":"vbfNotIso1stUp","vbf_gg":"vbf_ggNotIso1stUp","vbf_vbf":"vbf_vbfNotIso1stUp"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
elif shift=="Fakes2ndUp":
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso2ndUp","boost":"boostNotIso2ndUp","vbf":"vbfNotIso2ndUp","vbf_gg":"vbf_ggNotIso2ndUp","vbf_vbf":"vbf_vbfNotIso2ndUp"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
elif shift=="Fakes2ndDown":
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso2ndDown","boost":"boostNotIso2ndDown","vbf":"vbfNotIso2ndDown","vbf_gg":"vbf_ggNotIso2ndDown","vbf_vbf":"vbf_vbfNotIso2ndDown"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
else:
   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso","boost":"boostNotIso","vbf":"vbfNotIso","vbf_gg":"vbf_ggNotIso","vbf_vbf":"vbf_vbfNotIso"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
if RUN_OPTIMIZATION==1: 
   tmpvariable=channel.split("/")[1]
   QCDChannels={"preselection0Jet":"IsoSS0Jet/","preselectionSS":"notIsoSS/","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS/"+tmpvariable,"boost":"boostIsoSS/"+tmpvariable,"vbf":"vbfIsoSS/"+tmpvariable,"vbf_gg":"vbf_ggIsoSS/"+tmpvariable,"vbf_vbf":"vbf_vbfIsoSS/"+tmpvariable}
else:
   QCDChannels={"preselection0Jet":"IsoSS0Jet","preselectionSS":"notIsoSS","preselection1Jet":"IsoSS1Jet","preselection2Jet":"IsoSS2Jet","gg":"ggIsoSS","boost":"boostIsoSS","vbf":"vbfIsoSS","vbf_gg":"vbf_ggIsoSS","vbf_vbf":"vbf_vbfIsoSS"}
WmunufakeChannels={"preselection0Jet":"Wmunu_preselection0Jet","preselection1Jet":"Wmunu_preselection1Jet","preselection2Jet":"Wmunu_preselection2Jet","gg":"Wmunu_gg","boost":"Wmunu_boost","vbf_gg":"Wmunu_vbf_gg","vbf_vbf":"Wmunu_vbf_vbf"}
WtaunufakeChannels={"preselection0Jet":"Wtaunu_preselection0Jet","preselection1Jet":"Wtaunu_preselection1Jet","preselection2Jet":"Wtaunu_preselection2Jet","gg":"Wtaunu_gg","boost":"Wtaunu_boost","vbf_gg":"Wtaunu_vbf_gg","vbf_vbf":"Wtaunu_vbf_vbf"}
W2jetsfakeChannels={"preselection0Jet":"W2jets_preselection0Jet","preselection1Jet":"W2jets_preselection1Jet","preselection2Jet":"W2jets_preselection2Jet","gg":"W2jets_gg","boost":"W2jets_boost","vbf_gg":"W2jets_vbf_gg","vbf_vbf":"W2jets_vbf_vbf"}
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
		shiftStr="_CMS_MET_"+shift #corresponds to name Daniel used in datacards
rootdir = "mutau" #directory in datacard file
#rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau" #directory in datacard file

##########OPTIONS#########################
blinded = False #not blinded
#fakeRate = True #apply fake rate method
#QCDflag=False
fillEmptyBins = True #empty bins filled
shape_norm = False #normalize to 1 if True
#wjets_fakes=True
wjets_fakes=False
#drawdata=False
drawdata=True
#blinded = True #not blinded
QCDflag=True
fakeRate = False #apply fake rate method
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
	rootdir = "LFV_MuTau_2Jetgg_1_13TeVMuTau"
if channeltmp=="vbf_vbf":
	rootdir = "LFV_MuTau_2Jetvbf_1_13TeVMuTau"
if channeltmp=="boost":
	rootdir = "LFV_MuTau_1Jet_1_13TeVMuTau"
if channeltmp=="gg":
	rootdir = "LFV_MuTau_0Jet_1_13TeVMuTau"

canvas = ROOT.TCanvas("canvas","canvas",800,800)

if shape_norm == False:
        ynormlabel = " "
else:
        ynormlabel = "Normalized to 1 "

# Get parameters unique to each variable
getVarParams = "lfv_vars."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]

# binning for collinear mass
if "collMass" in var and "vbf" in channel:
	binwidth =25 
#if "collMass" in var and "vbf" in channel:
#	binwidth = 20
elif "collMass" in var and "preselection0Jet" in channel:
        binwidth = 5
elif "collMass" in var and "preselection1Jet" in channel:
        binwidth = 10
elif "collMass" in var and "preselection2Jet" in channel:
        binwidth = 20
elif "collMass" in var and "preselection" in channel:
        binwidth = 5

legend = eval(varParams[8])
isGeV = varParams[5]
xRange = varParams[6]

p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
p_lfv.SetLeftMargin(0.2147651)
p_lfv.SetRightMargin(0.06543624)
p_lfv.SetTopMargin(0.04895105)
p_lfv.SetBottomMargin(0.305)
p_lfv.Draw()
p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.295)
p_ratio.SetLeftMargin(0.2147651)
p_ratio.SetRightMargin(0.06543624)
p_ratio.SetTopMargin(0.04895105)
p_ratio.SetBottomMargin(0.295)
p_ratio.SetGridy()
p_ratio.Draw()
p_lfv.cd()
if RUN_OPTIMIZATION ==1:
   outfile_name = savedir+"LFV"+"_"+channel.split("/",1)[0]+channel.split("/",1)[1]+"_"+var+"_"+shiftStr
else:
   outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr
lumidir = savedir+"weights/"
lumiScale = float(argv[4]) #lumi to scale to
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi
data2016B = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
data2016C = make_histo(savedir,"data_SingleMuon_Run2016C_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
data2016D = make_histo(savedir,"data_SingleMuon_Run2016D_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
#data2016E = make_histo(savedir,"data_SingleMuon_Run2016E", channel,var,lumidir,lumi,True,)
#data2016F = make_histo(savedir,"data_SingleMuon_Run2016F", channel,var,lumidir,lumi,True,)
data2016B.Add(data2016C)
data2016B.Add(data2016D)
#data2016B.Add(data2016E)
#data2016B.Add(data2016F)
data=data2016B.Clone()
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
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#zjets.Sumw2()
#do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
z1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(z1jets,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
z2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(z2jets,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
z3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(z3jets,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
z4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(z4jets,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
zjets.Add(z1jets)
zjets.Add(z2jets)
zjets.Add(z3jets)
zjets.Add(z4jets)
ztautau = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#ztautau.Sumw2()
#do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
ztautau1Jets = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(ztautau1Jets,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
ztautau2Jets = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(ztautau2Jets,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
ztautau3Jets = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(ztautau3Jets,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
ztautau4Jets = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybin(ztautau4Jets,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
ztautau.Add(ztautau1Jets)
ztautau.Add(ztautau2Jets)
ztautau.Add(ztautau3Jets)
ztautau.Add(ztautau4Jets)
#ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",channel,var,lumidir,lumi)
ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",channel,var,lumidir,lumi)

#if (QCDflag == True):
#  QCDChannel = QCDChannels[channel.split("/")[0]]
#  data2016BQCDs = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", QCDChannel,var,lumidir,lumi,True,)
#  data2016CQCDs = make_histo(savedir,"data_SingleMuon_Run2016C_PromptReco-v2_25ns", QCDChannel,var,lumidir,lumi,True,)
#  data2016DQCDs = make_histo(savedir,"data_SingleMuon_Run2016D_PromptReco-v2_25ns", QCDChannel,var,lumidir,lumi,True,)
#  data2016BQCDs.Add(data2016CQCDs)
#  data2016BQCDs.Add(data2016DQCDs)
#  QCDs = data2016BQCDs.Clone()
#  wjetsQCDs = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(wjetsQCDs,lowDataBin,highDataBin)
#  w1jetsQCDs = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(w1jetsQCDs,lowDataBin,highDataBin)
#  w2jetsQCDs = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(w2jetsQCDs,lowDataBin,highDataBin)
#  w3jetsQCDs = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(w3jetsQCDs,lowDataBin,highDataBin)
#  w4jetsQCDs = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(w4jetsQCDs,lowDataBin,highDataBin)
#  wjetsQCDs.Add(w1jetsQCDs)
#  wjetsQCDs.Add(w2jetsQCDs)
#  wjetsQCDs.Add(w3jetsQCDs)
#  wjetsQCDs.Add(w4jetsQCDs)
##  do_binbybinQCD(wjetsQCDs,lowDataBin,highDataBin)
#  wjetsQCDs.Scale(-1)
#  zjetsQCDs = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(zjetsQCDs,lowDataBin,highDataBin)
##  zjetsQCDs.Sumw2()
#  z1jetsQCDs = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z1jetsQCDs,lowDataBin,highDataBin)
#  z2jetsQCDs = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z2jetsQCDs,lowDataBin,highDataBin)
#  z3jetsQCDs = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z3jetsQCDs,lowDataBin,highDataBin)
#  z4jetsQCDs = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(z4jetsQCDs,lowDataBin,highDataBin)
#  zjetsQCDs.Add(z1jetsQCDs) 
#  zjetsQCDs.Add(z2jetsQCDs) 
#  zjetsQCDs.Add(z3jetsQCDs) 
#  zjetsQCDs.Add(z4jetsQCDs) 
##  do_binbybinQCD(zjetsQCDs,lowDataBin,highDataBin)
#  zjetsQCDs.Scale(-1)
#  ztautauQCDs = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautauQCDs,lowDataBin,highDataBin)
##  ztautauQCDs.Sumw2()
#  ztautau1QCDs = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau1QCDs,lowDataBin,highDataBin)
#  ztautau2QCDs = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau2QCDs,lowDataBin,highDataBin)
#  ztautau3QCDs = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau3QCDs,lowDataBin,highDataBin)
#  ztautau4QCDs = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ztautau4QCDs,lowDataBin,highDataBin)
#  ztautauQCDs.Add(ztautau1QCDs)
#  ztautauQCDs.Add(ztautau2QCDs)
#  ztautauQCDs.Add(ztautau3QCDs)
#  ztautauQCDs.Add(ztautau4QCDs)
##  do_binbybinQCD(ztautauQCDs,lowDataBin,highDataBin)
#  ztautauQCDs.Scale(-1)
#  ttbarQCDs = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(ttbarQCDs,lowDataBin,highDataBin)
#  ttbarQCDs.Scale(-1)
#  vbfhmutau125QCDs = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(vbfhmutau125QCDs,lowDataBin,highDataBin)
#  gghmutau125QCDs = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(gghmutau125QCDs,lowDataBin,highDataBin)
#  vbfhmutau125QCDs.Scale(-1) 
#  gghmutau125QCDs.Scale(-1) 
#  smhvbfQCDs = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(smhvbfQCDs,lowDataBin,highDataBin)
#  smhggQCDs = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",QCDChannel,var,lumidir,lumi)
#  do_binbybinQCD(smhggQCDs,lowDataBin,highDataBin)
#  smhvbfQCDs.Scale(-1)
#  smhggQCDs.Scale(-1)
#  wwQCDs = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  wzQCDs = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  zzQCDs = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",QCDChannel,var,lumidir,lumi)
#  
#  St_tW_antiQCDs = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
#  St_tW_topQCDs = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",QCDChannel,var,lumidir,lumi)
#  
#  singletQCDs = St_tW_topQCDs.Clone()
#  singletQCDs.Add(St_tW_antiQCDs)
#  do_binbybinQCD(singletQCDs,lowDataBin,highDataBin)
#  singletQCDs.Scale(-1)
#  dibosonQCDs = wwQCDs.Clone()
#  dibosonQCDs.Add(wzQCDs)
#  dibosonQCDs.Add(zzQCDs)
#  do_binbybinQCD(dibosonQCDs,lowDataBin,highDataBin)
#  dibosonQCDs.Scale(-1)
#  QCDs.Add(ttbarQCDs) #avoid double counting
#  QCDs.Add(ztautauQCDs) #avoid double counting
#  QCDs.Add(zjetsQCDs) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
#  QCDs.Add(wjetsQCDs) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
#  QCDs.Add(vbfhmutau125QCDs)
#  QCDs.Add(gghmutau125QCDs)
#  QCDs.Add(smhvbfQCDs)
#  QCDs.Add(smhggQCDs)
#  QCDs.Add(dibosonQCDs)
#  QCDs.Add(singletQCDs)
#apply fake rate method
if (fakeRate == True):
  fakechannel = fakeChannels[channel]
  data2016Bfakes = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", fakechannel,var,lumidir,lumi,True,)
  data2016Cfakes = make_histo(savedir,"data_SingleMuon_Run2016C_PromptReco-v2_25ns", fakechannel,var,lumidir,lumi,True,)
  data2016Dfakes = make_histo(savedir,"data_SingleMuon_Run2016D_PromptReco-v2_25ns", fakechannel,var,lumidir,lumi,True,)
  data2016Bfakes.Add(data2016Cfakes)
  data2016Bfakes.Add(data2016Dfakes)
  wjets = data2016Bfakes.Clone()
  zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  zjetsfakes.Sumw2()
  #do_binbybin(zjetsfakes,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  z1jetsfakes = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(z1jetsfakes,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  z2jetsfakes = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(z2jetsfakes,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  z3jetsfakes = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(z3jetsfakes,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  z4jetsfakes = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(z4jetsfakes,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  zjetsfakes.Add(z1jetsfakes) 
  zjetsfakes.Add(z2jetsfakes) 
  zjetsfakes.Add(z3jetsfakes) 
  zjetsfakes.Add(z4jetsfakes) 
  zjetsfakes.Scale(-1)
  ztautaufakes = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  ztautaufakes.Sumw2()
  #do_binbybin(ztautaufakes,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  ztautau1fakes = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(ztautau1fakes,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  ztautau2fakes = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #do_binbybin(ztautau2fakes,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  ztautau3fakes = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
 # do_binbybin(ztautau3fakes,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  ztautau4fakes = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
#  do_binbybin(ztautau4fakes,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
  ztautaufakes.Add(ztautau1fakes)
  ztautaufakes.Add(ztautau2fakes)
  ztautaufakes.Add(ztautau3fakes)
  ztautaufakes.Add(ztautau4fakes)
  ztautaufakes.Scale(-1)
  ztautau.Add(ztautaufakes) #avoid double counting
#  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",fakechannel,var,lumidir,lumi)
  ttbarfakes.Scale(-1)
  ttbar.Add(ttbarfakes) #avoid double counting
  zjets.Add(zjetsfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
 # wjets.Add(zjetsfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
else: #if fakeRate==False
  #wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
  if wjets_fakes==False :
     wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
     wjets.Sumw2()
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
     QCDs = make_histo(savedir,"QCD_Pt-20toInf_MuEnrichedPt15_TuneCUETP8M1_13TeV_pythia8",channel,var,lumidir,lumi)
    # if QCDflag==True:
    #    QCDs.Scale(1.06)
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
     QCDs = make_histo(savedir,"QCD_Pt-20toInf_MuEnrichedPt15_TuneCUETP8M1_13TeV_pythia8",channel,var,lumidir,lumi)
#     if QCDflag==True:
#        QCDs.Scale(1.06)
#	do_binbybinQCD(QCDs,lowDataBin,highDataBin)
#     wjets.Add(QCDs)

vbfhmutau125 = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau125 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

smhvbf = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smhgg = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)

St_tW_anti = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
St_tW_top = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

singlet = St_tW_top.Clone()
singlet.Add(St_tW_anti)

diboson = ww.Clone()
diboson.Add(wz)
diboson.Add(zz)

#Set bin widths
data.Rebin(binwidth)
#if (fakeRate == True):
if QCDflag==True:
   QCDs.Rebin(binwidth)
if (fakeRate ==False and wjets_fakes==True):
   wjetsWtaunu.Rebin(binwidth)
   wjetsWmunu.Rebin(binwidth)
   wjetsW2jets.Rebin(binwidth)
wjets.Rebin(binwidth)
zjets.Rebin(binwidth)
ztautau.Rebin(binwidth)
ttbar.Rebin(binwidth)
diboson.Rebin(binwidth)
ww.Rebin(binwidth)
wz.Rebin(binwidth)
zz.Rebin(binwidth)
singlet.Rebin(binwidth)
smhgg.Rebin(binwidth)
gghmutau125.Rebin(binwidth)
smhvbf.Rebin(binwidth)
vbfhmutau125.Rebin(binwidth)

#options for name of outputfile
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
	if not ("Jes" in savedir or "Ues" in savedir or "Tes" in savedir or "Fakes" in savedir):
        	data.Write("data_obs")

if ("collMass" in var or "m_t_Mass" in var):
  binLow = data.FindBin(100)
  binHigh = data.FindBin(150)+1
#binLow = data.FindBin(100)
#binHigh = data.FindBin(150)+1
if blinded == True:
        if not ("Jes" in savedir or "Ues" in savedir or "Tes" in savedir or "Fakes" in savedir or ("preselection" in channel and "Jet" in channel)):
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
smhgg.SetLineWidth(3)
#smhgg.SetLineColor(ROOT.EColor.kMagenta)
#smhgg.SetFillColor(ROOT.EColor.kMagenta)
smhgg.SetLineColor(616)
smhgg.SetFillColor(616)
#vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineColor(600)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(3)
#smhvbf.SetLineColor(ROOT.EColor.kMagenta)
#smhvbf.SetFillColor(ROOT.EColor.kMagenta)
smhvbf.SetLineColor(616)
smhvbf.SetFillColor(616)
wjets.SetFillColor(616-10)
wjets.SetLineColor(616+4)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
if (QCDflag == True):
   QCDs.SetFillColor(221)
   QCDs.SetLineColor(221)
   QCDs.SetLineWidth(1)
   QCDs.SetMarkerSize(0)
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
#ztautau.SetFillColor(ROOT.EColor.kOrange-4)
#ztautau.SetLineColor(ROOT.EColor.kOrange+4)
ztautau.SetFillColor(800-4)
ztautau.SetLineColor(800+4)
ztautau.SetLineWidth(1)
ztautau.SetMarkerSize(0)
#zjets.SetFillColor(ROOT.EColor.kAzure+3)
#zjets.SetLineColor(ROOT.EColor.kAzure+3)
zjets.SetFillColor(860+3)
zjets.SetLineColor(860+3)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
#ttbar.SetFillColor(ROOT.EColor.kGreen+3)
#ttbar.SetLineColor(ROOT.EColor.kBlack)
ttbar.SetFillColor(416+3)
ttbar.SetLineColor(1)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
#diboson.SetFillColor(ROOT.EColor.kRed+2)
#diboson.SetLineColor(ROOT.EColor.kRed+4)
diboson.SetFillColor(632+2)
diboson.SetLineColor(632+4)
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
if fakeRate == False:
	do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
        if QCDflag==True:
	   do_binbybin(QCDs,"QCD_Pt-20toInf_MuEnrichedPt15_TuneCUETP8M1_13TeV_pythia8",lowDataBin,highDataBin)
do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",lowDataBin,highDataBin)
do_binbybin(diboson,"WW_TuneCUETP8M1_13TeV-pythia8",lowDataBin,highDataBin)
#do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",lowDataBin,highDataBin)
do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",lowDataBin,highDataBin)
do_binbybin(smhgg,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(smhvbf,"VBFHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(singlet,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",lowDataBin,highDataBin)
BLAND=0
#binLow = data.FindBin(100)
#binHigh = data.FindBin(150)+1
#if "preselection" not in channel:
if blinded==False and ("collMass" in var or "m_t_Mass" in var):
    for i in range(binLow,binHigh):
        data.SetBinContent(i,-100)
#Recommended by stats committee
if(poissonErrors==True):
	set_poissonerrors(data)

smh = smhgg.Clone()
smh.Add(smhvbf)
LFVStack = ROOT.THStack("stack","")
if wjets_fakes==False:
   LFVStack.Add(wjets)
if (QCDflag == True):
   LFVStack.Add(QCDs)
if (fakeRate ==False and wjets_fakes==True):
   LFVStack.Add(wjetsWmunu)
   LFVStack.Add(wjetsWtaunu)
   LFVStack.Add(wjetsW2jets)
LFVStack.Add(diboson)
LFVStack.Add(ttbar)
LFVStack.Add(singlet)
LFVStack.Add(zjets)
LFVStack.Add(ztautau)
LFVStack.Add(smh)
if (QCDflag == True):
   backgroundIntegral =QCDs.GetBinContent(7)+ wjets.GetBinContent(7) + zjets.GetBinContent(7) + ztautau.GetBinContent(7) + ttbar.GetBinContent(7) + diboson.GetBinContent(7)
else:
   backgroundIntegral = wjets.GetBinContent(7) + zjets.GetBinContent(7) + ztautau.GetBinContent(7) + ttbar.GetBinContent(7) + diboson.GetBinContent(7)
if ("vbf" in channel):
  signalIntegral = vbfhmutau125.GetBinContent(7)
else:
  signalIntegral = gghmutau125.GetBinContent(7)
#print str(signalIntegral) + "   "+ str(backgroundIntegral)
#print "Signal/sqrt(Background+Signal)!!!"
#print str(signalIntegral/(backgroundIntegral+signalIntegral))

#print "fw!!: " + str((yieldHisto(data2015B,50,200)-yieldHisto(diboson,50,200)-yieldHisto(zjets,50,200)-yieldHisto(ttbar,50,200)-yieldHisto(singlet,50,200)-yieldHisto(qcd,50,200))/(yieldHisto(wjets,50,200)))

#print channel + " data - MC: (low Mt) " + str(yieldHisto(data2015B,0,50)-yieldHisto(diboson,0,50)-yieldHisto(zjets,0,50)-yieldHisto(ttbar,0,50)-yieldHisto(singlet,0,50)-yieldHisto(wjets,0,50))

maxLFVStack = LFVStack.GetMaximum()
maxData=data.GetMaximum()
maxHist = max(maxLFVStack,maxData)

LFVStack.SetMaximum(maxHist*1.20)
LFVStack.Draw('hist')
if drawdata==True:
   if blinded==False :
     if ("preselection" in channel) or (("preselection" not in channel) and ("collMass" in var or "m_t_Mass" in var)):
       data.Draw("sames,E0")
   else:
     data.Draw("sames,E0")
lfvh = vbfhmutau125.Clone()
lfvh.Add(gghmutau125)
vbfhmutau125.Scale(0.2)
gghmutau125.Scale(0.2)

vbfhmutau125.Draw("hsames")
gghmutau125.Draw("hsames")

legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)

xbinLength = wjets.GetBinWidth(1)
widthOfBin = xbinLength

if isGeV:
        ylabel = ynormlabel + " Events / " + str(int(widthOfBin)) + " GeV"
else:
        ylabel = ynormlabel  + " Events / " + str(widthOfBin)

legend.Draw('sames')
LFVStack.GetXaxis().SetTitle(xlabel)
LFVStack.GetXaxis().SetNdivisions(510)
LFVStack.GetXaxis().SetLabelSize(0.035)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)



pave = ROOT.TPave(100,0,150,maxHist*1.25,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
pave.SetFillColor(920+4)
#pave.SetFillStyle(3003)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
if (xRange!=0):
	LFVStack.GetXaxis().SetRangeUser(0,xRange)
LFVStack.GetXaxis().SetTitle(xlabel)

xbinLength = wjets.GetBinWidth(1)
widthOfBin = binwidth*xbinLength

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
           stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)

        wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        xUncertRatio.append(wjets.GetBinCenter(i))
        yUncertRatio.append(0)
        
        exlUncert.append(binLength/2)
        exhUncert.append(binLength/2)
        exlUncertRatio.append(binLength/2)
        exhUncertRatio.append(binLength/2)
        if (fakeRate):
        	wjetsError = math.sqrt((wjets.GetBinContent(i)*0.3*wjets.GetBinContent(i)*0.3)+(wjets.GetBinError(i)*wjets.GetBinError(i)))  #here is different from others, why?
        else: 
                if (QCDflag == True):
        	    wjetsError = math.sqrt((QCDs.GetBinContent(i)*0.3*QCDs.GetBinContent(i)*0.3)+(QCDs.GetBinError(i)*QCDs.GetBinError(i))+(wjets.GetBinContent(i)*0.3*wjets.GetBinContent(i)*0.3)+(wjets.GetBinError(i)*wjets.GetBinError(i)))  #here is different from others, why?
                else:
        	    wjetsError = math.sqrt((wjets.GetBinContent(i)*0.3*wjets.GetBinContent(i)*0.3)+(wjets.GetBinError(i)*wjets.GetBinError(i)))  #here is different from others, why?
		#wjetsError = wjets.GetBinError(i)
        eylUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        eyhUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        if (stackBinContent==0):
        	eylUncertRatio.append(0)
                eyhUncertRatio.append(0)
	else:
        	eylUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)
        	eyhUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)

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
latexStr = "%.2f fb^{-1} (13 TeV)"%(lumi/1000)
latex.DrawLatex(0.9,0.96,latexStr)
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)
latex.DrawLatex(0.25,0.92,"CMS")
latex.SetTextFont(52)
latex.SetTextSize(0.027)
latex.DrawLatex(0.25,0.87,"Preliminary")

#systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrors.SetFillColorAlpha(920+2,0.35)
systErrors.SetMarkerSize(0)
systErrors.Draw('E2,sames')
legend.AddEntry(data, 'Data #mu#tau_{had}')
legend.AddEntry(systErrors,'Bkcg Uncertainty','f')
legend.AddEntry(smh, 'SM Higgs')
#legend.AddEntry(ztautau,'Z->#tau#tau (embedded)','f')
legend.AddEntry(ztautau,'Z->#tau#tau ','f')
legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
legend.AddEntry(ttbar,'t#bar{t}')
legend.AddEntry(singlet,'Single Top')
legend.AddEntry(diboson,'VV',"f")
if (QCDflag == True):
#   legend.AddEntry(wjets,'Wjets','f')
   legend.AddEntry(QCDs,'QCDs','f')
if (fakeRate ==False and wjets_fakes==True):
   legend.AddEntry(wjetsWmunu,'Wmunu','f')
   legend.AddEntry(wjetsWtaunu,'Wtaunu','f')
   legend.AddEntry(wjetsW2jets,'W2jets','f')

if fakeRate ==True :
   legend.AddEntry(wjets,'Fakes (jet #rightarrow #tau)','f')
if fakeRate ==False and wjets_fakes==False :
   legend.AddEntry(wjets,'Wjets','f')
legend.AddEntry(gghmutau125,'LFV GG Higgs (BR=20%)')
legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=20%)')


p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ztautau)
mc.Add(ttbar)
mc.Add(diboson)
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
if drawdata==True:
   ratio.Draw("E1")
#systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrorsRatio.SetFillColorAlpha(920+2,0.35)
systErrorsRatio.SetMarkerSize(0)
if drawdata==True:
   systErrorsRatio.Draw('E2,sames')
if ("mMt" in var):
	ratio.GetXaxis().SetRangeUser(0,200)
ratio.GetXaxis().SetTitle(xlabel)
ratio.GetXaxis().SetTitleSize(0.12)
ratio.GetXaxis().SetNdivisions(510)
ratio.GetXaxis().SetTitleOffset(1.1)
ratio.GetXaxis().SetLabelSize(0.12)
ratio.GetXaxis().SetLabelFont(42)
ratio.GetYaxis().SetNdivisions(505)
ratio.GetYaxis().SetLabelFont(42)
ratio.GetYaxis().SetLabelSize(0.1)
ratio.GetYaxis().SetRangeUser(-1,1)
#ratio.GetYaxis().SetTitle("#frac{Data-MC}{MC}")
ratio.GetYaxis().SetTitle("#frac{Data-BG}{BG}")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.12)
ratio.SetTitle("")

paveratio = ROOT.TPave(100,-1,150,1,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
pave.SetFillColor(920+4)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")

if (xRange!=0):
        ratio.GetXaxis().SetRangeUser(0,xRange)

canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
numberWjets=wjets.Integral()
print "Fakes Yield: " + str(wjets.Integral())
if wjets_fakes:
   print "wjetsWmunu: " + str(wjetsWmunu.Integral())
   print "wjetsWtaunu:" + str(wjetsWtaunu.Integral())
   print "wjetsW2jets:" + str(wjetsW2jets.Integral())
   print "ratio wjetsWmuno %f   wtaunu %f  w2jets %f" %(wjetsWmunu.Integral()/numberWjets,wjetsWtaunu.Integral()/numberWjets,wjetsW2jets.Integral()/numberWjets)
if QCDflag==True:
   print "QCDs Yield:" +str(QCDs.Integral())
print "DY Yield:" +str(zjets.Integral())
print "ZTauTau Yield: " +str(ztautau.Integral())
print "ttbar Yield: " + str(ttbar.Integral())
print "DiBoson Yield: " + str(diboson.Integral())
print "SMHVBF Yield: " + str(smhvbf.Integral())
print "SMHGG Yield: " + str(smhgg.Integral())
print "LFVVBF Yield: " +str(vbfhmutau125.Integral())
print "LFVGG Yield: " +str(gghmutau125.Integral())
print "Data Yield: " +str(data.Integral())

#fill output root file
if fakeRate == True:
        wjets.Write("wjets"+shiftStr)
else:
  if QCDflag==True:
     wjets.Add(QCDs)
     wjets.Write("wjets"+shiftStr)
  else:
     wjets.Write("wjets"+shiftStr)
zjets.Write("Zothers"+shiftStr)
ztautau.Write("ZTauTau"+shiftStr)
ttbar.Write("TT"+shiftStr)
vbfhmutau125.Scale(0.05)
gghmutau125.Scale(0.05)
do_binbybin(vbfhmutau125,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau125,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
vbfhmutau125.Write("LFVVBF125"+shiftStr)
gghmutau125.Write("LFVGG125"+shiftStr)
smhvbf.Write("vbfHTauTau"+shiftStr)
smhgg.Write("ggHTauTau"+shiftStr)
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
#print total yields
outfile.Write()
