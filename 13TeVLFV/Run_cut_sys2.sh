rm Run_cut_tesdown.sh
cp  Run_cut.sh  Run_cut_tesdown.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTautesdown," -e"s,none,TesDown,"    -i Run_cut_tesdown.sh
chmod 777 Run_cut_tesdown.sh
./Run_cut_tesdown.sh
#sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys/AnalyzeLFVMuTaufakesup"  -i Run_cut_fakeup.sh
rm Run_cut_tesup.sh
cp  Run_cut.sh  Run_cut_tesup.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTautesup," -e"s,none,TesUp,"   -i Run_cut_tesup.sh
chmod 777 Run_cut_tesup.sh
./Run_cut_tesup.sh



rm Run_cut_uesdown.sh
cp  Run_cut.sh  Run_cut_uesdown.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTauuesdown," -e"s,none,UesDown,"   -i Run_cut_uesdown.sh
chmod 777 Run_cut_uesdown.sh
./Run_cut_uesdown.sh



rm Run_cut_uesup.sh
cp  Run_cut.sh  Run_cut_uesup.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTauuesup," -e"s,none,UesUp,"  -i Run_cut_uesup.sh
chmod 777 Run_cut_uesup.sh
./Run_cut_uesup.sh


rm Run_cut_nosys.sh
cp  Run_cut.sh  Run_cut_nosys.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTau," -i Run_cut_nosys.sh
chmod 777 Run_cut_nosys.sh
./Run_cut_nosys.sh
