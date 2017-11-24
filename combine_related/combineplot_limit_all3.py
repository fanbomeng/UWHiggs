import subprocess
#import optimizer
import os
import shutil
#import ROOT
from ROOT import *
import ROOT
import math
import numpy as np
import matplotlib.pyplot as pyplot
from array import array
gROOT.ProcessLine(
         "struct limit_t {\
         Double_t         limit_0;\
         }")

samplelist=("GG","GG0jet","GG1jet")
def Readtree(filename,limitnumber,counts1,counts2,Xsection):
      filein=ROOT.TFile.Open(filename, "READ")
      limitTree=filein.Get("limit")
      #limit=-2.00
      nentries = limitTree.GetEntries();
      limit_s=limit_t()
      limitTree.SetBranchAddress("limit",AddressOf(limit_s,"limit_0"));
     # for i in range(0,5):
      limitTree.GetEntry(2);
      limitnumber[counts1][counts2]=limit_s.limit_0*Xsection
#def Readtree(filename,limitnumber,counts,Xsection):
#      filein=ROOT.TFile.Open(filename, "READ")
#      limitTree=filein.Get("limit")
#      #limit=-2.00
#      nentries = limitTree.GetEntries();
#      limit_s=limit_t()
#      limitTree.SetBranchAddress("limit",AddressOf(limit_s,"limit_0"));
#      for i in range(0,5):
#          limitTree.GetEntry(i);
#          limitnumber[i][counts]=limit_s.limit_0*Xsection
#fh = open("limitplots/limit_all.txt","a")
limit=[[0.0 for x in range(15)] for y in range(6)]
counts=0
for CAT in samplelist:
    #   if cuts in region: 
    counts_2=0
#    for catogray in [("200",16.94),("300",6.59),("450",2.3),("600",1.001),("750",0.4969),("900",0.2685)]:
    for catogray in [("200",0.1694),("300",0.0659),("450",0.023),("600",0.01001),("750",0.004969),("900",0.002685)]:
          xvariable=catogray[0].split("fb",1)[0]
          Readtree("limits_highmass/"+CAT+catogray[0]+".root",limit,counts,counts_2,catogray[1])
          limit[3][counts_2]=float(xvariable)
#          print 'counts %f   and count_2 %f' %(counts,counts_2)
#          print limit[counts][counts_2]
          counts_2=counts_2+1
#          print counts_2
          #limit = np.array(limit)
          #print limit
    counts=counts+1
Yvariable=array("d",filter(lambda a: a != 0.0, limit[0]))
Yvariable1=array("d",filter(lambda a: a != 0.0, limit[1]))
Yvariable2=array("d",filter(lambda a: a != 0.0, limit[2]))
Xvariable=array("d",filter(lambda a: a != 0.0, limit[3]))
c= ROOT.TCanvas("c", "c", 700, 700)
c.SetLogy()
print "herere11111111"
print Yvariable
print Yvariable1
print Yvariable2
#print '222222222----------%f'%np.amax(Xvariable)*1.5
#print '333333333----------%f'%np.amax(Yvariable2)*1.5
#leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803)
leg =ROOT.TLegend(0.556,0.7542857,0.9000606,0.9006803)
hist0=c.DrawFrame(np.amin(Xvariable)*0.5,0.001,np.amax(Xvariable)*1.2,np.amax(Yvariable2)*1.5)
#hist0=c.DrawFrame(np.amin(Xvariable)*0.5,0.01,900*1.5,np.amax(Yvariable2)*1.5)
hist0.GetXaxis().SetTitle("M_col [GeV]")
hist0.GetYaxis().SetTitle("95% C.L. #sigma(gg#rightarrowH) x B(h#rightarrow#mu#tau) [pb]")
hist0.GetYaxis().SetTitleOffset(1.3)
#print Yvariable1l
print Yvariable
print Xvariable 
gr =ROOT.TGraph(len(Xvariable),Xvariable,Yvariable)
gr1 =ROOT.TGraph(len(Xvariable),Xvariable,Yvariable1)
gr2 =ROOT.TGraph(len(Xvariable),Xvariable,Yvariable2)
#***********1sigma****************
#grshade =ROOT.TGraph(2*len(Xvariable))
numberpoints=len(Xvariable)
#for i in range(len(Xvariable)):
#      grshade.SetPoint(i,Xvariable[i],Yvariable1h[i])
#      grshade.SetPoint(numberpoints+i,Xvariable[numberpoints-i-1],Yvariable1l[numberpoints-i-1])
#****************2sigma********
#grshade2 =ROOT.TGraph(2*len(Xvariable))
#for i in range(len(Xvariable)):
#      grshade2.SetPoint(i,Xvariable[i],Yvariable2h[i])
#      grshade2.SetPoint(numberpoints+i,Xvariable[numberpoints-i-1],Yvariable2l[numberpoints-i-1])
#grshade.SetFillColor(kGreen)
#grshade2.SetFillColor(kYellow)
#grshade2.GetXaxis().SetTitle("tpt")
#grshade2.Draw("f")
gr.SetMarkerStyle(20)
gr.SetLineWidth(2)
gr1.SetMarkerStyle(20)
gr1.SetLineWidth(2)
gr2.SetMarkerStyle(20)
gr2.SetLineWidth(2)
gr.SetLineColor(7)
gr1.SetLineColor(8)
gr2.SetLineColor(6)
gr.SetMarkerColor(7)
gr1.SetMarkerColor(8)
gr2.SetMarkerColor(6)
gr.Draw("pl")
gr1.Draw("pl")
gr2.Draw("pl")
entry=leg.AddEntry(gr,"#mu#tau_{h} combined Expected","pl");
entry=leg.AddEntry(gr1,"#mu#tau_{h} 0-Jet Expected","pl");
entry=leg.AddEntry(gr2,"#mu#tau_{h} 1-Jet Expected","pl");
#entry=leg.AddEntry(grshade," 1 std deviation","f")
#entry.SetFillColor(kGreen)
#entry.SetFillStyle(1001)
#entry.SetLineStyle(1);
#entry=leg.AddEntry(grshade2," 2 std deviation","f")
#entry.SetFillColor(kYellow)
#entry.SetFillStyle(1001)
#entry.SetLineStyle(1)
#gr.Draw("pl")
leg.Draw()
c.SaveAs("limitplots/"+"limit_combined.pdf")
#fh.write("GGtpt\n")
#fh.write("\n")
#DAT =  np.column_stack((Xvariable,Yvariable))
#name=np.array(["limits"+CAT])
#np.savetxt(fh,name,delimiter=" ", fmt="%s")
#np.savetxt(fh, DAT, delimiter="      ", fmt="%s") 
   
#print Yvariable 
#print Xvariable 
   
#fh.close()
       
