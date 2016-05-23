from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

def NoNegBins(histo):
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
def set_poissonerrors(histo):
	histo.SetBinErrorOption(ROOT.TH1.kPoisson)

	for i in range(1,histo.GetNbinsX()+1):
		errorLow = histo.GetBinErrorLow(i)
		errorUp = histo.GetBinErrorUp(i)			
		#print "errorLow: " + str(errorLow)
		#print "errorUp: " + str(errorUp)

def yieldHisto(histo,xmin,xmax):
        binmin = int(histo.FindBin(xmin))
        binwidth = histo.GetBinWidth(binmin)
        binmax = int(xmax/binwidth)
        signal = histo.Integral(binmin,binmax)
        #print "binmin" + str(binmin)
        #print "binmax" + str(binmax)
        return signal

def do_binbybin(histo,file_str,lowBound,highBound):
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
		if fillEmptyBins:
			if histo.GetBinContent(i) <= 0:
				#print "weight factor:" + str(1/nevents*xsec*JSONlumi)
				histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
				histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
		else:
                        if histo.GetBinContent(i) < 0:
                                #print "weight factor:" + str(1/nevents*xsec*JSONlumi)
                                histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)

def make_histo(savedir,file_str, channel,var,lumidir,lumi,isData=False,):
        histoFile = ROOT.TFile(savedir+file_str+".root")
        #print histoFile
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False):
        	#metafile = lumidir + file_str +".meta.json"
                metafile = lumidir + file_str+"_weight.log"
        	f = open(metafile).read().splitlines()
                nevents = float((f[0]).split(': ',1)[-1])
                #print "nevents: " + str(nevents)
		#xsecfile = lumidir+file_str+"_xsec.txt"
		#fx  = open(xsecfile).read().splitlines()
        	#xsec = float(fx[0])
                #getXsec="XSec."+file_str.replace("-","_")
                #print getXsec
                #xsecList = eval(getXsec)
                #print xsecList
                xsec = eval("XSec."+file_str.replace("-","_"))
		efflumi = nevents/xsec
		#print "efflumi" + file_str + str(efflumi)
		histo.Scale(lumi/efflumi)
	else:	
		histo.Scale(lumi/JSONlumi)
        #print file_str+" Integral: " + str(histo.Integral())
        if (shift in savedir and isData == False):
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
			#print histoNoShift.Integral()
			#print histo.Integral()
			print savedir +": " + channel + ": " + file_str + ": " + str(scale+1)
			#histo.Scale(histoNoShift.Integral()/histo.Integral())
		else:
			print savedir +": " + file_str + ": ---"
        return histo

##Set up style
JSONlumi = 2297.7
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")
print "test"

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso","boost":"boostNotIso","vbf":"vbfNotIso"}

savedir=argv[1]
var=argv[2]
channel=argv[3]
shift=argv[5]
poissonErrors=True
if "collMass_type1_1" in var:
	var = "collMass_type1"
if "none" in shift:
	shiftStr=""
else:
	if "FakesDown" in shift:
		shiftStr = "_FakeShapeMuTauDown"
	elif "FakesUp" in shift:
		shiftStr = "_FakeShapeMuTauUp"
	else:
		shiftStr="_CMS_MET_"+shift
rootdir = "mutau"
blinded = False
fillEmptyBins = True
if "vbf" in channel:
	rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau"
if "boost" in channel:
	rootdir = "LFV_MuTau_1Jet_1_13TeVMuTau"
if "gg" in channel:
	rootdir = "LFV_MuTau_0Jet_1_13TeVMuTau"
VLoose = False
fakeRate = True
canvas = ROOT.TCanvas("canvas","canvas",800,800)

shape_norm = False
if shape_norm == False:
        ynormlabel = " "
else:
        ynormlabel = "Normalized to 1 "

getVarParams = "lfv_vars."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]

if "collMass" in var and "vbf" in channel:
	binwidth = 50
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
#p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
#p_lfv.SetLeftMargin(0.2147651)
#p_lfv.SetRightMargin(0.06543624)
#p_lfv.SetTopMargin(0.04895105)
#p_lfv.SetBottomMargin(0.1311189)
#p_lfv.Draw()
#p_lfv.cd()

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
outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr
#lumidir = savedir+"json_lumicalc/"
lumidir = savedir+"weights/"
#lumidir = savedir+"json_xsec/"
#lumi =16.354
#lumi=166
#lumi=1253 #pb
lumiScale = float(argv[4])
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi
#lumi = 25000 #25 fb-1

#qcdShape = makeQCDShape()
#qcd = qcdShape.Clone()
#qcd.Scale(0.105)

#data2015B = make_histo(savedir,"SingleMuon2015B",channel,var,lumidir,lumi,True)
#data2015B_1 = make_histo(savedir,"data__SingleMuon_Run2015B-PromptReco-v1_MINIAOD",channel,var,lumidir,lumi,True)
#data2015C = make_histo(savedir,"data__SingleMuon_Run2015C-PromptReco-v1_MINIAOD",channel,var,lumidir,lumi,True)
#data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_PromptReco_25ns",channel,var,lumidir,lumi,True)
#data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_05Oct2015_25ns",channel,var,lumidir,lumi,True)
#data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_05Oct2015_25ns",channel,var,lumidir,lumi,True)
#data2015Dv4 = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco-v4_25ns",channel,var,lumidir,lumi,True)
data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns", channel,var,lumidir,lumi,True,)
data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns", channel,var,lumidir,lumi,True)
#data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco_25ns",channel,var,lumidir,lumi,True)
#data2015Dv4 = make_histo(savedir,"data_SingleMuon_Run2015D_PromptRecov4_25ns",channel,var,lumidir,lumi,True)
#zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
#zjets1 = make_histo(savedir, "DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel, var, lumidir,lumi)
#zjets2 = make_histo(savedir, "DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel, var, lumidir,lumi)
#zjets3 = make_histo(savedir, "DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel, var, lumidir,lumi)
#zjets4 = make_histo(savedir, "DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel, var, lumidir,lumi)
ztautau = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
#ztautau = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
#ztautau1 = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#ztautau2 = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#ztautau3 = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#ztautau4 = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)

#zjets.Add(zjets1)
#zjets.Add(zjets2)
#zjets.Add(zjets3)
#zjets.Add(zjets4)

#ztautau.Add(ztautau1)
#ztautau.Add(ztautau2)
#ztautau.Add(ztautau3)
#ztautau.Add(ztautau4)

ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",channel,var,lumidir,lumi)


if (fakeRate == True):
  fakechannel = fakeChannels[channel]
  #print channel
  #print fakechannel
#    if (VLoose):
#      fakechannel = "antiiso_"+channel.rstrip("iso")+"VLooseiso"
#    else:
#      fakechannel = "antiiso_"+channel.rstrip("iso")+"Looseiso"
  #data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_05Oct2015_25ns",fakechannel,var,lumidir,lumi,True)
  #data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_05Oct2015_25ns",fakechannel,var,lumidir,lumi,True)
  #data2015Dv4fakes = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco-v4_25ns",fakechannel,var,lumidir,lumi,True)
  data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
  wjets = data2015Cfakes.Clone()
  wjets.Add(data2015Dfakes)
  #print "fakes!!!" + str(fakechannel)
  #zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
  #zjetsfakes1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #zjetsfakes2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #zjetsfakes3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #zjetsfakes4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #zjetsfakes.Add(zjetsfakes1)
  #zjetsfakes.Add(zjetsfakes2)
  #zjetsfakes.Add(zjetsfakes3)
  #zjetsfakes.Add(zjetsfakes4)
  zjetsfakes.Scale(-1)
  ztautaufakes = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
  #ztautaufakes1 = make_histo(savedir,"ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #ztautaufakes2 = make_histo(savedir,"ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #ztautaufakes3 = make_histo(savedir,"ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #ztautaufakes4 = make_histo(savedir,"ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",fakechannel,var,lumidir,lumi)
  #ztautaufakes.Add(ztautaufakes1)
  #ztautaufakes.Add(ztautaufakes2)
  #ztautaufakes.Add(ztautaufakes3)
  #ztautaufakes.Add(ztautaufakes4)
  ztautaufakes.Scale(-1)
  ztautau.Add(ztautaufakes)
  #wjets.Add(ztautaufakes)
  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
  ttbarfakes.Scale(-1)
  ttbar.Add(ttbarfakes)
  wjets.Add(zjetsfakes)
else:
  wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)


#vbfhetau120 = make_histo(savedir,"VBF_LFV_HToETau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhetau125 = make_histo(savedir,"VBF_LFV_HToETau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhetau130 = make_histo(savedir,"VBF_LFV_HToETau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhetau150 = make_histo(savedir,"VBF_LFV_HToETau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhetau200 = make_histo(savedir,"VBF_LFV_HToETau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghetau120 = make_histo(savedir,"GluGlu_LFV_HToETau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghetau125 = make_histo(savedir,"GluGlu_LFV_HToETau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghetau130 = make_histo(savedir,"GluGlu_LFV_HToETau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghetau150 = make_histo(savedir,"GluGlu_LFV_HToETau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghetau200 = make_histo(savedir,"GluGlu_LFV_HToETau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

#vbfhemu120 = make_histo(savedir,"VBF_LFV_HToEMu_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhemu125 = make_histo(savedir,"VBF_LFV_HToEMu_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhemu130 = make_histo(savedir,"VBF_LFV_HToEMu_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhemu150 = make_histo(savedir,"VBF_LFV_HToEMu_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhemu200 = make_histo(savedir,"VBF_LFV_HToEMu_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghemu120 = make_histo(savedir,"GluGlu_LFV_HToEMu_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghemu125 = make_histo(savedir,"GluGlu_LFV_HToEMu_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghemu130 = make_histo(savedir,"GluGlu_LFV_HToEMu_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghemu150 = make_histo(savedir,"GluGlu_LFV_HToEMu_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghemu200 = make_histo(savedir,"GluGlu_LFV_HToEMu_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

#vbfhmutau120 = make_histo(savedir,"VBF_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
vbfhmutau125 = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau130 = make_histo(savedir,"VBF_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau150 = make_histo(savedir,"VBF_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#vbfhmutau200 = make_histo(savedir,"VBF_LFV_HToMuTau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau120 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M120_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
gghmutau125 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau130 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M130_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau150 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M150_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
#gghmutau200 = make_histo(savedir,"GluGlu_LFV_HToMuTau_M200_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

smhvbf = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
smhgg = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

#vbfhmutau125.Scale(0.1)
#gghmutau125.Scale(0.1)


#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8_PUReweight",channel,var,lumidir,lumi)
#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8_PUFix",channel,var,lumidir,lumi)
#wjets.Scale(wjetsScale)
#DYJets_10to50 = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8", channel,var,lumidir,lumi)
#zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel,var,lumidir,lumi)
#FIIIIIIIIIIIIIIIIX NEEEEEEEEEEEEDED
#zjets.Scale(0.9) #10% ztautau


#tFullT = make_histo(savedir,"ST_t-channel_4f_leptonDecays_13TeV-amcatnlo-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tW = make_histo(savedir,"ST_tW_top_5f_DS_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tS = make_histo(savedir,"ST_s-channel_4f_leptonDecays_13TeV-amcatnlo-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tbarW = make_histo(savedir,"ST_tW_antitop_5f_DS_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)

St_tW_anti = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
St_tW_top = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

singlet = St_tW_top.Clone()
singlet.Add(St_tW_anti)

#ttbar = make_histo(savedir,"TTJets_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
data=data2015C.Clone()
data.Add(data2015D)
#data.Add(data2015Dv4) doesn't exist for 76X

#singlet = tFullT.Clone()
#singlet.Add(tW)
#singlet.Add(tbarW)
#singlet.Add(tS)

diboson = ww.Clone()
diboson.Add(wz)
diboson.Add(zz)
#print "binwidth: " + str(binwidth)

data.Rebin(binwidth)
#qcd.Rebin(binwidth)
wjets.Rebin(binwidth)
zjets.Rebin(binwidth)
ztautau.Rebin(binwidth)
ttbar.Rebin(binwidth)
#singlet.Rebin(binwidth)
diboson.Rebin(binwidth)
ww.Rebin(binwidth)
wz.Rebin(binwidth)
zz.Rebin(binwidth)
singlet.Rebin(binwidth)
smhgg.Rebin(binwidth)
gghmutau125.Rebin(binwidth)
smhvbf.Rebin(binwidth)
vbfhmutau125.Rebin(binwidth)

if (fakeRate == True):
  outfile_name = outfile_name+"Fakes"
  if (VLoose and "Tight" in channel):
    outfile_name=outfile_name+"_VLooseAntiIso"
  elif ("Tight" in channel):
    outfile_name=outfile_name+"_LooseAntiIso"
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
  #for x in range(binLow,binHigh):
  #  data.SetBinContent(x,-1000)
if blinded == True:
        if not ("Jes" in savedir or "Ues" in savedir or "Tes" in savedir or "Fakes" in savedir or ("preselection" in channel and "Jet" in channel)):
                data.Write("data_obs")
#if ("collMass" in var and ("vbf" in channel or "boost" in channel)):
#  data.SetBinContent(3,-1000)

data.SetMarkerStyle(20)
data.SetMarkerSize(1)
data.SetLineColor(ROOT.EColor.kBlack)
#qcd.SetFillColor(ROOT.EColor.kBlue)
#qcd.SetLineColor(ROOT.EColor.kBlue)
#qcd.SetLineWidth(1)
#qcd.SetMarkerSize(0)
gghmutau125.SetLineColor(ROOT.EColor.kRed)
gghmutau125.SetLineWidth(3)
smhgg.SetLineWidth(3)
smhgg.SetLineColor(ROOT.EColor.kMagenta)
smhgg.SetFillColor(ROOT.EColor.kMagenta)
vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(3)
smhvbf.SetLineColor(ROOT.EColor.kMagenta)
smhvbf.SetFillColor(ROOT.EColor.kMagenta)
wjets.SetFillColor(ROOT.EColor.kMagenta-10)
wjets.SetLineColor(ROOT.EColor.kMagenta+4)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
ztautau.SetFillColor(ROOT.EColor.kOrange-4)
ztautau.SetLineColor(ROOT.EColor.kOrange+4)
ztautau.SetLineWidth(1)
ztautau.SetMarkerSize(0)
zjets.SetFillColor(ROOT.EColor.kAzure+3)
zjets.SetLineColor(ROOT.EColor.kAzure+3)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
ttbar.SetFillColor(ROOT.EColor.kGreen+3)
ttbar.SetLineColor(ROOT.EColor.kBlack)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
diboson.SetFillColor(ROOT.EColor.kRed+2)
diboson.SetLineColor(ROOT.EColor.kRed+4)
diboson.SetLineWidth(1)
diboson.SetMarkerSize(0)
singlet.SetFillColor(ROOT.EColor.kGreen+4)
singlet.SetLineColor(ROOT.EColor.kBlack)
singlet.SetLineWidth(1)
singlet.SetMarkerSize(0)
#singlet.SetFillColor(ROOT.EColor.kGreen-2)
#singlet.SetLineColor(ROOT.EColor.kGreen+4)
#singlet.SetLineWidth(1)
#singlet.SetMarkerSize(0)

#wjets.Scale(225892.45)

lowDataBin = 1
highDataBin = data.GetNbinsX()
for i in range(1,data.GetNbinsX()+1):
	if (data.GetBinContent(i) > 0):
		lowDataBin = i
		break
for i in range(data.GetNbinsX(),0,-1):
	if (data.GetBinContent(i) > 0):
		highDataBin = i
		break

if fakeRate == False:
	do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
do_binbybin(diboson,"WW_TuneCUETP8M1_13TeV-pythia8",lowDataBin,highDataBin)
do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",lowDataBin,highDataBin)
do_binbybin(smhgg,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(smhvbf,"VBFHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(singlet,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",lowDataBin,highDataBin)


if(poissonErrors==True):
	set_poissonerrors(data)

smh = smhgg.Clone()
smh.Add(smhvbf)
LFVStack = ROOT.THStack("stack","")
LFVStack.Add(wjets)
LFVStack.Add(diboson)
LFVStack.Add(ttbar)
LFVStack.Add(singlet)
LFVStack.Add(zjets)
LFVStack.Add(ztautau)
LFVStack.Add(smh)
#LFVStack.Add(qcd)
#LFVStack.Add(singlet)
#aLFVStack.Add(wjets)
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
data.Draw("sames,E0")
lfvh = vbfhmutau125.Clone()
lfvh.Add(gghmutau125)

vbfhmutau125.Draw("hsames")
gghmutau125.Draw("hsames")
#if ("vbf" in channel):
#	smhvbf.Draw("hsames")
#	vbfhmutau125.Draw("hsames")
#else:
#	smhgg.Draw("hsames")
#	gghmutau125.Draw("hsames")

#if ("vbf" in channel):
#        legend.AddEntry(smhvbf,'SM Higgs M=125')
#        legend.AddEntry(vbfhmutau125,'LFV H->MuTau, M=125, BR=10%')
#else:
#	legend.AddEntry(smhgg,'SM Higgs M=125')
#	legend.AddEntry(gghmutau125,'LFV H->MuTau, M=125, BR=10%')

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
#LFVStack.GetXaxis().SetTitleOffset(3.0)
#LFVStack.GetXaxis().SetLabelOffset(3.0)
LFVStack.GetXaxis().SetLabelSize(0.035)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)



pave = ROOT.TPave(100,0,150,maxHist*1.25,4,"br")
pave.SetFillColor(ROOT.kGray+4)
#pave.SetFillStyle(3003)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")
#if ("mMt" in var):
#	LFVStack.GetXaxis().SetRangeUser(0,200)
#if ("m_j" in var):
#	LFVStack.GetXaxis().SetRangeUser(0.2,4)
#if ("Mass" in var):
#        LFVStack.GetXaxis().SetRangeUser(0.2,1000)
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

for i in range(1,size+1):
        #stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
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
        	wjetsError = wjets.GetBinContent(i)*0.4
        else:
		wjetsError = wjets.GetBinError(i)
        #eylUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+ singlet.GetBinError(i))
        #eyhUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        eylUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        eyhUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        if (stackBinContent==0):
        	eylUncertRatio.append(0)
                eyhUncertRatio.append(0)
	else:
        	eylUncertRatio.append((wjetsError+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)
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

#systErrors.SetFillStyle(3003)
systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrors.SetMarkerSize(0)
systErrors.Draw('E2,sames')
legend.AddEntry(data, 'Data #mu#tau_{had}')
legend.AddEntry(systErrors,'Bkcg Uncertainty')
legend.AddEntry(smh, 'SM Higgs')
legend.AddEntry(ztautau,'Z->#tau#tau (embedded)','f')
legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
legend.AddEntry(ttbar,'t#bar{t}')
legend.AddEntry(singlet,'Single Top')
legend.AddEntry(diboson,'VV',"f")
legend.AddEntry(wjets,'Fakes (jet #rightarrow #tau)','f')
legend.AddEntry(gghmutau125,'LFV GG Higgs (BR=10%)')
legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=10%)')


p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ztautau)
mc.Add(ttbar)
mc.Add(diboson)
#mc.Add(singlet)
#mc.Add(qcd)
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
ratio.Draw("E1")
#systErrorsRatio.SetFillStyle(3001)
systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrorsRatio.SetMarkerSize(0)
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
ratio.GetYaxis().SetTitle("#frac{Data-MC}{MC}")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.12)
ratio.SetTitle("")

paveratio = ROOT.TPave(100,-1,150,1,4,"br")
pave.SetFillColor(ROOT.kGray+4)
#pave.SetFillStyle(3003)
pave.SetBorderSize(0)
if blinded==True and ("collMass" in var or "m_t_Mass" in var):
	pave.Draw("sameshist")

if (xRange!=0):
        ratio.GetXaxis().SetRangeUser(0,xRange)

canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")

if fakeRate == False:
        wjets.Write("wjets"+shiftStr)
else:
	wjets.Write("Fakes"+shiftStr)
zjets.Write("Zothers"+shiftStr)
ztautau.Write("ZTauTau"+shiftStr)
ttbar.Write("TT"+shiftStr)
#ttbar_semi.Write("ttbarsemi")
#ttbar_full.Write("ttbarfull")
#ww.Write("ww"+shiftStr)
#singlet.Write("singlet")
#scale signal to 1% for datacards
vbfhmutau125.Scale(0.01)
gghmutau125.Scale(0.01)
do_binbybin(vbfhmutau125,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
do_binbybin(gghmutau125,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
vbfhmutau125.Write("LFVVBF125"+shiftStr)
gghmutau125.Write("LFVGG125"+shiftStr)
smhvbf.Write("vbfHTauTau"+shiftStr)
smhgg.Write("ggHTauTau"+shiftStr)
print "Single Top Yield: " + str(singlet.Integral())
#vbfhmutau125.Write("LFVVBF")
#gghmutau125.Write("LFVGG")
#smhvbf.Write("SMVBF")
#smhgg.Write("SMGG")
diboson.Write("Diboson"+shiftStr)
#wz.Write("WZ"+shiftStr)
#zz.Write("ZZ"+shiftStr)

singlet.Write("T"+shiftStr)
full_bckg = wjets.Clone()
full_bckg.Add(zjets)
full_bckg.Add(ztautau)
full_bckg.Add(ttbar)
full_bckg.Add(diboson)
full_bckg.Add(smhvbf)
full_bckg.Add(smhgg)
full_bckg.Add(singlet)
#full_bckg.Write("full_bckg"+shiftStr)
print "Fakes Yield: " + str(wjets.Integral())
print "DY Yield:" +str(zjets.Integral())
print "ZTauTau Yield: " +str(ztautau.Integral())
print "ttbar Yield: " + str(ttbar.Integral())
print "DiBoson Yield: " + str(diboson.Integral())
print "SMHVBF Yield: " + str(smhvbf.Integral())
print "SMHGG Yield: " + str(smhgg.Integral())
print "LFVVBF Yield: " +str(vbfhmutau125.Integral())
print "LFVGG Yield: " +str(gghmutau125.Integral())
print "Data Yield: " +str(data.Integral())
outfile.Write()
