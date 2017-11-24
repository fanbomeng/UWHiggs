from sys import argv, stdout, stderr
import getopt
import ROOT
from  ROOT import *
import sys
import array

def do_binbybinQCD(histo): #fill empty bins and negtive content bins to a scaled number, but detail ?
           for i in range(0,histo.GetNbinsX()+2):
                           if histo.GetBinContent(i) <= 0:
                                   histo.SetBinContent(i,0.0)
                                   histo.SetBinError(i,0.0)
def make_histo(savedir,file_str, channel,var,isData=False,):     #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): #calculate effective luminosity
                histo.Scale(JSONlumi)
        return histo
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

channelTight=argv[1]
channelLoose=argv[2]
var=argv[3]
savedir = argv[4]
JSONlumi=35839.977 
canvas = ROOT.TCanvas("asdf", "adsf", 800, 800)
canvas.SetGrid()

mmtLoose1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)

mmtLoosevv = make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)
mmtLooseww = make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)
mmtLoosewzjlllnu = make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",channelLoose,var)
mmtLoosewz1l1nu2q = make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)
mmtLoosewz1l3nu = make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)
mmtLoosewz2l2q = make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)
mmtLoosezz4l = make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",channelLoose,var)
mmtLoosezz2l2q = make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelLoose,var)

mmtLooseww.Add(mmtLoosevv)
mmtLooseww.Add(mmtLoosewzjlllnu)
mmtLooseww.Add(mmtLoosewz1l1nu2q)
mmtLooseww.Add(mmtLoosewz1l3nu)
mmtLooseww.Add(mmtLoosewz2l2q)
mmtLooseww.Add(mmtLoosezz4l)
mmtLooseww.Add(mmtLoosezz2l2q)
do_binbybinQCD(mmtLooseww)
mmtLooseww.Scale(-1)

mmtLoose.Add(mmtLoose1)
mmtLoose.Add(mmtLoose2)
mmtLoose.Add(mmtLoose3)
mmtLoose.Add(mmtLoose4)
do_binbybinQCD(mmtLoose)

mmtTight1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)

mmtTightvv = make_histo(savedir,"VVTo2L2Nu_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)
mmtTightww = make_histo(savedir,"WWTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)
mmtTightwzjlllnu = make_histo(savedir,"WZJToLLLNu_TuneCUETP8M1_13TeV-amcnlo-pythia8",channelTight,var)
mmtTightwz1l1nu2q = make_histo(savedir,"WZTo1L1Nu2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)
mmtTightwz1l3nu = make_histo(savedir,"WZTo1L3Nu_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)
mmtTightwz2l2q = make_histo(savedir,"WZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)
mmtTightzz4l = make_histo(savedir,"ZZTo4L_13TeV-amcatnloFXFX-pythia8",channelTight,var)
mmtTightzz2l2q = make_histo(savedir,"ZZTo2L2Q_13TeV_amcatnloFXFX_madspin_pythia8",channelTight,var)

mmtTightww.Add(mmtTightvv)
mmtTightww.Add(mmtTightwzjlllnu)
mmtTightww.Add(mmtTightwz1l1nu2q)
mmtTightww.Add(mmtTightwz1l3nu)
mmtTightww.Add(mmtTightwz2l2q)
mmtTightww.Add(mmtTightzz4l)
mmtTightww.Add(mmtTightzz2l2q)
do_binbybinQCD(mmtTightww)
mmtTightww.Scale(-1)

mmtTight.Add(mmtTight1)
mmtTight.Add(mmtTight2)
mmtTight.Add(mmtTight3)
mmtTight.Add(mmtTight4)
do_binbybinQCD(mmtTight)
dataLoose = make_histo(savedir,"data_SingleMuon_Run2016B",channelLoose,var,True)
dataLooseC = make_histo(savedir,"data_SingleMuon_Run2016C",channelLoose,var,True)
dataLooseD = make_histo(savedir,"data_SingleMuon_Run2016D",channelLoose,var,True)
dataLooseE = make_histo(savedir,"data_SingleMuon_Run2016E",channelLoose,var,True)
dataLooseF = make_histo(savedir,"data_SingleMuon_Run2016F",channelLoose,var,True)
dataLooseG = make_histo(savedir,"data_SingleMuon_Run2016G",channelLoose,var,True)
dataLooseH = make_histo(savedir,"data_SingleMuon_Run2016H",channelLoose,var,True)
dataLoose.Add(dataLooseC)
dataLoose.Add(dataLooseD)
dataLoose.Add(dataLooseE)
dataLoose.Add(dataLooseF)
dataLoose.Add(dataLooseG)
dataLoose.Add(dataLooseH)
dataLoose.Add(mmtLooseww)
do_binbybinQCD(dataLoose)
dataTight = make_histo(savedir,"data_SingleMuon_Run2016B",channelTight,var,True)
dataTightC = make_histo(savedir,"data_SingleMuon_Run2016C",channelTight,var,True)
dataTightD = make_histo(savedir,"data_SingleMuon_Run2016D",channelTight,var,True)
dataTightE = make_histo(savedir,"data_SingleMuon_Run2016E",channelTight,var,True)
dataTightF = make_histo(savedir,"data_SingleMuon_Run2016F",channelTight,var,True)
dataTightG = make_histo(savedir,"data_SingleMuon_Run2016G",channelTight,var,True)
dataTightH = make_histo(savedir,"data_SingleMuon_Run2016H",channelTight,var,True)
dataTight.Add(dataTightC)
dataTight.Add(dataTightD)
dataTight.Add(dataTightE)
dataTight.Add(dataTightF)
dataTight.Add(dataTightG)
dataTight.Add(dataTightH)
dataTight.Add(mmtTightww)
do_binbybinQCD(dataTight)

xBins = array.array('d',[26,30,40,60,100,200])  # from the plots Tau
xBins1 = array.array('d',[30,35,40,45,50,55,60,65,70,80,150,400])  # from the plots Tau
if 'EE' in channelTight:
  xBins1 = array.array('d',[30,35,40,50,60,70,150]) 
if 'VBF' in channelTight:
   xBins1=array.array('d',[30,40,60,90,200])
if("tPt" in var):
        mmtLoose.Rebin(len(xBins1)-1,"mmtLooseRebinned",xBins1)
        mmtTight.Rebin(len(xBins1)-1,"mmtTightRebinned",xBins1)
        mmtLooseRebinned = ROOT.gDirectory.Get("mmtLooseRebinned")
        mmtTightRebinned = ROOT.gDirectory.Get("mmtTightRebinned")
        mmtLoose = mmtLooseRebinned.Clone()
        mmtTight = mmtTightRebinned.Clone()
        dataLoose.Rebin(len(xBins1)-1,"dataLooseRebinned",xBins1)
        dataTight.Rebin(len(xBins1)-1,"dataTightRebinned",xBins1)
        dataLooseRebinned = ROOT.gDirectory.Get("dataLooseRebinned")
        dataTightRebinned = ROOT.gDirectory.Get("dataTightRebinned")
        dataLoose = dataLooseRebinned.Clone()
        dataTight = dataTightRebinned.Clone()
if("m3Pt" in var):
        mmtLoose.Rebin(len(xBins)-1,"mmtLooseRebinned",xBins)
        mmtTight.Rebin(len(xBins)-1,"mmtTightRebinned",xBins)
        mmtLooseRebinned = ROOT.gDirectory.Get("mmtLooseRebinned")
        mmtTightRebinned = ROOT.gDirectory.Get("mmtTightRebinned")
        mmtLoose = mmtLooseRebinned.Clone()
        mmtTight = mmtTightRebinned.Clone()
        dataLoose.Rebin(len(xBins)-1,"dataLooseRebinned",xBins)
        dataTight.Rebin(len(xBins)-1,"dataTightRebinned",xBins)
        dataLooseRebinned = ROOT.gDirectory.Get("dataLooseRebinned")
        dataTightRebinned = ROOT.gDirectory.Get("dataTightRebinned")
        dataLoose = dataLooseRebinned.Clone()
        dataTight = dataTightRebinned.Clone()
if ("Eta" in var):
     if (("tEta" in var) or ('m3Etaabs' in var)):
        mmtLoose.Rebin(10)
        mmtTight.Rebin(10)
        dataLoose.Rebin(10)
        dataTight.Rebin(10)
     else:
        mmtLoose.Rebin(20)
        mmtTight.Rebin(20)
        dataLoose.Rebin(20)
        dataTight.Rebin(20)

fakeRate=ROOT.TEfficiency(mmtTight,mmtLoose);
#	fakeRate.Divide(mmtLoose)
fakeRate.SetMarkerStyle(20)
fakeRate.SetMarkerColor(8)
#fakeRate.SetMarkerColor(kGreen+3)
fakeRate.SetLineColor(8)
dataTight.SetBinContent(dataTight.GetXaxis().GetNbins()+1,0)

fakeRateData=ROOT.TEfficiency(dataTight,dataLoose);

for ibin in range(0,dataTight.GetXaxis().GetNbins()+1):
        if dataLoose.GetBinContent(ibin):
   	   print 'Data bin content tight and loose bin center, ratio', dataTight.GetBinContent(ibin), dataLoose.GetBinContent(ibin),dataLoose.GetBinCenter(ibin),(dataTight.GetBinContent(ibin)/dataLoose.GetBinContent(ibin))
fakeRateData.SetMarkerStyle(20)
canvas.cd()
fakeRate.Paint('ap')
fakeRate1=fakeRate.GetPaintedGraph().Clone()
fakeRateData.Paint('ap')
fakeRateData1=fakeRateData.GetPaintedGraph().Clone()
if 'tEta' in var:
   fakeRate1.GetXaxis().SetRangeUser(0,2.3)
   fakeRateData1.GetXaxis().SetRangeUser(0,2.3)
if 'm3Etaabs' in var:
   fakeRate1.GetXaxis().SetRangeUser(0,2.4)
   fakeRateData1.GetXaxis().SetRangeUser(0,2.4)
if 'm3Pt' in var:
   fakeRate1.GetXaxis().SetRangeUser(26,300)
   fakeRateData1.GetXaxis().SetRangeUser(26,300)
if 'tPt' in var:
   fakeRate1.GetXaxis().SetRangeUser(30,400)
   fakeRateData1.GetXaxis().SetRangeUser(30,400)
   if 'VBF' in channelTight:
      fakeRate1.GetXaxis().SetRangeUser(30,150)
      fakeRateData1.GetXaxis().SetRangeUser(30,150)
fakeRate1.Draw('ap')
fakeRate1.SetMaximum(1.1)
fakeRate1.SetMinimum(0)
fakeRateData1.Draw("psame")
canvas.Update()
legend = ROOT.TLegend(0.5763333,0.3642857,0.8990606,0.5506803)
legend.AddEntry(fakeRate,"DY+Jets MC",'lp')
legend.AddEntry(fakeRateData,"Data",'lp')

legend.Draw()

if ("Eta" in var):
  if ("m3Eta" in var):
     fakeRate1.GetXaxis().SetTitle("|#eta|")
     fakeRate1.GetYaxis().SetTitle('#mu fakerate') 
  if ("tEta" in var):
     fakeRate1.GetXaxis().SetTitle("|#eta|")
     fakeRate1.GetYaxis().SetTitle('#tau fakerate') 
elif ("Pt" in var):
 if ("m3Pt" in var):
     fakeRate1.GetXaxis().SetTitle("p_{T} [GeV]")
     fakeRate1.GetYaxis().SetTitle('#mu fakerate') 
 if ("tPt" in var):
     fakeRate1.GetXaxis().SetTitle("p_{T} [GeV]")
     fakeRate1.GetYaxis().SetTitle('#tau fakerate') 
if ("DecayMode" in var):
  fakeRate.GetXaxis().SetTitle("#tau Decay Mode")
latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
latexStr = "13 TeV, 2016"
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)


if ("Eta" in var):
    if ("tEta" in var):
        fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x+[3]*x*x*x+[4]*x*x*x*x",0,2.5)
        fakeRateData1.Fit(fakeFit,"R")
        fakeFit.Draw("same")
    if ("m3" in var):
        fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x+[3]*x*x*x",0,2.5)
        fakeRateData1.Fit(fakeFit,"R")
        fakeFit.Draw("sames")

if ("m3Pt" in var):
  fakeFit0 = ROOT.TF1("adsf","[0]",26,200)
  fakeFit1 = ROOT.TF1("adsf","[0]",30,50)
  fakeFit2 = ROOT.TF1("adsf","[0]",50,75)
  fakeFit3 = ROOT.TF1("adsf","[0]",75,300)
  fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x",26,200)
if ("tPt" in var):
  if not 'VBF' in channelTight:
     fakeFit = ROOT.TF1("adsf","[0]+[1]*(x-30)",30,200)
     fakeFit1 = ROOT.TF1("adsf","[0]",200,400)
     fakeRateData1.Fit(fakeFit,"R")
     fakeRateData1.Fit(fakeFit1,"R")
     fakeFit.Draw("sames")
     fakeFit1.Draw("sames")
canvas.SaveAs(savedir+"/"+channelTight+"_"+channelLoose+"_"+var+"_fakeRate.pdf")
