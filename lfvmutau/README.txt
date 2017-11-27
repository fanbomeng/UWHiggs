These are the Analyzers that the LFV group used for the HighMass Higgs LFV decay search for H->mutau_h channel

It looks a bit broken, sorry for this.

The main analyzer is:  AnalyzeLFVMuTau_HighMassTriggerEffiPosttune.py,  which can produce the normal histogram, 
also can be used for the tuning process. The systematics part is also adepted to highmass analysis.

The use for AnalyzeLFVMuTau_HighMassTriggerEffiPosttune.py:
1)
If we are using it for tuning, then we need to set the global variable RUN_OPTIMIZATION_v2=True 
the variable setup and tuning values are in the supplement file: optimizer_new.py and optimizer_new450.py 

2)
For now we are not adding in any shape systematics, but we will later and the part related to this is:
The global variable self.Sysin is the control if we are running with shape systematics. An additional 
supplement file for shape systematics is called Systematics.py which is imported by the main analyzer and
be used to compute the shift of systematics, together with some of the function in the main analyzer. 

3)
For the weight of Mc samples, now they are directly add in the analyzer, instead in the plotter step.
We need to scale the Mc to the according lumi from data, so the number in the current weight file called
weightNormal_MORE_S_WJ.py is the effective lumi and add the weight 1/effectivelumi to the weight.
This file is generated with the input files(they are event weights) by another implement file which 
is in the plotter folder and will showed later. 


4)
For running the analyzer, the highmass signal files current one is in /hdfs/store/user/taroni/, with the 
jobid=LFV_HighMass. While all the other ones are in /hdfs/store/user/ndev/, with the jobid=LFV_Mar15_mc for MC
and jobid=LFV_Mar15_data_v2 for data 

5)
The global variable self.light can control if running with more histograms, for example for the control regions, for semi data driven
estimation of QCDs and so on
 
For the Tau fake rate extraction, we use the analyzer AnalyzeLFVMuMuTau.py
The data are in /hdfs/store/user/taroni/ with   jobid=LFV_reminiaod_feb21_data
While MC is also in /hdfs/store/user/taroni/ with jobid=LFV_reminiaod_feb21_mc/


Some small scripts probably can help a bit:
1)
The data sample files are usually in a couple of folders and not uniform the sample names, so to merger the data path name
and merge the files, I use Rminput_redent.py, copyDYtoZttinput.py to help a bit, but still not complete, be careful/

 

