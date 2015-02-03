#include <math>
#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <TH2.h>
#include <TStyle.h>
#include <TCanvas.h>
#include <fstream>
#include <iostream>

void etautune()

{ 

   TString pathResults1 = "results/newNtuple_10Oct/LFVHETauAnalyzerMVA";
   TString pathInputs =   "inputs/newNtuple_10Oct/";

 //  TFile *GluGlutoHtoTauTau = new TFile("results/newNtuple_10Oct/LFVHETauAnalyzerMVA/GluGluToHToTauTau_M-125_8TeV-powheg-pythia6.root");
   TFile *GluGlutoHtoTauTau = new TFile("GluGluToHToTauTau_M-125_8TeV-powheg-pythia6.root");
   TTree *GGHTT0 = (TTree*)GluGlutoHtoTauTau->Get("os/gg/ept30/0/selected/");
   float GGHTT = getLumiCalc("inputs/newNtuple_10Oct/GluGluToHToTauTau_M-125_8TeV-powheg-pythia6.lumicalc.sum");
   float h_collmass_pfmet,ePt;
   &GGHTT0.ls()
//   GGHTT0->SetBranchAddress("ePt",&ePt);
  // GGHTT0->SetBranchAddress("h_collmass_pfmet",&h_collmass_pfmet);
 //  Long64_t nentries = GGHTT0->GetEntries();
//   t1->GetEntry(0);
 //  cout<<nentries<<"hope fine"<<endl;






}

TString pathName(TString path, TString name){
  TString combined(path);
  combined+=name;
  return combined;
}

float getLumiCalc (TString lumiFile) {

  ifstream file (lumiFile);

  string line;
  float lumi = 0;

  getline(file, line);

  istringstream(line) >> lumi;
    cout << "lumi for: " << lumiFile << " is: " << lumi << endl;
      return lumi;
   }
