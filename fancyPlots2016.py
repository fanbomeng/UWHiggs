from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

def get_histos(savedir,filename,rootdir,histoname):
        inputFile = ROOT.TFile(savedir+"/"+filename)
	print filename
        ROOT.gROOT.cd()
 	if presel == False:
		fitHisto = inputFile.Get("shapes_prefit/"+rootdir+"/"+histoname)
        	if "2" in rootdir:
                	histo = ROOT.TH1D(histoname,histoname,6,0,300)
        	else:
                	histo = ROOT.TH1D(histoname,histoname,20,0,300)
        	for i in range(1,histo.GetNbinsX()+1):
                	histo.SetBinContent(i,fitHisto.GetBinContent(i))
	else:
		histo = inputFile.Get(rootdir+"/"+histoname)
	histoNew = histo.Clone()
        return histoNew

##Set up style
JSONlumi = 12900.0
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")


ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

savedir=argv[1]
rootdir = argv[2]
var = argv[3]

fakeRate = True
blinded = True
canvas = ROOT.TCanvas("canvas","canvas",800,800)

#legend = ROOT.TLegend(0.65,0.60,0.93,0.98,' ','brNDC')
getVarParams = "lfv_vars."+var
varParams = eval(getVarParams)
xLabel = varParams[0]
isGeV = varParams[5]
xRange = varParams[6]
legend = eval(varParams[8])

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
p_lfv.cd()

outfile_name = savedir+"/"+rootdir+"_"+var+"_presel"
if fakeRate == False:
	outfile_name = outfile_name+"_WJetsMC"
lumi = JSONlumi

mlfitMap = {"mutau0J":"roots76xNEWJES_preselection0Jet_collMass_type1.root","mutau1J" : "roots76xNEWJES_preselection1Jet_collMass_type1.root", "mutau2J": "roots76xNEWJES_preselection2Jet_collMass_type1.root"}
dirMap = {"mutau0J":"mutau_preselection0Jet","mutau1J" : "mutau_preselection1Jet", "mutau2J": "mutau_preselection2Jet"}
if fakeRate == True:
	singletFileMap = {"mutau0J":"LFV_preselection0Jet_"+var+"_Fakes_Blinded_PoissonErrors.root","mutau1J":"LFV_preselection1Jet_"+var+"_Fakes_Blinded_PoissonErrors.root","mutau2J":"LFV_preselection2Jet_"+var+"_Fakes_Blinded_PoissonErrors.root","preselmutau":"LFV_preselection_"+var+"_Fakes_Blinded_PoissonErrors.root","ssmutau":"LFV_preselectionSS_"+var+"_Fakes_Blinded_PoissonErrors.root","notIsomutau":"LFV_notIso_"+var+"_Fakes_Blinded_PoissonErrors.root","ssnotIsomutau":"LFV_notIsoSS_"+var+"_Fakes_Blinded_PoissonErrors.root","nvtxmutau":"LFV_preselection_nvtx_Fakes_Blinded_PoissonErrors.root"}
else:
	singletFileMap = {"mutau0J":"LFV_preselection0Jet_"+var+"__Blinded_PoissonErrors.root","mutau1J":"LFV_preselection1Jet_"+var+"__Blinded_PoissonErrors.root","mutau2J":"LFV_preselection2Jet_"+var+"__Blinded_PoissonErrors.root","preselmutau":"LFV_preselection_"+var+"__Blinded_PoissonErrors.root","ssmutau":"LFV_preselectionSS_"+var+"__Blinded_PoissonErrors.root","notIsomutau":"LFV_notIso_"+var+"__Blinded_PoissonErrors.root","ssnotIsomutau":"LFV_notIsoSS_"+var+"__Blinded_PoissonErrors.root","nvtxmutau":"LFV_preselection_nvtx__Blinded_PoissonErrors.root"}
catStringMap = {"mutau0J":"#splitline{#mu#tau_{h} 0-Jet}{Loose selection}","mutau1J":"#splitline{#mu#tau_{h} 1-Jet}{Loose selection}","mutau2J":"#splitline{#mu#tau_{h} 2-Jet}{Loose selection}","preselmutau":"#splitline{#mu#tau_{h} Region I}{Loose selection}","ssmutau":"#splitline{#mu#tau_{h} Region II}{Loose selection}","notIsomutau":"#splitline{#mu#tau_{h} Region III}{Loose selection}","ssnotIsomutau":"#splitline{#mu#tau_{h} Region IV}{Loose selection}","nvtxmutau":"#splitline{#mu#tau_{h}}{Loose selection}"}
singletDirMap = {"mutau0J":"mutau","mutau1J":"mutau","mutau2J":"mutau","preselmutau":"mutau","ssmutau":"mutau","notIsomutau":"mutau","ssnotIsomutau":"mutau","nvtxmutau":"mutau"}
catNameMap = {"mutau0J":"preselection0Jet","mutau1J":"preselection1Jet","mutau2J":"preselection2Jet","preselmutau":"preselection","ssmutau":"preselectionSS","notIsomutau":"notIsoMu","ssnotIsomutau":"notIsoMuSS"}
catName = catNameMap[rootdir]
outfile_name = savedir+"/"+catName+"_"+var+"_MuTau_AMCATNLO"
if fakeRate == False:
        outfile_name = outfile_name+"_WJetsMC"

#inputFile = ROOT.TFile(savedir+"/"+mlfitMap[rootdir])
inputSingletFile = ROOT.TFile(savedir+"/"+singletFileMap[rootdir])
ROOT.gROOT.cd()
data = inputSingletFile.Get(singletDirMap[rootdir]+"/data_obs")
ztautau = inputSingletFile.Get(singletDirMap[rootdir]+"/ZTauTau")
zjets = inputSingletFile.Get(singletDirMap[rootdir]+"/Zothers")
diboson = inputSingletFile.Get(singletDirMap[rootdir]+"/Diboson")
ttbar = inputSingletFile.Get(singletDirMap[rootdir]+"/TT")
if fakeRate == True:
	wjets = inputSingletFile.Get(singletDirMap[rootdir]+"/Fakes")
else:
	wjets = inputSingletFile.Get(singletDirMap[rootdir]+"/wjets")
smhgg = inputSingletFile.Get(singletDirMap[rootdir]+"/ggHTauTau")
smhvbf = inputSingletFile.Get(singletDirMap[rootdir]+"/vbfHTauTau")
gghmutau125 = inputSingletFile.Get(singletDirMap[rootdir]+"/LFVGG125")
vbfhmutau125 = inputSingletFile.Get(singletDirMap[rootdir]+"/LFVVBF125")
singlet = inputSingletFile.Get(singletDirMap[rootdir]+"/T")

ttbar.Add(singlet) #combine ttbar and singlet

xbinLength = wjets.GetBinWidth(1)
widthOfBin = xbinLength
print "widthOfBin:" + str(widthOfBin)

if (widthOfBin == 50):
        print "Signal Region Yields:"
        print "misidentified leptons: " +str(wjets.GetBinContent(3))
        print "Z->TauTau: " + str(ztautau.GetBinContent(3))
        print "ZZ, WW: " + str(diboson.GetBinContent(3))
        if "mue" in rootdir:
                print "Wgamma: " +str(wg.GetBinContent(3))
        elif "mutau" in rootdir:
                print "Wgamma: -"
        print "Z->ll: " + str(zjets.GetBinContent(3))
        print "ttbar: " + str(ttbar.GetBinContent(3))
        print "t: " + str(singlet.GetBinContent(3))
        print "sm higgs: " + str(smhgg.GetBinContent(3)+smhvbf.GetBinContent(3))
        if "mue" in rootdir:
                print "sum of backgrounds: " + str(wjets.GetBinContent(3)+ztautau.GetBinContent(3)+diboson.GetBinContent(3)+zjets.GetBinContent(3)+ttbar.GetBinContent(3)+singlet.GetBinContent(3)+smhgg.GetBinContent(3)+smhvbf.GetBinContent(3)+wg.GetBinContent(3))
        elif "mutau" in rootdir:
                print "sum of backgrounds: " + str(wjets.GetBinContent(3)+ztautau.GetBinContent(3)+diboson.GetBinContent(3)+zjets.GetBinContent(3)+ttbar.GetBinContent(3)+singlet.GetBinContent(3)+smhgg.GetBinContent(3)+smhvbf.GetBinContent(3))
        print "lfv higgs: " + str(gghmutau125.GetBinContent(3)+vbfhmutau125.GetBinContent(3))
        print "data: " + str(data.GetBinContent(3))
if (widthOfBin == 15):
        print "Signal Region Yields 0 or 1:"
        print "misidentified leptons: " +str(wjets.Integral(7,10))
        print "Z->TauTau: " + str(ztautau.Integral(7,10))
        print "ZZ, WW: " + str(diboson.Integral(7,10))
        print "Wgamma: " + str(wg.Integral(7,10))
        print "Z->ll: " + str(zjets.Integral(7,10))
        print "ttbar: " + str(ttbar.Integral(7,10))
        print "t: " + str(singlet.Integral(7,10))
        print "sm higgs: " + str(smhgg.Integral(7,10)+smhvbf.Integral(7,10))
        print "sum of backgrounds: " + str(wjets.Integral(7,10)+ztautau.Integral(7,10)+diboson.Integral(7,10)+zjets.Integral(7,10)+ttbar.Integral(7,10)+singlet.Integral(7,10)+smhgg.Integral(7,10)+smhvbf.Integral(7,10)+wg.Integral(7,10))
        print "lfv higgs: " + str(gghmutau125.Integral(7,10)+vbfhmutau125.Integral(7,10))
        print "data: " + str(data.Integral(7,10))
if (widthOfBin == 20):
        print "Signal Region Yields 0 or 1:"
        print "misidentified leptons: " +str(wjets.Integral(6,8))
        print "Z->TauTau: " + str(ztautau.Integral(6,8))
        print "ZZ, WW: " + str(diboson.Integral(6,8))
        print "Wgamma: -"
        print "Z->ll: " + str(zjets.Integral(6,8))
        print "ttbar: " + str(ttbar.Integral(6,8))
        print "t: " + str(singlet.Integral(6,8))
        print "sm higgs: " + str(smhgg.Integral(6,8)+smhvbf.Integral(6,8))
        print "sum of backgrounds: " + str(wjets.Integral(6,8)+ztautau.Integral(6,8)+diboson.Integral(6,8)+zjets.Integral(6,8)+ttbar.Integral(6,8)+singlet.Integral(6,8)+smhgg.Integral(6,8)+smhvbf.Integral(6,8))
        print "lfv higgs: " + str(gghmutau125.Integral(6,8)+vbfhmutau125.Integral(6,8))
        print "data: " + str(data.Integral(6,8))
if (widthOfBin == 10):
        print "Signal Region Yields 0 or 1:"
        print "misidentified leptons: " +str(wjets.Integral(11,15))
        print "Z->TauTau: " + str(ztautau.Integral(11,15))
        print "ZZ, WW: " + str(diboson.Integral(11,15))
        print "Wgamma: -"
        print "Z->ll: " + str(zjets.Integral(11,15))
        print "ttbar: " + str(ttbar.Integral(11,15))
        print "t: " + str(singlet.Integral(11,15))
        print "sm higgs: " + str(smhgg.Integral(11,15)+smhvbf.Integral(11,15))
        print "sum of backgrounds: " + str(wjets.Integral(11,15)+ztautau.Integral(11,15)+diboson.Integral(11,15)+zjets.Integral(11,15)+ttbar.Integral(11,15)+singlet.Integral(11,15)+smhgg.Integral(11,15)+smhvbf.Integral(11,15))
        print "lfv higgs: " + str(gghmutau125.Integral(11,15)+vbfhmutau125.Integral(11,15))
        print "data: " + str(data.Integral(11,15))
if (widthOfBin == 5):
        print "Signal Region Yields 0 or 1:"
        print "misidentified leptons: " +str(wjets.Integral(21,30))
        print "Z->TauTau: " + str(ztautau.Integral(21,30))
        print "ZZ, WW: " + str(diboson.Integral(21,30))
        print "Wgamma: -"
        print "Z->ll: " + str(zjets.Integral(21,30))
        print "ttbar: " + str(ttbar.Integral(21,30))
        print "t: " + str(singlet.Integral(21,30))
        print "sm higgs: " + str(smhgg.Integral(21,30)+smhvbf.Integral(21,30))
        print "sum of backgrounds: " + str(wjets.Integral(21,30)+ztautau.Integral(21,30)+diboson.Integral(21,30)+zjets.Integral(21,30)+ttbar.Integral(21,30)+singlet.Integral(21,30)+smhgg.Integral(21,30)+smhvbf.Integral(21,30))
        print "lfv higgs: " + str(gghmutau125.Integral(21,30)+vbfhmutau125.Integral(21,30))
        print "data: " + str(data.Integral(21,30))



gghmutau125.Scale(100)
vbfhmutau125.Scale(100) #100% BR

data.SetMarkerStyle(8)
data.SetMarkerSize(1)
data.SetLineColor(ROOT.EColor.kBlack)
gghmutau125.SetLineColor(ROOT.EColor.kRed)
gghmutau125.SetLineWidth(3)
gghmutau125.SetMarkerSize(0)
smhgg.SetLineWidth(1)
smhgg.SetMarkerSize(0)
smhgg.SetFillColor(ROOT.EColor.kMagenta)
smhgg.SetLineColor(ROOT.EColor.kBlack)
vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineWidth(3)
vbfhmutau125.SetMarkerSize(0)
smhvbf.SetLineWidth(1)
smhvbf.SetMarkerSize(0)
smhvbf.SetFillColor(ROOT.EColor.kMagenta)
smhvbf.SetLineColor(ROOT.EColor.kBlack)
wjets.SetFillColor(ROOT.EColor.kMagenta-10)
wjets.SetLineColor(ROOT.EColor.kMagenta+4)
wjets.SetLineWidth(1)
wjets.SetMarkerSize(0)
ztautau.SetFillColor(ROOT.EColor.kOrange-4)
ztautau.SetLineColor(ROOT.EColor.kOrange+4)
ztautau.SetLineWidth(1)
ztautau.SetMarkerSize(0)
zjets.SetFillColor(ROOT.EColor.kAzure+3)
zjets.SetLineColor(ROOT.EColor.kAzure+5)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
ttbar.SetFillColor(ROOT.EColor.kGreen+3)
ttbar.SetLineColor(ROOT.EColor.kBlack)
ttbar.SetLineWidth(1)
ttbar.SetMarkerSize(0)
diboson.SetFillColor(ROOT.EColor.kRed+2)
diboson.SetLineColor(ROOT.EColor.kRed+4)
diboson.SetLineWidth(1)
diboson.SetMarkerSize(0)
singlet.SetFillColor(ROOT.EColor.kGreen+4)
singlet.SetLineColor(ROOT.EColor.kBlack)
singlet.SetLineWidth(1)
singlet.SetMarkerSize(0)


smh = smhgg.Clone()
smh.Add(smhvbf)
LFVStack = ROOT.THStack("stack","")
LFVStack.Add(wjets)
LFVStack.Add(diboson)
LFVStack.Add(ttbar)
#LFVStack.Add(singlet)
LFVStack.Add(zjets)
LFVStack.Add(ztautau)
LFVStack.Add(smh)

maxLFVStack = LFVStack.GetMaximum()
maxData=data.GetMaximum()
maxHist = max(maxLFVStack,maxData)

LFVStack.SetMaximum(maxHist*1.20)
LFVStack.Draw('hist')
data.Draw("sames,E")
lfvh = vbfhmutau125.Clone()
lfvh.Add(gghmutau125)

vbfhmutau125.Draw("histsames")
gghmutau125.Draw("histsames")

legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)

xbinLength = wjets.GetBinWidth(10)
widthOfBin = xbinLength
print widthOfBin
ylabel = " Events / " + str(widthOfBin)
if (isGeV):
	ylabel = ylabel + " GeV"

legend.Draw('sames')
LFVStack.GetXaxis().SetNdivisions(510)
#LFVStack.GetXaxis().SetTitleOffset(3.0)
#LFVStack.GetXaxis().SetLabelOffset(3.0)
LFVStack.GetXaxis().SetLabelSize(0.035)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)
print "xRange:" + str(xRange)
if (xRange != 0):
	LFVStack.GetXaxis().SetRangeUser(0,xRange)
LFVStack.GetXaxis().SetTitle(xLabel)
widthOfBin = wjets.GetBinWidth(1)

size = wjets.GetNbinsX()
#build tgraph of systematic bands
xUncert = array.array('f',[])
yUncert = array.array('f',[])
exlUncert = array.array('f',[])
exhUncert = array.array('f',[])
eylUncert = array.array('f',[])
eyhUncert = array.array('f',[])
xUncertRatio = array.array('f',[])
yUncertRatio = array.array('f',[])
exlUncertRatio = array.array('f',[])
exhUncertRatio = array.array('f',[])
eylUncertRatio = array.array('f',[])
eyhUncertRatio = array.array('f',[])
binLength = wjets.GetBinCenter(2)-wjets.GetBinCenter(1)

for i in range(1,size+1):
        stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)
        wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        xUncertRatio.append(wjets.GetBinCenter(i))
        yUncertRatio.append(0)
        
        exlUncert.append(binLength/2)
        exhUncert.append(binLength/2)
        exlUncertRatio.append(binLength/2)
        exhUncertRatio.append(binLength/2)
	if (fakeRate == True):
        	wjetsError = math.sqrt(wjets.GetBinContent(i)*0.3*wjets.GetBinContent(i)*0.3 + wjets.GetBinError(i)*wjets.GetBinError(i))
	else:
		wjetsError = wjets.GetBinError(i)
	errTot = wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)
        eylUncert.append(errTot)
        eyhUncert.append(errTot)
        if (stackBinContent==0):
        	eylUncertRatio.append(0)
                eyhUncertRatio.append(0)
	else:
        	eylUncertRatio.append(errTot/stackBinContent)
        	eyhUncertRatio.append(errTot/stackBinContent)

xUncertVec = ROOT.TVectorF(len(xUncert),xUncert)
yUncertVec = ROOT.TVectorF(len(yUncert),yUncert)
exlUncertVec = ROOT.TVectorF(len(exlUncert),exlUncert)
exhUncertVec = ROOT.TVectorF(len(exhUncert),exhUncert)
eylUncertVec = ROOT.TVectorF(len(eylUncert),eylUncert)
eyhUncertVec = ROOT.TVectorF(len(eyhUncert),eyhUncert)
systErrors = ROOT.TGraphAsymmErrors(xUncertVec,yUncertVec,exlUncertVec,exhUncertVec,eylUncertVec,eyhUncertVec)

xUncertVecRatio = ROOT.TVectorF(len(xUncertRatio),xUncertRatio)
yUncertVecRatio = ROOT.TVectorF(len(yUncertRatio),yUncertRatio)
exlUncertVecRatio = ROOT.TVectorF(len(exlUncertRatio),exlUncertRatio)
exhUncertVecRatio = ROOT.TVectorF(len(exhUncertRatio),exhUncertRatio)
eylUncertVecRatio = ROOT.TVectorF(len(eylUncertRatio),eylUncertRatio)
eyhUncertVecRatio = ROOT.TVectorF(len(eyhUncertRatio),eyhUncertRatio)
systErrorsRatio = ROOT.TGraphAsymmErrors(xUncertVecRatio,yUncertVecRatio,exlUncertVecRatio,exhUncertVecRatio,eylUncertVecRatio,eyhUncertVecRatio)

latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
latexStr = "%.2f fb^{-1} (13 TeV)"%(lumi/1000)
latex.DrawLatex(0.9,0.96,latexStr)
latex.SetTextAlign(11)
#if "0J" in rootdir:
#        catString = "#mu#tau_{h} 0-Jet"
#if "1J" in rootdir:
#        catString = "#mu#tau_{h} 1-Jet"
#if "2J" in rootdir:
#        catString = "#mu#tau_{h} 2-Jet"
#if "preselmutau" in rootdir or "notIso" in rootdir or "nvtx" in rootdir:
#	catString = "#mu#tau_{h}"
latex.DrawLatex(0.25,0.87,catStringMap[rootdir])
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)
latex.DrawLatex(0.25,0.92,"CMS")
latex.SetTextFont(52)
latex.SetTextSize(0.027)
latex.DrawLatex(0.35,0.92,"Preliminary")

#systErrors.SetFillStyle(3003)
systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrors.SetMarkerSize(0)
systErrors.Draw('E2,sames')
legend.AddEntry(data, 'Data #mu#tau_{h}')
legend.AddEntry(systErrors,'Pre-fit background unc.',"f")
legend.AddEntry(smh, 'SM Higgs',"f")
legend.AddEntry(ztautau,'Z->#tau#tau','f')
legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
#legend.AddEntry(singlet,"Single Top Quark",'f')
legend.AddEntry(ttbar,'t#bar{t}, t, #bar{t}',"f")
legend.AddEntry(diboson,'VV',"f")
if fakeRate == True:
	legend.AddEntry(wjets,'Misidentified #tau','f')
else:
	legend.AddEntry(wjets,'W+Jets MC','f')
legend.AddEntry(gghmutau125,'LFV GF Higgs (BR=100%)')
legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=100%)')


p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ztautau)
mc.Add(ttbar)
mc.Add(diboson)
#mc.Add(singlet)
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
ratio.Draw("E1")
systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrorsRatio.SetMarkerSize(0)
systErrorsRatio.Draw('E2,sames')
ratio.GetXaxis().SetTitle(xLabel)
ratio.GetXaxis().SetTitleSize(0.12)
ratio.GetXaxis().SetNdivisions(510)
ratio.GetXaxis().SetTitleOffset(1.1)
ratio.GetXaxis().SetLabelSize(0.12)
ratio.GetXaxis().SetLabelFont(42)
ratio.GetYaxis().SetNdivisions(505)
ratio.GetYaxis().SetLabelFont(42)
ratio.GetYaxis().SetLabelSize(0.1)
ratio.GetYaxis().SetRangeUser(-1,1)
ratio.GetYaxis().SetTitle("#frac{Data-BG}{BG}")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.12)
ratio.SetTitle("")
if (xRange != 0):
	ratio.GetXaxis().SetRangeUser(0,xRange)

canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
