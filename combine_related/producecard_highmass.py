import subprocess
import optimizer_new
import optimizer_new450
for region in optimizer_new.regions["0"]:
   subprocess.call(["LFVVBFHighMass200tune","10","--i","subgg200"+region,"--o","subgg200"+region,"--l","cardroot30fb_sys","--name","subgg200"+region,"--d","cardroot30fb_sys","--b"])
for region in optimizer_new.regions["1"]:
   subprocess.call(["LFVVBFHighMass200tune","10","--i","subboost200"+region,"--o","subboost200"+region,"--l","cardroot30fb_sys","--name","subboost200"+region,"--d","cardroot30fb_sys","--b"])
for region in optimizer_new450.regions["0"]:
   subprocess.call(["LFVVBFHighMass450tune","10","--i","subgg450"+region,"--o","subgg450"+region,"--l","cardroot30fb_sys","--name","subgg450"+region,"--d","cardroot30fb_sys","--b"])
for region in optimizer_new450.regions["1"]:
   subprocess.call(["LFVVBFHighMass450tune","10","--i","subboost450"+region,"--o","subboost450"+region,"--l","cardroot30fb_sys","--name","subboost450"+region,"--d","cardroot30fb_sys","--b"])

