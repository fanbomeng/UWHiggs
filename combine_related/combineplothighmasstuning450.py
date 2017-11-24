import subprocess
import optimizer_new450
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

samplelist=(("gg450","0"),("boost450","1"))
cutvarible={
                "1":['tMtToPfMet_type1','tPt','mPt'],
                "0":['tPt','mPt','tMtToPfMet_type1'],
                # "0":['tPt','mPt','DeltaPhi','tmetdeltaPhi','tMtToPfMet_type1'],
                # "0":['tPt'],
                 #"0":['deltaPhi','tMtToPfMet_type1'],
                 #"2":['vbfMass']
                # "1":['tMtToPfMet_type1'],
                # "2":['vbfMass','vbfDeta']
               }
def Readtree(filename,limitnumber,counts):
      filein=ROOT.TFile.Open(filename, "READ")
      limitTree=filein.Get("limit")
      #limit=-2.00
      nentries = limitTree.GetEntries();
      limit_s=limit_t()
      limitTree.SetBranchAddress("limit",AddressOf(limit_s,"limit_0"));
      for i in range(0,5):
         limitTree.GetEntry(i);
         limitnumber[i][counts]=limit_s.limit_0
for catogray in range(2):
   fh = open("limitplots/limit_450"+samplelist[catogray][1]+".txt","a")
   for cuts in cutvarible[samplelist[catogray][1]]:
   
   
      limit=[[0.0 for x in range(25)] for y in range(6)]
      counts=0 
      for region in optimizer_new450.regions[samplelist[catogray][1]]:
         if cuts in region: 
            xvariable=region.split(cuts,1)[1]
            Readtree("combineoutput/"+samplelist[catogray][0]+region+".root",limit,counts)
            limit[5][counts]=float(xvariable)
            counts=counts+1
      #limit = np.array(limit)
      #print limit
      c= ROOT.TCanvas("c", "c", 700, 700)
      #mg =ROOT.TMultiGraph()
      leg =ROOT.TLegend(0.5833333,0.7142857,0.9060606,0.9006803)
      Yvariable=array("d",filter(lambda a: a != 0.0, limit[2]))
      Yvariable1l=array("d",filter(lambda a: a != 0.0, limit[1]))
      Yvariable1h=array("d",filter(lambda a: a != 0.0, limit[3]))
      Yvariable2l=array("d",filter(lambda a: a != 0.0, limit[0]))
      Yvariable2h=array("d",filter(lambda a: a != 0.0, limit[4]))
      Xvariable=array("d",filter(lambda a: a != 0.0, limit[5]))
      
      hist0=c.DrawFrame(np.amin(Xvariable)*0.5,0,np.amax(Xvariable)*1.5,np.amax(Yvariable2h)*1.5)
      hist0.GetXaxis().SetTitle(samplelist[catogray][0]+cuts)
      hist0.GetYaxis().SetTitle("95% CL limit on B(h#rightarrow#mu#tau)")
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
      c.SaveAs("limitplots/"+samplelist[catogray][0]+cuts+".pdf")
      DAT =  np.column_stack((Xvariable,Yvariable))
      name=np.array([samplelist[catogray][0]+cuts])
      np.savetxt(fh,name,delimiter=" ", fmt="%s")
      np.savetxt(fh, DAT, delimiter="      ", fmt="%s") 
   fh.close()
   
   print Yvariable 
   print Xvariable 
