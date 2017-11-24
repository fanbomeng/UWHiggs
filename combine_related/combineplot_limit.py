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
def Readtree(filename,limitnumber,counts,Xsection):
      filein=ROOT.TFile.Open(filename, "READ")
      limitTree=filein.Get("limit")
      #limit=-2.00
      nentries = limitTree.GetEntries();
      limit_s=limit_t()
      limitTree.SetBranchAddress("limit",AddressOf(limit_s,"limit_0"));
      for i in range(0,5):
         limitTree.GetEntry(i);
         limitnumber[i][counts]=limit_s.limit_0*Xsection
fh = open("limitplots/limit_all.txt","a")
for CAT in samplelist:
    #   if cuts in region: 
    limit=[[0.0 for x in range(15)] for y in range(6)]
    counts=0 
    #for catogray in [("200",16.94),("300",6.59),("450",2.3),("600",1.001),("750",0.4969),("900",0.2685)]:
    for catogray in [("200",0.1694),("300",0.0659),("450",0.023),("600",0.01001),("750",0.004969),("900",0.002685)]:
          xvariable=catogray[0].split("fb",1)[0]
          Readtree("limits_highmass/"+CAT+catogray[0]+".root",limit,counts,catogray[1])
          limit[5][counts]=float(xvariable)
          counts=counts+1
          #limit = np.array(limit)
          #print limit
    Yvariable=array("d",filter(lambda a: a != 0.0, limit[2]))
    Yvariable1l=array("d",filter(lambda a: a != 0.0, limit[1]))
    Yvariable1h=array("d",filter(lambda a: a != 0.0, limit[3]))
    Yvariable2l=array("d",filter(lambda a: a != 0.0, limit[0]))
    Yvariable2h=array("d",filter(lambda a: a != 0.0, limit[4]))
    Xvariable=array("d",filter(lambda a: a != 0.0, limit[5]))
    c= ROOT.TCanvas("c", "c", 700, 700)
    c.SetLogy()
    #leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803)
    leg =ROOT.TLegend(0.556,0.7542857,0.9000606,0.9006803)
    hist0=c.DrawFrame(np.amin(Xvariable)*0.5,0.001,np.amax(Xvariable)*1.5,np.amax(Yvariable2h)*1.5)
    hist0.GetXaxis().SetTitle("Scalar Mass [GeV]")
    hist0.GetYaxis().SetTitle("95% C.L. #sigma(gg#rightarrowH) x B(h#rightarrow#mu#tau) [pb]")
    hist0.GetYaxis().SetTitleOffset(1.3)
#    hist0.GetYaxis().SetMinimum(0.001)
    #print Yvariable1l
    Xvariablezero=array('d',[])
    for i in range(len(Xvariable)):
       Xvariablezero.append(0.0)
    gr =ROOT.TGraph(len(Xvariable),Xvariable,Yvariable)
    #***********1sigma****************
    grshade =ROOT.TGraph(2*len(Xvariable))
    numberpoints=len(Xvariable)
    for i in range(len(Xvariable)):
          grshade.SetPoint(i,Xvariable[i],Yvariable1h[i])
          grshade.SetPoint(numberpoints+i,Xvariable[numberpoints-i-1],Yvariable1l[numberpoints-i-1])
    #****************2sigma********
    grshade2 =ROOT.TGraph(2*len(Xvariable))
    for i in range(len(Xvariable)):
          grshade2.SetPoint(i,Xvariable[i],Yvariable2h[i])
          grshade2.SetPoint(numberpoints+i,Xvariable[numberpoints-i-1],Yvariable2l[numberpoints-i-1])
    grshade.SetFillColor(kGreen)
    grshade2.SetFillColor(kYellow)
    #grshade2.GetXaxis().SetTitle("tpt")
    grshade2.Draw("f")
    gr.SetMarkerStyle(20)
    gr.SetLineWidth(2)
    grshade.Draw("f")
    entry=leg.AddEntry(gr,"Expected","p");
    entry=leg.AddEntry(grshade," 1 std deviation","f")
    entry.SetFillColor(kGreen)
    entry.SetFillStyle(1001)
    entry.SetLineStyle(1);
    entry=leg.AddEntry(grshade2," 2 std deviation","f")
    entry.SetFillColor(kYellow)
    entry.SetFillStyle(1001)
    entry.SetLineStyle(1)
    gr.Draw("pl")
    leg.Draw()
    c.SaveAs("limitplots/"+"limit"+CAT+".pdf")
    #fh.write("GGtpt\n")
    #fh.write("\n")
    DAT =  np.column_stack((Xvariable,Yvariable))
    name=np.array(["limits"+CAT])
    np.savetxt(fh,name,delimiter=" ", fmt="%s")
    np.savetxt(fh, DAT, delimiter="      ", fmt="%s") 
       
    print Yvariable 
    print Xvariable 
       
fh.close()
       
