import subprocess
import optimizer
import os
import shutil
#import ROOT
from ROOT import *
import ROOT
import math
import numpy as np
import matplotlib.pyplot as pyplot
from array import array



def Readtree_AddMCB(filename,channel):
      filein=ROOT.TFile.Open(filename, "READ")
      histowjets= filein.Get(channel+"/wjets").Clone()
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
      histowjets.Add(T)
      return histowjets


def Readtree_AddMCS(filename,channel):
      filein=ROOT.TFile.Open(filename, "READ")
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
              'tPt':['0','150'],
              'tEta':['-2.5','2.5'],
              'tPhi':['-3.4','3.4'],
              'tJetPt':['0','150']
             }   

for i in range(0,3):
    for variable in variablelist:
       c= ROOT.TCanvas("c", "c", 700, 700)
       hist0= Readtree_AddMCB("LFV_"+samplelist[str(i)][0]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       Xmax=hist0.GetMaximumBin()
       Ymax=hist0.GetXaxis().GetBinCenter(Xmax)
       hist1= Readtree_AddMCB("LFV_"+samplelist[str(i)][1]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       hist10= Readtree_AddMCB("LFV_"+samplelist[str(i)][2]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       histx=c.DrawFrame(float(variablelist[variable][0]),0,float(variablelist[variable][1]),Ymax*1.5)
       hist0.SetLineColor(1) 
       hist0.SetLineColor(2) 
       hist0.SetLineColor(4) 
       hist0.Draw("pl") 
       hist1.Draw("pl") 
       hist10.Draw("pl") 
       c.SaveAs("DMplots/"+str(i)+"_jets_BG_"+variable+".pdf")   
     
       c.Clear()
     
       hist0= Readtree_AddMCS("LFV_"+samplelist[str(i)][0]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       Xmax=hist0.GetMaximumBin()
       Ymax=hist0.GetXaxis().GetBinCenter(Xmax)
       hist1= Readtree_AddMCS("LFV_"+samplelist[str(i)][1]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       hist10= Readtree_AddMCS("LFV_"+samplelist[str(i)][2]+"_"+variable+"__"+"Blinded"+"_PoissonErrors"],samplelist[str(i)][3])
       histx=c.DrawFrame(float(variablelist[variable][0]),0,float(variablelist[variable][1]),Ymax*1.5)
       hist0.SetLineColor(1)
       hist0.SetLineColor(2)
       hist0.SetLineColor(4)
       hist0.Draw("pl")
       hist1.Draw("pl")
       hist10.Draw("pl")
       c.SaveAs("DMplots/"+str(i)+"_jets_S_"+variable+".pdf")       





