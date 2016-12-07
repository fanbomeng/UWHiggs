from sys import argv, stdout, stderr
import getopt
import ROOT
import sys
import math
import array
import lfv_vars
import XSec

def NoNegBins(histo):    #no negtive bin, if negtive then set Zero
	for i in range(1,histo.GetNbinsX()+1):
		if histo.GetBinContent(i) != 0:
			lowBound = i
			break
        for i in range(histo.GetNbinsX(),0,-1):
                if histo.GetBinContent(i) != 0:
                        highBound = i
                        break
	for i in range(lowBound, highBound+1):
		if histo.GetBinContent(i) <= 0:
			histo.SetBinContent(i,0)
def set_poissonerrors(histo):     #set bin errors from Poisson interval at 68.3%
	histo.SetBinErrorOption(ROOT.TH1.kPoisson)

	for i in range(1,histo.GetNbinsX()+1):
		errorLow = histo.GetBinErrorLow(i)
		errorUp = histo.GetBinErrorUp(i)			

def yieldHisto(histo,xmin,xmax):   # Find the bin number from the range of x axis, and then get the integrate event number of the histogram
        binmin = int(histo.FindBin(xmin))
        binwidth = histo.GetBinWidth(binmin)
        binmax = int(xmax/binwidth)
        signal = histo.Integral(binmin,binmax)
        return signal

def do_binbybinQCD(histo,lowBound,highBound): #fill empty bins and negtive content bins to a scaled number, but detail ?
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
                                histo.SetBinContent(i,0.0)
                                histo.SetBinError(i,0.0)
                else:
                        if histo.GetBinContent(i) < 0:
                                histo.SetBinContent(i,0.001/nevents*xsec*JSONlumi)
                                histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)

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
			#	histo.SetBinError(i,1.8/nevents*xsec*JSONlumi)
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

##Set up style
#JSONlumi = 2297.7
#JSONlumi =334.836434 
#JSONlumi =561.123523153 
#JSONlumi =3950.74 
#JSONlumi =20000.00 
#JSONlumi =12890.00 
#JSONlumi = 20076.26 
JSONlumi = 15850.00 
#JSONlumi = 20100.00 
#JSONlumi = 20000.0 
#JSONlumi =12878.27 
#JSONlumi =15000.0 
#JSONlumi =218.042 
ROOT.gROOT.LoadMacro("tdrstyle.C")
#ROOT.gROOT.LoadMacro("Rtypes.h")
ROOT.setTDRStyle()

ROOT.gROOT.LoadMacro("CMS_lumi.C")
print "test"

ROOT.gROOT.SetStyle("Plain")
ROOT.gROOT.SetBatch(True)
ROOT.gStyle.SetOptStat(0)
savedir=argv[1]
var=argv[2]
channel=argv[3]
shift=argv[5]
opcut=argv[6]
RUN_OPTIMIZATION=int(argv[7])
#RUN_OPTIMIZATION=1
poissonErrors=True
if "collMass_type1_1" in var:
	var = "collMass_type1"
if "none" in shift:
	shiftStr="" #Not JES,TES, etc.
#else:
#	if "FakesDown" in shift:
#		shiftStr = "_FakeShapeMuTauDown"
#	elif "FakesUp" in shift:
#		shiftStr = "_FakeShapeMuTauUp"
#	else:
#		shiftStr="_CMS_MET_"+shift #corresponds to name Daniel used in datacards
rootdir = "mutau" #directory in datacard file
#rootdir = "LFV_MuTau_2Jet_1_13TeVMuTau" #directory in datacard file

##########OPTIONS#########################
#blinded = True #not blinded
blinded = False #not blinded
#fillEmptyBins = True #empty bins filled
#fakeRate = False #apply fake rate method
fakeRate = True #apply fake rate method
QCDflag=False
fillEmptyBins = True #empty bins filled
shape_norm = False #normalize to 1 if True
#wjets_fakes=True
wjets_fakes=False
#DY_bin=True
DY_bin=False
#fakeallplot=True
fakeallplot=False
#drawdata=False
drawdata=True
#blinded = True #not blinded
#QCDflag=True


canvas = ROOT.TCanvas("canvas","canvas",800,800)

if shape_norm == False:
        ynormlabel = " "
else:
        ynormlabel = "Normalized to 1 "

# Get parameters unique to each variable
getVarParams = "lfv_vars."+var
varParams = eval(getVarParams)
xlabel = varParams[0]
binwidth = varParams[7]

# binning for collinear mass
if "collMass" in var and "vbf" in channel:
	binwidth =25 
#if "collMass" in var and "vbf" in channel:
#	binwidth = 20
elif "collMass" in var and "preselection0Jet" in channel:
        binwidth = 5
elif "collMass" in var and "preselection1Jet" in channel:
        binwidth = 10
elif "collMass" in var and "preselection2Jet" in channel:
        binwidth = 20
elif "collMass" in var and "preselection" in channel:
        binwidth = 5

legend = eval(varParams[8])
isGeV = varParams[5]
xRange = varParams[6]

outfile_name = savedir+"LFV"+"_"+channel+"_"+var+"_"+shiftStr
lumidir = savedir+"weights/"
lumiScale = float(argv[4]) #lumi to scale to
lumi = lumiScale*1000
if (lumiScale==0):
	lumi = JSONlumi
print lumi
data2016B = make_histo(savedir,"data_SingleMuon_Run2016B_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
#data2016B.Sumw2()
data2016C = make_histo(savedir,"data_SingleMuon_Run2016C_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
data2016D = make_histo(savedir,"data_SingleMuon_Run2016D_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
data2016E = make_histo(savedir,"data_SingleMuon_Run2016E_PromptReco-v2_25ns", channel,var,lumidir,lumi,True,)
#data2016F = make_histo(savedir,"data_SingleMuon_Run2016F", channel,var,lumidir,lumi,True,)
data2016B.Add(data2016C)
data2016B.Add(data2016D)
data2016B.Add(data2016E)
#data2016B.Add(data2016F)
data=data2016B.Clone()
lowDataBin =1 
highDataBin = data.GetNbinsX()#-1
for i in range(1,data.GetNbinsX()+1):
	if (data.GetBinContent(i) > 0):
		lowDataBin = i
		break
for i in range(data.GetNbinsX(),0,-1):
	if (data.GetBinContent(i) > 0):
		highDataBin = i
		break
zjets = make_histo(savedir,"DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(zjets,lowDataBin,highDataBin)
z1jets = make_histo(savedir,"DY1JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z1jets,lowDataBin,highDataBin)
z2jets = make_histo(savedir,"DY2JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z2jets,lowDataBin,highDataBin)
z3jets = make_histo(savedir,"DY3JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z3jets,lowDataBin,highDataBin)
z4jets = make_histo(savedir,"DY4JetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8",channel,var,lumidir,lumi)
#do_binbybinQCD(z4jets,lowDataBin,highDataBin)
zjets.Add(z1jets)
zjets.Add(z2jets)
zjets.Add(z3jets)
zjets.Add(z4jets)
zjets.Rebin(binwidth)


#apply fake rate method


ww = make_histo(savedir,"WW_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
wz = make_histo(savedir,"WZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)
zz = make_histo(savedir,"ZZ_TuneCUETP8M1_13TeV-pythia8",channel,var,lumidir,lumi)

diboson = ww.Clone()
diboson.Add(wz)
diboson.Add(zz)

#Set bin widths
data.Rebin(binwidth)
#if (fakeRate == True):
diboson.Rebin(binwidth)
do_binbybinQCD(zjets,lowDataBin,highDataBin)
do_binbybinQCD(diboson,lowDataBin,highDataBin)
diboson.Scale(-1)
data.Add(diboson)
#options for name of outputfile
if poissonErrors==True:
	outfile_name = outfile_name+"_PoissonErrors"
outfile = ROOT.TFile(outfile_name+".root","RECREATE")

outfile.mkdir(rootdir)
outfile.cd(rootdir+"/")
xbinLength = zjets.GetBinWidth(1)
widthOfBin = xbinLength

if isGeV:
        ylabel = ynormlabel + " Events / " + str(int(widthOfBin)) + " GeV"
else:
        ylabel = ynormlabel  + " Events / " + str(widthOfBin)

#Plotting options (not to be used for final plots)
data.SetMarkerStyle(20)
data.SetMarkerSize(1)
data.SetMarkerColor(1)
#data.SetLineColor(ROOT.EColor.kBlack)
data.SetLineColor(1)
zjets.SetLineColor(860+3)
zjets.SetLineWidth(1)
zjets.SetMarkerSize(0)
zjets.SetMarkerColor(860+3)

#fill empty bins
#if(poissonErrors==True):
#	set_poissonerrors(data)
data.GetXaxis().SetTitle(xlabel)
data.GetXaxis().SetNdivisions(510)
data.GetXaxis().SetLabelSize(0.035)
data.GetYaxis().SetTitle(ylabel)
data.GetYaxis().SetTitleOffset(1.40)
data.GetYaxis().SetLabelSize(0.035)
if (xRange!=0):
        data.GetXaxis().SetRangeUser(0,xRange)
data.GetXaxis().SetTitle(xlabel)
#data.Draw("E0")
#data.Draw("E0")
#zjets.Draw('E0,sames')
legend.SetFillColor(0)
legend.SetBorderSize(0)
legend.SetFillStyle(0)


legend.Draw('sames')


latex = ROOT.TLatex()
latex.SetNDC()
latex.SetTextSize(0.03)
latex.SetTextAlign(31)
print lumi
latexStr = "%.2f fb^{-1} (13 TeV)"%(lumi/1000)
latex.DrawLatex(0.9,0.96,latexStr)
latex.SetTextAlign(11)
latex.SetTextFont(61)
latex.SetTextSize(0.04)
latex.DrawLatex(0.25,0.92,"CMS")
latex.SetTextFont(52)
latex.SetTextSize(0.027)
latex.DrawLatex(0.25,0.87,"Preliminary")

#systErrors.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
legend.AddEntry(data, 'Data #mu#tau_{had}')
legend.AddEntry(zjets,'Z->l^{+}l^{-}','f')
zjets.Write("Zothers"+shiftStr)
ROOT.gROOT.LoadMacro("tdrstyle.C")
ROOT.setTDRStyle()
ratio = data.Clone()
mc = zjets.Clone()
mc.Scale(-1)
ratio.Add(mc)
mc.Scale(-1)
ratio.Divide(mc)
#systErrorsRatio.SetFillColorAlpha(ROOT.EColor.kGray+2,0.35)
ratio.GetXaxis().SetTitle(xlabel)
ratio.GetXaxis().SetTitleSize(0.12)
ratio.GetXaxis().SetNdivisions(510)
ratio.GetXaxis().SetTitleOffset(1.1)
ratio.GetXaxis().SetLabelSize(0.12)
ratio.GetXaxis().SetLabelFont(42)
ratio.GetYaxis().SetNdivisions(505)
ratio.GetYaxis().SetLabelFont(42)
ratio.GetYaxis().SetLabelSize(0.1)
ratio.GetYaxis().SetRangeUser(-1,1)
#ratio.GetYaxis().SetTitle("#frac{Data-MC}{MC}")
ratio.GetYaxis().SetTitle("#frac{Data-BG}{BG}")
ratio.GetYaxis().CenterTitle(1)
ratio.GetYaxis().SetTitleOffset(0.4)
ratio.GetYaxis().SetTitleSize(0.12)
ratio.SetTitle("")
ratio.Draw("E1")

canvas.SaveAs(outfile_name+".png")
canvas.SaveAs(outfile_name+".pdf")
outfile.Write()
