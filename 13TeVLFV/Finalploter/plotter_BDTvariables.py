/#!/usr/bin/env python
import ROOT
import re
from array import array
from collections import OrderedDict
import argparse
import os

parser = argparse.ArgumentParser(
    "Create pre/post-fit plots for LFV H analysis")
parser.add_argument(
    "--isLog",
    type=int,
    action="store",
    dest="isLog",
    default=0,
    help="Plot Log Y? (Integers 0, false, 1 true)")
parser.add_argument(
    "--channel",
    action="store",
    dest="channel",
    default="et",
    help="Which channel to run over? (et, mt, em, me)")
parser.add_argument(
    "--prefix",
    action="store",
    dest="prefix",
    default="",
    help="Provide prefix for TDirectory holding histograms such as 'prefit_' or postfin_'.  Default is '' and will search in CHANNEL_0jet, CHANNEL_boosted, CHANNEL_VBF")
parser.add_argument(
    "--higgsSF",
    type=int,
    action="store",
    dest="higgsSF",
    default=20,
    help="Provide the Scale Factor for the SM-Higgs signals.  10x is default")
parser.add_argument(
    "--inputFile",
    action="store",
    dest="inputFile",
    help="Provide the relative path to the target input file")
args = parser.parse_args()

channel = args.channel
higgsSF = args.higgsSF
fileName = args.inputFile

file = ROOT.TFile( fileName, "r" )

# Category map for the LaTeX naming of histograms
catMap = {
    "em" : "e#tau_{#mu}",
    "et" : "e#tau_{h}",
    "mt" : "#mu#tau_{h}",
    "me" : "#mu#tau_{e}",
}

def add_lumi():
    lowX=0.65
    lowY=0.835
    lumi  = ROOT.TPaveText(lowX, lowY+0.06, lowX+0.30, lowY+0.16, "NDC")
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.SetTextSize(0.04)
    lumi.SetTextFont (   42 )
    lumi.AddText("35.9 fb^{-1} (13 TeV)")
    return lumi

def add_CMS():
    lowX=0.18
    lowY=0.745
    lumi  = ROOT.TPaveText(lowX, lowY+0.06, lowX+0.15, lowY+0.16, "NDC")
    lumi.SetTextFont(61)
    lumi.SetTextSize(0.05)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("CMS")
    return lumi

def add_Preliminary():
    lowX=0.18
    lowY=0.695
    lumi  = ROOT.TPaveText(lowX, lowY+0.06, lowX+0.15, lowY+0.16, "NDC")
    lumi.SetTextFont(52)
    lumi.SetTextSize(0.04)
    lumi.SetBorderSize(   0 )
    lumi.SetFillStyle(    0 )
    lumi.SetTextAlign(   12 )
    lumi.SetTextColor(    1 )
    lumi.AddText("Preliminary")
    return lumi

def make_legend():
	output = ROOT.TLegend(0.56, 0.5, 0.93, 0.85, "", "brNDC")
        output.SetNColumns(2)
        #output = ROOT.TLegend(0.2, 0.1, 0.47, 0.65, "", "brNDC")
        output.SetLineWidth(0)
        output.SetLineStyle(0)
        output.SetFillStyle(0)
        #output.SetFillColor(0)
        output.SetBorderSize(0)
        output.SetTextFont(62)
        return output

ROOT.gStyle.SetFrameLineWidth(3)
ROOT.gStyle.SetLineWidth(3)
ROOT.gStyle.SetOptStat(0)
ROOT.gROOT.SetBatch(True)

c=ROOT.TCanvas("canvas","",0,0,800,800)
c.cd()


adapt=ROOT.gROOT.GetColor(12)
new_idx=ROOT.gROOT.GetListOfColors().GetSize() + 1
trans=ROOT.TColor(new_idx, adapt.GetRed(), adapt.GetGreen(),adapt.GetBlue(), "",0.5)

hist_ZTT=file.Get("etauh_0jet").Get("ZTauTau")
hist_Fakes=file.Get("etauh_0jet").Get("Fakes")
hist_TT=file.Get("etauh_0jet").Get("TT")
hist_TT.Add(file.Get("etauh_0jet").Get("T"))
hist_sig=file.Get("etauh_0jet").Get("LFVGG125")
hist_sig.Add(file.Get("etauh_0jet").Get("LFVVBF125"))
hist_VV=file.Get("etauh_0jet").Get("Diboson")
hist_data=file.Get("etauh_0jet").Get("data_obs")
hist_ZL=file.Get("etauh_0jet").Get("Zothers")
hist_SM=file.Get("etauh_0jet").Get("ggH_htt")
hist_SM.Add(file.Get("etauh_0jet").Get("qqH_htt"))
#hist_SM.Add(file.Get("etauh_0jet").Get("ggH_hww"))
#hist_SM.Add(file.Get("etauh_0jet").Get("qqH_hww"))

for k in range(1,hist_ZTT.GetSize()-1):
   hist_TT.SetBinError(k,(0.10*hist_TT.GetBinContent(k)*0.10*hist_TT.GetBinContent(k)+hist_TT.GetBinError(k)*hist_TT.GetBinError(k))**0.5)
   hist_ZTT.SetBinError(k,(0.10*hist_ZTT.GetBinContent(k)*0.10*hist_ZTT.GetBinContent(k)+hist_ZTT.GetBinError(k)*hist_ZTT.GetBinError(k))**0.5)
   hist_ZL.SetBinError(k,(0.12*hist_ZL.GetBinContent(k)*0.12*hist_ZL.GetBinContent(k)+hist_ZL.GetBinError(k)*hist_ZL.GetBinError(k))**0.5)
   hist_Fakes.SetBinError(k,(0.30*hist_Fakes.GetBinContent(k)*0.30*hist_Fakes.GetBinContent(k)+hist_Fakes.GetBinError(k)*hist_Fakes.GetBinError(k))**0.5)
   hist_VV.SetBinError(k,(0.05*hist_VV.GetBinContent(k)*0.05*hist_VV.GetBinContent(k)+hist_VV.GetBinError(k)*hist_VV.GetBinError(k))**0.5)
   hist_SM.SetBinError(k,(0.10*hist_SM.GetBinContent(k)*0.10*hist_SM.GetBinContent(k)+hist_SM.GetBinError(k)*hist_SM.GetBinError(k))**0.5)

hist_Fakes.SetFillColor(ROOT.TColor.GetColor("#ffccff"))
hist_Fakes.SetLineColor(1)
hist_VV.SetFillColor(ROOT.TColor.GetColor("#12cadd"))
hist_VV.SetLineColor(1)
hist_ZTT.SetFillColor(ROOT.TColor.GetColor("#ffcc66"))
hist_ZTT.SetLineColor(1)
hist_ZL.SetFillColor(ROOT.TColor.GetColor("#4496c8"))
hist_ZL.SetLineColor(1)
hist_TT.SetFillColor(ROOT.TColor.GetColor("#9999cc"))
hist_TT.SetLineColor(1)
hist_SM.SetFillColor(ROOT.TColor.GetColor("#c243cd"))
hist_sig.SetLineColor(ROOT.TColor.GetColor("#111bbb"))
hist_SM.SetLineColor(1)
hist_data.SetLineColor(1)

mystack=ROOT.THStack("mystack","")
mystack.Add(hist_Fakes)
mystack.Add(hist_SM)
mystack.Add(hist_VV)
mystack.Add(hist_TT)
mystack.Add(hist_ZL)
mystack.Add(hist_ZTT)

errorBand=hist_Fakes.Clone()
errorBand.Add(hist_SM)
errorBand.Add(hist_VV)
errorBand.Add(hist_TT)
errorBand.Add(hist_ZL)
errorBand.Add(hist_ZTT)
    
# Set aesthetics
hist_data.GetXaxis().SetTitleSize(0.04)
hist_data.GetXaxis().SetNdivisions(505)
hist_data.GetYaxis().SetLabelFont(42)
hist_data.GetYaxis().SetLabelOffset(0.01)
hist_data.GetYaxis().SetLabelSize(0.04)
hist_data.GetXaxis().SetLabelSize(0.04)
hist_data.GetYaxis().SetTitleSize(0.04)
hist_data.GetYaxis().SetTitleOffset(2.0)#0.96)
hist_data.SetTitle("")
hist_data.GetYaxis().SetTitle("Events/bin")
hist_data.GetXaxis().SetTitle("e p_{T} (GeV)")
hist_data.SetMarkerStyle(20)
hist_data.SetMarkerSize(1)
hist_data.SetLineWidth(1)
hist_sig.SetLineWidth(5)

errorBand.SetMarkerSize(0)
errorBand.SetFillColor(new_idx)
errorBand.SetFillStyle(3001)
errorBand.SetLineWidth(1)

c.cd()
c.SetFillColor(0)
c.SetBorderMode(0)
c.SetBorderSize(10)
c.SetTickx(1)
c.SetTicky(1)
c.SetLeftMargin(0.16)
c.SetRightMargin(0.05)
c.SetTopMargin(0.10)
c.SetBottomMargin(0.10)
c.SetFrameFillStyle(0)
c.SetFrameLineStyle(0)
c.SetFrameLineWidth(3)
c.SetFrameBorderMode(0)
c.SetFrameBorderSize(10)

hist_data.SetMaximum(1.25*max(mystack.GetMaximum(),hist_data.GetMaximum()))
hist_data.SetMinimum(0.0)
hist_data.Draw("ep")
mystack.Draw("histsame")
errorBand.Draw("e2same")
hist_sig.Scale(higgsSF)
hist_sig.Draw("histsame")
hist_data.Draw("esame")

legend=make_legend()
legend.AddEntry(hist_data, "Observed","ep")
legend.AddEntry(hist_ZTT, "Z#rightarrow#tau#tau","f")
legend.AddEntry(hist_ZL, "Z#rightarrowee/#mu#mu","f")
legend.AddEntry(hist_TT, "t#bar{t},t+jets","f")
legend.AddEntry(hist_VV, "Diboson","f")
legend.AddEntry(hist_Fakes, "Reducible","f")
legend.AddEntry(hist_SM, "SM H#rightarrow#tau#tau","f")
legend.AddEntry(hist_sig, "H#rightarrowe#tau (B=20%)","l")
legend.AddEntry(errorBand,"Bkg. unc.","f")
legend.Draw()

l1=add_lumi()
l1.Draw("same")
l2=add_CMS()
l2.Draw("same")
l3=add_Preliminary()
l3.Draw("same")

categ  = ROOT.TPaveText(0.18, 0.655, 0.45, 0.655+0.155, "NDC")
categ.SetBorderSize(   0 )
categ.SetFillStyle(    0 )
categ.SetTextAlign(   12 )
categ.SetTextSize ( 0.04 )
categ.SetTextColor(    1 )
categ.SetTextFont (   42 )
categ.AddText("e#tau_{h}")
categ.Draw("same")

c.cd()

ROOT.gPad.RedrawAxis()

c.Modified()
c.SaveAs("plotsBDT/etauh_pte.pdf")
c.SaveAs("plotsBDT/etauh_pte.png")
 
