This forder contains the plotter and some supporting scripts

There are a couple of plotters, which all comes with the same base, aimed for a bit different purpose, not unified 
for a single one at current stage.

Plotter   plot_13TeV_vbfbined_QCD_36_highmass_5new.py  is the main plotter for Highmass search. It is used to generate 
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
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg200   0 none    tPt30   0  200
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
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1       preselection   0 none   tPt30   0 None
or
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1       preselection   0 none   tPt30   0 200

For generating selection level but have 2 bin 200~300GeV and 450~900GeV
for bin 200~300GeV:
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg200   0 none    tPt30   0  200
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     boost200   0 none    tPt30   0  200
for bin 450~900GeV
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1     gg450   0 none    tPt30   0  450
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1  boost450   0 none    tPt30   0  450 


For tunning: 
set fakeRate=False and QCDflag=True and DrawallMass=False
Example
python plot_13TeV_vbfbined_QCD_36_highmass_5new.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1 gg200/mPt75    0   none  tPt0   1 200
Function corresponding starting from LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/:
[input directory]    [variable]     [channel/tunning channel]  [lumi scale]      [systematics shift]  [not used for now] [running tunning]  [Mass point] 


3)
The weight generating script, from which the output file used in the analyzer.
WeightCalcu.py and XSecnew.py
WeightCalcu.py as you will see take the input log files as input and generate the effective luminosity, with some input also from XSecnew.py
Similar for WeightCalcuMuMuTau.py  and   WeightCalcuMME.py  are used for the weights files calcualtion in fake rate analysis. This should be re-done whenever a new set of Ntuples is produced, cause the exact number of files maybe different  



4)
Fake rate related. Currently we only use Tau fake rate, with both mumutau and eetau
With the output from the Tau fake rate analyzer, we use the plotter plot_2016_FakeRateMMEE.py  and plot_2016_FakeRateMMEEtrial.py
the use of the plotter :
tau DM 0 & 1:
python plot_2016_FakeRateMMEEtrial.py  preselectionDecay0  preselectionVLooseIsoDecay0     tPt   LFV_MiniAODVtrial_sys/AnalyzeLFVMuMuTau/  LFV_MiniAODVtrial_sys/AnalyzeLFVEETau/
tau DM 10:

python plot_2016_FakeRateMMEE.py  preselectionDecay10  preselectionVLooseIsoDecay10   tPt   LFV_MiniAODVtrial_sys/AnalyzeLFVMuMuTau/  LFV_MiniAODVtrial_sys/AnalyzeLFVEETau/

As you will see, plot_2016_FakeRateMMEEtrial.py is a very bad written one that just make things works. It is basically a hand copy of plot_2016_FakeRateMMEE.py, I did not put the effort in to make it looks nicer

plotter plot_2016_FakeRatenewDiboson.py was used initally for mumutau only as you will see








5)
For the fake rate study general plotter, but either you cancled the ztautau contribution or you merged with other DY at the analyzer step, so be careful:
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

8)
some the running examples can be found in Run_fakestudynew.sh  Run_vbf_split_2.sh 



9) the plotter plot_13TeV_vbfbined_QCD_36_highmass_5newMuonfake.py is used to plotter fake muons controbution separately, bad written:
   example:
    python plot_13TeV_vbfbined_QCD_36_highmass_5newMuonfake.py LFV_MiniAODVtrial_sys/AnalyzeLFVMuTau/ collMass_type1  preselection   0 none    tPt30   0  200
   plotter plot_13TeV_vbfbined_QCD_36_highmass_5newFake*.py for the data-driven vs MC wjets related study as shown in the talk, bad written.
   These plotters are very similar to the main one, just small changes to complete specific tasks.


10) Run the plotter with systermatics:
    making the running script in large scale:
        Run   MakeRunscriptsCutbased3.py to generate the running scripts 
    run with Run_sys_renamedtmp.sh and Run_sys_renamed2tmp.sh  
    comment: this will take some time to runing, test by hand before run in large scale

    
11) plotter plot_13TeV_vbfbined_QCD_36_vInputnew.py was used in 125GeV analysis for the plots without the downward matching indicator, but it is not adapted for the high mass analysis, but it would not be hard to change it to highmass ones and possibly be used in the future



An summary for the most general use:
1) after running the analyzer, put the outfile(AnalyzeLFVMuTau_HighMassnewtest as an example) in  LFV_MiniAODVtrial_sys as AnalyzeLFVMuTau, copy the input files into folder AnalyzeLFVMuTau as weights(example for now is copy inputs/LFV_Feb5_2018_mc)

2) performance plots generation, run the plotter plot_13TeV_vbfbined_QCD_36_highmass_5new.py
 




 
