rm  Run_sys10fb.sh
cp  Run_systempfb.sh  Run_sys10fb.sh
sed -e "s,hallo,10,"  -i Run_sys10fb.sh
./Run_sys10fb.sh

rm Merge_10sys.sh
cp Merge_tmpsys.sh  Merge_10sys.sh
sed -e "s,hallo,10,"  -i Merge_10sys.sh
./Merge_10sys.sh



rm  Run_sys15fb.sh
cp  Run_systempfb.sh  Run_sys15fb.sh
sed -e "s,hallo,15,"  -i Run_sys15fb.sh
./Run_sys15fb.sh

rm Merge_15sys.sh
cp Merge_tmpsys.sh  Merge_15sys.sh
sed -e "s,hallo,15,"  -i Merge_15sys.sh
./Merge_15sys.sh




rm  Run_sys20fb.sh
cp  Run_systempfb.sh  Run_sys20fb.sh
sed -e "s,hallo,20,"  -i Run_sys20fb.sh
./Run_sys20fb.sh

rm Merge_20sys.sh
cp Merge_tmpsys.sh  Merge_20sys.sh
sed -e "s,hallo,20,"  -i Merge_20sys.sh
./Merge_20sys.sh



rm  Run_sys25fb.sh
cp  Run_systempfb.sh  Run_sys25fb.sh
sed -e "s,hallo,25,"  -i Run_sys25fb.sh
./Run_sys25fb.sh

rm Merge_25sys.sh
cp Merge_tmpsys.sh  Merge_25sys.sh
sed -e "s,hallo,25,"  -i Merge_25sys.sh
./Merge_25sys.sh
