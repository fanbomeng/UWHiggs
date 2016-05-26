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
JSONlumi = 2297.7
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")


ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)

savedir=argv[1]
rootdir = argv[2]
canvas = ROOT.TCanvas("canvas","canvas",800,800)
presel = True
outfile_name = savedir+"/"+rootdir+"_preselection"

legend = ROOT.TLegend(0.65,0.60,0.93,0.98,' ','brNDC')
xRange = 300


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

dirMap = {"mue0J":"LFV_MuE_0Jet_1_13TeVMuE","mue1J" : "LFV_MuE_1Jet_1_13TeVMuE", "mue2J": "LFV_MuE_2Jet_1_13TeVMuE"}
fileMap = {"mue0J":"LFV_datacard_shape_EMU_0Jet.root","mue1J" : "LFV_datacard_shape_EMU_1Jet.root", "mue2J": "LFV_datacard_shape_EMU_2Jet.root"}
if presel == False:
	mlfitMap = {"mue0J":"mlfit_mue0.root","mue1J" : "mlfit_mue1.root", "mue2J": "mlfit_mue2.root"}
else:
	mlfitMap=fileMap
if presel == False:
	maxHistMap = {"mue0J": 30, "mue1J": 35, "mue2J": 70}
elif "SS" in savedir:
	maxHistMap ={"mue0J":  200, "mue1J": 700, "mue2J": 400}
	outfile_name=outfile_name+"_SS"
else:
	maxHistMap ={"mue0J":  2500, "mue1J": 700, "mue2J": 400}
lumi = JSONlumi
print rootdir
inputFile = ROOT.TFile(savedir+"/"+fileMap[rootdir])
#ROOT.gROOT.cd()
#data = inputFile.Get(dirMap[rootdir]+"/data_obs")
data = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"data_obs")
ztautau = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"ZTauTau")
zjets = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"Zothers")
diboson = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"Diboson")
ttbar = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"TT")
wjets = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"Fakes_HMuE")
smhgg = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"ggHTauTau")
smhvbf = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"vbfHTauTau")
wg = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"WG")
singlet = get_histos(savedir,mlfitMap[rootdir],dirMap[rootdir],"T")
gghmutau125 = get_histos(savedir, mlfitMap[rootdir],dirMap[rootdir],"LFVGG125")
vbfhmutau125 = get_histos(savedir, mlfitMap[rootdir],dirMap[rootdir],"LFVVBF125")
ttbar.Add(singlet) #combine singlet and ttbar
gghmutau125.Sumw2()
vbfhmutau125.Sumw2()

gghmutau125.Scale(100)
vbfhmutau125.Scale(100)

data.SetBinErrorOption(ROOT.TH1.kPoisson)
data.SetMarkerStyle(8)
data.SetMarkerSize(1)
data.SetLineColor(ROOT.EColor.kBlack)
gghmutau125.SetLineColor(ROOT.EColor.kRed)
gghmutau125.SetLineWidth(3)
smhgg.SetLineWidth(1)
smhgg.SetLineColor(ROOT.EColor.kBlack)
smhgg.SetFillColor(ROOT.EColor.kMagenta)
vbfhmutau125.SetLineStyle(ROOT.ELineStyle.kSolid)
vbfhmutau125.SetLineColor(ROOT.EColor.kBlue)
vbfhmutau125.SetLineWidth(3)
smhvbf.SetLineWidth(1)
smhvbf.SetLineColor(ROOT.EColor.kBlack)
smhvbf.SetFillColor(ROOT.EColor.kMagenta)
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
wg.SetFillColor(ROOT.EColor.kCyan)
wg.SetLineColor(ROOT.EColor.kBlack)
wg.SetLineWidth(1)
wg.SetMarkerSize(0)
singlet.SetFillColor(ROOT.EColor.kGreen+4)
singlet.SetLineColor(ROOT.EColor.kBlack)
singlet.SetLineWidth(1)
singlet.SetMarkerSize(0)


smh = smhgg.Clone()
smh.Add(smhvbf)
LFVStack = ROOT.THStack("stack","")
LFVStack.Add(wjets)
LFVStack.Add(wg)
LFVStack.Add(diboson)
LFVStack.Add(ttbar)
LFVStack.Add(zjets)
LFVStack.Add(ztautau)
LFVStack.Add(smh)

LFVStack.SetMaximum(maxHistMap[rootdir])
LFVStack.Draw('hist')
data.Draw("sames,E")
lfvh = vbfhmutau125.Clone()
lfvh.Add(gghmutau125)

vbfhmutau125.Draw("hsame")
gghmutau125.Draw("hsame")

legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)

xbinLength = wjets.GetBinWidth(1)
widthOfBin = xbinLength

ylabel = " Events / " + str(int(widthOfBin)) + " GeV"

legend.Draw('sames')
LFVStack.GetXaxis().SetNdivisions(510)
#LFVStack.GetXaxis().SetTitleOffset(3.0)
#LFVStack.GetXaxis().SetLabelOffset(3.0)
LFVStack.GetXaxis().SetLabelSize(0.035)
LFVStack.GetYaxis().SetTitle(ylabel)
LFVStack.GetYaxis().SetTitleOffset(1.40)
LFVStack.GetYaxis().SetLabelSize(0.035)

LFVStack.GetXaxis().SetRangeUser(0,xRange)
LFVStack.GetXaxis().SetTitle("M(#mu#tau_{e})_{col} (GeV)")

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
        stackBinContent = wjets.GetBinContent(i)+zjets.GetBinContent(i)+ztautau.GetBinContent(i)+ttbar.GetBinContent(i)+diboson.GetBinContent(i)+wg.GetBinContent(i)
        wjetsBinContent = wjets.GetBinContent(i)
        xUncert.append(wjets.GetBinCenter(i))
        yUncert.append(stackBinContent)
        xUncertRatio.append(wjets.GetBinCenter(i))
        yUncertRatio.append(0)
        
        exlUncert.append(binLength/2)
        exhUncert.append(binLength/2)
        exlUncertRatio.append(binLength/2)
        exhUncertRatio.append(binLength/2)
        wjetsError = math.sqrt(0.4*wjets.GetBinContent(i)*0.4*wjets.GetBinContent(i)+wjets.GetBinError(i)*wjets.GetBinError(i))
	errTot = wjetsError+zjets.GetBinError(i)+ztautau.GetBinError(i)+ttbar.GetBinError(i)+diboson.GetBinError(i)+wg.GetBinError(i)
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
if "0J" in rootdir:
        catString = "#splitline{#mu#tau_{e} 0-Jet}"
if "1J" in rootdir:
        catString = "#splitline{#mu#tau_{e} 1-Jet}"
if "2J" in rootdir:
        catString = "#splitline{#mu#tau_{e} 2-Jet}"
catString = catString + "{Loose selection}"
if "SS" in savedir:
	catString = "#splitline{#mu#tau_{e} Region II}{Loose selection}"
latex.DrawLatex(0.25,0.87,catString)
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
legend.AddEntry(data, 'Data #mu#tau_{e}',"lp")
legend.AddEntry(systErrors,'Pre-fit background unc.','f')
legend.AddEntry(smh, 'SM Higgs','f')
legend.AddEntry(ztautau,'Z->#tau#tau','f')
legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
legend.AddEntry(ttbar,'t#bar{t}, t, #bar{t}','f')
legend.AddEntry(diboson,'VV',"f")
legend.AddEntry(wg,"W#gamma","f")
legend.AddEntry(wjets,'Misidentified leptons','f')
legend.AddEntry(gghmutau125,'LFV GF Higgs (BR=100%)',"l")
legend.AddEntry(vbfhmutau125,'LFV VBF Higgs (BR=100%)',"l")


p_ratio.cd()
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = wjets.Clone()
mc.Add(zjets)
mc.Add(ztautau)
mc.Add(ttbar)
mc.Add(diboson)
mc.Add(wg)
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
ratio.Draw("E1")
systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
systErrorsRatio.SetMarkerSize(0)
systErrorsRatio.Draw('E2,sames')
ratio.GetXaxis().SetTitle("M(#mu#tau_{e})_{col} (GeV)")
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

ratio.GetXaxis().SetRangeUser(0,xRange)

canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
