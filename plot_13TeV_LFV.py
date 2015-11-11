from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

def yieldHisto(histo,xmin,xmax):
        binmin = int(histo.FindBin(xmin))
        binwidth = histo.GetBinWidth(binmin)
        binmax = int(xmax/binwidth)
        signal = histo.Integral(binmin,binmax)
        print "binmin" + str(binmin)
        print "binmax" + str(binmax)
        return signal

def make_histo(savedir,file_str, channel,var,lumidir,lumi,isData=False):
        histoFile = ROOT.TFile(savedir+file_str+".root")
        print histoFile
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False):
        	#metafile = lumidir + file_str +".meta.json"
                metafile = lumidir + file_str+"_weight.log"
        	f = open(metafile).read().splitlines()
                nevents = float((f[0]).split(': ',1)[-1])
                print "nevents: " + str(nevents)
		#xsecfile = lumidir+file_str+"_xsec.txt"
		#fx  = open(xsecfile).read().splitlines()
        	#xsec = float(fx[0])
                #getXsec="XSec."+file_str.replace("-","_")
                #print getXsec
                #xsecList = eval(getXsec)
                #print xsecList
                xsec = eval("XSec."+file_str.replace("-","_"))
		efflumi = nevents/xsec
        	histo.Scale(lumi/efflumi)
        print file_str+" Integral: " + str(histo.Integral())
        return histo

##Set up style
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

savedir=argv[1]
var=argv[2]
channel=argv[3]

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
outfile_name = savedir+"LFV"+"_"+channel+"_"+var
#lumidir = savedir+"json_lumicalc/"
lumidir = savedir+"json_xsec/"
#lumi =16.354
#lumi=166
lumi=1253 #pb
#lumi = 25000 #25 fb-1

#qcdShape = makeQCDShape()
#qcd = qcdShape.Clone()
#qcd.Scale(0.105)

#data2015B = make_histo(savedir,"SingleMuon2015B",channel,var,lumidir,lumi,True)
#data2015B_1 = make_histo(savedir,"data__SingleMuon_Run2015B-PromptReco-v1_MINIAOD",channel,var,lumidir,lumi,True)
#data2015C = make_histo(savedir,"data__SingleMuon_Run2015C-PromptReco-v1_MINIAOD",channel,var,lumidir,lumi,True)
#data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_PromptReco_25ns",channel,var,lumidir,lumi,True)
data2015C = make_histo(savedir,"data_SingleMuon_Run2015C_05Oct2015_25ns",channel,var,lumidir,lumi,True)
data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_05Oct2015_25ns",channel,var,lumidir,lumi,True)
data2015Dv4 = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco-v4_25ns",channel,var,lumidir,lumi,True)
#data2015D = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco_25ns",channel,var,lumidir,lumi,True)
#data2015Dv4 = make_histo(savedir,"data_SingleMuon_Run2015D_PromptRecov4_25ns",channel,var,lumidir,lumi,True)

if (fakeRate == True):
  fakechannel="antiiso_"+channel
  data2015Cfakes = make_histo(savedir,"data_SingleMuon_Run2015C_05Oct2015_25ns",fakechannel,var,lumidir,lumi,True)
  data2015Dfakes = make_histo(savedir,"data_SingleMuon_Run2015D_05Oct2015_25ns",fakechannel,var,lumidir,lumi,True)
  data2015Dv4fakes = make_histo(savedir,"data_SingleMuon_Run2015D_PromptReco-v4_25ns",fakechannel,var,lumidir,lumi,True)
  wjets = data2015Cfakes.Clone()
  wjets.Add(data2015Dfakes)
  wjets.Add(data2015Dv4fakes)
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




#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8_PUReweight",channel,var,lumidir,lumi)
#wjets = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8_PUFix",channel,var,lumidir,lumi)
#wjets.Scale(wjetsScale)
#DYJets_10to50 = make_histo(savedir,"DYJetsToLL_M-10to50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8", channel,var,lumidir,lumi)
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8", channel,var,lumidir,lumi)
#FIIIIIIIIIIIIIIIIX NEEEEEEEEEEEEDED
zjets.Scale(0.9) #10% ztautau


#tFullT = make_histo(savedir,"ST_t-channel_4f_leptonDecays_13TeV-amcatnlo-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tW = make_histo(savedir,"ST_tW_top_5f_DS_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tS = make_histo(savedir,"ST_s-channel_4f_leptonDecays_13TeV-amcatnlo-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)
#tbarW = make_histo(savedir,"ST_tW_antitop_5f_DS_inclusiveDecays_13TeV-powheg-pythia8_TuneCUETP8M1",channel,var,lumidir,lumi)

ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)

#ttbar = make_histo(savedir,"TTJets_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
ttbar = make_histo(savedir,"TT_TuneCUETP8M1_13TeV-amcatnlo-pythia8",channel,var,lumidir,lumi)

data=data2015C.Clone()
data.Add(data2015D)
data.Add(data2015Dv4)

#singlet = tFullT.Clone()
#singlet.Add(tW)
#singlet.Add(tbarW)
#singlet.Add(tS)

diboson = ww.Clone()
diboson.Add(wz)
diboson.Add(zz)
print "binwidth: " + str(binwidth)

data.Rebin(binwidth)
#qcd.Rebin(binwidth)
wjets.Rebin(binwidth)
zjets.Rebin(binwidth)
ttbar.Rebin(binwidth)
#singlet.Rebin(binwidth)
diboson.Rebin(binwidth)
#smhgg.Rebin(binwidth)
#gghmutau125.Rebin(binwidth)

if ("collMass" in var):
  data.SetBinContent(6,-1000)
  data.SetBinContent(7,-1000)
  data.SetBinContent(8,-1000)

data.SetMarkerStyle(8)
data.SetMarkerSize(1)
#qcd.SetFillColor(ROOT.EColor.kBlue)
#qcd.SetLineColor(ROOT.EColor.kBlue)
#qcd.SetLineWidth(1)
#qcd.SetMarkerSize(0)
gghmutau125.SetLineColor(ROOT.EColor.kMagenta)
gghmutau125.SetLineWidth(3)
smhgg.SetLineWidth(3)
smhgg.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineColor(ROOT.EColor.kMagenta)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(3)
smhvbf.SetLineColor(ROOT.EColor.kBlue)
wjets.SetFillColor(ROOT.EColor.kMagenta-10)
wjets.SetLineColor(ROOT.EColor.kMagenta+4)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
zjets.SetFillColor(ROOT.EColor.kOrange-4)
zjets.SetLineColor(ROOT.EColor.kOrange+4)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
ttbar.SetFillColor(40)
ttbar.SetLineColor(ROOT.EColor.kBlack)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
diboson.SetFillColor(ROOT.EColor.kRed+2)
diboson.SetLineColor(ROOT.EColor.kRed+4)
diboson.SetLineWidth(1)
diboson.SetMarkerSize(0)
#singlet.SetFillColor(ROOT.EColor.kGreen-2)
#singlet.SetLineColor(ROOT.EColor.kGreen+4)
#singlet.SetLineWidth(1)
#singlet.SetMarkerSize(0)

#wjets.Scale(225892.45)

LFVStack = ROOT.THStack("stack","")
LFVStack.Add(diboson)
LFVStack.Add(zjets)
#LFVStack.Add(qcd)
LFVStack.Add(ttbar)
#LFVStack.Add(singlet)
LFVStack.Add(wjets)

#print "fw!!: " + str((yieldHisto(data2015B,50,200)-yieldHisto(diboson,50,200)-yieldHisto(zjets,50,200)-yieldHisto(ttbar,50,200)-yieldHisto(singlet,50,200)-yieldHisto(qcd,50,200))/(yieldHisto(wjets,50,200)))

#print channel + " data - MC: (low Mt) " + str(yieldHisto(data2015B,0,50)-yieldHisto(diboson,0,50)-yieldHisto(zjets,0,50)-yieldHisto(ttbar,0,50)-yieldHisto(singlet,0,50)-yieldHisto(wjets,0,50))

maxLFVStack = LFVStack.GetMaximum()
maxData=data.GetMaximum()
maxHist = max(maxLFVStack,maxData)

LFVStack.SetMaximum(maxHist*1.20)
LFVStack.Draw('hist')
data.Draw("sames,E1")
#if ("vbf" in channel):
#	smhvbf.Draw("hsames")
#	vbfhmutau125.Draw("hsames")
#else:
#	smhgg.Draw("hsames")
#	gghmutau125.Draw("hsames")

legend.AddEntry(diboson,'EWK Di-Boson',"f")
legend.AddEntry(zjets,'Z+Jets','f')
#legend.AddEntry(qcd,'QCD','f')
legend.AddEntry(ttbar,'t#bar{t}')
#legend.AddEntry(singlet,'Single Top')
legend.AddEntry(wjets,'Fakes','f')

#if ("vbf" in channel):
#        legend.AddEntry(smhvbf,'SM Higgs M=125')
#        legend.AddEntry(vbfhmutau125,'LFV H->MuTau, M=125, BR=100%')
#else:
#	legend.AddEntry(smhgg,'SM Higgs M=125')
#	legend.AddEntry(gghmutau125,'LFV H->MuTau, M=125, BR=100%')

legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)

xbinLength = wjets.GetBinWidth(1)
widthOfBin = binwidth*xbinLength

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
#LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)

if ("mMt" in var):
	LFVStack.GetXaxis().SetRangeUser(0,200)
if ("m_j" in var):
	LFVStack.GetXaxis().SetRangeUser(0.2,4)
if ("Mass" in var):
        LFVStack.GetXaxis().SetRangeUser(0.2,1000)
#else:
#	LFVStack.GetXaxis().SetRangeUser(0,xRange)
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
binLength = wjets.GetBinCenter(2)-wjets.GetBinCenter(1)

for i in range(1,size+1):
        #stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+singlet.GetBinContent(i)
        stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)
        wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        exlUncert.append(binLength/2)
        exhUncert.append(binLength/2)
        #eylUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+ singlet.GetBinError(i))
        #eyhUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+singlet.GetBinError(i))
        eylUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i))
        eyhUncert.append(wjets.GetBinError(i)+zjets.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i))
        xUncertVec = ROOT.TVectorF(len(xUncert),xUncert)
        yUncertVec = ROOT.TVectorF(len(yUncert),yUncert)
        exlUncertVec = ROOT.TVectorF(len(exlUncert),exlUncert)
        exhUncertVec = ROOT.TVectorF(len(exhUncert),exhUncert)
        eylUncertVec = ROOT.TVectorF(len(eylUncert),eylUncert)
        eyhUncertVec = ROOT.TVectorF(len(eyhUncert),eyhUncert)
        systErrors = ROOT.TGraphAsymmErrors(xUncertVec,yUncertVec,exlUncertVec,exhUncertVec,eylUncertVec,eyhUncertVec)

latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
latexStr = "%.1f pb^{-1}, #sqrt{s} = 13 TeV"%(lumi)
latex.DrawLatex(0.9,0.96,latexStr)
latex.SetTextAlign(11)
latex.DrawLatex(0.25,0.96,"CMS preliminary")

systErrors.SetFillStyle(3001)
systErrors.SetFillColor(ROOT.EColor.kGray+3)
systErrors.SetMarkerSize(0)
#systErrors.Draw('sames,E2')
#legend.AddEntry(systErrors,'Bkg. Uncertainty')


p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ttbar)
mc.Add(diboson)
#mc.Add(singlet)
#mc.Add(qcd)
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
ratio.Draw("E1")
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

if (fakeRate == True):
  outfile_name = outfile_name+"Fakes"
canvas.SaveAs(outfile_name+"FixedWeight.png")
