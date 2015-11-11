from sys import argv, stdout, stderr
import getopt
import ROOT
import sys

ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

channel=argv[1]
var=argv[2]

canvas = ROOT.TCanvas("asdf", "adsf", 800, 800)
canvas.SetGrid()
channelLoose = "loose"+channel
channelTight = "tight"+channel

mmtFile = ROOT.TFile("Nov9_MMT/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.root")
mmtLoose = mmtFile.Get(channelLoose+"/"+var)
mmtTight = mmtFile.Get(channelTight+"/"+var)

data2015CFile = ROOT.TFile("Nov9_MMT/data_SingleMuon_Run2015C_05Oct2015_25ns.root")
data2015CLoose = data2015CFile.Get(channelLoose+"/"+var)
data2015CTight = data2015CFile.Get(channelTight+"/"+var)

data2015DFile = ROOT.TFile("Nov9_MMT/data_SingleMuon_Run2015D_05Oct2015_25ns.root")
data2015DLoose = data2015DFile.Get(channelLoose+"/"+var)
data2015DTight = data2015DFile.Get(channelTight+"/"+var)

data2015Dv4File = ROOT.TFile("Nov9_MMT/data_SingleMuon_Run2015D_PromptReco-v4_25ns.root")
data2015Dv4Loose = data2015Dv4File.Get(channelLoose+"/"+var)
data2015Dv4Tight = data2015Dv4File.Get(channelTight+"/"+var)

dataLoose = data2015CLoose.Clone()
dataLoose.Add(data2015DLoose)
dataLoose.Add(data2015Dv4Loose)

dataTight = data2015CTight.Clone()
dataTight.Add(data2015DTight)
dataTight.Add(data2015Dv4Tight)

if ("tDecayMode" not in var):
	mmtLoose.Rebin(10)
	mmtTight.Rebin(10)
        dataLoose.Rebin(10)
        dataTight.Rebin(10)


fakeRate = mmtTight.Clone()
fakeRate.Divide(mmtLoose)
fakeRate.SetMarkerStyle(20)
fakeRate.SetMarkerColor(ROOT.EColor.kRed)
fakeRate.SetMarkerSize(1.5)

fakeRateData = dataTight.Clone()
fakeRateData.Divide(dataLoose)
fakeRateData.SetMarkerStyle(20)
fakeRateData.SetMarkerColor(ROOT.EColor.kBlue)
fakeRateData.SetMarkerSize(1.5)
fakeRateData.SetTitle("")

fakeRate.Draw("ep")
fakeRateData.Draw("epsames")
maxy = max(fakeRate.GetMaximum(),fakeRateData.GetMaximum())*1.1

fakeRate.GetYaxis().SetRangeUser(0,1.1)

legend = ROOT.TLegend(0.55,0.6,0.8,0.90,' ','brNDC')
legend.AddEntry(fakeRate,"DY MC")
legend.AddEntry(fakeRateData,"Data")

legend.Draw("sames")

if ("Eta" in var):
  fakeRate.GetXaxis().SetTitle("#tau Eta")
elif ("Pt" in var):
  fakeRate.GetXaxis().SetTitle("#tau Pt")
if ("DecayMode" in var):
  fakeRate.GetXaxis().SetTitle("#tau Decay Mode")

canvas.SaveAs("Nov9_MMT/"+channel+"_"+var+"_fakeRate.png")
