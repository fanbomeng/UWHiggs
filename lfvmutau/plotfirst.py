
import ROOT

from ROOT import *
import math
#import ROOT
import numpy
#from PeakFitter import *
import matplotlib.pyplot as pyplot

ROOT.gROOT.SetStyle("Plain")
#ROOT.gStyle.SetOptTitle(0)
#ROOT.gStyle.SetOptStat(0)
ROOT.gStyle.SetTitleXOffset(1.)
ROOT.gStyle.SetTitleYOffset(2.)
ROOT.gStyle.SetLabelOffset(0.01, "XYZ")
ROOT.gStyle.SetPadLeftMargin(0.2)
ROOT.gStyle.SetPadRightMargin(0.1)
ROOT.gStyle.SetHistLineWidth(2)


filein=[ROOT.TFile.Open("results/LFV_807v2/AnalyzeLFVMuTau/WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8.root ", "READ"),ROOT.TFile.Open("results/LFV_807v2/AnalyzeLFVMuTau/data_SingleMuon_Run2016B_PromptReco-v2_25ns.root", "READ")]
title_name_string=['Wjets','Data']
#lumi=(8,2)
#title_name_string=("2015D")
#Brange=18


c= ROOT.TCanvas("c", "c", 700, 700)
#c.Draw()
Plots=["collMass_type1","nvtx","singleIsoMu22Pass","singleIsoTkMu22Pass"]
Xlable=["collMass_type1","nvtx","singleIsoMu22Pass","singleIsoTkMu22Pass"]
leg =ROOT.TLegend(0.2,0.85,0.48,0.9);
#text =ROOT.TLatex(-1,0.0405,"CMS Preliminary");
#text.SetTextSize(0.03);
#text.SetTextFont(42);
Groupplots=len(Plots)
Groupplots=2
#norm=1
#Etareso=(ROOT.TGraphAsymmErrors(Brange),ROOT.TGraphAsymmErrors(Brange))
for i in range(0,Groupplots):
#   for binnumber in range(0,Brange):
   hist0=filein[0].Get("preselection/"+Xlable[i])
   hist1=filein[1].Get("preselection/"+Xlable[i])
   norm0=hist0.GetEntries()
   norm1=hist1.GetEntries()
   print norm0
   print norm1
   hist0.Scale(1/61526.7)
#   hist0.Scale(1/119.217087866)
#   hist0.Scale(1/60730461.2)
   hist1.Scale(3)
#   hist1.Scale(1/norm1)
#hist.Sumw2()
#fit= doubleCBFit(hist,5.)
   hist0.GetXaxis().SetTitle(Xlable[i])
   hist0.GetYaxis().SetTitle("Events")
   hist0.SetLineColorAlpha(2,1)
   hist1.SetLineColorAlpha(1,1)
   leg.AddEntry(hist0,title_name_string[0],'l')
   leg.AddEntry(hist1,title_name_string[1],'l')
 #  hist0.Scale(norm,"width")
 #  hist1.Scale(norm,"width")
   hist0.Draw()
   c.Update()
   hist1.Draw("SAME L")
  # text.Draw("SAME")
   leg.Draw("SAME L")
 #  c.Update()
   c.SaveAs("Plots/"+Plots[i]+".png")
#hist.SetTitle(title_name_string[i]+", #eta bin range "+str(round(-2.5+binnumber*Bwidth,2))+" to "+ str(round(-2.5+(binnumber+1)*Bwidth,2)) )
#func=fit[0]
#peak = func.GetParameter(1)




#text =ROOT.TLatex(-1,0.0405,"CMS Preliminary");
#text.SetTextSize(0.03);
#text.SetTextFont(42);
#text.Draw("SAME")
#hist0.Draw("AP")
#c.SaveAs("Etareso_2012vs2015.png")
