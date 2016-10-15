import subprocess
#import optimizer
import os
import shutil
#import ROOT
from ROOT import *
import ROOT
import math
import numpy as np
import matplotlib.pyplot as pyplot
from array import array


ROOT.gROOT.LoadMacro("tdrstyle.C")
#ROOT.gROOT.LoadMacro("Rtypes.h")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
normalize=1

def Readtree_AddMCB(filename,channel):
      filein=ROOT.TFile.Open(filename, "READ")
      ROOT.gROOT.cd()
      histowjets= filein.Get(channel+"/wjets").Clone()
     # SetFillColor(920+4)
      histowjets.Sumw2()
      histoZothers= filein.Get(channel+"/Zothers").Clone()
      histoZTauTau= filein.Get(channel+"/ZTauTau").Clone()
      histoTT= filein.Get(channel+"/TT").Clone()
      histovbfHTauTau= filein.Get(channel+"/vbfHTauTau").Clone()
      histoggHTauTau= filein.Get(channel+"/ggHTauTau").Clone()
      histoDiboson= filein.Get(channel+"/Diboson").Clone()
      histoT= filein.Get(channel+"/T").Clone()
      histowjets.Add(histoZothers)
      histowjets.Add(histoZTauTau)
      histowjets.Add(histoTT)
      histowjets.Add(histovbfHTauTau)
      histowjets.Add(histoggHTauTau)
      histowjets.Add(histoDiboson)
      histowjets.Add(histoT)
      return histowjets


def Readtree_AddMCS(filename,channel):
      filein=ROOT.TFile.Open(filename, "READ")
      ROOT.gROOT.cd()
      histoLFVGG= filein.Get(channel+"/LFVGG125").Clone()
      histoLFVGG.Sumw2()
      histoLFVVBF= filein.Get(channel+"/LFVVBF125").Clone()
      histoLFVGG.Add(histoLFVVBF)
      return histoLFVGG


samplelist={
             "0":["ggTD0","ggTD1","ggTD10","LFV_MuTau_0Jet_1_13TeVMuTau"],
             "1":["boostTD0","boostTD1","boostTD10","LFV_MuTau_1Jet_1_13TeVMuTau"],
             "2":["vbfTD0","vbfTD1","vbfTD10","LFV_MuTau_2Jet_1_13TeVMuTau"],
           }
variablelist={
              'tPt':['0.0','120.0'],
              'tEta':['-2.5','2.5'],
              'tPhi':['-3.1','3.1'],
              'tJetPt':['0.0','120.0']
             }   

for i in range(0,3):
    for variable in variablelist:
       c= ROOT.TCanvas("c", "c", 700, 700)
       c.cd()
       print "LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root"
       hist0= Readtree_AddMCB("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
       hist1= Readtree_AddMCB("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][1]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
       Xmax=hist1.GetMaximumBin()
       Ymax=hist1.GetXaxis().GetBinCenter(Xmax)
       print "the Xmax is %f and Y range is %f " %(Xmax,Ymax)
       hist10= Readtree_AddMCB("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][2]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
  #     histx=c.DrawFrame(float(variablelist[variable][0]),0,float(variablelist[variable][1]),Ymax*1.5)
       c.Clear()
       if normalize==1:
             scale = 1.00/(hist1.Integral());
             hist1.Scale(scale)
             hist1.SetMaximum(0.5)
             hist1.SetMinimum(0) 
       if normalize==1:
             scale = 1.00/(hist0.Integral());
             hist0.Scale(scale)
       if normalize==1:
             scale = 1.00/(hist10.Integral());
             hist10.Scale(scale)
       leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803) 
       leg.AddEntry(hist0,"Tau DM0","l")
       leg.AddEntry(hist1,"Tau DM1","l")
       leg.AddEntry(hist10,"Tau DM10","l")
       hist1.SetLineColor(2) 
       hist0.SetLineColor(1)
       hist10.SetLineColor(4)
       hist1.GetXaxis().SetRangeUser(float(variablelist[variable][0]),float(variablelist[variable][1]))
       hist1.Draw("h") 
       hist1.SetFillColor(0)
       hist0.SetFillColor(0)
       hist0.Draw("hsames") 
       hist10.Draw("hsames") 
       hist10.SetFillColor(0)
       leg.Draw("hsames")
       if normalize==1:
          c.SaveAs("DMplots/"+str(i)+"_jets_BG_"+variable+"_normalized.pdf")
       else:
          c.SaveAs("DMplots/"+str(i)+"_jets_BG_"+variable+".pdf")   
     
       c.Clear()
       c.cd()
       hist0= Readtree_AddMCS("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
       hist1= Readtree_AddMCS("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][1]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
       Xmax=hist1.GetMaximumBin()
       Ymax=hist1.GetXaxis().GetBinCenter(Xmax)
       hist10= Readtree_AddMCS("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][2]+"_"+variable+"__"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3])
#       histx=c.DrawFrame(float(variablelist[variable][0]),0,float(variablelist[variable][1]),Ymax*1.5)
       hist0.SetLineColor(1)
       hist1.SetLineColor(2)
       hist10.SetLineColor(4)
       leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803) 
       leg.AddEntry(hist0,"Tau DM0","l")
       leg.AddEntry(hist1,"Tau DM1","l")
       leg.AddEntry(hist10,"Tau DM10","l")
      # hist0.Draw("pl")
       hist1.GetXaxis().SetRangeUser(float(variablelist[variable][0]),float(variablelist[variable][1]))
       if normalize==1:
             scale = 1.00/(hist1.Integral());
             hist1.Scale(scale)
             hist1.SetMaximum(0.5)
             hist1.SetMinimum(0) 
       if normalize==1:
             scale = 1.00/(hist0.Integral());
             hist0.Scale(scale)
       if normalize==1:
             scale = 1.00/(hist10.Integral());
             hist10.Scale(scale)
       hist1.Draw("h")
       hist0.Draw("hsames")
       hist10.Draw("hsames")
       leg.Draw("hsames")
       if normalize==1:
          c.SaveAs("DMplots/"+str(i)+"_jets_S_"+variable+"_normalized.pdf")
       else:
          c.SaveAs("DMplots/"+str(i)+"_jets_S_"+variable+".pdf")       





