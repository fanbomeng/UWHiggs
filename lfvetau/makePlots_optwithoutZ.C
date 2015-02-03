#include <cmath>
#include "formats10.h" 
void makePlots_optwithoutZ(){

  TString pathResults1 = "results/newNtuple_5Nov/LFVHETauAnalyzerMVA1/";
  //TString pathResults1 = "results/newNtuple_10Oct/LFVHETauAnalyzerMVA/";
  //TString pathResults2 = "results/MuTauSingleMuJetReRecoSkimTotal2/AnalyzeMuTauTight_opt_GG1Jet_noPU/";
  TString pathInputs =   "inputs/newNtuple_5Nov/";
  TString pathPlots0="os/gg/ept30/0/selected/";  
  TString pathPlots1="os/gg/ept30/1/selected/";  
  TString pathPlots2="os/gg/ept30/2/selected/";  
  TString pathPlots3="os/gg/ept30/";  
  //TFile *fLFVgg =  new TFile(pathName(pathResults1, "LFV_GG_H2MuTau_ntuples.root"));
  TFile *fLFVvbf = new TFile(pathName(pathResults1, "vbfHiggsToETau.root"));
  TFile *fW1Jets = new TFile(pathName(pathResults1, "Wplus1Jets_madgraph.root"));
  TFile *fW2Jets = new TFile(pathName(pathResults1, "Wplus2Jets_madgraph.root"));
  TFile *fW3Jets = new TFile(pathName(pathResults1, "Wplus3Jets_madgraph.root"));
  TFile *fW4Jets = new TFile(pathName(pathResults1, "Wplus4Jets_madgraph.root"));
  
  TFile *fGGHTT = new TFile(pathName(pathResults1, "GluGluToHToTauTau_M-125_8TeV-powheg-pythia6.root"));
  TFile *fTTJetsFLMGD = new TFile(pathName(pathResults1, "TTJetsFullLepMGDecays.root"));
  TFile *fTTJetsSLMGD = new TFile(pathName(pathResults1, "TTJetsSemiLepMGDecays.root"));
   
  TFile *fT_tZ2star=  new TFile(pathName(pathResults1, "T_t-channel_TuneZ2star_8TeV-powheg-tauola.root "));
  TFile *fT_twZ2star = new TFile(pathName(pathResults1, "T_tW-channel-DR_TuneZ2star_8TeV-powheg-tauola.root"));
  TFile *fTbar_tZ2star = new TFile(pathName(pathResults1, "Tbar_t-channel_TuneZ2star_8TeV-powheg-tauola.root"));
  TFile *fTbar_twZ2star = new TFile(pathName(pathResults1, "Tbar_tW-channel-DR_TuneZ2star_8TeV-powheg-tauola.root"));
  TFile *fWWJets = new TFile(pathName(pathResults1, "WWJets.root"));
  TFile *fWZJets = new TFile(pathName(pathResults1, "WZJets.root"));
  TFile *fZ0jetsLL = new TFile(pathName(pathResults1, "Z0jets_M50_skimmedLL.root"));
  TFile *fZ1jetsLL = new TFile(pathName(pathResults1, "Z1jets_M50_skimmedLL.root"));
  TFile *fZ2jetsLL = new TFile(pathName(pathResults1, "Z2jets_M50_skimmedLL.root"));
  TFile *fZ3jetsLL = new TFile(pathName(pathResults1, "Z3jets_M50_skimmedLL.root"));
  TFile *fZ4jetsLL = new TFile(pathName(pathResults1, "Z4jets_M50_skimmedLL.root"));
  TFile *fZ0jetsTT = new TFile(pathName(pathResults1, "Z0jets_M50_skimmedTT.root"));
  TFile *fZ1jetsTT = new TFile(pathName(pathResults1, "Z1jets_M50_skimmedTT.root"));
  TFile *fZ2jetsTT = new TFile(pathName(pathResults1, "Z2jets_M50_skimmedTT.root"));
  TFile *fZ3jetsTT = new TFile(pathName(pathResults1, "Z3jets_M50_skimmedTT.root"));
  TFile *fZ4jetsTT = new TFile(pathName(pathResults1, "Z4jets_M50_skimmedTT.root"));
  TFile *fZZjets= new TFile(pathName(pathResults1, "ZZJets.root"));
 // TFile *fZetauA= new TFile(pathName(pathResults1, "ZetauEmbedded_Run2012A.root"));
 // TFile *fZetauB= new TFile(pathName(pathResults1, "ZetauEmbedded_Run2012B.root"));
 // TFile *fZetauC= new TFile(pathName(pathResults1, "ZetauEmbedded_Run2012C.root"));
 // TFile *fZetauD= new TFile(pathName(pathResults1, "ZetauEmbedded_Run2012D.root"));
  TFile *fLFVgg= new TFile(pathName(pathResults1, "ggHiggsToETau.root"));
//jet0panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('deltaPhicut',1,1,10,35),('tMtToPFMETcut',1,1,0,160)]
//jet1panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('tMtToPFMETcut',1,1,0,160)]
//jet2panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('tMtToPFMETcut',1,1,0,160),('vbfMasscut',1,4,0,800),('vbfDetacut',1,1,10,80)]
  const string jet0[]={"tPtcut","ePtcut","deltaPhicut","tMtToPFMETcut","0jets"}; 
  const string jet1[]={"tPtcut","ePtcut","tMtToPFMETcut","1jets"}; 
  const string jet2[]={"tPtcut","ePtcut","tMtToPFMETcut","vbfMasscut","vbfDetacut","2jets"}; 
  
  //  cout << "datalumi: " << DataLumi << endl;
  //cout << "lfvlumi:  " << LFVvbfLumi << endl;
    
/*  overlay("Yield/Yield_mPt", 0, "yield_mPt_2Jet1Test_re", "SoverSqrtB_2Jet1Test_mPt_re", "",
          fLFVvbf,    fW1Jets,    fW2Jets,    fW3Jets,    fW4Jets,    fW1JetsExt,    fW2JetsExt,    fW3JetsExt,    fDY1Jets,    fDY2Jets,    fDY3Jets,    fDY4Jets,    fZJets,    fTTJetsFull,    fTTJetsSemi,
          LFVvbfLumi, W1JetsLumi, W2JetsLumi, W3JetsLumi, W4JetsLumi, W1JetsExtLumi, W2JetsExtLumi, W3JetsExtLumi, DY1JetsLumi, DY2JetsLumi, DY3JetsLumi, DY4JetsLumi, ZJetsLumi, TTJetsFullLumi, TTJetsSemiLumi,  DataLumi); */ 
// for(int i=0;i<=3;i++)
// { 
    jet0tune(pathPlots2,pathInputs,"vbfDetacut",0,fLFVvbf,fW1Jets, fW2Jets, fW3Jets, fW4Jets, fGGHTT,fTTJetsFLMGD, fTTJetsSLMGD, fT_tZ2star, fT_twZ2star, fTbar_tZ2star, fTbar_twZ2star,fWWJets, fWZJets, fZ0jetsTT, fZ1jetsTT, fZ2jetsTT, fZ3jetsTT, fZ4jetsTT, fZ0jetsLL, fZ1jetsLL, fZ2jetsLL, fZ3jetsLL, fZ4jetsLL, fZZjets,fLFVgg);

// }
// jet0tune(pathplots0,"tPtcut",0, fLFVvbf,fW1Jets,LFVvbfLumi,W1JetsLumi,DataLumi);
}

void jet0tune(TString path,TString pathInputs,char * variable,int rebin, TFile *fLFVvbf,TFile *fW1Jets,TFile * fW2Jets,TFile * fW3Jets,TFile * fW4Jets,TFile * fGGHTT,TFile *fTTJetsFLMGD,TFile * fTTJetsSLMGD,TFile * fT_tZ2star,TFile * fT_twZ2star,TFile *  fTbar_tZ2star,TFile * fTbar_twZ2star,TFile *fWWJets,TFile * fWZJets,TFile * fZ0jetsTT,TFile * fZ1jetsTT,TFile * fZ2jetsTT,TFile * fZ3jetsTT,TFile * fZ4jetsTT,TFile * fZ0jetsLL,TFile * fZ1jetsLL,TFile * fZ2jetsLL,TFile * fZ3jetsLL,TFile * fZ4jetsLL,TFile * fZZjets,TFile * fLFVgg)

{

  TH1F *hLFVvbf = (TH1F*) fLFVvbf->Get(pathName(path,variable));
  TH1F *hW1Jets = (TH1F*) fW1Jets->Get(pathName(path,variable));
  TH1F *hW2Jets= (TH1F*) fW2Jets->Get(pathName(path,variable));
  TH1F *hW3Jets= (TH1F*) fW3Jets->Get(pathName(path,variable));
  TH1F *hW4Jets= (TH1F*) fW4Jets->Get(pathName(path,variable));
  TH1F *hGGHTT= (TH1F*) fGGHTT->Get(pathName(path,variable));
  TH1F *hTTJetsFLMGD= (TH1F*) fTTJetsFLMGD->Get(pathName(path,variable));
  TH1F *hTTJetsSLMGD= (TH1F*) fTTJetsSLMGD->Get(pathName(path,variable));
  TH1F *hT_tZ2star= (TH1F*) fT_tZ2star->Get(pathName(path,variable));
  TH1F *hT_twZ2star= (TH1F*) fT_twZ2star->Get(pathName(path,variable));
  TH1F *hTbar_tZ2star= (TH1F*) fTbar_tZ2star->Get(pathName(path,variable));
  TH1F *hTbar_twZ2star= (TH1F*) fTbar_twZ2star->Get(pathName(path,variable));
  TH1F *hWWJets= (TH1F*) fWWJets->Get(pathName(path,variable));
  TH1F *hWZJets= (TH1F*) fWZJets->Get(pathName(path,variable));
  TH1F *hZ0jetsTT= (TH1F*) fZ0jetsTT->Get(pathName(path,variable));
  TH1F *hZ1jetsTT= (TH1F*) fZ1jetsTT->Get(pathName(path,variable));
  TH1F *hZ2jetsTT= (TH1F*) fZ2jetsTT->Get(pathName(path,variable));
  TH1F *hZ3jetsTT= (TH1F*) fZ3jetsTT->Get(pathName(path,variable));
  TH1F *hZ4jetsTT= (TH1F*) fZ4jetsTT->Get(pathName(path,variable));
  TH1F *hZ0jetsLL= (TH1F*) fZ0jetsLL->Get(pathName(path,variable));
  TH1F *hZ1jetsLL= (TH1F*) fZ1jetsLL->Get(pathName(path,variable));
  TH1F *hZ2jetsLL= (TH1F*) fZ2jetsLL->Get(pathName(path,variable));
  TH1F *hZ3jetsLL= (TH1F*) fZ3jetsLL->Get(pathName(path,variable));
  TH1F *hZ4jetsLL= (TH1F*) fZ4jetsLL->Get(pathName(path,variable));
  TH1F *hZZjets= (TH1F*) fZZjets->Get(pathName(path,variable));
//  TH1F *hZetauA= (TH1F*) fZetauA->Get(pathName(path,variable));
//  TH1F *hZetauB= (TH1F*) fZetauB->Get(pathName(path,variable));
//  TH1F *hZetauC= (TH1F*) fZetauC->Get(pathName(path,variable));
//  TH1F *hZetauD= (TH1F*) fZetauD->Get(pathName(path,variable));
  TH1F *hLFVgg= (TH1F*) fLFVgg->Get(pathName(path,variable));


  float LFVvbfLumi = getLumiCalc(pathName(pathInputs, "vbfHiggsToETau.lumicalc.sum"));

  float W1JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus1Jets_madgraph.lumicalc.sum"));
  float W2JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus2Jets_madgraph.lumicalc.sum"));
  float W3JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus3Jets_madgraph.lumicalc.sum"));
  float W4JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus4Jets_madgraph.lumicalc.sum"));

  float GGHTTLumi = getLumiCalc(pathName(pathInputs, "GluGluToHToTauTau_M-125_8TeV-powheg-pythia6.lumicalc.sum"));
  float TTJetsFLMGDLumi = getLumiCalc(pathName(pathInputs, "TTJetsFullLepMGDecays.lumicalc.sum"));
  float TTJetsSLMGDLumi = getLumiCalc(pathName(pathInputs, "TTJetsSemiLepMGDecays.lumicalc.sum"));

  float DataLumiA =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012A_22Jan2013_v1.lumicalc.sum"));
  float DataLumiB =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012B_22Jan2013_v1.lumicalc.sum"));
  float DataLumiC =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012C_22Jan2013_v1.lumicalc.sum"));
  float DataLumiD =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012D_22Jan2013_v1.lumicalc.sum"));
  float DataLumi =   DataLumiA+DataLumiB+DataLumiC+DataLumiD;  
  float T_tZ2starLumi =  getLumiCalc(pathName(pathInputs, "T_t-channel_TuneZ2star_8TeV-powheg-tauola.lumicalc.sum"));
  float T_twZ2starLumi =  getLumiCalc(pathName(pathInputs, "T_tW-channel-DR_TuneZ2star_8TeV-powheg-tauola.lumicalc.sum"));
  float Tbar_tZ2starLumi =  getLumiCalc(pathName(pathInputs, "Tbar_t-channel_TuneZ2star_8TeV-powheg-tauola.lumicalc.sum"));
  float Tbar_tw2starLumi =  getLumiCalc(pathName(pathInputs, "Tbar_tW-channel-DR_TuneZ2star_8TeV-powheg-tauola.lumicalc.sum"));
  float WWJetsLumi =  getLumiCalc(pathName(pathInputs, "WWJets.lumicalc.sum"));
  float WZJetsLumi =  getLumiCalc(pathName(pathInputs, "WZJets.lumicalc.sum"));
  float Z0JetsTTLumi =  getLumiCalc(pathName(pathInputs, "Z0jets_M50_skimmedTT.lumicalc.sum"));
  float Z1JetsTTLumi =  getLumiCalc(pathName(pathInputs, "Z1jets_M50_skimmedTT.lumicalc.sum"));
  float Z2JetsTTLumi =  getLumiCalc(pathName(pathInputs, "Z2jets_M50_skimmedTT.lumicalc.sum"));
  float Z3JetsTTLumi =  getLumiCalc(pathName(pathInputs, "Z3jets_M50_skimmedTT.lumicalc.sum"));
  float Z4JetsTTLumi =  getLumiCalc(pathName(pathInputs, "Z4jets_M50_skimmedTT.lumicalc.sum"));
  float Z0JetsLLLumi =  getLumiCalc(pathName(pathInputs, "Z0jets_M50_skimmedLL.lumicalc.sum"));
  float Z1JetsLLLumi =  getLumiCalc(pathName(pathInputs, "Z1jets_M50_skimmedLL.lumicalc.sum"));
  float Z2JetsLLLumi =  getLumiCalc(pathName(pathInputs, "Z2jets_M50_skimmedLL.lumicalc.sum"));
  float Z3JetsLLLumi =  getLumiCalc(pathName(pathInputs, "Z3jets_M50_skimmedLL.lumicalc.sum"));
  float Z4JetsLLLumi =  getLumiCalc(pathName(pathInputs, "Z4jets_M50_skimmedLL.lumicalc.sum"));
  float ZZJetsLumi =  getLumiCalc(pathName(pathInputs, "ZZJets.lumicalc.sum"));
//  float ZetauLumiA =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012A_22Jan2013_v1.lumicalc.sum"));
//  float ZetauLumiB =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012B_22Jan2013_v1.lumicalc.sum"));
//  float ZetauLumiC =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012C_22Jan2013_v1.lumicalc.sum"));
//  float ZetauLumiD =  getLumiCalc(pathName(pathInputs, "data_SingleElectron_Run2012D_22Jan2013_v1.lumicalc.sum"));
  float LFVggLumi =  getLumiCalc(pathName(pathInputs, "ggHiggsToETau.lumicalc.sum"));
//  std::cout<<"aaaaaaaaaaaaaaaaaa"<<T_tZ2starLumi<<std::endl;
//  hLFV->SetLineColor(kBlack);
//  hLFV->SetLineWidth(2);
  hLFVvbf ->SetLineColor(5);
  hLFVvbf->SetFillColor(5); 
  hLFVvbf->Scale(0.1*DataLumi/LFVvbfLumi);
  hW1Jets->SetLineColor(31);
  hW1Jets->SetFillColor(31);        
  hW1Jets->Scale(DataLumi/W1JetsLumi);   
  hW2Jets->SetLineColor(31);
  hW2Jets->SetFillColor(31);        
  hW2Jets->Scale(DataLumi/W2JetsLumi);          
  hW3Jets->SetLineColor(31);
  hW3Jets->SetFillColor(31);        
  hW3Jets->Scale(DataLumi/W3JetsLumi );         
  hW4Jets->SetLineColor(31);
  hW4Jets->SetFillColor(31);        
  hW4Jets->Scale(DataLumi/W4JetsLumi);  
  hGGHTT->SetLineColor(7);       
  hGGHTT->SetFillColor(7); 
  hGGHTT->Scale(DataLumi/GGHTTLumi);                               
  hTTJetsFLMGD->SetLineColor(6);
  hTTJetsFLMGD->SetFillColor(6);        
  hTTJetsFLMGD->Scale(DataLumi/TTJetsFLMGDLumi); 
  hTTJetsSLMGD->SetLineColor(6);
  hTTJetsSLMGD->SetFillColor(6);        
  hTTJetsSLMGD->Scale(DataLumi/TTJetsSLMGDLumi);
  hT_tZ2star->SetLineColor(31);
  hT_tZ2star->SetFillColor(31);
  hT_tZ2star->Scale(DataLumi/T_tZ2starLumi);   
  hT_twZ2star->SetLineColor(31);         
  hT_twZ2star->SetFillColor(31); 
  hT_twZ2star->Scale(DataLumi/T_twZ2starLumi);   
  hTbar_tZ2star->SetLineColor(31);
  hTbar_tZ2star->SetFillColor(31);      
  hTbar_tZ2star->Scale(DataLumi/Tbar_tZ2starLumi);  
  hTbar_twZ2star->SetLineColor(31);
  hTbar_twZ2star->SetFillColor(31);  
  hTbar_twZ2star->Scale(DataLumi/Tbar_tw2starLumi);  
  hWWJets->SetLineColor(8);
  hWWJets->SetFillColor(8);  
  hWWJets->Scale(DataLumi/WWJetsLumi);              
  hWZJets->SetLineColor(8);
  hWZJets->SetFillColor(8);  
  hWZJets->Scale(DataLumi/WZJetsLumi);   
  hZ0jetsTT->SetLineColor(6);         
  hZ0jetsTT->SetFillColor(6); 
  hZ0jetsTT->Scale(DataLumi/Z0JetsTTLumi);        
  hZ1jetsTT->SetLineColor(6);         
  hZ1jetsTT->SetFillColor(6); 
  hZ1jetsTT->Scale(DataLumi/Z1JetsTTLumi);       
  hZ2jetsTT->SetLineColor(6);         
  hZ2jetsTT->SetFillColor(6); 
  hZ2jetsTT->Scale(DataLumi/Z2JetsTTLumi);      
  hZ3jetsTT->SetLineColor(6);         
  hZ3jetsTT->SetFillColor(6); 
  hZ3jetsTT->Scale(DataLumi/Z3JetsTTLumi);     
  hZ4jetsTT->SetLineColor(6);         
  hZ4jetsTT->SetFillColor(6); 
  hZ4jetsTT->Scale(DataLumi/Z4JetsTTLumi);    
  hZ0jetsLL->SetLineColor(4);         
  hZ0jetsLL->SetFillColor(4); 
  hZ0jetsLL->Scale(DataLumi/Z0JetsLLLumi);        
  hZ1jetsLL->SetLineColor(4);         
  hZ1jetsLL->SetFillColor(4); 
  hZ1jetsLL->Scale(DataLumi/Z1JetsLLLumi);       
  hZ2jetsLL->SetLineColor(4);         
  hZ2jetsLL->SetFillColor(4); 
  hZ2jetsLL->Scale(DataLumi/Z2JetsLLLumi);      
  hZ3jetsLL->SetLineColor(4);         
  hZ3jetsLL->SetFillColor(4); 
  hZ3jetsLL->Scale(DataLumi/Z3JetsLLLumi);     
  hZ4jetsLL->SetLineColor(4);         
  hZ4jetsLL->SetFillColor(4); 
  hZ4jetsLL->Scale(DataLumi/Z4JetsLLLumi);    
  hZZjets->SetLineColor(6);         
  hZZjets->SetFillColor(6); 
  hZZjets->Scale(DataLumi/ZZJetsLumi);   
//  hZetauA->SetLineColor(4);         
//  hZetauA->SetFillColor(4); 
//  hZetauA->Scale(DataLumi/ZetauLumiA);       
//  hZetauB->SetLineColor(4);         
//  hZetauB->SetFillColor(4); 
//  hZetauB->Scale(DataLumi/ZetauLumiB);      
//  hZetauC->SetLineColor(4);         
//  hZetauC->SetFillColor(4); 
//  hZetauC->Scale(DataLumi/ZetauLumiC);     
//  hZetauD->SetLineColor(4);         
//  hZetauD->SetFillColor(4); 
//  hZetauD->Scale(DataLumi/ZetauLumiD);  
  hLFVgg->SetLineColor(2); 
  hLFVgg-> SetFillColor(2); 
  hLFVgg->Scale(0.1*DataLumi/LFVggLumi);     

  THStack *histos = new THStack("name2"," label");
  histos->Add(hW1Jets);
  histos->Add(hW2Jets);
  histos->Add(hW3Jets);
  histos->Add(hW4Jets);
  histos->Add(hGGHTT);
  histos->Add(hTTJetsFLMGD);
  histos->Add(hTTJetsSLMGD);
  histos->Add(hT_tZ2star);
  histos->Add(hT_twZ2star);
  histos->Add(hTbar_tZ2star);
  histos->Add(hTbar_twZ2star);
  histos->Add(hWWJets);
  histos->Add(hWZJets);
  histos->Add(hZ0jetsTT);
  histos->Add(hZ1jetsTT);
  histos->Add(hZ2jetsTT);
  histos->Add(hZ3jetsTT);
  histos->Add(hZ3jetsTT);
  histos->Add(hZ4jetsTT);
  histos->Add(hZ0jetsLL);
  histos->Add(hZ1jetsLL);
  histos->Add(hZ2jetsLL);
  histos->Add(hZ3jetsLL);
  histos->Add(hZ3jetsLL);
  histos->Add(hZ4jetsLL);
  histos->Add(hZZjets);
//  histos->Add(hZetauA);
//  histos->Add(hZetauB);
//  histos->Add(hZetauC);
//  histos->Add(hZetauD);






 THStack *histos1 = new THStack("name1"," label1");
  histos1->Add(hLFVgg);
  histos1->Add(hLFVvbf);
//  histos->Add(hLFVvbf);
  histos->SetMaximum(1.1*histos->GetMaximum());
  if(hLFVgg->GetMaximum() > histos->GetMaximum()){histos->SetMaximum(1.1*hLFVgg->GetMaximum());}

  //histos->GetStack()->Last()->Draw();
  //histos->Draw("hist");

//  hZetauD->Draw("SAME");
//  histos1->Draw("hist same");
//  hGGHTT->Draw("hist same");



//  hW1Jets->SetLineColor(46);
//  hW1Jets->SetFillColor(46);
// jet0panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('deltaPhicut',1,1,10,35),('tMtToPFMETcut',1,1,0,160)]
// jet1panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('tMtToPFMETcut',1,1,0,160)]
// jet2panel=[('tPtcut',1,1,30,80),('ePtcut',1,1,30,80),('tMtToPFMETcut',1,1,0,160),('vbfMasscut',1,4,0,800),('vbfDetacut',1,1,10,80)]
  int binnumb,rang1,rang2;
  float xvalue,yvalue,errorvalue;
  float signal, background,errorbstep1,errorbstep2,errorsstep1,,errorstep1,error;
  float ymax=0,xmax=0;
  //jet0bin(100,100,35,200); 
  if(variable=="tPtcut")
    {
       binnumb=100;
       rang1=25;
       rang2=75;
    }
  if(variable=="ePtcut")
    {
       binnumb=100;
       rang1=25;
       rang2=75;
    }
  if(variable=="deltaPhicut")
    {   
       binnumb=35;
       rang1=1.5;
       rang2=4;
    }
  if(variable=="tMtToPFMETcut")
    {
       binnumb=200;
       rang1=15;
       rang2=85;
    }
  if(variable=="vbfMasscut")
    {
       binnumb=200;
       rang1=250;
       rang2=750;
    }
  if(variable=="vbfDetacut")
    {
       binnumb=70;
       rang1=1.5;
       rang2=6.5;
    }
  if((variable=="h_collmass_pfmet") || (variable=="h_collmass_pfmet_Ty1") ||(variable=="h_vismass"))
       binnumb=320;
  const int binnumb1=binnumb;
  float x[binnumb1],y[binnumb1],yerr[binnumb1];
  for(int i=0;i<binnumb1;i++)
   {
       x[i]=0;
       y[i]=0;
       yerr[i]=0;



   }
//  for(int i=0;i<=binnumb;i++)
  for(int i=0;i<=binnumb;i++)
     {
         signal= hLFVvbf->GetBinContent(i)+hLFVgg->GetBinContent(i);
         background=((TH1*)(histos->GetStack()->Last()))->GetBinContent(i);
//         background=hW1Jets->GetBinContent(i)+hW2Jets->GetBinContent(i)+hW3Jets->GetBinContent(i)+hW4Jets->GetBinContent(i)+hGGHTT->GetBinContent(i)+hTTJetsFLMGD->GetBinContent(i)+hTTJetsSLMGD->GetBinContent(i)+hT_tZ2star->GetBinContent(i)+hT_twZ2star->GetBinContent(i)+ hTbar_tZ2star->GetBinContent(i)+hTbar_twZ2star->GetBinContent(i)+hWWJets->GetBinContent(i)+hWZJets->GetBinContent(i)+ hZ0jetsLL->GetBinContent(i)+ hZ1jetsLL->GetBinContent(i)+hZ2jetsLL->GetBinContent(i)+hZ3jetsLL->GetBinContent(i)+hZ4jetsLL->GetBinContent(i)+Z0jetsTT->GetBinContent(i)+ hZ1jetsTT->GetBinContent(i)+hZ2jetsTT->GetBinContent(i)+hZ3jetsTT->GetBinContent(i)+hZ4jetsTT->GetBinContent(i)+hZZjets->GetBinContent(i)+hZetauA->GetBinContent(i)+hZetauB->GetBinContent(i)+hZetauC->GetBinContent(i)+hZetauD->GetBinContent(i);
         errorbstep1=std::pow(hW1Jets->GetBinError(i)+hW2Jets->GetBinError(i)+hW3Jets->GetBinError(i)+hW4Jets->GetBinError(i)+hGGHTT->GetBinError(i)+hTTJetsFLMGD->GetBinError(i)+hTTJetsSLMGD->GetBinError(i)+hT_tZ2star->GetBinError(i)+hT_twZ2star->GetBinError(i)+ hTbar_tZ2star->GetBinError(i)+hTbar_twZ2star->GetBinError(i)+hWWJets->GetBinError(i)+hWZJets->GetBinError(i)+ hZ0jetsLL->GetBinError(i)+ hZ1jetsLL->GetBinError(i)+hZ2jetsLL->GetBinError(i)+hZ3jetsLL->GetBinError(i)+hZ4jetsLL->GetBinError(i)+hZ0jetsTT->GetBinError(i)+ hZ1jetsTT->GetBinError(i)+hZ2jetsTT->GetBinError(i)+hZ3jetsTT->GetBinError(i)+hZ4jetsTT->GetBinError(i)+hZZjets->GetBinError(i),2);
         errorbstep2=std::pow(hW1Jets->GetBinError(i),2)+std::pow(hW2Jets->GetBinError(i),2)+std::pow(hW3Jets->GetBinError(i),2)+std::pow(hW4Jets->GetBinError(i),2)+std::pow(hGGHTT->GetBinError(i),2)+std::pow(hTTJetsFLMGD->GetBinError(i),2)+std::pow(hTTJetsSLMGD->GetBinError(i),2)+std::pow(hT_tZ2star->GetBinError(i),2)+std::pow(hT_twZ2star->GetBinError(i),2)+ std::pow(hTbar_tZ2star->GetBinError(i),2)+std::pow(hTbar_twZ2star->GetBinError(i),2)+std::pow(hWWJets->GetBinError(i),2)+std::pow(hWZJets->GetBinError(i),2)+ std::pow(hZ0jetsLL->GetBinError(i),2)+ std::pow(hZ1jetsLL->GetBinError(i),2)+std::pow(hZ2jetsLL->GetBinError(i),2)+std::pow(hZ3jetsLL->GetBinError(i),2)+std::pow(hZ4jetsLL->GetBinError(i),2)+std::pow(hZ0jetsTT->GetBinError(i),2)+std::pow(hZ1jetsTT->GetBinError(i),2)+std::pow(hZ2jetsTT->GetBinError(i),2)+std::pow(hZ3jetsTT->GetBinError(i),2)+std::pow(hZ4jetsTT->GetBinError(i),2)+std::pow(hZZjets->GetBinError(i),2);
         errorsstep1=std::pow(hLFVgg->GetBinError(i)+hLFVvbf->GetBinError(i),2);
         errorstep1=errorsstep1/(std::pow(errorbstep1,2));
         error=sqrt(std::pow(hLFVgg->GetBinError(i),2)/errorbstep1+std::pow(hLFVvbf->GetBinError(i),2)/errorbstep1+errorstep1*errorbstep2);        
       
     //   std::cout<<signal<<"back" <<background<<std::endl;
         if (background==0)
            continue;
         xvalue=i-1;
         if(variable=="deltaPhicut")
                xvalue=(i-1)/10.0;
         if (variable=="vbfMasscut")
                xvalue=(i-1)*4;
         if(variable=="vbfDetacut")
                xvalue=(i-1)/10.0;
         yvalue=signal/sqrt((background+signal));
 //        if (yvalue>500)
 //           continue;
    //     if (yvalue==0)
    //        continue;
         if(yvalue>ymax)
           {
               ymax=yvalue;
               xmax=xvalue;
               errorvalue=error;
           }
 //        std::cout<<xvalue<<"             "<<yvalue<<"         "<<error<<std::endl;
         x[i]=xvalue;
         y[i]=yvalue;
         yerr[i]=error; 
     }
   TCanvas *c2 = new TCanvas("c2","canvas");
   c2->cd();
   c2->SetGrid(); 
   TGraphErrors *gSB = new TGraphErrors(binnumb1, x,y, 0,yerr);
//   TGraphErrors *gSB = new TGraphErrors(binnumb, &x[0], &y[0],0,&yerr[0]);
   gSB->SetMarkerColor(1);
   gSB->SetMarkerStyle(7);
   gSB->SetMarkerSize(0.9);
 //  gSB->SetMinimum(rang1); 
 //  gSB->SetMaximum(rang2);
   TAxis *axis = gSB->GetXaxis();
   axis->SetLimits(rang1,rang2);  
//   axis->SetLimits(1.5,3.5);  
   gSB->GetYaxis()->SetTitle("S/sqrt(S+B)");
   gSB->GetXaxis()->SetTitle(variable);
//   gSB->GetXaxis()->SetTitle("tPtcut(GeV)");
   gSB->SetTitle("2 jets"); 
   gSB->Draw("AP");
 //  gSB->Draw();
   char  ss1[100];
   sprintf(ss1,"plots/round1/2jets/%s.png",variable);
   std::cout<<"largest point at for"<<path<<"  cut "<<variable<<"  x=  "<<xmax<<"    y=  "<<ymax<<"    error=   "<<errorvalue<<std::endl;
   c2->Print(ss1);
//   TLatex T1;
//   T1.SetTextSize(.04014599);
//   T1.SetNDC();
//   T1.DrawLatex(0.45,0.95,"CMS Simulation Preliminary");
 //  c2->Clear();
//void formatHisto1(int logY, const char* legendTitle, string * legendNames, const char* xTitle, float xMin, float xMax, const char* yTitle, int *colors, TGraph** hist, const int nPoints, const char* filename,const char* direct);
//formatHisto(0,legname,legendname," #R9 of photons",0,1,"efficiency/rejection", colors,&r9EBsleHist[0],2,"r9EBsleplot2.png",dirctoryname);
//   int colors[nEta] = {1,2,4,5,6,8};
//   formatHisto(0,"legname","legendname"," #R9 of photons",0,1,"efficiency/rejection", colors,&gSB,2,"r9EBsleplot2.png",plots/newNtuple_10Oct/LFVHETauAnalyzerMVA);


}
void overlay(TString path, int rebin, TString name1, TString name2, TString label,
             TFile* fileLFV, TFile* fileW1Jets, TFile* fileW2Jets, TFile* fileW3Jets, TFile* fileW4Jets, TFile* fileW1JetsExt, TFile* fileW2JetsExt, TFile* fileW3JetsExt, TFile* fileDY1Jets, TFile* fileDY2Jets, TFile* fileDY3Jets, TFile* fileDY4Jets, TFile* fileZJets, TFile* fileTTJetsFull, TFile* fileTTJetsSemi,
             float LFVLumi,  float W1JetsLumi,  float W2JetsLumi,  float W3JetsLumi,  float W4JetsLumi,  float W1JetsExtLumi,  float W2JetsExtLumi,  float W3JetsExtLumi,  float DY1JetsLumi,  float DY2JetsLumi,  float DY3JetsLumi,  float DY4JetsLumi,  float ZJetsLumi,  float TTJetsFullLumi,  float TTJetsSemiLumi, float DataLumi){

  bool isAngle = 0;
  bool isEta = 0;
  bool isVbfMass = 0;

  //  bool isBR1 = 1;
  
  //TH1F *hData = (TH1F*) fileData->Get(path);
  TH1F *hLFV = (TH1F*) fileLFV->Get(path);
  TH1F *hW1Jets = (TH1F*) fileW1Jets->Get(path);
  TH1F *hW2Jets = (TH1F*) fileW2Jets->Get(path);
  TH1F *hW3Jets = (TH1F*) fileW3Jets->Get(path);
  TH1F *hW4Jets = (TH1F*) fileW4Jets->Get(path);
  TH1F *hW1JetsExt = (TH1F*) fileW1JetsExt->Get(path);
  TH1F *hW2JetsExt = (TH1F*) fileW2JetsExt->Get(path);
  TH1F *hW3JetsExt = (TH1F*) fileW3JetsExt->Get(path);
  TH1F *hDY1Jets = (TH1F*) fileDY1Jets->Get(path);
  TH1F *hDY2Jets = (TH1F*) fileDY2Jets->Get(path);
  TH1F *hDY3Jets = (TH1F*) fileDY3Jets->Get(path);
  TH1F *hDY4Jets = (TH1F*) fileDY4Jets->Get(path);
  TH1F *hZJets = (TH1F*) fileZJets->Get(path);
  TH1F *hTTJetsFull = (TH1F*) fileTTJetsFull->Get(path);
  TH1F *hTTJetsSemi = (TH1F*) fileTTJetsSemi->Get(path);  
  //  TH1F *hSM = (TH1F*) fileSM->Get(path);

  ## needs updating
  if (rebin != 0 ){
    //hData->Rebin(rebin);
    hLFV->Rebin(rebin);
    hW1Jets->Rebin(rebin);
    hW2Jets->Rebin(rebin);
    hW3Jets->Rebin(rebin);
    hW4Jets->Rebin(rebin);
    hZJets->Rebin(rebin);
    hTTJetsFull->Rebin(rebin);
    hTTJetsSemi->Rebin(rebin);
    //hSM->Rebin(rebin);
  }
  
  /*      
  if(path=="gg/m_t_Mass"){
    for(int i=5; i<=7; i++){
      hData->SetBinContent(i, 0);
      hData->SetBinError(i, 0);
    }
  }
  */

  //Int_t Nbins = 1;
  
  TCanvas *c1 = new TCanvas("c1","canvas");
  THStack *histos = new THStack(name2, label);
  c1->cd();

  //hData->SetMarkerStyle(21);
  //hData->SetMarkerSize(1);  
  
  hLFV->SetLineColor(kBlack);
  hLFV->SetLineWidth(2);
  hLFV->Scale(0.1*DataLumi/LFVLumi);
  //else{hLFV->Scale(DataLumi/LFVLumi);}
  
  
  hTTJetsFull->SetFillColor(31);
  hTTJetsFull->Scale(DataLumi/TTJetsFullLumi);
  histos->Add(hTTJetsFull);
  //  Nbins = hTTJets->GetNbinsX();

  hTTJetsSemi->SetFillColor(31);
  hTTJetsSemi->Scale(DataLumi/TTJetsSemiLumi);
  histos->Add(hTTJetsSemi);
  
  hZJets->SetFillColor(8);
  hZJets->Scale(DataLumi/ZJetsLumi); 
  histos->Add(hZJets);

  hDY1Jets->SetLineColor(8);
  hDY1Jets->SetFillColor(8);
  hDY1Jets->Scale(DataLumi/DY1JetsLumi);
  histos->Add(hDY1Jets);

  hDY2Jets->SetLineColor(8);
  hDY2Jets->SetFillColor(8);
  hDY2Jets->Scale(DataLumi/DY2JetsLumi);
  histos->Add(hDY2Jets);

  hDY3Jets->SetLineColor(8);
  hDY3Jets->SetFillColor(8);
  hDY3Jets->Scale(DataLumi/DY3JetsLumi);
  histos->Add(hDY3Jets);

  hDY4Jets->SetLineColor(8);
  hDY4Jets->SetFillColor(8);
  hDY4Jets->Scale(DataLumi/DY4JetsLumi);
  histos->Add(hDY4Jets);
  
  hW1Jets->SetLineColor(46);
  hW1Jets->SetFillColor(46);
  hW1Jets->Scale(DataLumi/W1JetsLumi);
  histos->Add(hW1Jets);
  
  hW2Jets->SetLineWidth(0);
  hW2Jets->SetLineColor(46);
  hW2Jets->SetFillColor(46);
  hW2Jets->Scale(DataLumi/W2JetsLumi);
  histos->Add(hW2Jets);
  
  hW3Jets->SetLineWidth(0);
  hW3Jets->SetLineColor(46);
  hW3Jets->SetFillColor(46);
  hW3Jets->Scale(DataLumi/W3JetsLumi);
  histos->Add(hW3Jets);
  
  hW4Jets->SetLineWidth(0);
  hW4Jets->SetLineColor(46);
  hW4Jets->SetFillColor(46);
  hW4Jets->Scale(DataLumi/W4JetsLumi);
  histos->Add(hW4Jets);

  hW1JetsExt->SetLineColor(46);
  hW1JetsExt->SetFillColor(46);
  hW1JetsExt->Scale(DataLumi/W1JetsExtLumi);
  histos->Add(hW1JetsExt);
  
  hW2JetsExt->SetLineWidth(0);
  hW2JetsExt->SetLineColor(46);
  hW2JetsExt->SetFillColor(46);
  hW2JetsExt->Scale(DataLumi/W2JetsExtLumi);
  histos->Add(hW2JetsExt);
  
  hW3JetsExt->SetLineWidth(0);
  hW3JetsExt->SetLineColor(46);
  hW3JetsExt->SetFillColor(46);
  hW3JetsExt->Scale(DataLumi/W3JetsExtLumi);
  histos->Add(hW3JetsExt);

  
  /*
  hSM->SetLineColor(kBlue);
  hSM->SetLineWidth(2);
  hSM->Scale(DataLumi/SMLumi);
  */
  
  /* SM VBF
  hSMvbf->SetLineColor(kViolet);
  hSMvbf->SetLineWidth(2);
  hSMvbf->Scale(1.58*dataLumi*0.063/998836);
  */

  histos->SetMaximum(1.1*histos->GetMaximum());
  if(hLFV->GetMaximum() > histos->GetMaximum()){histos->SetMaximum(1.1*hLFV->GetMaximum());}
  
 // histos->Draw("hist");
//  hLFV->Draw("hist same");
  //  hData->Draw("e1 x0 same");
 
  /*
  //  legend = new TLegend(0.15,0.68,0.30,0.88);
  legend = new TLegend(0.70,0.68,0.85,0.88);
  legend->AddEntry(hData, "data");
  legend->AddEntry(hLFV, "LFV");
  //  legend->AddEntry(hSM, "SM");
  legend->AddEntry(hW1Jets, "WJets");
  legend->AddEntry(hZJets, "ZJets");
  legend->AddEntry(hTTJets, "TTJets");
  legend->Draw("SAME P");
  */
  c1->SaveAs(name1 + ".png");
  
  if (isAngle){
    int num = 34;
    float step = 1;
    float start = 1;  
  }
  else if(isEta){
    int num = 49;
    float step = 1;
    float start = 1;
  }
  else if(isVbfMass){
    int num = 19;
    float step = 1;
    float start = 1;
  }
  else{
    int num = 99;
    float step = 1;
    float start = 1;
  }
  

  
  int bin;
  float Sig;
  float Bkg;
  float SerrSqr;
  float BerrSqr;
  float xtemp;
  float ytemp;
  float yerrtemp;
  float ytemp_old;
  float yerrtemp_old;
  float ytemp_10;
  float yerrtemp_10;
  float xmax = 0;
  float ymax = 0;
  double xCurrent, yCurrent;
  vector<float> x;
  vector<float> y;
  vector<float> yerr;
  vector<float> y_old;
  vector<float> yerr_old;
  vector<float> y_10;
  vector<float> yerr_10;
  
  for (int i=0; i<num; i++){
    bin = (start+1+i*step);
    Sig = hLFV->GetBinContent(bin);
    //    if(isBR1){Sig = Sig*0.1;}
     
    //    if (Sig==0){bin = bin-1;Sig = hLFV->GetBinContent(bin);}
    Bkg = ((TH1*)(histos->GetStack()->Last()))->GetBinContent(bin);
    if (Bkg ==0){Bkg = 0.01;}
    SerrSqr = std::pow(hLFV->GetBinError(bin),2);
    BerrSqr = std::pow(hTTJetsFull->GetBinError(bin),2)
      +std::pow(hTTJetsSemi->GetBinError(bin),2)
      +std::pow(hZJets->GetBinError(bin),2)
      +std::pow(hDY1Jets->GetBinError(bin),2)
      +std::pow(hDY2Jets->GetBinError(bin),2)
      +std::pow(hDY3Jets->GetBinError(bin),2)
      +std::pow(hDY4Jets->GetBinError(bin),2)
      +std::pow(hW1Jets->GetBinError(bin),2)
      +std::pow(hW2Jets->GetBinError(bin),2)
      +std::pow(hW3Jets->GetBinError(bin),2)
      +std::pow(hW4Jets->GetBinError(bin),2);

    if(isAngle || isEta){xtemp = (bin)/10.0;}
    elseif(isVbfMass){xtemp = (bin-1)*50;}
    else{xtemp = (bin-1)/1.0;}

    ytemp_old = 10*Sig/sqrt(Bkg);
    yerrtemp_old = sqrt(SerrSqr/Bkg + std::pow(10*Sig,2)*BerrSqr/(4*std::pow(Bkg,3)));                
    ytemp_10 = 10*Sig/sqrt(10*Sig+Bkg);
    yerrtemp_10 = sqrt(SerrSqr*std::pow(10*Sig+2*Bkg,2)/(4*std::pow(10*Sig+Bkg,3)) + BerrSqr*std::pow(10*Sig,2)/(4*std::pow(10*Sig+Bkg,3)));
    ytemp = Sig/sqrt(Sig+Bkg);
    yerrtemp = sqrt(SerrSqr*std::pow(Sig+2*Bkg,2)/(4*std::pow(Sig+Bkg,3)) + BerrSqr*std::pow(Sig,2)/(4*std::pow(Sig+Bkg,3)));
    
    cout << "xtemp: " << xtemp << "   ytemp: " << ytemp <<  "   Bkg:  " << Bkg << "    Sig: " << Sig << "    ytemp_old: " << ytemp_old << "     ytemp_10: " << ytemp_10 << endl;
    
    if(ytemp>ymax){
      ymax = ytemp;
      xmax = xtemp;
    }
    x.push_back(xtemp);
    y.push_back(ytemp);
    yerr.push_back(yerrtemp);
    y_old.push_back(ytemp_old);
    yerr_old.push_back(yerrtemp_old);
    y_10.push_back(ytemp_10);
    yerr_10.push_back(yerrtemp_10);
  }

  /*
  TGraphErrors *gSB = new TGraphErrors(num, &x[0], &y[0], 0, &yerr[0]);
  gSB->SetTitle(name2);
  TCanvas *c2 = new TCanvas("c2","canvas");
  c2->cd();
  gSB->Draw("A*");
  //  gSB->GetPoint(9, xCurrent, yCurrent);
  //cout << "current value: " << yCurrent << "    at cut: " << xCurrent << endl;
  cout << "peak value: " << ymax << "    at cut: " << xmax << endl;
  c2->SaveAs(name2+".png");

  TGraphErrors *gSB_old = new TGraphErrors(num, &x[0], &y_old[0], 0, &yerr_old[0]);
  TCanvas *c3 = new TCanvas("c3","canvas_old");
  c3->cd();
  gSB_old->Draw("A*");
  c3->SaveAs(name2+"_old.png");
  
  TGraphErrors *gSB_10 = new TGraphErrors(num, &x[0], &y_10[0], 0, &yerr_10[0]);
  TCanvas *c4 = new TCanvas("c4","canvas_BR10");
  c4->cd();
  gSB_10->Draw("A*");
  c4->SaveAs(name2+"_10.png");
  */
  
}


float getLumiCalc (TString lumiFile) {

  ifstream file (lumiFile);

  string line;
  float lumi = 0;

  getline(file, line);

  istringstream(line) >> lumi;

  //  cout << "lumi for: " << lumiFile << " is: " << lumi << endl;
  return lumi;
}

TString pathName(TString path, TString name){
  TString combined(path);
  combined+=name;
  return combined;
}

TString pathName(TString path, TString name, TString ending){
  TString combined(path);
  combined+=name;
  combined+=ending;
  return combined;
}
