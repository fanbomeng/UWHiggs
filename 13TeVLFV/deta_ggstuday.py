from sys import argv, stdout, stderr
import os
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec
import optimizer
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
				histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
		else:
                        if histo.GetBinContent(i) < 0:
                                histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
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
JSONlumi =809.0 
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
##RUN_OPTIMIZATION=int(argv[7])
#samepleused=argv[7]
#RUN_OPTIMIZATION=1
##if RUN_OPTIMIZATION==1:
##   fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg/"+opcut:"ggNotIso/"+opcut,"boost/"+opcut:"boostNotIso/"+opcut,"vbf/"+opcut:"vbfNotIso/"+opcut} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS
##else:
fakeChannels = {"preselection":"notIso","preselectionSS":"notIsoSS","notIso":"notIso","notIsoSS":"notIsoSS","preselection0Jet":"notIso0Jet","preselection1Jet":"notIso1Jet","preselection2Jet":"notIso2Jet","gg":"ggNotIso","boost":"boostNotIso","vbf":"vbfNotIso"} #map of channels corresponding to selection used for data driven fakes (Region II)  tight tight Isolation with SS

poissonErrors=True
if "collMass_type1_1" in var:
	var = "collMass_type1"
if "none" in shift:
	shiftStr="" #Not JES,TES, etc.
else:
	if "FakesDown" in shift:
		shiftStr = "_FakeShapeMuTauDown"
	elif "FakesUp" in shift:
		shiftStr = "_FakeShapeMuTauUp"
	else:
		shiftStr="_CMS_MET_"+shift #corresponds to name Daniel used in datacards
rootdir = "mutau" #directory in datacard file
#rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau" #directory in datacard file

##########OPTIONS#########################
blinded = False #not blinded
#blinded = True #not blinded
#fillEmptyBins = True #empty bins filled
fillEmptyBins =False #apply fake rate method
fakeRate = False #apply fake rate method
#shape_norm = False #normalize to 1 if True
shape_norm = True #normalize to 1 if True


#directory names in datacard file
if "preselection" in channel:
	rootdir="mutau_preselection"
if "vbf" in channel:
	rootdir = "mutau_vbf"
        numberJet='2'
if "boost" in channel:
	rootdir = "mutau_boost"
        numberJet='1'
if "gg" in channel:
	rootdir = "mutau_gg"
        numberJet='0'
#if "vbf" in channel:
#	rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau"
#if "boost" in channel:
#	rootdir = "LFV_MuTau_1Jet_1_13TeVMuTau"
#if "gg" in channel:
#	rootdir = "LFV_MuTau_0Jet_1_13TeVMuTau"

canvas = ROOT.TCanvas("canvas","canvas",800,800)

#if shape_norm == False:
ynormlabel = " "
#else:
#        ynormlabel = "Normalized to 1 "

# Get parameters unique to each variable
getVarParams = "lfv_vars."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]

# binning for collinear mass
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

#legend = eval(varParams[8])
isGeV = varParams[5]
xRange = varParams[6]

##p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
##p_lfv.SetLeftMargin(0.2147651)
##p_lfv.SetRightMargin(0.06543624)
##p_lfv.SetTopMargin(0.04895105)
##p_lfv.SetBottomMargin(0.305)
##p_lfv.Draw()
##p_lfv.cd()
##p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.295)
##p_ratio.SetLeftMargin(0.2147651)
##p_ratio.SetRightMargin(0.06543624)
##p_ratio.SetTopMargin(0.04895105)
##p_ratio.SetBottomMargin(0.295)
##p_ratio.SetGridy()
##p_ratio.Draw()
##if RUN_OPTIMIZATION ==1:
##   outfile_name = savedir+"LFV"+"_"+channel.split("/",1)[0]+channel.split("/",1)[1]+"_"+var+"_"+shiftStr
##else:
##   outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr
lumidir = savedir+"weights/"
lumiScale = float(argv[4]) #lumi to scale to
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi
#data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns", channel,var,lumidir,lumi,True,)
#data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns", channel,var,lumidir,lumi,True)
data2016B = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
##zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
##ztautau = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",channel,var,lumidir,lumi)
#ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",channel,var,lumidir,lumi)
##ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",channel,var,lumidir,lumi)
Sampletable={'DYJets':'DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8',
	     'ZTauTauJets':'ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8',
             'TT':'TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen',
             'WJets':'WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'W1Jets':'W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'W2Jets':'W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'W3Jets':'W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'W4Jets':'W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
	     'VBF_LFV':'VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8',
             'GluGlu_LFV':'GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8',
             'VBFHToTauTau':'VBFHToTauTau_M125_13TeV_powheg_pythia8',
             'GluGluHToTauTau':'GluGluHToTauTau_M125_13TeV_powheg_pythia8',
             'WW':'WW_TuneCUETP8M1_13TeV-pythia8',
             'WZ':'WZ_TuneCUETP8M1_13TeV-pythia8',
             'ZZ':'ZZ_TuneCUETP8M1_13TeV-pythia8',
             'ST_tW_antitop':'ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1',
             'ST_tW_top':'ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1'}
Sample_list=['DYJets','ZTauTauJets','TT','WJets','VBF_LFV','GluGlu_LFV','VBFHToTauTau','GluGluHToTauTau','WW','WZ','ZZ','ST_tW_antitop','ST_tW_top']
data=data2016B.Clone()
data.Rebin(binwidth)
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
#apply fake rate method
##if (fakeRate == True):
##  fakechannel = fakeChannels[channel]
##  #data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
##  #data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_16Dec2015_25ns",fakechannel,var,lumidir,lumi,True)
##  data2016Bfakes = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", fakechannel,var,lumidir,lumi,True,)
## # wjets = data2015Cfakes.Clone()
## # wjets.Add(data2015Dfakes)
##  wjets = data2016Bfakes.Clone()
##  zjetsfakes = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
##  zjetsfakes.Scale(-1)
##  ztautaufakes = make_histo(savedir,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",fakechannel,var,lumidir,lumi)
##  ztautaufakes.Scale(-1)
##  ztautau.Add(ztautaufakes) #avoid double counting
###  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",fakechannel,var,lumidir,lumi)
##  ttbarfakes = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",fakechannel,var,lumidir,lumi)
##  ttbarfakes.Scale(-1)
##  ttbar.Add(ttbarfakes) #avoid double counting
##  wjets.Add(zjetsfakes) #avoid double counting  say besides the fakes from DY, and ztautau,ttbar, then the remainning is wjets
##else: #if fakeRate==False
wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)

xbinLength = data.GetBinWidth(1)
widthOfBin = xbinLength

if isGeV:
        ylabel = ynormlabel + " Events / " + str(int(widthOfBin)) + " GeV"
else:
        ylabel = ynormlabel  + " Events / " + str(widthOfBin)
##vbfhmutau125 = make_histo(savedir,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
colorlist=[1,632,416,600,400,616,432,800,820,840,860,880,900]
hist0=type(wjets) #hist0#,hist1,hist2,hist3,hist4,hist5,hist6,hist7,hist8
hist1=type(wjets)
hist2=type(wjets)
hist3=type(wjets)
hist4=type(wjets)
hist5=type(wjets)
hist6=type(wjets)
hist7=type(wjets)
hist8=type(wjets)
hist9=type(wjets)
hist10=type(wjets)
W1jets=type(wjets)
W2jets=type(wjets)
W3jets=type(wjets)
W4jets=type(wjets)
histlist=[hist0,hist1,hist2,hist3,hist4,hist5,hist6,hist7,hist8,hist9,hist10]
## samepleused
for sampleused in Sample_list:
   p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
   p_lfv.SetLeftMargin(0.2147651)
   p_lfv.SetRightMargin(0.06543624)
   p_lfv.SetTopMargin(0.04895105)
   p_lfv.SetBottomMargin(0.305)
   p_lfv.Draw()
   p_lfv.cd()
   legend = eval(varParams[8])
   i=0
   normalize=int(argv[7])
   normalizetag=''
   for region in optimizer.regions[numberJet]:
      if opcut in region:
          channelwithcut=os.path.join(channel,region) 
          if i==0:
             if sampleused=="WJets":
                histlist[i] = make_histo(savedir,Sampletable[sampleused],channelwithcut,var,lumidir,lumi)
                
                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
                W1jets = make_histo(savedir,Sampletable["W1Jets"],channelwithcut,var,lumidir,lumi)
                W2jets = make_histo(savedir,Sampletable["W2Jets"],channelwithcut,var,lumidir,lumi)
                W3jets = make_histo(savedir,Sampletable["W3Jets"],channelwithcut,var,lumidir,lumi)
                W4jets = make_histo(savedir,Sampletable["W4Jets"],channelwithcut,var,lumidir,lumi)
                do_binbybin(W1jets,Sampletable["W1Jets"],1,500)
                do_binbybin(W2jets,Sampletable["W2Jets"],1,500)
                do_binbybin(W3jets,Sampletable["W3Jets"],1,500)
                do_binbybin(W4jets,Sampletable["W4Jets"],1,500)
                histlist[i].Add(W1jets)
                histlist[i].Add(W2jets)
                histlist[i].Add(W3jets)
                histlist[i].Add(W4jets)
             else:
                histlist[i] = make_histo(savedir,Sampletable[sampleused],channelwithcut,var,lumidir,lumi)
                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
             histlist[i].Rebin(binwidth)
             histlist[i].SetLineColor(colorlist[i])
             histlist[i].SetLineWidth(3)
             legend.AddEntry(histlist[i],sampleused+region)
             #norm=gghmutau125_0.GetEntries()
             #gghmutau125_0.Scale(1.00/norm);
             histlist[i].SetTitle("")
             histlist[i].GetXaxis().SetTitle(xlabel)
             histlist[i].GetXaxis().SetNdivisions(510)
             histlist[i].GetXaxis().SetLabelSize(0.035)
             histlist[i].GetXaxis().SetRangeUser(0,xRange)
             histlist[i].GetYaxis().SetTitle(ylabel)
             histlist[i].GetYaxis().SetTitleOffset(1.40)
             histlist[i].SetMinimum(0)
             if normalize==1:
#                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
                normalizetag="normalized"
                scale = 1.00/(histlist[i].Integral());
                histlist[i].Scale(scale)
             #   histlist[i].GetYaxis().SetTitle(ylabel)
             #   histlist[i].GetYaxis().SetTitleOffset(1.40)
                histlist[i].GetYaxis().SetLabelSize(0.035)
   #             histlist[i].GetYaxis().SetRangeUser(0,1)
                histlist[i].SetMaximum(1)
                histlist[i].SetMinimum(0)
             histlist[i].Draw("hsames")
             #p_lfv.Update()
        ##     gghmutau125_0.Draw("hsames")
           #gghmutau125.Rebin(binwidth)
          else:
             if sampleused=="WJets":
                histlist[i] = make_histo(savedir,Sampletable[sampleused],channelwithcut,var,lumidir,lumi)
                
                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
                W1jets = make_histo(savedir,Sampletable["W1Jets"],channelwithcut,var,lumidir,lumi)
                W2jets = make_histo(savedir,Sampletable["W2Jets"],channelwithcut,var,lumidir,lumi)
                W3jets = make_histo(savedir,Sampletable["W3Jets"],channelwithcut,var,lumidir,lumi)
                W4jets = make_histo(savedir,Sampletable["W4Jets"],channelwithcut,var,lumidir,lumi)
                do_binbybin(W1jets,Sampletable["W1Jets"],1,500)
                do_binbybin(W2jets,Sampletable["W2Jets"],1,500)
                do_binbybin(W3jets,Sampletable["W3Jets"],1,500)
                do_binbybin(W4jets,Sampletable["W4Jets"],1,500)
                histlist[i].Add(W1jets)
                histlist[i].Add(W2jets)
                histlist[i].Add(W3jets)
                histlist[i].Add(W4jets)
             else:
                histlist[i] = make_histo(savedir,Sampletable[sampleused],channelwithcut,var,lumidir,lumi)
                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
             histlist[i].Rebin(binwidth)
             histlist[i].SetLineColor(colorlist[i])
             histlist[i].SetLineWidth(3)
             legend.AddEntry(histlist[i],sampleused+region)
             #norm=gghmutau125.GetEntries()
             if normalize==1:
                do_binbybin(histlist[i],Sampletable[sampleused],1,500)
                scale = 1.00/(histlist[i].Integral());
                histlist[i].Scale(scale)
           #  gghmutau125.Scale(1.00/norm);
             histlist[i].Draw("hsames")
            # p_lfv.Update()
              
          i=i+1
   
   #p_lfv.Update()
   outfile_name = savedir+'background'+sampleused+"_"+channel+"_"+var+"_"+shiftStr+opcut+normalizetag
   ##gghmutau125.GetXaxis().SetTitle(xlabel)
   ##gghmutau125.GetXaxis().SetNdivisions(510)
   ##gghmutau125.GetXaxis().SetLabelSize(0.035)
   ##gghmutau125.GetXaxis().SetRangeUser(0,xRange)
   latex = ROOT.TLatex()
   latex.SetNDC()
   latex.SetTextSize(0.03)
   latex.SetTextAlign(31)
   print lumi
   latexStr = "%.2f fb^{-1} (13 TeV)"%(lumi/1000)
   #latex.DrawLatex(0.9,0.96,latexStr)
   latex.SetTextAlign(11)
   latex.SetTextFont(61)
   latex.SetTextSize(0.04)
   latex.DrawLatex(0.25,0.92,"CMS")
   latex.SetTextFont(52)
   latex.SetTextSize(0.027)
   latex.DrawLatex(0.25,0.87,"Preliminary")
   legend.SetFillColor(0)
   legend.SetBorderSize(0)
   legend.SetFillStyle(0)
   legend.Draw('sames')
   canvas.SaveAs(outfile_name+".png")
   canvas.SaveAs(outfile_name+".pdf")
#legend.Draw('sames')
#p_lfv.Update()
##smhvbf = make_histo(savedir,"VBFHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)
##smhgg = make_histo(savedir,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",channel,var,lumidir,lumi)

##ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
##wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
##zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)

##St_tW_anti = make_histo(savedir,"ST_tW_antitop_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
##St_tW_top = make_histo(savedir,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

##singlet = St_tW_top.Clone()
##singlet.Add(St_tW_anti)

#data=data2015C.Clone()
#data.Add(data2015D)

##diboson = ww.Clone()
##diboson.Add(wz)
##diboson.Add(zz)

#Set bin widths
##wjets.Rebin(binwidth)
##zjets.Rebin(binwidth)
##ztautau.Rebin(binwidth)
##ttbar.Rebin(binwidth)
##diboson.Rebin(binwidth)
##ww.Rebin(binwidth)
##wz.Rebin(binwidth)
##zz.Rebin(binwidth)
##singlet.Rebin(binwidth)
##smhgg.Rebin(binwidth)
##gghmutau125.Rebin(binwidth)
##smhvbf.Rebin(binwidth)
##vbfhmutau125.Rebin(binwidth)

#options for name of outputfile
##if (fakeRate == True):
##  outfile_name = outfile_name+"Fakes"
##if lumiScale != 0:
##        outfile_name = outfile_name+"_Lumi"+str(lumi)
##if blinded==True:
##	outfile_name = outfile_name+"_Blinded"
##if fillEmptyBins==False:
##	outfile_name = outfile_name+"_EmptyBins"
##if poissonErrors==True:
##	outfile_name = outfile_name+"_PoissonErrors"
outfile = ROOT.TFile(outfile_name+".root","RECREATE")

outfile.mkdir(rootdir)
outfile.cd(rootdir+"/")
##if blinded == False:
##	if not ("Jes" in savedir or "Ues" in savedir or "Tes" in savedir or "Fakes" in savedir):
##        	data.Write("data_obs")

##if ("collMass" in var or "m_t_Mass" in var):
##  binLow = data.FindBin(100)
##  binHigh = data.FindBin(150)+1
##binLow = data.FindBin(100)
##binHigh = data.FindBin(150)+1
##if blinded == True:
##       if not ("Jes" in savedir or "Ues" in savedir or "Tes" in savedir or "Fakes" in savedir or ("preselection" in channel and "Jet" in channel)):
##                data.Write("data_obs")
#enum EColor { kWhite =0,   kBlack =1,   kGray=920,
#              kRed   =632, kGreen =416, kBlue=600, kYellow=400, kMagenta=616, kCyan=432,
#              kOrange=800, kSpring=820, kTeal=840, kAzure =860, kViolet =880, kPink=900 };

#Plotting options (not to be used for final plots)
##data.SetMarkerStyle(20)
##data.SetMarkerSize(1)
#data.SetLineColor(ROOT.EColor.kBlack)
##data.SetLineColor(1)
#gghmutau125.SetLineColor(ROOT.EColor.kRed)
##gghmutau125.SetLineColor(632)
##gghmutau125.SetLineWidth(3)
##smhgg.SetLineWidth(3)
#smhgg.SetLineColor(ROOT.EColor.kMagenta)
#smhgg.SetFillColor(ROOT.EColor.kMagenta)
##smhgg.SetLineColor(616)
##smhgg.SetFillColor(616)
#vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
##vbfhmutau125.SetLineColor(600)
##vbfhmutau125.SetLineWidth(3)
##smhvbf.SetLineWidth(3)
#smhvbf.SetLineColor(ROOT.EColor.kMagenta)
#smhvbf.SetFillColor(ROOT.EColor.kMagenta)
##smhvbf.SetLineColor(616)
##smhvbf.SetFillColor(616)
##wjets.SetFillColor(616-10)
##wjets.SetLineColor(616+4)
##wjets.SetLineWidth(1)
##wjets.SetMarkerSize(0)
#ztautau.SetFillColor(ROOT.EColor.kOrange-4)
#ztautau.SetLineColor(ROOT.EColor.kOrange+4)
##ztautau.SetFillColor(800-4)
##ztautau.SetLineColor(800+4)
##ztautau.SetLineWidth(1)
##ztautau.SetMarkerSize(0)
#zjets.SetFillColor(ROOT.EColor.kAzure+3)
#zjets.SetLineColor(ROOT.EColor.kAzure+3)
##zjets.SetFillColor(860+3)
##zjets.SetLineColor(860+3)
##zjets.SetLineWidth(1)
##zjets.SetMarkerSize(0)
#ttbar.SetFillColor(ROOT.EColor.kGreen+3)
#ttbar.SetLineColor(ROOT.EColor.kBlack)
##ttbar.SetFillColor(416+3)
##ttbar.SetLineColor(1)
##ttbar.SetLineWidth(1)
##ttbar.SetMarkerSize(0)
###diboson.SetFillColor(ROOT.EColor.kRed+2)
###diboson.SetLineColor(ROOT.EColor.kRed+4)
##diboson.SetFillColor(632+2)
##diboson.SetLineColor(632+4)
##diboson.SetLineWidth(1)
##diboson.SetMarkerSize(0)
###singlet.SetFillColor(ROOT.EColor.kGreen+4)
###singlet.SetLineColor(ROOT.EColor.kBlack)
##singlet.SetFillColor(416+4)
##singlet.SetLineColor(1)
##singlet.SetLineWidth(1)
##singlet.SetMarkerSize(0)


#fill empty bins
##if fakeRate == False:
##	do_binbybin(wjets,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
##do_binbybin(ztautau,"ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
##do_binbybin(zjets,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8",lowDataBin,highDataBin)
##do_binbybin(diboson,"WW_TuneCUETP8M1_13TeV-pythia8",lowDataBin,highDataBin)
###do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8",lowDataBin,highDataBin)
##do_binbybin(ttbar,"TT_TuneCUETP8M1_13TeV-powheg-pythia8-evtgen",lowDataBin,highDataBin)
##do_binbybin(smhgg,"GluGluHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
##do_binbybin(smhvbf,"VBFHToTauTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
##do_binbybin(singlet,"ST_tW_top_5f_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",lowDataBin,highDataBin)
BLAND=1
#binLow = data.FindBin(100)
#binHigh = data.FindBin(150)+1
##if BLAND==1:
##   for i in range(binLow,binHigh):
##        data.SetBinContent(i,-100)
###Recommended by stats committee
##if(poissonErrors==True):
##	set_poissonerrors(data)
##
##smh = smhgg.Clone()
##smh.Add(smhvbf)
##LFVStack = ROOT.THStack("stack","")
##LFVStack.Add(wjets)
##LFVStack.Add(diboson)
##LFVStack.Add(ttbar)
##LFVStack.Add(singlet)
##LFVStack.Add(zjets)
##LFVStack.Add(ztautau)
##LFVStack.Add(smh)
##backgroundIntegral = wjets.GetBinContent(7) + zjets.GetBinContent(7) + ztautau.GetBinContent(7) + ttbar.GetBinContent(7) + diboson.GetBinContent(7)
##if ("vbf" in channel):
##  signalIntegral = vbfhmutau125.GetBinContent(7)
##else:
##  signalIntegral = gghmutau125.GetBinContent(7)
#print str(signalIntegral) + "   "+ str(backgroundIntegral)
#print "Signal/sqrt(Background+Signal)!!!"
#print str(signalIntegral/(backgroundIntegral+signalIntegral))

#print "fw!!: " + str((yieldHisto(data2015B,50,200)-yieldHisto(diboson,50,200)-yieldHisto(zjets,50,200)-yieldHisto(ttbar,50,200)-yieldHisto(singlet,50,200)-yieldHisto(qcd,50,200))/(yieldHisto(wjets,50,200)))

#print channel + " data - MC: (low Mt) " + str(yieldHisto(data2015B,0,50)-yieldHisto(diboson,0,50)-yieldHisto(zjets,0,50)-yieldHisto(ttbar,0,50)-yieldHisto(singlet,0,50)-yieldHisto(wjets,0,50))

##maxLFVStack = LFVStack.GetMaximum()
##maxData=data.GetMaximum()
##maxHist = max(maxLFVStack,maxData)

##LFVStack.SetMaximum(maxHist*1.20)
#LFVStack.Draw('hist')
##data.Draw("sames,E0")
##lfvh = vbfhmutau125.Clone()
##lfvh = gghmutau125.Clone()
##lfvh.Add(gghmutau125)
##vbfhmutau125.Scale(0.2)
#gghmutau125.Scale(0.2)

##vbfhmutau125.Draw("hsames")
##gghmutau125.Draw("hsames")
##gghmutau125.Draw("hsames")


xbinLength = wjets.GetBinWidth(1)
widthOfBin = xbinLength

##if isGeV:
##        ylabel = ynormlabel + " Events / " + str(int(widthOfBin)) + " GeV"
##else:
##        ylabel = ynormlabel  + " Events / " + str(widthOfBin)

##legend.Draw('sames')
##LFVStack.GetXaxis().SetTitle(xlabel)
##LFVStack.GetXaxis().SetNdivisions(510)
##LFVStack.GetXaxis().SetLabelSize(0.035)
##LFVStack.GetYaxis().SetTitle(ylabel)
##LFVStack.GetYaxis().SetTitleOffset(1.40)
##LFVStack.GetYaxis().SetLabelSize(0.035)



##pave = ROOT.TPave(100,0,150,maxHist*1.25,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
##pave.SetFillColor(920+4)
#pave.SetFillStyle(3003)
##pave.SetBorderSize(0)
##if blinded==True and ("collMass" in var or "m_t_Mass" in var):
##	pave.Draw("sameshist")
##if (xRange!=0):
##	LFVStack.GetXaxis().SetRangeUser(0,xRange)
##LFVStack.GetXaxis().SetTitle(xlabel)

##xbinLength = wjets.GetBinWidth(1)
##widthOfBin = binwidth*xbinLength

##size = wjets.GetNbinsX()
#build tgraph of systematic bands
##xUncert = array.array('f',[])
##yUncert = array.array('f',[])
##exlUncert = array.array('f',[])
##exhUncert = array.array('f',[])
##eylUncert = array.array('f',[])
##eyhUncert = array.array('f',[])
##xUncertRatio = array.array('f',[])
##yUncertRatio = array.array('f',[])
##exlUncertRatio = array.array('f',[])
##exhUncertRatio = array.array('f',[])
##eylUncertRatio = array.array('f',[])
##eyhUncertRatio = array.array('f',[])
##binLength = wjets.GetBinCenter(2)-wjets.GetBinCenter(1)

#build tgraph of errors   
##for i in range(1,size+1):
##        stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
##        wjetsBinContent = wjets.GetBinContent(i)
##        xUncert.append(wjets.GetBinCenter(i))
##        yUncert.append(stackBinContent)
##        xUncertRatio.append(wjets.GetBinCenter(i))
##        yUncertRatio.append(0)
##        
##        exlUncert.append(binLength/2)
##        exhUncert.append(binLength/2)
##        exlUncertRatio.append(binLength/2)
##        exhUncertRatio.append(binLength/2)
##        if (fakeRate):
##        	wjetsError = math.sqrt((wjets.GetBinContent(i)*0.3*wjets.GetBinContent(i)*0.3)+(wjets.GetBinError(i)*wjets.GetBinError(i)))  #here is different from others, why?
##        else:
##		wjetsError = wjets.GetBinError(i)
##        eylUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
##        eyhUncert.append(wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
##        if (stackBinContent==0):
##        	eylUncertRatio.append(0)
##                eyhUncertRatio.append(0)
##	else:
##        	eylUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)
##        	eyhUncertRatio.append((wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))/stackBinContent)
##
##xUncertVec = ROOT.TVectorF(len(xUncert),xUncert)
##yUncertVec = ROOT.TVectorF(len(yUncert),yUncert)
##exlUncertVec = ROOT.TVectorF(len(exlUncert),exlUncert)
##exhUncertVec = ROOT.TVectorF(len(exhUncert),exhUncert)
##eylUncertVec = ROOT.TVectorF(len(eylUncert),eylUncert)
##eyhUncertVec = ROOT.TVectorF(len(eyhUncert),eyhUncert)
##systErrors = ROOT.TGraphAsymmErrors(xUncertVec,yUncertVec,exlUncertVec,exhUncertVec,eylUncertVec,eyhUncertVec)
##
##xUncertVecRatio = ROOT.TVectorF(len(xUncertRatio),xUncertRatio)
##yUncertVecRatio = ROOT.TVectorF(len(yUncertRatio),yUncertRatio)
##exlUncertVecRatio = ROOT.TVectorF(len(exlUncertRatio),exlUncertRatio)
##exhUncertVecRatio = ROOT.TVectorF(len(exhUncertRatio),exhUncertRatio)
##eylUncertVecRatio = ROOT.TVectorF(len(eylUncertRatio),eylUncertRatio)
##eyhUncertVecRatio = ROOT.TVectorF(len(eyhUncertRatio),eyhUncertRatio)
##systErrorsRatio = ROOT.TGraphAsymmErrors(xUncertVecRatio,yUncertVecRatio,exlUncertVecRatio,exhUncertVecRatio,eylUncertVecRatio,eyhUncertVecRatio)

##latex = ROOT.TLatex()
##latex.SetNDC()
##latex.SetTextSize(0.03)
##latex.SetTextAlign(31)
##print lumi
##latexStr = "%.2f fb^{-1} (13 TeV)"%(lumi/1000)
###latex.DrawLatex(0.9,0.96,latexStr)
##latex.SetTextAlign(11)
##latex.SetTextFont(61)
##latex.SetTextSize(0.04)
##latex.DrawLatex(0.25,0.92,"CMS")
##latex.SetTextFont(52)
##latex.SetTextSize(0.027)
##latex.DrawLatex(0.25,0.87,"Preliminary")

#systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
##systErrors.SetFillColorAlpha(920+2,0.35)
##systErrors.SetMarkerSize(0)
##systErrors.Draw('E2,sames')
##legend.AddEntry(data, 'Data #mu#tau_{had}')
##legend.AddEntry(systErrors,'Bkcg Uncertainty','f')
##legend.AddEntry(smh, 'SM Higgs')
#legend.AddEntry(ztautau,'Z->#tau#tau (embedded)','f')
##legend.AddEntry(ztautau,'Z->#tau#tau ','f')
##legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
##legend.AddEntry(ttbar,'t#bar{t}')
##legend.AddEntry(singlet,'Single Top')
##legend.AddEntry(diboson,'VV',"f")
##legend.AddEntry(wjets,'Fakes (jet #rightarrow #tau)','f')
##legend.AddEntry(gghmutau125,'LFV GG Higgs (BR=20%)')
##legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=20%)')


##p_ratio.cd()
##ROOT.gROOT.LoadMacro("tdrstyle.C")
##ROOT.setTDRStyle()
##ratio = data.Clone()
##mc = wjets.Clone()
##mc.Add(zjets)
##mc.Add(ztautau)
##mc.Add(ttbar)
##mc.Add(diboson)
##mc.Scale(-1)
##ratio.Add(mc)
##mc.Scale(-1)
##ratio.Divide(mc)
##ratio.Draw("E1")
#systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
##systErrorsRatio.SetFillColorAlpha(920+2,0.35)
##systErrorsRatio.SetMarkerSize(0)
##systErrorsRatio.Draw('E2,sames')
##if ("mMt" in var):
##	ratio.GetXaxis().SetRangeUser(0,200)
##ratio.GetXaxis().SetTitle(xlabel)
##ratio.GetXaxis().SetTitleSize(0.12)
##ratio.GetXaxis().SetNdivisions(510)
##ratio.GetXaxis().SetTitleOffset(1.1)
##ratio.GetXaxis().SetLabelSize(0.12)
##ratio.GetXaxis().SetLabelFont(42)
##ratio.GetYaxis().SetNdivisions(505)
##ratio.GetYaxis().SetLabelFont(42)
##ratio.GetYaxis().SetLabelSize(0.1)
##ratio.GetYaxis().SetRangeUser(-1,1)
###ratio.GetYaxis().SetTitle("#frac{Data-MC}{MC}")
##ratio.GetYaxis().SetTitle("#frac{Data-BG}{BG}")
##ratio.GetYaxis().CenterTitle(1)
##ratio.GetYaxis().SetTitleOffset(0.4)
##ratio.GetYaxis().SetTitleSize(0.12)
##ratio.SetTitle("")

##paveratio = ROOT.TPave(100,-1,150,1,4,"br")
#pave.SetFillColor(ROOT.kGray+4)
##pave.SetFillColor(920+4)
##pave.SetBorderSize(0)
##if blinded==True and ("collMass" in var or "m_t_Mass" in var):
##	pave.Draw("sameshist")

##if (xRange!=0):
##        ratio.GetXaxis().SetRangeUser(0,xRange)

##canvas.SaveAs(outfile_name+".png")
##canvas.SaveAs(outfile_name+".pdf")

#fill output root file
##if fakeRate == False:
##        wjets.Write("wjets"+shiftStr)
##else:
##	wjets.Write("Fakes"+shiftStr)
##zjets.Write("Zothers"+shiftStr)
##ztautau.Write("ZTauTau"+shiftStr)
##ttbar.Write("TT"+shiftStr)
##vbfhmutau125.Scale(0.05)
#gghmutau125.Scale(0.05)
##do_binbybin(vbfhmutau125,"VBF_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
#do_binbybin(gghmutau125,"GluGlu_LFV_HToMuTau_M125_13TeV_powheg_pythia8",lowDataBin,highDataBin)
##vbfhmutau125.Write("LFVVBF125"+shiftStr)
##gghmutau125.Write("LFVGG125"+shiftStr)
##smhvbf.Write("vbfHTauTau"+shiftStr)
##smhgg.Write("ggHTauTau"+shiftStr)
##print "Single Top Yield: " + str(singlet.Integral())
##diboson.Write("Diboson"+shiftStr)
##singlet.Write("T"+shiftStr)
##full_bckg = wjets.Clone()
##full_bckg.Add(zjets)
##full_bckg.Add(ztautau)
##full_bckg.Add(ttbar)
##full_bckg.Add(diboson)
##full_bckg.Add(smhvbf)
##full_bckg.Add(smhgg)
##full_bckg.Add(singlet)
###print total yields
##print "Fakes Yield: " + str(wjets.Integral())
##print "DY Yield:" +str(zjets.Integral())
##print "ZTauTau Yield: " +str(ztautau.Integral())
##print "ttbar Yield: " + str(ttbar.Integral())
##print "DiBoson Yield: " + str(diboson.Integral())
##print "SMHVBF Yield: " + str(smhvbf.Integral())
##print "SMHGG Yield: " + str(smhgg.Integral())
##print "LFVVBF Yield: " +str(vbfhmutau125.Integral())
##print "LFVGG Yield: " +str(gghmutau125.Integral())
##print "Data Yield: " +str(data.Integral())
outfile.Write()
