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
import XSec

ROOT.gROOT.LoadMacro("tdrstyle.C")
#ROOT.gROOT.LoadMacro("Rtypes.h")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
normalize=0


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
                        #       histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
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
savedir="LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/"
shift="none"
lumidir = savedir+"weights/"
JSONlumi = 20076.26
Sampletable={'DataB':'data_SingleMuon_Run2016B',
             'DataC':'data_SingleMuon_Run2016C',
             'DataD':'data_SingleMuon_Run2016D',
             'DataE':'data_SingleMuon_Run2016E',
             'DataF':'data_SingleMuon_Run2016F',
             'DYJets':'DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'DY1Jets':'DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'DY2Jets':'DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'DY3Jets':'DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'DY4Jets':'DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'ZTauTauJets':'ZTauTauJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'ZTauTau1Jets':'ZTauTau1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'ZTauTau2Jets':'ZTauTau2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'ZTauTau3Jets':'ZTauTau3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'ZTauTau4Jets':'ZTauTau4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8',
             'TT':'TT_TuneCUETP8M1_13TeV-powheg-pythia8',
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
Sample_list0=['WJets','W1Jets','W2Jets','W3Jets','W4Jets']
Sample_list1=['WJets','W1Jets','W2Jets','W3Jets','W4Jets']
Sample_list2=['DYJets','DY1Jets','DY2Jets','DY3Jets','DY4Jets']
Channel0=['preselectionSS','preselection']
Channel1=['preselection','preselectionSS']



samplelistG={
             "0":["ggTD0","ggTD1","ggTD10","LFV_MuTau_0Jet_1_13TeVMuTau"],
             "1":["boostTD0","boostTD1","boostTD10","LFV_MuTau_1Jet_1_13TeVMuTau"],
             "2":["vbfTD0","vbfTD1","vbfTD10","LFV_MuTau_2Jet_1_13TeVMuTau"],
           }
variablelist={
              'tPt':['0.0','120.0'],
              'tEta':['-2.5','2.5'],
              'tPhi':['-3.1','3.1'],
              'tJetPt':['0.0','120.0'],
              'tJetPartonFlavour':['-7.0','23.0']
             }   
Histo0 = make_histo(savedir,Sampletable[Sample_list0[0]],Channel0[0],'tJetPartonFlavour',lumidir,JSONlumi)
Histo0.Add(make_histo(savedir,Sampletable[Sample_list0[1]],Channel0[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo0.Add(make_histo(savedir,Sampletable[Sample_list0[2]],Channel0[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo0.Add(make_histo(savedir,Sampletable[Sample_list0[3]],Channel0[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo0.Add(make_histo(savedir,Sampletable[Sample_list0[4]],Channel0[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo1 = make_histo(savedir,Sampletable[Sample_list1[0]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi)
Histo1.Add(make_histo(savedir,Sampletable[Sample_list1[1]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo1.Add(make_histo(savedir,Sampletable[Sample_list1[2]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo1.Add(make_histo(savedir,Sampletable[Sample_list1[3]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo1.Add(make_histo(savedir,Sampletable[Sample_list1[4]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo2 = make_histo(savedir,Sampletable[Sample_list2[0]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi)
Histo2.Add(make_histo(savedir,Sampletable[Sample_list2[1]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo2.Add(make_histo(savedir,Sampletable[Sample_list2[2]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo2.Add(make_histo(savedir,Sampletable[Sample_list2[3]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
Histo2.Add(make_histo(savedir,Sampletable[Sample_list2[4]],Channel1[0],'tJetPartonFlavour',lumidir,JSONlumi))
c= ROOT.TCanvas("c", "c", 700, 700)
c.cd()
Xmax=Histo0.GetMaximumBin()
Ymax=Histo0.GetXaxis().GetBinCenter(Xmax)
histx=c.DrawFrame(float(variablelist['tJetPartonFlavour'][0]),0,float(variablelist['tJetPartonFlavour'][1]),Ymax*1.2)
c.Clear()
if normalize==1:
      scale = 1.00/(hist1.Integral());
      hist1.Scale(scale)
      hist1.SetMaximum(0.5)
      hist1.SetMinimum(0) 
if normalize==1:
      scale = 1.00/(hist0.Integral());
      hist0.Scale(scale)
#leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803) 
kWhite  = 0;   kBlack  = 1;   kGray    = 920;  kRed    = 632;  kGreen  = 416;
kBlue   = 600; kYellow = 400; kMagenta = 616;  kCyan   = 432;  kOrange = 800;
kSpring = 820; kTeal   = 840; kAzure   =  860; kViolet = 880;  kPink   = 900
leg =ROOT.TLegend(0.5833333,0.7142857,0.900606,0.9006803)
#leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803)
#leg.AddEntry(Histo0,"preselection","l")
#leg.AddEntry(Histo1,"preselectionSS","l")
leg.AddEntry(Histo0,"W SS","l")
leg.AddEntry(Histo1,"W OS","l")
leg.AddEntry(Histo2,"Zs OS","l")
Histo0.SetLineColor(616) 
Histo1.SetLineColor(600)
Histo2.SetLineColor(416)
Histo2.GetXaxis().SetTitle("Jet Parton Truth")
#hist1.GetXaxis().SetRangeUser(float(variablelist[variable][0]),float(variablelist[variable][1]))
Histo2.Draw("hist") 
Histo1.Draw("hist same") 
Histo2.SetTitle("")
Histo0.Draw("hist same") 
#Histo0.SetFillColorAlpha(kRed-4,0.35)
#Histo1.SetFillColorAlpha(kBlue,0.9)
#Histo1.SetFillStyle(3003)
leg.Draw("sames")
if normalize==1:
   c.SaveAs(savedir+"LFV"+"_"+"SS_OS"+"_tJetPatonFlavour_"+"normalized.pdf")
else:
   c.SaveAs(savedir+"LFV"+"_"+"SS_OS"+"_tJetPatonFlavour"+".pdf")
     





