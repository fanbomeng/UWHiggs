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


def Readtree(filename,channel,varibles):
      filein=ROOT.TFile.Open(filename, "READ")
      ROOT.gROOT.cd()
      histoLFVGG= filein.Get(channel+varibles).Clone()
      return histoLFVGG


samplelist={
             "0":["gg","FakeShapeMuTau1st","FakeShapeMuTau2nd","LFV_MuTau_0Jet_1_13TeVMuTau"],
             "1":["boost","FakeShapeMuTau1st","FakeShapeMuTau2nd","LFV_MuTau_1Jet_1_13TeVMuTau"],
             "2":["vbf_gg","FakeShapeMuTau1st","FakeShapeMuTau2nd","LFV_MuTau_2Jetgg_1_13TeVMuTau"],
             "3":["vbf_vbf","FakeShapeMuTau1st","FakeShapeMuTau2nd","LFV_MuTau_2Jetvbf_1_13TeVMuTau"],
           }
variablelist={
              'tPt':['0.0','120.0'],
              'tEta':['-2.5','2.5'],
              'tPhi':['-3.1','3.1'],
              'tJetPt':['0.0','120.0'],
              'collMass_type1':['0.0','500']
             }   

for i in range(0,4):
#    for variable in variablelist:
       c= ROOT.TCanvas("c", "c", 700, 700)
       c.cd()
       hist0= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1__"+samplelist[str(i)][1]+"UpFakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets_"+samplelist[str(i)][1]+"Up")
       hist1= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1_"+"Fakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets")
       hist2= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1__"+samplelist[str(i)][1]+"DownFakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets_"+samplelist[str(i)][1]+"Down")
       Xmax=hist0.GetMaximumBin()
       Ymax=hist0.GetXaxis().GetBinCenter(Xmax)
       histx=c.DrawFrame(float(variablelist['collMass_type1'][0]),0,float(variablelist['collMass_type1'][1]),Ymax*1.5)
       c.Clear()
  #     if normalize==1:
  #           scale = 1.00/(hist1.Integral());
  #           hist1.Scale(scale)
  #           hist1.SetMaximum(0.5)
  #           hist1.SetMinimum(0) 
  #     if normalize==1:
  #           scale = 1.00/(hist0.Integral());
  #           hist0.Scale(scale)
  #     if normalize==1:
  #           scale = 1.00/(hist10.Integral());
  #           hist10.Scale(scale)
       leg =ROOT.TLegend(0.5833333,0.7142857,0.900606,0.9006803)
       leg.AddEntry(hist0,"Fakes + 1#sigma","l")
       leg.AddEntry(hist1,"Unshifted Fakes","l")
       leg.AddEntry(hist2,"Fakes - 1#sigma","l")
       hist1.SetLineColor(1) 
       hist0.SetLineColor(2)
       hist2.SetLineColor(4)
       hist0.SetTitle("")
       hist0.GetXaxis().SetRangeUser(float(variablelist['collMass_type1'][0]),float(variablelist['collMass_type1'][1]))
       hist0.SetFillColor(0)
       hist0.SetLineWidth(2)
       hist1.SetFillColor(0)
       hist1.SetLineWidth(2)
       hist2.SetFillColor(0)
       hist2.SetLineWidth(2)
       hist0.Draw("hist") 
       hist1.Draw("hist sames") 
       hist2.Draw("hist sames") 
       leg.Draw("hsames")
       if normalize==1:
          c.SaveAs("DMplots/"+samplelist[str(i)][0]+"_"+samplelist[str(i)][1]+"_normalized.pdf")
       else:
          c.SaveAs("DMplots/"+samplelist[str(i)][0]+"_"+samplelist[str(i)][1]+".pdf")
    
       c.Clear()
       c.cd()


       #print "LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1__"+samplelist[str(i)][2]+"UpFakes_"+"Blinded"+"_PoissonErrors.root"
       hist0= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1__"+samplelist[str(i)][2]+"UpFakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets_"+samplelist[str(i)][2]+"Up")
       hist1= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1_"+"Fakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets")
       hist2= Readtree("LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/LFV_"+samplelist[str(i)][0]+"_collMass_type1__"+samplelist[str(i)][2]+"DownFakes_"+"Blinded"+"_PoissonErrors.root",samplelist[str(i)][3],"/wjets_"+samplelist[str(i)][2]+"Down")
       Xmax=hist0.GetMaximumBin()
       Ymax=hist0.GetXaxis().GetBinCenter(Xmax)
       histx=c.DrawFrame(float(variablelist['collMass_type1'][0]),0,float(variablelist['collMass_type1'][1]),Ymax*1.5)
       c.Clear()
  #     if normalize==1:
  #           scale = 1.00/(hist1.Integral());
  #           hist1.Scale(scale)
  #           hist1.SetMaximum(0.5)
  #           hist1.SetMinimum(0) 
  #     if normalize==1:
  #           scale = 1.00/(hist0.Integral());
  #           hist0.Scale(scale)
  #     if normalize==1:
  #           scale = 1.00/(hist10.Integral());
  #           hist10.Scale(scale)
       leg =ROOT.TLegend(0.5833333,0.7142857,0.900606,0.9006803)
       leg.AddEntry(hist0,"Fakes + 1#sigma","l")
       leg.AddEntry(hist1,"Unshifted Fakes","l")
       leg.AddEntry(hist2,"Fakes - 1#sigma","l")
       hist1.SetLineColor(1) 
       hist0.SetLineColor(2)
       hist2.SetLineColor(4)
       hist0.SetTitle("")
       hist0.GetXaxis().SetRangeUser(float(variablelist['collMass_type1'][0]),float(variablelist['collMass_type1'][1]))
       hist0.SetFillColor(0)
       hist0.SetLineWidth(2)
       hist1.SetFillColor(0)
       hist1.SetLineWidth(2)
       hist2.SetFillColor(0)
       hist2.SetLineWidth(2)
       hist0.Draw("hist") 
       hist1.Draw("hist sames") 
       hist2.Draw("hist sames") 
       leg.Draw("hsames")
       if normalize==1:
          c.SaveAs("DMplots/"+samplelist[str(i)][0]+"_"+samplelist[str(i)][2]+"_normalized.pdf")
       else:
          c.SaveAs("DMplots/"+samplelist[str(i)][0]+"_"+samplelist[str(i)][2]+".pdf")


 




