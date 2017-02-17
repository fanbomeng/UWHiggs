from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec
clearnoverflow=1
moveoverflow=0
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ROOT.gROOT.LoadMacro("CMS_lumi.C")
ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

def make_histo(histoFile,channel,BkN):     #get histogram from file, properly weight histogram
        ROOT.gROOT.cd()
        histo = histoFile.Get(channel+"/"+BkN).Clone()
#        histo.Scale(1/histo.Integral())
        return histo

histoFile = ROOT.TFile("LFV_36fb_mutauhad_cutbasedrebin_check.root")
#samplename=['data_obs','wjets','Zothers','ZTauTau','TT','LFVVBF125','LFVGG125','vbfHTauTau','ggHTauTau','Dibison','T']
samplename=['Zothers','ZTauTau','TT','LFVVBF125','LFVGG125','vbfHTauTau','ggHTauTau','Diboson','T']
categories=['LFV_MuTau_0Jet_1_13TeVMuTau','LFV_MuTau_1Jet_1_13TeVMuTau','LFV_MuTau_2Jetgg_1_13TeVMuTau','LFV_MuTau_2Jetvbf_1_13TeVMuTau']
#sysused=['Ues']#,'Jes','Tes']
sysused=['Jes','Ues','Tes']
'''
access each category
access each sample
plotting sys up and down
'''
canvas = ROOT.TCanvas("canvas","canvas",800,800)
canvas.cd()
p_lfv = ROOT.TPad('p_lfv','p_lfv',0,0,1,1)
p_lfv.SetLeftMargin(0.2147651)
p_lfv.SetRightMargin(0.06543624)
p_lfv.SetTopMargin(0.04895105)
p_lfv.SetBottomMargin(0.305)
p_lfv.Draw()
p_ratio = ROOT.TPad('p_ratio','p_ratio',0,0,1,0.295)
p_ratio.SetLeftMargin(0.2147651)
p_ratio.SetRightMargin(0.06543624)
p_ratio.SetTopMargin(0.04895105)
p_ratio.SetBottomMargin(0.295)
p_ratio.SetGridy()
p_ratio.Draw()
for i in samplename:


   for j in  categories:

    
       for k in sysused:
          histoname=i+'_CMS_MET_'+k
          nosys=make_histo(histoFile,j,i)
          sysup=make_histo(histoFile,j,histoname+'Up')
          sysdown=make_histo(histoFile,j,histoname+'Down')
          nosys.SetLineColor(1)
          nosys.SetFillColor(0)
          nosys.SetLineWidth(1)
          nosys.SetMarkerSize(0)
          sysup.SetLineColor(2)
          sysup.SetFillColor(0)
          sysup.SetLineWidth(1)
          sysup.SetMarkerSize(0)
          sysdown.SetLineColor(4)
          sysdown.SetFillColor(0)
          sysdown.SetLineWidth(1)
          sysdown.SetMarkerSize(0)
          p_ratio.cd() 
          ROOT.gROOT.LoadMacro("tdrstyle.C")
          ROOT.setTDRStyle()
          ratio = sysup.Clone()
          ratio_2=sysdown.Clone()
#          Sysdown = sysdown.Clone()
          ratio.Divide(nosys)
          ratio_2.Divide(nosys)
          ratio.GetXaxis().SetTitle("M(#mu#tau_{h})_{col} [GeV])")
          ratio.GetXaxis().SetTitleSize(0.12)
          ratio.GetXaxis().SetNdivisions(510)
          ratio.GetXaxis().SetTitleOffset(1.1)
          ratio.GetXaxis().SetLabelSize(0.12)
          ratio.GetXaxis().SetLabelFont(42)
          ratio.GetYaxis().SetNdivisions(505)
          ratio.GetYaxis().SetLabelFont(42)
          ratio.GetYaxis().SetLabelSize(0.1)
          ratio.GetYaxis().SetRangeUser(0.6,1.4)
          ratio.GetYaxis().SetTitle("shape ratio")
          ratio.GetYaxis().SetTitle("")
          ratio.GetYaxis().CenterTitle(1)
          ratio.GetYaxis().SetTitleOffset(0.4)
          ratio.GetYaxis().SetTitleSize(0.12)
          ratio.SetTitle("")
          ratio.Draw("E1")
          ratio_2.Draw("E1 sames")
          p_lfv.cd()
#          p_lfv.SetTitle(i)
          LFVStack = ROOT.THStack("stack",i) 
          #nosys.Scale(1/nosys.Integral())
          #sysup.Scale(1/sysup.Integral())
          #sysdown.Scale(1/sysdown.Integral())
          LFVStack.Add(nosys)
          maxLFVStack = LFVStack.GetMaximum()
          LFVStack.SetMaximum(maxLFVStack*1.20)
          LFVStack.Draw('hist')
          sysup.Draw('hsames')
          sysdown.Draw('hsames')
          LFVStack.GetXaxis().SetTitle("M(#mu#tau_{h})_{col} [GeV])")
          LFVStack.GetXaxis().SetNdivisions(510)
          LFVStack.GetXaxis().SetLabelSize(0.035)
          LFVStack.GetYaxis().SetTitle("Events")
          LFVStack.GetYaxis().SetTitleOffset(1.40)
          LFVStack.GetYaxis().SetLabelSize(0.035)
          latex = ROOT.TLatex()
          latex.SetNDC()
          latex.SetTextSize(0.03)
          latex.SetTextAlign(31)
          latexStr = "%.2f fb^{-1} (13 TeV)"%(36.81)
          latex.DrawLatex(0.9,0.96,latexStr)
          latex.SetTextAlign(11)
          latex.SetTextFont(61)
          latex.SetTextSize(0.04)
          latex.DrawLatex(0.25,0.92,"CMS")
          latex.SetTextFont(52)
          latex.SetTextSize(0.027)
          latex.DrawLatex(0.25,0.87,"Preliminary")
          
          legend=ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')
          legend.SetFillColor(0)
          legend.SetBorderSize(0)
          legend.SetFillStyle(0)
          legend.Draw('sames')
          legend.AddEntry(sysup,k+'_Up')
          legend.AddEntry(nosys,k)
          legend.AddEntry(sysdown,k+'_Down')
#Canvas.Update() 

          outfile_name=i+'_'+j+'_'+k
          canvas.Update() 
          canvas.SaveAs('plots/'+outfile_name+".pdf") 
          canvas.Clear('D')
'''
legend
'''



'''
normal plots
ratio
'''















