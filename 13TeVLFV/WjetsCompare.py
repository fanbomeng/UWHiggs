from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

def make_histo(savedir,file_str, channel,var,lumidir,lumi,isData=False,):     #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): #calculate effective luminosity
                #metafile = lumidir + file_str+"_weight.log"
                #f = open(metafile).read().splitlines()
                #nevents = float((f[0]).split(': ',1)[-1])
                #xsec = eval("XSec."+file_str.replace("-","_"))
                #efflumi = nevents/xsec
                #histo.Scale(lumi/efflumi) 
                histo.Scale(lumi)
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

  wjetsQCDs = make_histo(savedir,"WJetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(wjetsQCDs,lowDataBin,highDataBin)
  w1jetsQCDs = make_histo(savedir,"W1JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w1jetsQCDs,lowDataBin,highDataBin)
  w2jetsQCDs = make_histo(savedir,"W2JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w2jetsQCDs,lowDataBin,highDataBin)
  w3jetsQCDs = make_histo(savedir,"W3JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w3jetsQCDs,lowDataBin,highDataBin)
  w4jetsQCDs = make_histo(savedir,"W4JetsToLNu_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",QCDChannel,var,lumidir,lumi)
  #do_binbybinQCD(w4jetsQCDs,lowDataBin,highDataBin)
  wjetsQCDs.Add(w1jetsQCDs)
  wjetsQCDs.Add(w2jetsQCDs)
  wjetsQCDs.Add(w3jetsQCDs)
  wjetsQCDs.Add(w4jetsQCDs)
