#include "HTT-utilities/RecoilCorrections/interface/RecoilCorrector.h"
#!/usr/bin/python
import os
import re
import ROOT
import math 
class RecoilCorrector:
   def __init__(self,fileName):
#RecoilCorrector::RecoilCorrector(TString fileName) {

      cmsswBase ="/afs/hep.wisc.edu/cms/fmeng/Fanbo/CMSSW_8_0_26"#str(os.path.basename(os.environ['CMSSW_BASE'])) #str($CMSSW_BASE)
      baseDir = cmsswBase + "/src"+"/HTT-utilities/RecoilCorrections/data"
#      print cmsswBase 
      _fileName = baseDir+"/"+fileName
#      print _fileName
      File =ROOT.TFile.Open(_fileName)
      if (File.IsZombie()):
        print "file not found"
      
    
      projH =File.Get("projH")
      if (projH==None):
        print "File should contain histogram with the name projH " 
    
      firstBinStr  = projH.GetXaxis().GetBinLabel(1)
      secondBinStr = projH.GetXaxis().GetBinLabel(2)
    
      paralZStr = firstBinStr
      perpZStr  = secondBinStr
      #if (firstBinStr.Contains("Perp")):
      if ("Perp" in firstBinStr):
        paralZStr = secondBinStr
        perpZStr  = firstBinStr
      
     # std::cout << "Parallel component      (U1) : " << paralZStr << std::endl;
     # std::cout << "Perpendicular component (U2) : " << perpZStr << std::endl;
    
      ZPtBinsH =File.Get("ZPtBinsH")
      if (ZPtBinsH==None):
        print  "File should contain histogram with the name ZPtBinsH "
      
      nZPtBins = ZPtBinsH.GetNbinsX()
      ZPtBins=[]
      ZPtStr=[]
 #     print "line 45 nZPtBins %f" %nZPtBins
      #for i in range(0,<=nZPtBins):
      for i in range(0,nZPtBins+1):
        ZPtBins.append(ZPtBinsH.GetXaxis().GetBinLowEdge(i+1))
        if (i<nZPtBins):
          ZPtStr.append(ZPtBinsH.GetXaxis().GetBinLabel(i+1))
      
    
      nJetBinsH =File.Get("nJetBinsH")
      if (nJetBinsH==None):
        print "File should contain histogram with the name nJetBinsH"
      nJetsBins = nJetBinsH.GetNbinsX()
      nJetsStr=[]
      for i in range(0,nJetsBins):
        nJetsStr.append(nJetBinsH.GetXaxis().GetBinLabel(i+1))
      
    
      self.InitMEtWeights(File,perpZStr,paralZStr,nZPtBins,ZPtBins,ZPtStr,nJetsBins,nJetsStr)
    
      _epsrel = 5e-4
      _epsabs = 5e-4
      _range = 0.95
    
  #  }
#RecoilCorrector::~RecoilCorrector() {

#}
#void RecoilCorrector::InitMEtWeights(TFile * _file,
#                                     TString  _perpZStr,
#                                     TString  _paralZStr,
#                                     int nZPtBins,
#                                     float * ZPtBins,
#                                     TString * _ZPtStr,
#                                     int nJetsBins,
#                                     TString * _nJetsStr) {
   def InitMEtWeights(self,_file,_perpZStr,_paralZStr,nZPtBins,ZPtBins,_ZPtStr,nJetsBins,_nJetsStr):
#	std::vector<float> newZPtBins;
#	std::vector<std::string> newZPtStr;
#	std::vector<std::string> newNJetsStr;

	newPerpZStr  = str(_perpZStr)
	newParalZStr = str(_paralZStr)
        newZPtBins=[]
        newZPtStr=[]
        newNJetsStr=[]
	for idx in range(0,nZPtBins+1): 
	  newZPtBins.append(ZPtBins[idx])
	for idx in range(0,nZPtBins): 
	  newZPtStr.append(str(_ZPtStr[idx]))
	for idx in range(0,nJetsBins):
	  newNJetsStr.append(str(_nJetsStr[idx]))
	self.InitMEtWeightsC(_file,newZPtBins,newPerpZStr,newParalZStr,newZPtStr,newNJetsStr)
#}



#void RecoilCorrector::InitMEtWeights(TFile * _fileMet,
#				     const std::vector<float>& ZPtBins,
#				     const std::string _perpZStr,
#				     const std::string _paralZStr,
#				     const std::vector<std::string>& _ZPtStr,
#				     const std::vector<std::string>& _nJetsStr)
   def InitMEtWeightsC(self,_fileMet,ZPtBins,_perpZStr,_paralZStr,_ZPtStr,_nJetsStr): 

      _nZPtBins = len(ZPtBins)-1 #// the -1 is on purpose!
      #_nJetsBins = len(_nJetsStr)
      self._nJetsBins = len(_nJetsStr)
      
      self._ZPtBins = ZPtBins
      _ZPtBins = ZPtBins
      _metZParalData=[[0 for x in range(3)] for y in range(5)]
      _xminMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      _xmaxMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      _metZPerpData=[[0 for x in range(3)] for y in range(5)]
      _xminMetZPerpData=[[0 for x in range(3)] for y in range(5)] 
      _xmaxMetZPerpData=[[0 for x in range(3)] for y in range(5)] 
      _metZParalMC=[[0 for x in range(3)] for y in range(5)]
      _xminMetZParalMC=[[0 for x in range(3)] for y in range(5)]
      _xmaxMetZParalMC=[[0 for x in range(3)] for y in range(5)]
      _metZPerpMC=[[0 for x in range(3)] for y in range(5)] 
      _xminMetZPerpMC=[[0 for x in range(3)] for y in range(5)] 
      _xmaxMetZPerpMC=[[0 for x in range(3)] for y in range(5)] 
      _xminMetZParal=[[0 for x in range(3)] for y in range(5)] 
      _xmaxMetZParal=[[0 for x in range(3)] for y in range(5)] 
      _xminMetZPerp=[[0 for x in range(3)] for y in range(5)] 
      _xmaxMetZPerp=[[0 for x in range(3)] for y in range(5)] 
      self._meanMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      self._rmsMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      self._rmsMetZPerpData=[[0 for x in range(3)] for y in range(5)] 
      self._meanMetZParalMC=[[0 for x in range(3)] for y in range(5)] 
      self._rmsMetZParalMC=[[0 for x in range(3)] for y in range(5)] 
      self._rmsMetZPerpMC=[[0 for x in range(3)] for y in range(5)] 

      #_meanMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      #_rmsMetZParalData=[[0 for x in range(3)] for y in range(5)] 
      #_rmsMetZPerpData=[[0 for x in range(3)] for y in range(5)] 
      #_meanMetZParalMC=[[0 for x in range(3)] for y in range(5)] 
      #_rmsMetZParalMC=[[0 for x in range(3)] for y in range(5)] 
      #_rmsMetZPerpMC=[[0 for x in range(3)] for y in range(5)] 
      for ZPtBin in range(0,_nZPtBins):
        for jetBin in range(0,self._nJetsBins):
        #for jetBin in range(0,_nJetsBins):
    
          binStrPerpData  = _perpZStr  + "_" + _nJetsStr[jetBin] + _ZPtStr[ZPtBin] + "_data"
          binStrParalData = _paralZStr + "_" + _nJetsStr[jetBin] + _ZPtStr[ZPtBin] + "_data"
          binStrPerpMC    = _perpZStr  + "_" + _nJetsStr[jetBin] + _ZPtStr[ZPtBin] + "_mc"
          binStrParalMC   = _paralZStr + "_" + _nJetsStr[jetBin] + _ZPtStr[ZPtBin] + "_mc"
    
          _metZParalData[ZPtBin][jetBin] = _fileMet.Get(binStrParalData)
          _metZPerpData[ZPtBin][jetBin]  = _fileMet.Get(binStrPerpData)
          _metZParalMC[ZPtBin][jetBin]   = _fileMet.Get(binStrParalMC)
          _metZPerpMC[ZPtBin][jetBin]    = _fileMet.Get(binStrPerpMC)
    
    
    
          if (_metZParalData[ZPtBin][jetBin]==None):
    	      print  "Function with names not found in file "
          if (_metZPerpData[ZPtBin][jetBin]==None):
    	      print  "Function with names not found in file "
          if (_metZParalMC[ZPtBin][jetBin]==None):
    	      print  "Function with names not found in file "
          if (_metZPerpMC[ZPtBin][jetBin]==None):
    	      print  "Function with names not found in file "
          
          xminD=ROOT.Double(0.0000000000000)
          xmaxD=ROOT.Double(0.0000000000000)
    
          _metZParalData[ZPtBin][jetBin].GetRange(xminD,xmaxD)
          _xminMetZParalData[ZPtBin][jetBin] = float(xminD)
          _xmaxMetZParalData[ZPtBin][jetBin] = float(xmaxD)
    
          _metZPerpData[ZPtBin][jetBin].GetRange(xminD,xmaxD);
          _xminMetZPerpData[ZPtBin][jetBin] = float(xminD);
          _xmaxMetZPerpData[ZPtBin][jetBin] = float(xmaxD);
    
          _metZParalMC[ZPtBin][jetBin].GetRange(xminD,xmaxD);
          _xminMetZParalMC[ZPtBin][jetBin] = float(xminD);
          _xmaxMetZParalMC[ZPtBin][jetBin] = float(xmaxD);
    
          _metZPerpMC[ZPtBin][jetBin].GetRange(xminD,xmaxD);
          _xminMetZPerpMC[ZPtBin][jetBin] = float(xminD);
          _xmaxMetZPerpMC[ZPtBin][jetBin] = float(xmaxD);
    
          _xminMetZParal[ZPtBin][jetBin] = max(_xminMetZParalData[ZPtBin][jetBin],_xminMetZParalMC[ZPtBin][jetBin]);
          _xmaxMetZParal[ZPtBin][jetBin] = min(_xmaxMetZParalData[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin]);
    
          _xminMetZPerp[ZPtBin][jetBin] = max(_xminMetZPerpData[ZPtBin][jetBin],_xminMetZPerpMC[ZPtBin][jetBin]);
          _xmaxMetZPerp[ZPtBin][jetBin] = min(_xmaxMetZPerpData[ZPtBin][jetBin],_xmaxMetZPerpMC[ZPtBin][jetBin]);
          
          #_meanMetZParalData[ZPtBin][jetBin] = _metZParalData[ZPtBin][jetBin].Mean(_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin])
          self._meanMetZParalData[ZPtBin][jetBin] = _metZParalData[ZPtBin][jetBin].Mean(_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin])
          self._rmsMetZParalData[ZPtBin][jetBin] = (_metZParalData[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin]))**(0.5)
          #_meanMetZParalData[ZPtBin][jetBin] = _metZParalData[ZPtBin][jetBin].Mean(_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin])
          #_rmsMetZParalData[ZPtBin][jetBin] = (_metZParalData[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin]))**(0.5)
#          _rmsMetZParalData[ZPtBin][jetBin] = (_metZParalData[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalData[ZPtBin][jetBin],_xmaxMetZParalData[ZPtBin][jetBin]))**(0.5)
          #self._meanMetZPerpData[ZPtBin][jetBin] = 0
          self._rmsMetZPerpData[ZPtBin][jetBin] =(_metZPerpData[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpData[ZPtBin][jetBin],_xmaxMetZPerpData[ZPtBin][jetBin]))**(0.5)
          #_rmsMetZPerpData[ZPtBin][jetBin] =(_metZPerpData[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpData[ZPtBin][jetBin],_xmaxMetZPerpData[ZPtBin][jetBin]))**(0.5)
#          _rmsMetZPerpData[ZPtBin][jetBin] =(_metZPerpData[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpData[ZPtBin][jetBin],_xmaxMetZPerpData[ZPtBin][jetBin]))**(0.5)
    
          self._meanMetZParalMC[ZPtBin][jetBin] = _metZParalMC[ZPtBin][jetBin].Mean(_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin])
          #_meanMetZParalMC[ZPtBin][jetBin] = _metZParalMC[ZPtBin][jetBin].Mean(_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin])
#          _meanMetZParalMC[ZPtBin][jetBin] = _metZParalMC[ZPtBin][jetBin].Mean(_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin])
          #_rmsMetZParalMC[ZPtBin][jetBin] = (_metZParalMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin]))**(0.5)
          self._rmsMetZParalMC[ZPtBin][jetBin] = (_metZParalMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin]))**(0.5)
          #_rmsMetZParalMC[ZPtBin][jetBin] = (_metZParalMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZParalMC[ZPtBin][jetBin],_xmaxMetZParalMC[ZPtBin][jetBin]))**(0.5)
          #self._meanMetZPerpMC[ZPtBin][jetBin] = 0
#          _rmsMetZPerpMC[ZPtBin][jetBin] = (_metZPerpMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpMC[ZPtBin][jetBin],_xmaxMetZPerpMC[ZPtBin][jetBin]))**(0.5)
          self._rmsMetZPerpMC[ZPtBin][jetBin] = (_metZPerpMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpMC[ZPtBin][jetBin],_xmaxMetZPerpMC[ZPtBin][jetBin]))**(0.5)
          #_rmsMetZPerpMC[ZPtBin][jetBin] = (_metZPerpMC[ZPtBin][jetBin].CentralMoment(2,_xminMetZPerpMC[ZPtBin][jetBin],_xmaxMetZPerpMC[ZPtBin][jetBin]))**(0.5)
    

#void RecoilCorrector::CorrectByMeanResolution(float MetPx,
#					      float MetPy,
#					      float genVPx, 
#					      float genVPy,
#					      float visVPx,
#					      float visVPy,
#					      int njets,
#					      float & MetCorrPx,
#					      float & MetCorrPy) {
   def CorrectByMeanResolution(self,MetPx,MetPy,genVPx,genVPy,visVPx,visVPy,njets):#,MetCorrPx,MetCorrPy):  

       Zpt = math.sqrt(genVPx*genVPx + genVPy*genVPy)
       self.U1 = 0
       self.U2 = 0
       self.metU1 = 0
       self.metU2 = 0

       #self.CalculateU1U2FromMet(MetPx,MetPy,genVPx,genVPy,visVPx,visVPy,self.U1,self.U2,self.metU1,self.metU2)
       self.CalculateU1U2FromMet(MetPx,MetPy,genVPx,genVPy,visVPx,visVPy)
    #   print 'line 235 U1 U2 metU1 metU2 %f, %f, %f, %f'  %(self.U1,self.U2,self.metU1,self.metU2)
       if (Zpt>1000):
           Zpt = 999

       if (njets>=self._nJetsBins):
           njets =self._nJetsBins - 1
       MetCorrPx=0.00000000
       MetCorrPy=0.00000000
# ------binNumber part
       for iB in range(0,len(self._ZPtBins)):
          if (Zpt>=self._ZPtBins[iB] and Zpt<self._ZPtBins[iB+1]):
            ZptBin=iB 
          else:
            ZptBin=0
#       ZptBin = binNumber(Zpt, _ZPtBins)

       #self.U1U2CorrectionsByWidth(self.U1,self.U2,ZptBin,njets) 
       self.U1U2CorrectionsByWidth(ZptBin,njets) 
     #  print "line 251 U1 U2 after the correcton %f    %f "  %(self.U1,self.U2) 
       #tmpMet=self.CalculateMetFromU1U2(self.U1,self.U2,genVPx,genVPy,visVPx,visVPy,MetCorrPx,MetCorrPy)
       tmpMet=self.CalculateMetFromU1U2(genVPx,genVPy,visVPx,visVPy,MetCorrPx,MetCorrPy)
      # print "line 253 U1 U2 after the correcton %f    %f "  %(self.U1,self.U2) 
       #MetCorrPx=tmpMet[0]
       #MetCorrPy=tmpMet[1]
       #print tmpMet
       return tmpMet
#void RecoilCorrector::U1U2CorrectionsByWidth(float & U1, 
#					     float & U2,
#					     int ZptBin,
#					     int njets) {
#
   #def U1U2CorrectionsByWidth(self,U1,U2,ZptBin,njets):
   #    if (njets>=self._nJetsBins):
   #       njets = self._nJetsBins - 1
   #  
   #    width = U1 - self._meanMetZParalMC[ZptBin][njets]
   #    width *= self._rmsMetZParalData[ZptBin][njets]/self._rmsMetZParalMC[ZptBin][njets]
   #    U1 = self._meanMetZParalData[ZptBin][njets] + width
   #  
   #    width = U2
   #    width *= self._rmsMetZPerpData[ZptBin][njets]/self._rmsMetZPerpMC[ZptBin][njets]
   #    U2 = width

   def U1U2CorrectionsByWidth(self,ZptBin,njets):
       if (njets>=self._nJetsBins):
          njets = self._nJetsBins - 1
     
       width = self.U1 - self._meanMetZParalMC[ZptBin][njets]
       width *= self._rmsMetZParalData[ZptBin][njets]/self._rmsMetZParalMC[ZptBin][njets]
       self.U1 = self._meanMetZParalData[ZptBin][njets] + width
     
       width = self.U2
       width *= self._rmsMetZPerpData[ZptBin][njets]/self._rmsMetZPerpMC[ZptBin][njets]
       self.U2 = width

#void RecoilCorrector::CalculateU1U2FromMet(float metPx,
#					   float metPy,
#					   float genZPx,
#					   float genZPy,
#					   float diLepPx,
#					   float diLepPy,
#					   float & U1,
#					   float & U2,
#					   float & metU1,
#					   float & metU2) {
   def CalculateU1U2FromMet(self,metPx,metPy,genZPx,genZPy,diLepPx,diLepPy):  
       hadRecX = metPx + diLepPx - genZPx
       hadRecY = metPy + diLepPy - genZPy
       
       hadRecPt = (hadRecX*hadRecX+hadRecY*hadRecY)**(0.5)
       
       phiHadRec = math.atan2(hadRecY,hadRecX)
       
       phiDiLep = math.atan2(diLepPy,diLepPx)
       
       phiMEt =math.atan2(metPy,metPx)
       
       metPt =(metPx*metPx+metPy*metPy)**(0.5)
       
       phiZ = math.atan2(genZPy,genZPx)
       
       deltaPhiZHadRec  = phiHadRec - phiZ
       deltaPhiDiLepMEt = phiMEt - phiDiLep
       
       self.U1 = hadRecPt * math.cos(deltaPhiZHadRec)
       self.U2 = hadRecPt * math.sin(deltaPhiZHadRec)
#       print "line 308the U1, U2 after the correction %f   %f" %(self.U1,self.U2) 
       self.metU1 = metPt * math.cos(deltaPhiDiLepMEt)      
       self.metU2 = metPt * math.sin(deltaPhiDiLepMEt)

#   def CalculateU1U2FromMet(self,metPx,metPy,genZPx,genZPy,diLepPx,diLepPy,U1,U2,metU1,metU2):  
#       hadRecX = metPx + diLepPx - genZPx
#       hadRecY = metPy + diLepPy - genZPy
#       
#       hadRecPt = (hadRecX*hadRecX+hadRecY*hadRecY)**(0.5)
#       
#       phiHadRec = math.atan2(hadRecY,hadRecX)
#       
#       phiDiLep = math.atan2(diLepPy,diLepPx)
#       
#       phiMEt =math.atan2(metPy,metPx)
#       
#       metPt =(metPx*metPx+metPy*metPy)**(0.5)
#       
#       phiZ = math.atan2(genZPy,genZPx)
#       
#       deltaPhiZHadRec  = phiHadRec - phiZ
#       deltaPhiDiLepMEt = phiMEt - phiDiLep
#       
#       U1 = hadRecPt * math.cos(deltaPhiZHadRec)
#       U2 = hadRecPt * math.sin(deltaPhiZHadRec)
#       print "line 308the U1, U2 after the correction %f   %f" %(U1,U2) 
#       metU1 = metPt * math.cos(deltaPhiDiLepMEt)      
#       metU2 = metPt * math.sin(deltaPhiDiLepMEt)

#void RecoilCorrector::CalculateMetFromU1U2(float U1,
#					   float U2,
#					   float genZPx,
#					   float genZPy,
#					   float diLepPx,
#					   float diLepPy,
#					   float & metPx,
#					   float & metPy) {
   def CalculateMetFromU1U2(self,genZPx,genZPy,diLepPx,diLepPy,metPx,metPy):  
       hadRecPt =math.sqrt(self.U1*self.U1+self.U2*self.U2)
#       print "at line 323 the hadRecPt value %f"  %hadRecPt
       deltaPhiZHadRec =math.atan2(self.U2,self.U1)

       phiZ = math.atan2(genZPy,genZPx)

       phiHadRec = phiZ + deltaPhiZHadRec
       
       hadRecX = hadRecPt*math.cos(phiHadRec)
       hadRecY = hadRecPt*math.sin(phiHadRec)
       
       metPx = hadRecX + genZPx - diLepPx
       metPy = hadRecY + genZPy - diLepPy
       return [metPx,metPy]
#       print "metPx=%f and metPy=%f"   %(metPx,metPx)
##
#   def CalculateMetFromU1U2(self,U1,U2,genZPx,genZPy,diLepPx,diLepPy,metPx,metPy):  
#       hadRecPt =math.sqrt(U1*U1+U2*U2)
#       print "at line 323 the hadRecPt value %f"  %hadRecPt
#       deltaPhiZHadRec =math.atan2(U2,U1)
#
#       phiZ = math.atan2(genZPy,genZPx)
#
#       phiHadRec = phiZ + deltaPhiZHadRec
#       
#       hadRecX = hadRecPt*math.cos(phiHadRec)
#       hadRecY = hadRecPt*math.sin(phiHadRec)
#       
#       metPx = hadRecX + genZPx - diLepPx
#       metPy = hadRecY + genZPy - diLepPy
#       return [metPx,metPy]
##       print "metPx=%f and metPy=%f"   %(metPx,metPx)