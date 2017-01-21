from sys import argv, stdout, stderr
import getopt
import ROOT
from  ROOT import *
import sys
import array
#import XSec_2016
#import XSec

#def make_histo(savedir,file_str, channel,var,isData=False,): #get histogram from file, properly weight histogram
#        histoFile = ROOT.TFile(savedir+file_str+".root")
#        ROOT.gROOT.cd()
#        histo = histoFile.Get(channel+"/"+var).Clone()
#        if (isData==False): #calculate effective luminosity
#                #metafile = lumidir + file_str+"_weight.log"
                #f = open(metafile).read().splitlines()
                #nevents = float((f[0]).split(': ',1)[-1])
#                xsec = eval("XSec_2016."+file_str.replace("-","_"))
#                xsec0Jet = eval("XSec_2016.DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")
#                relscale = xsec/xsec0Jet
#                histo.Scale(relscale)
#        return histo
def make_histo(savedir,file_str, channel,var,isData=False,):     #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): #calculate effective luminosity
                histo.Scale(JSONlumi)
    #    else:
     #           histo.Scale(lumi/JSONlumi)
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
#JSONlumi=36145.360  
JSONlumi=20076.26  
#JSONlumi=36161.136  
canvas = ROOT.TCanvas("asdf", "adsf", 800, 800)
#canvas = ROOT.TCanvas("asdf", "adsf",600,400)
canvas.SetGrid()

mmtLoose1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLoose = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
mmtLooseww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)
mmtLoosewz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)
mmtLoosezz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)

#mmtLoosewwold.Add(mmtLoosewzold)
#mmtLoosewwold.Add(mmtLoosezzold)
#print "the number of Loose Dibson old %f"   %(mmtLoosewwold.Integral())

#mmtLooseww = make_histo(savedir,"WWTo2L2Nu_13TeV-powheg",channelLoose,var)
#mmtLoosewz = make_histo(savedir,"WZTo3LNu_TuneCUETP8M1_13TeV-powheg-pythia8",channelLoose,var)
#mmtLoosezz = make_histo(savedir,"ZZTo4L_13TeV_powheg_pythia8",channelLoose,var)

mmtLooseww.Add(mmtLoosewz)
mmtLooseww.Add(mmtLoosezz)
print "the number of Loose Dibson %f"   %(mmtLooseww.Integral())
mmtLooseww.Scale(-1)

mmtLoose.Add(mmtLoose1)
mmtLoose.Add(mmtLoose2)
mmtLoose.Add(mmtLoose3)
mmtLoose.Add(mmtLoose4)
#mmtLoose.Add(mmtLooseww)
#mmtLoose.Add(mmtLoosewz)
#mmtLoose.Add(mmtLoosezz)

mmtTight1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
mmtTight = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
#mmtTightww = make_histo(savedir,"WWTo2L2Nu_13TeV-powheg",channelTight,var)
#mmtTightwz = make_histo(savedir,"WZTo3LNu_TuneCUETP8M1_13TeV-powheg-pythia8",channelTight,var)
#mmtTightzz = make_histo(savedir,"ZZTo4L_13TeV_powheg_pythia8",channelTight,var)

mmtTightww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channelTight,var)
mmtTightwz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channelTight,var)
mmtTightzz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channelTight,var)
#mmtTightwwold.Add(mmtTightwzold)
#mmtTightwwold.Add(mmtTightzzold)
#print "the number of Tight Dibson old %f"   %(mmtTightwwold.Integral())

mmtTightww.Add(mmtTightwz)
mmtTightww.Add(mmtTightzz)
print "the number of Tight Dibson %f"   %(mmtTightww.Integral())
mmtTightww.Scale(-1)

mmtTight.Add(mmtTight1)
mmtTight.Add(mmtTight2)
mmtTight.Add(mmtTight3)
mmtTight.Add(mmtTight4)

dataLoose = make_histo(savedir,"data_SingleMuon_Run2016B",channelLoose,var,True)
dataLooseC = make_histo(savedir,"data_SingleMuon_Run2016C",channelLoose,var,True)
dataLooseD = make_histo(savedir,"data_SingleMuon_Run2016D",channelLoose,var,True)
dataLooseE = make_histo(savedir,"data_SingleMuon_Run2016E",channelLoose,var,True)
dataLooseF = make_histo(savedir,"data_SingleMuon_Run2016F",channelLoose,var,True)
#dataLooseG = make_histo(savedir,"data_SingleMuon_Run2016G",channelLoose,var,True)
#dataLooseH = make_histo(savedir,"data_SingleMuon_Run2016H",channelLoose,var,True)
dataLoose.Add(dataLooseC)
dataLoose.Add(dataLooseD)
dataLoose.Add(dataLooseE)
dataLoose.Add(dataLooseF)
#dataLoose.Add(dataLooseG)
#dataLoose.Add(dataLooseH)
print "the number of Loose  data %f"   %(dataLoose.Integral())
dataLoose.Add(mmtLooseww)
dataTight = make_histo(savedir,"data_SingleMuon_Run2016B",channelTight,var,True)
dataTightC = make_histo(savedir,"data_SingleMuon_Run2016C",channelTight,var,True)
dataTightD = make_histo(savedir,"data_SingleMuon_Run2016D",channelTight,var,True)
dataTightE = make_histo(savedir,"data_SingleMuon_Run2016E",channelTight,var,True)
dataTightF = make_histo(savedir,"data_SingleMuon_Run2016F",channelTight,var,True)
#dataTightG = make_histo(savedir,"data_SingleMuon_Run2016G",channelTight,var,True)
#dataTightH = make_histo(savedir,"data_SingleMuon_Run2016H",channelTight,var,True)
dataTight.Add(dataTightC)
dataTight.Add(dataTightD)
dataTight.Add(dataTightE)
dataTight.Add(dataTightF)
#dataTight.Add(dataTightG)
#dataTight.Add(dataTightH)
print "the number of Tight data %f"   %(dataTight.Integral())
dataTight.Add(mmtTightww)

#xBins = array.array('d',[30,50,65,85,100,200])
#xBins = array.array('d',[30,45,55,75,100,200])
xBins = array.array('d',[35,45,55,75,100,200])
#xBins = array.array('d',[30,50,65,85,100,200])

#if ("tDecayMode" not in var and "tPt" not in var):
#	mmtLoose.Rebin(1)
#	mmtTight.Rebin(1)
#        dataLoose.Rebin(1)
#        dataTight.Rebin(1)
if("Pt" in var):
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
#if ("tEta" in var):
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

#fakeRate = mmtTight.Clone()
#if ("m1_m2" not in var):
fakeRate=ROOT.TEfficiency(mmtTight,mmtLoose);
#	fakeRate.Divide(mmtLoose)
fakeRate.SetMarkerStyle(20)
fakeRate.SetMarkerColor(8)
#fakeRate.SetMarkerColor(kGreen+3)
fakeRate.SetLineColor(8)
#fakeRate.SetMarkerSize(1.5)

#fakeRateData = dataTight.Clone()
#if ("m1_m2" not in var):
#	fakeRateData.Divide(dataLoose)
print "***********the number of Tight data %f1"   %(dataTight.Integral())
print "***********the number of losose data %f"   %(dataLoose.Integral())
dataTight.SetBinContent(dataTight.GetXaxis().GetNbins()+1,0)
#dataTight.SetBinContent(-1,0)

fakeRateData=ROOT.TEfficiency(dataTight,dataLoose);

print 'bin in tight and loose', dataTight.GetXaxis().GetNbins(), dataLoose.GetXaxis().GetNbins()
for ibin in range(0,dataTight.GetXaxis().GetNbins()+2):
	print 'bin content tight and loose', dataTight.GetBinContent(ibin), dataLoose.GetBinContent(ibin)
#if (('Pt' in var)or ('Eta' in var)):
#     for i in range(0,fakeRateData.GetNbinsX()+1):
#         print "%d bin; center %f;   content %f;  error %f " %(i,fakeRateData.GetBinCenter(i),fakeRateData.GetBinContent(i),fakeRateData.GetBinError(i)) 
fakeRateData.SetMarkerStyle(20)
#fakeRateData.SetMarkerColor(kBlack)
#fakeRateData.SetLineColor(kBlack)
#fakeRateData.SetMarkerSize(1.5)
#fakeRateData.SetTitle("")
#fakeRate.SetTitle("; #mu |#eta|-x ; #mu Fake Rate-y"); 
canvas.cd()
#fakeRate.Draw("ap")
fakeRate.Paint('ap')
fakeRate1=fakeRate.GetPaintedGraph().Clone()
fakeRateData.Paint('ap')
fakeRateData1=fakeRateData.GetPaintedGraph().Clone()
print "***********the number of Tight dataaaaaaaaaaaaaaaaaaa %f"   %(fakeRateData1.Integral())
if 'Eta' in var:
   fakeRate1.GetXaxis().SetRangeUser(0,2.5)
   fakeRateData1.GetXaxis().SetRangeUser(0,2.5)
if 'Pt' in var:
   fakeRate1.GetXaxis().SetRangeUser(30,200)
   fakeRateData1.GetXaxis().SetRangeUser(30,200)
fakeRate1.Draw('ap')
#fakeRate1.GetXaxis().SetTitle('|#eta|')
#fakeRate1.GetYaxis().SetTitle('#mu fakerate')
fakeRate1.SetMaximum(1.1)
fakeRate1.SetMinimum(0)
fakeRateData1.Draw("psame")
#fakeRateData.Paint("psame")
canvas.Update()
#fakeRateData.Draw("ap")
#fakeRate.SetTitle("")
#maxy = max(fakeRate.GetMaximum(),fakeRateData.GetMaximum())*1.1

#if ("m1_m2" not in var):
#	fakeRate.GetYaxis().SetRangeUser(0,1.1)
#else:
#	fakeRate.GetYaxis().SetRangeUser(0,1.1*maxy)

#fakeRate.GetYaxis().SetTitle("#tau Fake Rate")
#fakeRate.GetYaxis().SetTitle("#mu Fake Rate")
#fakeRate.GetYaxis().SetTitleSize(0.05)
#legend = ROOT.TLegend(0.5833333,0.3142857,0.9060606,0.5006803)
legend = ROOT.TLegend(0.5763333,0.3642857,0.8990606,0.5506803)
#legend = ROOT.TLegend(0.55,0.6,0.8,0.90,' ','brNDC')
legend.AddEntry(fakeRate,"DY+Jets MC",'lp')
legend.AddEntry(fakeRateData,"Data",'lp')

legend.Draw()

if ("Eta" in var):
  #fakeRate.GetXaxis().SetTitle("Tau Eta")
  if ("m3Eta" in var):
     fakeRate1.GetXaxis().SetTitle("|#eta|")
     fakeRate1.GetYaxis().SetTitle('#mu fakerate') 
  if ("tEta" in var):
     fakeRate1.GetXaxis().SetTitle("|#eta|")
     fakeRate1.GetYaxis().SetTitle('#tau fakerate') 
#     fakeRate.GetXaxis().SetTitleSize(0.05)
elif ("Pt" in var):
  #fakeRate.GetXaxis().SetTitle("#tau Pt")
 if ("m3Pt" in var):
     fakeRate1.GetXaxis().SetTitle("p_{T} [GeV]")
     fakeRate1.GetYaxis().SetTitle('#mu fakerate') 
 if ("tPt" in var):
     fakeRate1.GetXaxis().SetTitle("p_{T} [GeV]")
     fakeRate1.GetYaxis().SetTitle('#tau fakerate') 
if ("DecayMode" in var):
  fakeRate.GetXaxis().SetTitle("#tau Decay Mode")
  print "decay mode 0: " + str(fakeRateData.GetBinContent(1))
  print "decay mode 1: " + str(fakeRateData.GetBinContent(2))
  print "decay mode 10: " + str(fakeRateData.GetBinContent(11))
#
latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
#latexStr = "%.2f fb^{-1} (13 TeV)"%(2300.0/1000)
latexStr = "13 TeV, 2016"
#latex.DrawLatex(0.9,0.92,latexStr)
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)


if ("Eta" in var):
    if ("tEta" in var):
        #fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x+[3]*x*x*x+[4]*x*x*x*x",-2.5,2.5)
        #fakeFit = ROOT.TF1("adsf","[0]+[1]*x",-2.3,2.3)
        fakeFit = ROOT.TF1("adsf","[0]",0,2.5)
  #fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x",-2.5,2.5)
        fakeRateData1.Fit(fakeFit,"R")
        fakeFit.Draw("same")
    if ("m3" in var):
        #fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x+[3]*x*x*x+[4]*x*x*x*x",-2.5,2.5)
        fakeFit = ROOT.TF1("adsf","[0]",0,2.5)
  #fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x",-2.5,2.5)
        fakeRateData1.Fit(fakeFit,"R")
#        fakeFit.Draw("sames")

#if ("Pt" in var):
#fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x+[3]*x*x*x+[4]*x*x*x*x",40,200)
  #fakeFit = ROOT.TF1("adsf","pol1",30,200)
#  fakeFit = ROOT.TF1("adsf","[0]",30,55)
#  fakeFit1 = ROOT.TF1("adsf","[0]",55,200)
#fakeFit = ROOT.TF1("adsf","[0]+[1]*x+[2]*x*x",-2.5,2.5)
#  fakeRateData1.Fit(fakeFit,"R")
#  fakeRateData1.Fit(fakeFit1,"R")
#  fakeRateData.Draw("sames")
  #fakeFit.Draw("sames")
  #fakeFit1.Draw("sames")
canvas.SaveAs(savedir+"/"+channelTight+"_"+channelLoose+"_"+var+"_fakeRate.pdf")
