from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import array
import XSec_2016

def make_histo(savedir,file_str, channel,var,isData=False,): #get histogram from file, properly weight histogram
        histoFile = ROOT.TFile(savedir+file_str+".root")
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+var).Clone()
        if (isData==False): #calculate effective luminosity
                metafile = savedir+"/weights/" + file_str+"_weight.log"
                f = open(metafile).read().splitlines()
                nevents = float((f[0]).split(': ',1)[-1])
                xsec = eval("XSec_2016."+file_str.replace("-","_"))
                #xsec0Jet = eval("XSec_2016.DYJetsToLL_M_50_TuneCUETP8M1_13TeV_madgraphMLM_pythia8")
                datalumi = 15700.0
                efflumi = nevents/xsec
                relscale = datalumi/efflumi
                histo.Scale(relscale)
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

canvas = ROOT.TCanvas("asdf", "adsf", 800, 800)
canvas.SetGrid()

eetLoose1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
eetLoose2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
eetLoose3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
eetLoose4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
eetLoose = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelLoose,var)
eetLooseWW = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)
eetLooseWZ = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)
eetLooseZZ = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channelLoose,var)

eetLooseDiboson = eetLooseWW.Clone()
eetLooseDiboson.Add(eetLooseWZ)
eetLooseDiboson.Add(eetLooseZZ)
eetLoose.Add(eetLoose1)
eetLoose.Add(eetLoose2)
eetLoose.Add(eetLoose3)
eetLoose.Add(eetLoose4)

eetTight1 = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
eetTight2 = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
eetTight3 = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
eetTight4 = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
eetTight = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channelTight,var)
eetTightWW = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channelTight,var)
eetTightWZ = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channelTight,var)
eetTightZZ = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channelTight,var)

eetTightDiboson = eetTightWW.Clone()
eetTightDiboson.Add(eetTightWZ)
eetTightDiboson.Add(eetTightZZ)
eetTight.Add(eetTight1)
eetTight.Add(eetTight2)
eetTight.Add(eetTight3)
eetTight.Add(eetTight4)

dataLoose = make_histo(savedir,"data_SingleElectron_Run2016BE",channelLoose,var,True)
dataTight = make_histo(savedir,"data_SingleElectron_Run2016BE",channelTight,var,True)

eetTightDiboson.Scale(-1)
eetLooseDiboson.Scale(-1)
dataLoose.Add(eetLooseDiboson)
dataTight.Add(eetTightDiboson)

xBins = array.array('d',[35,45,55,75,100,200])

if ("tDecayMode" not in var and "tPt" not in var):
	eetLoose.Rebin(1)
	eetTight.Rebin(1)
        dataLoose.Rebin(1)
        dataTight.Rebin(1)
if("tPt" in var):
        eetLoose.Rebin(len(xBins)-1,"eetLooseRebinned",xBins)
        eetTight.Rebin(len(xBins)-1,"eetTightRebinned",xBins)
        eetLooseRebinned = ROOT.gDirectory.Get("eetLooseRebinned")
        eetTightRebinned = ROOT.gDirectory.Get("eetTightRebinned")
        eetLoose = eetLooseRebinned.Clone()
        eetTight = eetTightRebinned.Clone()
        dataLoose.Rebin(len(xBins)-1,"dataLooseRebinned",xBins)
        dataTight.Rebin(len(xBins)-1,"dataTightRebinned",xBins)
        dataLooseRebinned = ROOT.gDirectory.Get("dataLooseRebinned")
        dataTightRebinned = ROOT.gDirectory.Get("dataTightRebinned")
        dataLoose = dataLooseRebinned.Clone()
        dataTight = dataTightRebinned.Clone()
if ("tEta" in var):
        eetLoose.Rebin(5)
        eetTight.Rebin(5)
        dataLoose.Rebin(5)
        dataTight.Rebin(5)

fakeRate = eetTight.Clone()
if ("m1_m2" not in var):
	fakeRate.Divide(eetLoose)
fakeRate.SetMarkerStyle(20)
fakeRate.SetMarkerColor(ROOT.EColor.kGreen+3)
fakeRate.SetLineColor(ROOT.EColor.kBlack)
fakeRate.SetMarkerSize(1.5)

fakeRateData = dataTight.Clone()
if ("m1_m2" not in var):
	fakeRateData.Divide(dataLoose)
fakeRateData.SetMarkerStyle(20)
fakeRateData.SetMarkerColor(ROOT.EColor.kBlack)
fakeRateData.SetLineColor(ROOT.EColor.kBlack)
fakeRateData.SetMarkerSize(1.5)
fakeRateData.SetTitle("")

fakeRate.Draw("ep")
fakeRateData.Draw("epsames")
fakeRate.SetTitle("")
maxy = max(fakeRate.GetMaximum(),fakeRateData.GetMaximum())*1.1

if ("m1_m2" not in var):
	fakeRate.GetYaxis().SetRangeUser(0,1.1)
else:
	fakeRate.GetYaxis().SetRangeUser(0,1.1*maxy)

fakeRate.GetYaxis().SetTitle("Tau Fake Rate")
fakeRate.GetYaxis().SetTitleSize(0.05)
legend = ROOT.TLegend(0.55,0.6,0.8,0.90,' ','brNDC')
legend.AddEntry(fakeRate,"Z+Jets MC")
legend.AddEntry(fakeRateData,"Data")

legend.Draw("sames")

if ("Eta" in var):
  fakeRate.GetXaxis().SetTitle("Tau Eta")
  fakeRate.GetXaxis().SetTitleSize(0.05)
elif ("Pt" in var):
  fakeRate.GetXaxis().SetTitle("#tau Pt")
if ("DecayMode" in var):
  fakeRate.GetXaxis().SetTitle("#tau Decay Mode")
  print "decay mode 0: " + str(fakeRateData.GetBinContent(1))
  print "decay mode 1: " + str(fakeRateData.GetBinContent(2))
  print "decay mode 10: " + str(fakeRateData.GetBinContent(11))

latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
#latexStr = "%.2f fb^{-1} (13 TeV)"%(2300.0/1000)
latexStr = "13 TeV, 2016"
latex.DrawLatex(0.9,0.92,latexStr)
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)


canvas.SaveAs(savedir+"/"+channelTight+"_"+channelLoose+"_"+var+"_fakeRate.png")
