This forder contains the plotter and some supporting scripts

There are a couple of plotters, which all comes with the same base, aimed for a bit different purpose, not unified 
for a single one at current stage.

Plotter   plot_13TeV_vbfbined_QCD_36_highmass_5.py is the main plotter for Highmass search. It is used to generate 
the histogram and root file for combined data card. It can also be used to plot each highmass sigal seperately from other sigals,
the preselection plots with all of the masspoints, the high mass selection in 2 bins group, plots with 200GeV and 300 GeV,  
plots with 450~900GeV. 
Supporting scripts for the general plotter
lfv_varsnew.py  this file have some of variable character setups

1)
The plotter is controlled by a couple global variables. 
Variable:
blinded=True Then this means the root files and plots generated is for un-blind purpose. No blind will placed. 
So the data will be visible. Usually it is set to be false, which means it is for continue research, this is a 
bit strange, I know...

Variable:
fakeRate,QCDflag
When using the semi-data driven method, besides make sure when generating the root files out of the analyzer with the SS region, also turn fakeRake=False
and QCDflag=True. fakeRake=False which indicate to use Wjets samples instead of the fake background estimated from fakerate method. While QCDflage is to determine whether or not add in the QCDs estimated from SS region 

Variable:
DrawallMass,DrawselectionLevel_2bin
If DrawallMass=True, and DrawselectionLevel_2bin=False, then all of the mass points will be draw, the 200 GeV binning will used
If DrawallMass=Fale, and rawselectionLevel_2bin=False, then we use it for plotting the 2binning plots


2)
The command used in running the plotter is :

For plotting all of the mass point in the same plot


For generating root file that used for limit extracting:
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg200   0 none    tPt30   0  200
Function corresponding starting from LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/:
[input directory]    [variable]     [channel/tunning channel]  [lumi scale]      [systematics shift]  [not used for now] [running tunning]  [Mass point] 
[variable]: is the variable  we plot
[channel/tunning channel]: is the one with the condition we setup, like we plot preseleciton, gg200(stands for 0 jet 200 GeV mass point)
[lumi scale]: is if we want to further scale the plot to other luminosity
[systematics shift]: if we want to have the systematic shape in, currently for high mass, it is not properly setup yet
[running tunning]: a flag to indicate if we want to run tunning, 0, or 1 as input
[Mass point]: is the mass point we are considering, also can stand for the starting mass point range we are working on 
this generate for 0 jet 200 mass point collMass_type1 rootfile, while we also need other mass points





For generating the preselection level plots:
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1       preselection   0 none   tPt30   0 None
or
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1       preselection   0 none   tPt30   0 200

For generating selection level but have 2 bin 200~300GeV and 450~900GeV
for bin 200~300GeV:
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg200   0 none    tPt30   0  200
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     boost200   0 none    tPt30   0  200
for bin 450~900GeV
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg450   0 none    tPt30   0  450
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1  boost450   0 none    tPt30   0  450 


For tunning: 
set fakeRate=False and QCDflag=True and DrawallMass=False
Example
python plot_13TeV_vbfbined_QCD_36_highmass_5.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 gg200/mPt75    0   none  tPt0   1 200
Function corresponding starting from LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/:
[input directory]    [variable]     [channel/tunning channel]  [lumi scale]      [systematics shift]  [not used for now] [running tunning]  [Mass point] 


3)
The weight generating script, from which the output file used in the analyzer.
WeightCalcu.py and XSecnew.py
WeightCalcu.py as you will see take the input log files as input and generate the effective luminosity, with some input also from XSecnew.py




4)
Fake rate related. Currently we only use Tau fake rate
With the output from the Tau fake rate analyzer, we use the plotter plot_2016_FakeRatenewDiboson.py
one of the example for this plotter is:
python plot_2016_FakeRatenewDiboson.py preselection preselectionVLooseIso tPt   LFV_MiniAODVtrial_sys/AnalyzeLFVMuMuTau/


5)
For the fake rate study general plotter:
python plot_13TeV_vbfbined_QCD_36_highmassMMT.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuMuTau/ tPt   preselection            0 none    tPt0   0
python plot_13TeV_vbfbined_QCD_36_highmassMMT.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuMuTau/ tPt   preselectionVLooseIso            0 none    tPt0   0

Which is pretty much the same as the above ones but can plot the variables standing alone for the variables 

6)
plot_13TeV_vbfbined_QCD_36_highmass_tunning.py  this is the plotter I used to in tuning by check the significance, S/sqrt(S+B) compare with checking the limits, this is much faster, so be used as a quick check and reference
Example can be like:
python plot_13TeV_vbfbined_QCD_36_highmass_tunning.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ mPt                gg300   0 none      tPt30   0   300

7)
For tuning, very small, probably can help a bit are the small assisting script, which helps generating the Run command faster
They are in AssisScript:
MakeRunscriptsHighmassTuning.py  for Highmass tunning apparently from the name
mergercardrootHighmass.py  for Merging them into different file names 
