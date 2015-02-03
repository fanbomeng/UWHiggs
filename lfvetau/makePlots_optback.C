#include <cmath>

void makePlots_opt(){

  TString pathResults1 = "results/MuTauSingleMuJetReRecoSkimTotal2/AnalyzeMuTauTight_opt_VBF/";
  //TString pathResults2 = "results/MuTauSingleMuJetReRecoSkimTotal2/AnalyzeMuTauTight_opt_GG1Jet_noPU/";
  TString pathInputs =   "inputs/MuTauSingleMuJetReReco_bu/";
  
  //TFile *fLFVgg =  new TFile(pathName(pathResults1, "LFV_GG_H2MuTau_ntuples.root"));
  TFile *fLFVvbf = new TFile(pathName(pathResults1, "LFV_VBF_H2MuTau_ntuples.root"));
  TFile *fW1Jets = new TFile(pathName(pathResults1, "Wplus1Jets_madgraph.root"));
  TFile *fW2Jets = new TFile(pathName(pathResults1, "Wplus2Jets_madgraph.root"));
  TFile *fW3Jets = new TFile(pathName(pathResults1, "Wplus3Jets_madgraph.root"));
  TFile *fW4Jets = new TFile(pathName(pathResults1, "Wplus4Jets_madgraph.root"));
  
  TFile *fW1JetsExt = new TFile(pathName(pathResults1, "Wplus1Jets_madgraph_extension.root"));
  TFile *fW2JetsExt = new TFile(pathName(pathResults1, "Wplus2Jets_madgraph_extension.root"));
  TFile *fW3JetsExt = new TFile(pathName(pathResults1, "Wplus3Jets_madgraph_extension.root"));
   
  TFile *fZJets =  new TFile(pathName(pathResults1, "Zjets_M50.root"));
  TFile *fDY1Jets = new TFile(pathName(pathResults1, "DY1Jets_madgraph.root"));
  TFile *fDY2Jets = new TFile(pathName(pathResults1, "DY2Jets_madgraph.root"));
  TFile *fDY3Jets = new TFile(pathName(pathResults1, "DY3Jets_madgraph.root"));
  TFile *fDY4Jets = new TFile(pathName(pathResults1, "DY4Jets_madgraph.root"));
  //  TFile *fData =   new TFile(pathName(pathResults1, "data_SingleMu_Run2012_Total.root"));
  //TFile *fSMgg =   new TFile(pathName(pathResults1, "GGH_H2Tau_M-125.root"));
  //TFile *fSMvbf =  new TFile(pathName(pathResults1, "VBF_H2Tau_M-125.root"));
  TFile *fTTJetsFull = new TFile(pathName(pathResults1, "TTJets_FullLeptMGDecays_8TeV-madgraph-tauola.root"));
  TFile *fTTJetsSemi = new TFile(pathName(pathResults1, "TTJets_SemiLeptMGDecays_8TeV-madgraph-tauola.root"));

  
  //float LFVggLumi =  getLumiCalc(pathName(pathInputs, "LFV_GG_H2MuTau_ntuples.lumicalc.sum"));
  float LFVvbfLumi = getLumiCalc(pathName(pathInputs, "LFV_VBF_H2MuTau_ntuples.lumicalc.sum"));

  float W1JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus1Jets_madgraph.lumicalc.sum"));
  float W2JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus2Jets_madgraph.lumicalc.sum"));
  float W3JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus3Jets_madgraph.lumicalc.sum"));
  float W4JetsLumi = getLumiCalc(pathName(pathInputs, "Wplus4Jets_madgraph.lumicalc.sum"));

  float W1JetsExtLumi = getLumiCalc(pathName(pathInputs, "Wplus1Jets_madgraph_extension.lumicalc.sum"));
  float W2JetsExtLumi = getLumiCalc(pathName(pathInputs, "Wplus2Jets_madgraph_extension.lumicalc.sum"));
  float W3JetsExtLumi = getLumiCalc(pathName(pathInputs, "Wplus3Jets_madgraph_extension.lumicalc.sum"));

  float DataLumiA =  getLumiCalc(pathName(pathInputs, "data_SingleMu_Run2012A_22Jan2013_v1_2.lumicalc.sum"));
  float DataLumiB =  getLumiCalc(pathName(pathInputs, "data_SingleMu_Run2012B_22Jan2013_v1_2.lumicalc.sum"));
  float DataLumiC =  getLumiCalc(pathName(pathInputs, "data_SingleMu_Run2012C_22Jan2013_v1_2.lumicalc.sum"));
  float DataLumiD =  getLumiCalc(pathName(pathInputs, "data_SingleMu_Run2012D_22Jan2013_v1.lumicalc.sum"));
  float DataLumi =   DataLumiA+DataLumiB+DataLumiC+DataLumiD;  

  float DY1JetsLumi = getLumiCalc(pathName(pathInputs, "DY1Jets_madgraph.lumicalc.sum"));
  float DY2JetsLumi = getLumiCalc(pathName(pathInputs, "DY2Jets_madgraph.lumicalc.sum"));
  float DY3JetsLumi = getLumiCalc(pathName(pathInputs, "DY3Jets_madgraph.lumicalc.sum"));
  float DY4JetsLumi = getLumiCalc(pathName(pathInputs, "DY4Jets_madgraph.lumicalc.sum"));
  float ZJetsLumi =  getLumiCalc(pathName(pathInputs, "Zjets_M50.lumicalc.sum"));
  //  float DataLumi =   getLumiCalc(pathName(pathInputs, "data_SingleMu_Run2012_Total.lumicalc.sum"));
  float SMggLumi =   getLumiCalc(pathName(pathInputs, "GGH_H2Tau_M-125.lumicalc.sum"));
  float SMvbfLumi =  getLumiCalc(pathName(pathInputs, "VBF_H2Tau_M-125.lumicalc.sum"));
  float TTJetsFullLumi = getLumiCalc(pathName(pathInputs, "TTJets_FullLeptMGDecays_8TeV-madgraph-tauola.lumicalc.sum"));
  float TTJetsSemiLumi = getLumiCalc(pathName(pathInputs, "TTJets_SemiLeptMGDecays_8TeV-madgraph-tauola.lumicalc.sum"));

  //  cout << "datalumi: " << DataLumi << endl;
  //cout << "lfvlumi:  " << LFVvbfLumi << endl;
    
  overlay("Yield/Yield_mPt", 0, "yield_mPt_2Jet1Test_re", "SoverSqrtB_2Jet1Test_mPt_re", "",
          fLFVvbf,    fW1Jets,    fW2Jets,    fW3Jets,    fW4Jets,    fW1JetsExt,    fW2JetsExt,    fW3JetsExt,    fDY1Jets,    fDY2Jets,    fDY3Jets,    fDY4Jets,    fZJets,    fTTJetsFull,    fTTJetsSemi,
          LFVvbfLumi, W1JetsLumi, W2JetsLumi, W3JetsLumi, W4JetsLumi, W1JetsExtLumi, W2JetsExtLumi, W3JetsExtLumi, DY1JetsLumi, DY2JetsLumi, DY3JetsLumi, DY4JetsLumi, ZJetsLumi, TTJetsFullLumi, TTJetsSemiLumi,  DataLumi);  
  
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
  istos->Add(hDY3Jets);

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
  
  histos->Draw("hist");
  hLFV->Draw("hist same");
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
