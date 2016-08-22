./Run_sys_vbf.sh
./Merge_sys.sh
./Run_sys50_vbf.sh &
#./Merge_sys50.sh

rm Run_sys20_vbf.sh
cp Run_sys50_vbf.sh  Run_sys20_vbf.sh
sed -e "s,50,20,"  -i Run_sys20_vbf.sh
chmod 777 Run_sys20_vbf.sh
./Run_sys20_vbf.sh  &
cp Merge_sys50.sh Merge_20sys.sh
sed -e "s,50,20,"  -i Merge_20sys.sh
#./Merge_20sys.sh


rm Run_sys30_vbf.sh
cp Run_sys50_vbf.sh  Run_sys30_vbf.sh
sed -e "s,50,30,"  -i Run_sys30_vbf.sh
chmod 777 Run_sys30_vbf.sh
./Run_sys30_vbf.sh  &
cp Merge_sys50.sh Merge_30sys.sh
sed -e "s,50,30,"  -i Merge_30sys.sh
#./Merge_30sys.sh

rm Run_sys40_vbf.sh
cp Run_sys50_vbf.sh  Run_sys40_vbf.sh
sed -e "s,50,40,"  -i Run_sys40_vbf.sh
chmod 777 Run_sys40_vbf.sh
./Run_sys40_vbf.sh  &
cp Merge_sys50.sh Merge_40sys.sh
sed -e "s,50,40,"  -i Merge_40sys.sh
#./Merge_40sys.sh
