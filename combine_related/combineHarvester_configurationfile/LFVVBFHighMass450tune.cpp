#include <string>
#include <map>
#include <set>
#include <iostream>
#include <utility>
#include <vector>
#include <cstdlib>
#include "CombineHarvester/CombineTools/interface/CombineHarvester.h"
#include "CombineHarvester/CombineTools/interface/Observation.h"
#include "CombineHarvester/CombineTools/interface/Process.h"
#include "CombineHarvester/CombineTools/interface/Utilities.h"
#include "CombineHarvester/CombineTools/interface/Systematics.h"
#include "CombineHarvester/CombineTools/interface/BinByBin.h"

using namespace std;

int main(int argc, char* argv[]){

  printf ("Creating LFV MuTau_had datacards. \n ");

  string folder="lfvauxiliaries/datacards";
  string lumi="goldenJson2p11";
  //string inputFile="LFV_2p11fb_mutauhad_1Dic";
  string inputFile="LFV_2p11fb_mutauhad_1Dic_Fanbo_trial";
  string outputFile="HMuTau_mutauhad_2015_input";
  string dirInput="Maria2015Data";
  bool  binbybin=false;
  string name="def";

  if (argc > 1)
    { int count=0;
      for (count = 1; count < argc; count++)
      {
        if(strcmp(argv[count] ,"--i")==0) inputFile=argv[count+1];
        if(strcmp(argv[count] ,"--o")==0) outputFile=argv[count+1];
        if(strcmp(argv[count] ,"--l")==0) lumi=argv[count+1];
        if(strcmp(argv[count] ,"--d")==0) dirInput=argv[count+1];
        if(strcmp(argv[count] ,"--f")==0) folder=argv[count+1];
        if(strcmp(argv[count] ,"--b")==0) binbybin=true;
        if(strcmp(argv[count] ,"--name")==0) name=argv[count+1];

      }
    }


  //! [part1]
  // First define the location of the "auxiliaries" directory where we can
  // source the input files containing the datacard shapes
  string aux_shapes = string(getenv("CMSSW_BASE")) + "/src/lfvauxiliaries/shapes/";

  // Create an empty CombineHarvester instance that will hold all of the
  // datacard configuration and histograms etc.
  ch::CombineHarvester cb;
  // Uncomment this next line to see a *lot* of debug information
  // cb.SetVerbosity(3);

  // Here we will just define two categories for an 8TeV analysis. Each entry in
  // the vector below specifies a bin name and corresponding bin_id.

  ch::Categories cats = {
      {1450, "mutauh_0Jet450"},
      {2450, "mutauh_1Jet450"},
    };
/*
  ch::Categories cats = {
      {-1, "mutau"},
      {0, "mutau_gg"},
      {1, "mutau_boost"},
      {2, "mutau_vbf"},
    };
*/

  // ch::Categories is just a typedef of vector<pair<int, string>>
  //! [part1]


  //! [part2]
//  vector<string> masses = ch::MassesFromRange("125");
  // Or equivalently, specify the mass points explicitly:
  vector<string> masses = {"450"};
  //! [part2]

  //! [part3]
  cb.AddObservations({"*"}, {"HMuTau"}, {"2016"}, {name}, cats);
  //! [part3]

  //! [part4]
  vector<string> bkg_procs = {"ZTauTau", "Zothers", "Diboson", "TT","T","ggH_htt","qqH_htt","Fakes"};
  cb.AddProcesses({"*"}, {"HMuTau"}, {"2016"}, {name}, bkg_procs, cats, false);

  vector<string> sig_procs = {"LFV"};
  cb.AddProcesses(masses, {"HMuTau"}, {"2016"}, {name}, sig_procs, cats, true);
  //! [part4]

//Fakes to Fakes
//"ggH_htt","qqH_htt" to ggH_htt, qqH_htt
  //Some of the code for this is in a nested namespace, so
  // we'll make some using declarations first to simplify things a bit.
  using ch::syst::SystMap;
  using ch::syst::era;
  using ch::syst::bin_id;
  using ch::syst::process;


  //! [part5]

  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggH_htt","qqH_htt"}}))
      .AddSyst(cb, "CMS_lumi_13TeV", "lnN", SystMap<>::init(1.025));

  //cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggH_htt","qqH_htt"}}))
  //    .AddSyst(cb, "btag", "lnN", SystMap<>::init(1.03));
//  cb.cp().process({"TT",'T'})
//      .AddSyst(cb, "CMS_eff_btag", "lnN", SystMap<>::init(1.05));
////cb.cp().process({"TT","T"}).bin_id({1})
////      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.022));
////
////  cb.cp().process({"TT","T"}).bin_id({2})
////      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.048));
////
////  cb.cp().process({"TT","T"}).bin_id({3})
////      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.065));
////
////  cb.cp().process({"TT","T"}).bin_id({4})
////      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.051));

  cb.cp().process({"TT"}).bin_id({2450})
      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0245));

//  cb.cp().process({"TT"}).bin_id({3})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0437));

  //cb.cp().process({"TT"}).bin_id({4})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0259));


  cb.cp().process({"T"}).bin_id({2450})
      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0211));

//  cb.cp().process({"T"}).bin_id({3})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0307));

//  cb.cp().process({"T"}).bin_id({4})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.0198));



  cb.cp().AddSyst(cb,"acceptance_scale_gg","lnN",SystMap<process,bin_id>::init
    ({"ggH_htt"},{1450},1.02)
    ({"ggH_htt"},{2450},0.996)
//    ({"LFVGG","ggH_htt"},{3},0.97)
//    ({"LFVGG","ggH_htt"},{4},0.97)
    );

  cb.cp().AddSyst(cb,"acceptance_pdf_gg","lnN",SystMap<process,bin_id>::init
    ({"ggH_htt"},{1450},1.005)
    ({"ggH_htt"},{2450},1.005)
    //({"LFVGG","ggH_htt"},{3},0.995)
    //({"LFVGG","ggH_htt"},{4},0.995)
    );


//  cb.cp().AddSyst(cb,"acceptance_scale_vbf","lnN",SystMap<process,bin_id>::init
//    ({"LFVVBF","qqH_htt"},{1},1.01)
//    ({"LFVVBF","qqH_htt"},{2},1.006)
//    ({"LFVVBF","qqH_htt"},{3},0.999)
//    ({"LFVVBF","qqH_htt"},{4},0.999)
//    );


//  cb.cp().AddSyst(cb,"acceptance_pdf_vbf","lnN",SystMap<process,bin_id>::init
//    ({"LFVVBF","qqH_htt"},{1},1.005)
//    ({"LFVVBF","qqH_htt"},{2},0.99)
//    ({"LFVVBF","qqH_htt"},{3},0.985)
//    ({"LFVVBF","qqH_htt"},{4},0.985)
//    );

  //    Uncertainty on BR for HTT @ 125 GeV
  cb.cp().process({"ggH_htt","qqH_htt"}).AddSyst(cb,"BR_htt_THU", "lnN", SystMap<>::init(1.017));
  cb.cp().process({"ggH_htt","qqH_htt"}).AddSyst(cb,"BR_htt_PU_mq", "lnN", SystMap<>::init(1.0099));
  cb.cp().process({"ggH_htt","qqH_htt"}).AddSyst(cb,"BR_htt_PU_alphas", "lnN", SystMap<>::init(1.0062));



//  cb.cp().process({"TT"}).bin_id({2})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.026));
//
//  cb.cp().process({"TT"}).bin_id({3})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.045));
//
//  cb.cp().process({"TT"}).bin_id({4})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.02));
//
//
//  cb.cp().process({"T"}).bin_id({2})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.025));
//
//  cb.cp().process({"T"}).bin_id({3})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.032));
//
//  cb.cp().process({"T"}).bin_id({4})
//      .AddSyst(cb, "CMS_eff_btag_13TeV", "lnN", SystMap<>::init(1.021));
//

  cb.cp().process({"ggH_htt"}).AddSyst(cb,"QCDScale_ggH", "lnN", SystMap<>::init(1.039)); 
//  cb.cp().process({"LFVVBF","qqH_htt"}).AddSyst(cb,"QCDScale_qqH", "lnN", SystMap<>::init(1.004));
  cb.cp().process({"ggH_htt"}).AddSyst(cb,"pdf_Higgs_gg", "lnN", SystMap<>::init(1.032));
//  cb.cp().process({"LFVVBF","qqH_htt"}).AddSyst(cb,"pdf_Higgs_qq", "lnN", SystMap<>::init(1.021));



//  cb.cp().process({"Dibosons"})
//      .AddSyst(cb, "CMS_eff_misbtag", "lnN", SystMap<>::init(1.02));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "lumi_$ERA", "lnN", SystMap<era>::init
//      ({"2016"}, 1.12));
  //! [part5]

  //! [part6]
  cb.cp().process({"LFV"}).AddSyst(cb, "pdf_gg", "lnN", SystMap<>::init(1.1));
//  cb.cp().process({"LFVVBF","qqH_htt"})
//      .AddSyst(cb, "pdf_vbf", "lnN", SystMap<>::init(1.1));

  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggH_htt","qqH_htt"}}))
      .AddSyst(cb, "CMS_eff_m", "lnN", SystMap<>::init(1.02));   // form 1.03

  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau","TT","T","Diboson","ggH_htt","qqH_htt"}}))
      .AddSyst(cb, "CMS_eff_tau", "lnN", SystMap<>::init(1.05));

  cb.cp().process({"Fakes"})
      .AddSyst(cb, "norm_fakes_mutauh", "lnN", SystMap<>::init(1.30));

  cb.cp().process({"Fakes"})
      .AddSyst(cb,
        "norm_fakes_mutauh_uncor_$BIN", "lnN", SystMap<>::init(1.1));

  cb.cp().process({"ZTauTau"})
      .AddSyst(cb, "norm_ztt", "lnN", SystMap<>::init(1.1));

  cb.cp().process({"ZTauTau"})
      .AddSyst(cb,"norm_ztt_$BIN", "lnN", SystMap<>::init(1.05));

  cb.cp().process({"Zothers"})
      .AddSyst(cb, "norm_Zothers", "lnN", SystMap<>::init(1.25));

  cb.cp().process({"Zothers"})
      .AddSyst(cb,"norm_Zothers_$BIN", "lnN", SystMap<>::init(1.05));

  cb.cp().process({"Diboson"})
      .AddSyst(cb, "norm_Diboson", "lnN", SystMap<>::init(1.05));   //from  1.1

  cb.cp().process({"TT"})
      .AddSyst(cb, "norm_TT ", "lnN", SystMap<>::init(1.10));
      //.AddSyst(cb, "norm_tt ", "lnN", SystMap<>::init(1.1));

  cb.cp().process({"T"})
      .AddSyst(cb, "norm_T", "lnN", SystMap<>::init(1.05));//from 1.1

 cb.cp().process({"Diboson"})
      .AddSyst(cb,"norm_Diboson_$BIN", "lnN", SystMap<>::init(1.05));

 cb.cp().process({"TT"})
      .AddSyst(cb,
        "norm_TT_$BIN", "lnN", SystMap<>::init(1.05));

 cb.cp().process({"T"})
      .AddSyst(cb,"norm_T_$BIN", "lnN", SystMap<>::init(1.05));


 // cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggHTauTau","qqH_htt"}}))
 //     .AddSyst(cb, "CMS_MET_Jes","shape",SystMap<>::init(1.));

//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggHTauTau","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_Jes","lnN",SystMap<>::init(1.034));
 // cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggHTauTau","qqH_htt"}}))
 //     .AddSyst(cb, "CMS_MET_UES","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_Pileup_13TeV","shape",SystMap<>::init(1.));

//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_chargedUes_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_ecalUes_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_hcalUes_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers","T","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_hfUes_13TeV","shape",SystMap<>::init(1.));
  //cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","Diboson","ggHTauTau","qqH_htt"}}))
  //    .AddSyst(cb, "CMS_MET_UESCheck","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","Diboson","ggHTauTau","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MET_Ues","lnN",SystMap<>::init(1.024));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_scale_t_1prong_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_scale_t_1prong1pizero_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_scale_t_3prong_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau","TT","Diboson","ggH_htt","qqH_htt"}}))
//      .AddSyst(cb, "CMS_MES_13TeV","shape",SystMap<>::init(1.));
//   cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggH_htt","qqH_htt"}}))
//     .AddSyst(cb, "CMS_MET_Tes","lnN",SystMap<>::init(1.03));
//  cb.cp().process(ch::JoinStr({{"Zothers"}}))
//     .AddSyst(cb, "CMS_scale_mfaketau_1prong1pizero_13TeV","shape",SystMap<>::init(1.));
//CMS_MET_MFT to CMS_scale_efaketau_1prong1pizero_13TeV
//CMS_scale_t_1prong_13TeV
//CMS_scale_t_1prong1pizero_13TeV
//CMS_scale_t_3prong_13TeV
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm0_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm0_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm1_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm1_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm10_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm10_B_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm0_E_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm0_E_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm1_E_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm1_E_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p0_dm10_E_13TeV","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "CMS_TauFakeRate_p1_dm10_E_13TeV","shape",SystMap<>::init(1.));
//  TString JESNAMES[27]={"CMS_Jes_JetAbsoluteFlavMap_13TeV","CMS_Jes_JetAbsoluteMPFBias_13TeV","CMS_Jes_JetAbsoluteScale_13TeV", "CMS_Jes_JetAbsoluteStat_13TeV","CMS_Jes_JetFlavorQCD_13TeV", "CMS_Jes_JetFragmentation_13TeV", "CMS_Jes_JetPileUpDataMC_13TeV", "CMS_Jes_JetPileUpPtBB_13TeV", "CMS_Jes_JetPileUpPtEC1_13TeV", "CMS_Jes_JetPileUpPtEC2_13TeV","CMS_Jes_JetPileUpPtHF_13TeV","CMS_Jes_JetPileUpPtRef_13TeV","CMS_Jes_JetRelativeBal_13TeV","CMS_Jes_JetRelativeFSR_13TeV","CMS_Jes_JetRelativeJEREC1_13TeV", "CMS_Jes_JetRelativeJEREC2_13TeV","CMS_Jes_JetRelativeJERHF_13TeV","CMS_Jes_JetRelativePtBB_13TeV","CMS_Jes_JetRelativePtEC1_13TeV","CMS_Jes_JetRelativePtEC2_13TeV","CMS_Jes_JetRelativePtHF_13TeV","CMS_Jes_JetRelativeStatEC_13TeV","CMS_Jes_JetRelativeStatFSR_13TeV", "CMS_Jes_JetRelativeStatHF_13TeV","CMS_Jes_JetSinglePionECAL_13TeV", "CMS_Jes_JetSinglePionHCAL_13TeV","CMS_Jes_JetTimePtEta_13TeV"};
  
//    for (int i=0; i<27;i++){
//    cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT", "T", "ggH_htt", "qqH_htt", "Diboson"}}))
//        .AddSyst(cb, JESNAMES[i].Data(), "shape", SystMap<>::init(1.00));
//    }
  

//  cb.cp().process(ch::JoinStr({{"Fakes"}}))
//     .AddSyst(cb, "FakeShapeMuTau1st","shape",SystMap<>::init(1.));
// cb.cp().process(ch::JoinStr({{"Fakes"}}))
     //.AddSyst(cb, "FakeShapeMuTau2nd","shape",SystMap<>::init(1.));
//  cb.cp().process(ch::JoinStr({sig_procs, {"ZTauTau", "Zothers", "TT","T","Diboson","ggH_htt","qqH_htt"}}))
//     .AddSyst(cb, "CMS_MET_Btag","shape",SystMap<>::init(1.));
/*
  double ZTauTauJES[3]   ={1.016,1.041,1.252};
  double ZothersJES[3]   ={1.006,1.012,1.516};
  double TTJES[3]        ={1.115,1.091,1.045};
  double DibosonJES[3]   ={1.076,1.191,1.0};
  double ggHTauTauJES[3] ={1.017,1.009,1.042};
  double qqH_httJES[3]={1.129,1.035,1.023};
  double LFVGGJES[3]     ={1.019,1.023,1.071};
  double LFVVBFJES[3]    ={1.129,1.035,1.055};

  cb.cp().AddSyst(cb, "CMS_JES","lnN",SystMap<process,bin_id>::init 
            ({"ZTauTau"},{0},ZTauTauJES[0]) ({"ZTauTau"},{1},ZTauTauJES[1]) ({"ZTauTau"},{2},ZTauTauJES[2]) 
            ({"Zothers"},{0},ZothersJES[0]) ({"Zothers"},{1},ZothersJES[1]) ({"Zothers"},{2},ZothersJES[2]) 
            ({"TT"},{0},TTJES[0]) ({"TT"},{1},TTJES[1]) ({"TT"},{2},TTJES[2])
            ({"Diboson"},{0},DibosonJES[0]) ({"Diboson"},{1},DibosonJES[1]) ({"Diboson"},{2},DibosonJES[2])
            ({"ggHTauTau"},{0},ggHTauTauJES[0]) ({"ggHTauTau"},{1},ggHTauTauJES[1]) ({"ggHTauTau"},{2},ggHTauTauJES[2])
            ({"qqH_htt"},{0},qqH_httJES[0]) ({"qqH_htt"},{1},qqH_httJES[1]) ({"qqH_htt"},{2},qqH_httJES[2])
            ({"LFVGG"},{0},LFVGGJES[0]) ({"LFVGG"},{1},LFVGGJES[1]) ({"LFVGG"},{2},LFVGGJES[2])
            ({"LFVVBF"},{0},LFVVBFJES[0]) ({"LFVVBF"},{1},LFVVBFJES[1]) ({"LFVVBF"},{2},LFVVBFJES[2])
  );


  double ZTauTauTES[3]   ={1.049,1.021,1.209};
  double ZothersTES[3]   ={1.008,1.045,2.042};
  double TTTES[3]        ={1.300,1.312,1.307};
  double DibosonTES[3]   ={1.038,1.049,1.0};
  double ggHTauTauTES[3] ={1.766,1.712,1.681};
  double qqH_httTES[3]={1.130,1.220,1.220};
  double LFVGGTES[3]     ={1.009,1.031,1.080};
  double LFVVBFTES[3]    ={1.006,1.033,1.049};

  cb.cp().AddSyst(cb, "CMS_TES","lnN",SystMap<process,bin_id>::init 
            ({"ZTauTau"},{0},ZTauTauTES[0]) ({"ZTauTau"},{1},ZTauTauTES[1]) ({"ZTauTau"},{2},ZTauTauTES[2]) 
            ({"Zothers"},{0},ZothersTES[0]) ({"Zothers"},{1},ZothersTES[1]) ({"Zothers"},{2},ZothersTES[2]) 
            ({"TT"},{0},TTTES[0]) ({"TT"},{1},TTTES[1]) ({"TT"},{2},TTTES[2])
            ({"Diboson"},{0},DibosonTES[0]) ({"Diboson"},{1},DibosonTES[1]) ({"Diboson"},{2},DibosonTES[2])
            ({"ggHTauTau"},{0},ggHTauTauTES[0]) ({"ggHTauTau"},{1},ggHTauTauTES[1]) ({"ggHTauTau"},{2},ggHTauTauTES[2])
            ({"qqH_htt"},{0},qqH_httTES[0]) ({"qqH_htt"},{1},qqH_httTES[1]) ({"qqH_htt"},{2},qqH_httTES[2])
            ({"LFVGG"},{0},LFVGGTES[0]) ({"LFVGG"},{1},LFVGGTES[1]) ({"LFVGG"},{2},LFVGGTES[2])
            ({"LFVVBF"},{0},LFVVBFTES[0]) ({"LFVVBF"},{1},LFVVBFTES[1]) ({"LFVVBF"},{2},LFVVBFTES[2])
  );
*/

  cb.cp().backgrounds().ExtractShapes(
      aux_shapes + dirInput+"/"+inputFile+".root",
      "$BIN/$PROCESS",
      "$BIN/$PROCESS_$SYSTEMATIC");
  cb.cp().signals().ExtractShapes(
//      aux_shapes + "Maria2016Data/LFV_2p11fb_mutauhad_1Dic.root",
      aux_shapes + dirInput+"/"+inputFile+".root",
      "$BIN/$PROCESS$MASS",
      "$BIN/$PROCESS$MASS_$SYSTEMATIC");



  //! [part8]
 if(binbybin){
 auto bbb = ch::BinByBinFactory()
   .SetAddThreshold(0.1)
   .SetMergeThreshold(0.5)
   .SetFixNorm(false);
//  bbb.MergeBinErrors(cb.cp().backgrounds());
  bbb.MergeBinErrors(cb.cp().process({"Diboson","ZTauTau","Zothers","T","TT","ggH_htt","qqH_htt"}));
  bbb.AddBinByBin(cb.cp().backgrounds(), cb);
  }

  // This function modifies every entry to have a standardised bin name of
  // the form: {analysis}_{channel}_{bin_id}_{era}
  // which is commonly used in the htt analyses
  ch::SetStandardBinNames(cb);
  //! [part8]

  boost::filesystem::create_directories(folder);
  boost::filesystem::create_directories(folder + "/"+lumi);


  //! [part9]
  // First we generate a set of bin names:
  set<string> bins = cb.bin_set();
  // This method will produce a set of unique bin names by considering all
  // Observation, Process and Systematic entries in the CombineHarvester
  // instance.

  // We create the output root file that will contain all the shapes.
//  TFile output("HMuTau_mutauhad_2016.input.root", "RECREATE");

    string textbinbybin="";
    if(binbybin) textbinbybin="_bbb";

    TFile output((folder + "/"+lumi+"/"+outputFile+"_"+lumi+textbinbybin+".root").c_str(), "RECREATE");

  // Finally we iterate through each bin,mass combination and write a
  // datacard.
  for (auto b : bins) {
    for (auto m : masses) {
      cout << ">> Writing datacard for bin: " << b << " and mass: " << m
           << "\n";
      // We need to filter on both the mass and the mass hypothesis,
      // where we must remember to include the "*" mass entry to get
      // all the data and backgrounds.
      cb.cp().bin({b}).mass({m, "*"}).WriteDatacard(folder + "/"+lumi+"/"+
          b +textbinbybin+"_m" + m + "_"+lumi+".txt", output);
      
    }
  }

      //cb.cp().mass({"125", "*"}).bin({"HMuTau_mutauhad_0_2016","HMuTau_mutauhad_1_2016","HMuTau_mutauhad_2_2016","HMuTau_mutauhad_3_2016"}).WriteDatacard(folder + "/"+lumi+"/"+"HMuTau_"+name+"_mutauhad_combined_2016"+textbinbybin+"_m125_"+lumi+".txt", output);
      //
      cb.cp().mass({"200", "*"}).bin({"HMuTau"+name+"1450_2016","HMuTau"+name+"_2450_2016"}).WriteDatacard(folder + "/"+lumi+"/"+"HMuTau_"+name+"_combined_2016"+textbinbybin+"_m450_"+lumi+".txt", output);
//      cb.cp().mass({"200", "*"}).bin({"HMuTau_mutauhad_1200_2016","HMuTau_mutauhad_2200_2016"}).WriteDatacard(folder + "/"+lumi+"/"+"HMuTau_mutauhad_combined_2016"+textbinbybin+"_m200_"+lumi+".txt", output);


  //! [part9]

}
