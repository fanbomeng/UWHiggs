rm Run_cut_fakeup.sh
cp  Run_cut.sh  Run_cut_fakeup.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTaufakesup," -e "s,none,FakesUp," -i Run_cut_fakeup.sh
chmod 777 Run_cut_fakeup.sh
./Run_cut_fakeup.sh
#sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys/AnalyzeLFVMuTaufakesup"  -i Run_cut_fakeup.sh
rm Run_cut_fakedown.sh
cp  Run_cut.sh  Run_cut_fakedown.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTaufakesdown," -e "s,none,FakesDown," -i Run_cut_fakedown.sh
chmod 777 Run_cut_fakedown.sh
./Run_cut_fakedown.sh


rm Run_cut_jesdown.sh
cp  Run_cut.sh  Run_cut_jesdown.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTaujesdown," -e "s,none,JesDown,"  -i Run_cut_jesdown.sh
chmod 777 Run_cut_jesdown.sh
./Run_cut_jesdown.sh


rm Run_cut_jesup.sh
cp  Run_cut.sh  Run_cut_jesup.sh
sed -e "s,LFV_MiniAODVtrial,LFV_MiniAODVtrial_sys\/AnalyzeLFVMuTaujesup," -e "s,none,JesUp,"   -i Run_cut_jesup.sh
chmod 777 Run_cut_jesup.sh
./Run_cut_jesup.sh
