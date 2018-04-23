These are the Analyzers that the LFV group used for the HighMass Higgs LFV decay search for H->mutau_h channel

It looks a bit broken, sorry for this.

The main analyzer is:  AnalyzeLFVMuTau_HighMassnewtest.py,  which can produce the normal histogram, 
also can be used for the tuning process. The systematics part is also adepted to highmass analysis.

The use for AnalyzeLFVMuTau_HighMassnewtest.py:
1)
If we are using it for tuning, then we need to set the global variable RUN_OPTIMIZATION_v2=True 
the variable setup and tuning values are in the supplement file: optimizer_new.py and optimizer_new450.py 

2)
The global variable self.Sysin is the control if we are running with shape systematics. An additional 
supplement file for shape systematics is called Systematics.py which is imported by the main analyzer and
be used to compute the shift of systematics, together with some of the function in the main analyzer. 

3)
For the weight of Mc samples, now they are directly add in the analyzer, instead in the plotter step.
We need to scale the Mc to the according lumi from data, so the number in the current weight file called
weightNormalNewtrigger.py is the effective lumi and add the weight 1/effectivelumi to the weight.
This file is generated with the input files(they are event weights) by another implement file which 
is in the plotter folder and will showed later. 


4)
For running the analyzer, data samples currently used is in /hdfs/store/user/ndev/, with the 
jobid=LFV_Feb5_2018_mc and LFV_Feb5_2018_datasamples
5)
The global variable self.light* can control if running with more histograms, for example for the control regions, for semi data driven
estimation of QCDs and so on
 
For the Tau fake rate extraction, we use the analyzer AnalyzeLFVMuMuTau.py and AnalyzeLFVEETau.py 
The data are in /hdfs/store/user/taroni/ with   jobid=LFV_reminiaod_feb21_data
While MC is also in /hdfs/store/user/taroni/ with jobid=LFV_reminiaod_feb21_mc/
As you see in the folder, there are others analyzer related to the fakes, like fake muon, fake electron, all of these are similar and
are used or was used in the study.

Some small scripts probably can help a bit:
1)
The data sample files are usually in a couple of folders and not uniform the sample names, so to merger the data path name
and merge the files, I use Rminput_redent.py, copyDYtoZttinput.py to help a bit, but still not complete, be careful/
copyDYtoZttinput.py is used because Z->tautau use the same MC samples as DY, so we need to rename and copy the files

 
An example of running the code:
1. source environment :
   in the folder UWHiggs/lfvmutau
   source  ../environment.sh
2. source environmental variables:
   for the local run:
       export dryrun=0
       export farmout=0
       export MEGAPATH=/hdfs/store/user/ndev/
       export jobid=LFV_Feb5_2018_mc/
   for run on the condor:
       export MEGAPATH=/hdfs/store/user/ndev/
       export jobid=LFV_Feb5_2018_mc/
       export dryrun=1
       export farmout=1
       source  your grid
   commment:   the  MEGAPATH and  jobid show where the data is. currently if running the fake rate then:
               export MEGAPATH=/hdfs/store/user/taroni/
               export jobid=Trilepton_D_LFV_reminiaod_feb21_data_MC_LFV_reminiaod_feb21_mc/
               the below variable controls run locally or condor:
                          export dryrun=0
                          export farmout=0 
3. The exact samples run by an analyzer is controlled by file Rakefile in different tasks


4. Run the analyzer
   if run locally, then ./Run_alltest.sh
   if run on condor then ./Run_alltest.sh >& submit.sh,  remove the following two redundant line in the submit.sh:
      (in /afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_26_highmass/src/UWHiggs/lfvmutau)
      warning: Insecure world writable dir /afs/hep.wisc.edu/cms/fmeng in PATH, mode 040777
   I add in a couple lines in the MuonPOGCorrections.py where it suppose to be in folder: FinalStateAnalysis/TagAndProbe/python/.  
   you can see it is very simple and I put it here just for your convinience
