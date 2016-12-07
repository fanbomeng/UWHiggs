##list of variables for plot_mutau.py
## order of parameters: xlabel, binwidth, legend, blindlow, blindhigh, include "GeV" on plot, xRangeMax, preselection binwidth
higgsMass = ("Exact M(#mu#tau_{h}) (GeV)",50,"ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')",100,145,True,300,50, "ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
collMass_type1 = ("M(#mu#tau_{h})_{col} [GeV])",20,"ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')",100,150,True,300,20, "ROOT.TLegend(0.65,0.60,0.93,0.98,' ','brNDC')")
collMass_type1MetC = ("M(#mu#tau_{h})_{col} [GeV])",20,"ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')",100,150,True,300,20, "ROOT.TLegend(0.65,0.60,0.93,0.98,' ','brNDC')")

collMass_jes_plus = ("M_{#mu#tau} coll [GeV]",50,"ROOT.TLegend(0.55,0.45,0.85,0.97,' ','brNDC')",100,200,True,500,20, "ROOT.TLegend(0.55,0.3,0.8,0.95,' ','brNDC')")

collMass_jes_minus = ("M_{#mu#tau} coll [GeV]",50,"ROOT.TLegend(0.55,0.45,0.85,0.97,' ','brNDC')",100,200,True,500,20, "ROOT.TLegend(0.55,0.3,0.8,0.95,' ','brNDC')")

collMass_type1_ues_plus = ("M_{#mu#tau} coll [GeV]",50,"ROOT.TLegend(0.55,0.45,0.85,0.97,' ','brNDC')",100,200,True,500,20, "ROOT.TLegend(0.55,0.3,0.8,0.95,' ','brNDC')")

collMass_type1_ues_minus = ("M_{#mu#tau} coll [GeV]",50,"ROOT.TLegend(0.55,0.45,0.85,0.97,' ','brNDC')",100,200,True,500,20, "ROOT.TLegend(0.55,0.3,0.8,0.95,' ','brNDC')")

mPt = ("#mu P_{T} [GeV]",2,"ROOT.TLegend(0.6,0.55,0.81,0.99,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
m3Pt = ("#mu P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.55,0.81,0.99,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
mPtavColMass = ("#mu P_{T} / ColMass",5,"ROOT.TLegend(0.6,0.55,0.81,0.99,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
m1Pt = ("#mu1 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.55,0.81,0.99,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
m2Pt = ("#mu2 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.55,0.81,0.99,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")

tPt = ("#tau P_{T} [GeV]",2,"ROOT.TLegend(0.55,0.50,0.85,0.87,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
tPtavColMass = ("#tau P_{T} / ColMass",10,"ROOT.TLegend(0.55,0.50,0.85,0.87,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")

tJetPt = ("Tau Jet P_{T}" , 10,"ROOT.TLegend(0.55,0.45,0.8,0.85,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")

mEta = ("Muon #eta",10,"ROOT.TLegend(0.13,0.6,0.33,0.9,' ','brNDC')",0,0,False,0,5,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")
#m3Eta = ("Muon #eta",20,"ROOT.TLegend(0.13,0.6,0.33,0.9,' ','brNDC')",0,0,False,0,5,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")
m3Eta = ("Muon #eta",10,"ROOT.TLegend(0.55,0.50,0.85,0.87,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
tEta = ("Tau #eta",10,"ROOT.TLegend(0.7,0.65,0.9,0.88,' ','brNDC')",-1,1,False,0,5,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")
tPhi = ("Tau #phi",10,"ROOT.TLegend(0.7,0.65,0.9,0.88,' ','brNDC')",-1,1,False,0,5,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")

#m1_m2_Mass= ("Exact M(#mu#mu) (GeV)",50,"ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')",100,145,True,300,2, "ROOT.TLegend(0.52,0.45,0.87,0.95,' ','brNDC')")
m1_m2_Mass= ("Exact M(#mu#mu) (GeV)",50,"ROOT.TLegend(0.63,0.60,0.93,0.97,' ','brNDC')",100,145,True,150,2, "ROOT.TLegend(0.62,0.45,0.97,0.95,' ','brNDC')")
mMtToPfMet_Ty1 = ("#mu,MET M_{T} [GeV]",5,"ROOT.TLegend(0.6,0.6,0.8,0.8,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.6,0.6,0.8,0.8,' ','brNDC')")

mMtToPfMet_type1 = ("#mu,MET M_{T} [GeV]",5,"ROOT.TLegend(0.6,0.6,0.8,0.8,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.55,0.6,0.93,0.93,' ','brNDC')")

tMtToPfMet_Ty1 = ("#tau,MET M_{T} Ty1 [GeV]",2,"ROOT.TLegend(0.58,0.55,0.87,0.95,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.58,0.55,0.8,0.95,' ','brNDC')")

tMtToPfMet_type1 = ("#tau,MET M_{T} Ty1 [GeV]",2,"ROOT.TLegend(0.58,0.55,0.87,0.95,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.58,0.55,0.8,0.95,' ','brNDC')")
tMtToPfMet_type1MetC = ("#tau,MET M_{T} Ty1 [GeV]",2,"ROOT.TLegend(0.58,0.55,0.87,0.95,' ','brNDC')",0,0,True,0,5,"ROOT.TLegend(0.58,0.55,0.8,0.95,' ','brNDC')")

type1_pfMetEt = ("MET E_{T}[GeV]",50,"ROOT.TLegend(0.38,0.55,0.87,0.95,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.38,0.55,0.8,0.95,' ','brNDC')")

tMtToPfMet_ues = ("#tau,MET M_{T} Ty1 [GeV]",2,"ROOT.TLegend(0.58,0.55,0.87,0.95,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.58,0.55,0.8,0.95,' ','brNDC')")

vbfDeta = ("#Delta#eta_{jj}",10,"ROOT.TLegend(0.55,0.2,0.9,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.5,0.4,0.75,0.9,' ','brNDC')")

mDPhiToPfMet_type1 = ("#Delta#phi_{m_met}",10,"ROOT.TLegend(0.75,0.2,1.1,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.5,0.4,0.75,0.9,' ','brNDC')")
tDPhiToPfMet_type1 = ("#Delta#phi_{t_met}",10,"ROOT.TLegend(0.35,0.2,0.7,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.5,0.4,0.75,0.9,' ','brNDC')")
mDPhiToPfMet_tDPhiToPfMet = ("mDPhiToPfMet",10,"ROOT.TLegend(0.35,0.2,0.7,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.7,0.8,0.95,1.1,' ','brNDC')")
mDPhiToPfMet_ggdeltaphi = ("mDPhiToPfMet",10,"ROOT.TLegend(0.35,0.2,0.7,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.7,0.8,0.95,1.1,' ','brNDC')")
tDPhiToPfMet_ggdeltaphi = ("tDPhiToPfMet",10,"ROOT.TLegend(0.35,0.2,0.7,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.7,0.8,0.95,1.1,' ','brNDC')")
vbfmass_vbfdeta= ("vbfmass_vbfdeta",10,"ROOT.TLegend(0.35,0.2,0.7,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.7,0.8,0.95,1.1,' ','brNDC')")
vbfDijetrap = ("Rapidity_{jj}",10,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')")

vbfDphihjnomet = ("#Delta#phi_{Hj} (no MET)",10,"ROOT.TLegend(0.2,0.6,0.5,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.2,0.6,0.5,0.8,' ','brNDC')")

vbfDphihj = ("#Delta#phi_{Hj}",10,"ROOT.TLegend(0.2,0.6,0.5,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.2,0.6,0.5,0.8,' ','brNDC')")

vbfHrap = ("Rapidity_{H}",10,"ROOT.TLegend(0.4,0.6,0.89,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.4,0.6,0.89,0.8,' ','brNDC')")

vbfj1eta = ("#eta_{j1}",10,"ROOT.TLegend(0.23,0.55,0.45,0.99,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.65,0.45,0.99,' ','brNDC')")

vbfj2eta = ("#eta_{j2}",10,"ROOT.TLegend(0.23,0.59,0.45,0.99,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.59,0.45,0.99,' ','brNDC')")

vbfMass = ("M_{jj} [GeV]",10,"ROOT.TLegend(0.55,0.2,0.95,0.92,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.55,0.2,0.9,0.92,' ','brNDC')")

vbfj1pt = ("j_{1}P_{T} [GeV]",10,"ROOT.TLegend(0.55,0.3,0.95,0.92,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.55,0.3,0.87,0.92,' ','brNDC')")

vbfj2pt = ("j_{2}P_{T} [GeV]",10,"ROOT.TLegend(0.55,0.3,0.95,0.92,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.55,0.3,0.95,0.92,' ','brNDC')")

m_t_Mass = ("M(#mu,#tau) [GeV]",20,"ROOT.TLegend(0.66,0.5,0.98,0.95,' ','brNDC')",60,140,True,0,5,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")

m_t_DPhi = ("Muon Tau #Delta#phi",5,"ROOT.TLegend(0.25,0.6,0.6,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.25,0.6,0.6,0.8,' ','brNDC')")

m_t_Pt = ("Visible P_{T} [GeV]",10,"ROOT.TLegend(0.45,0.5,0.85,0.8,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.45,0.5,0.85,0.8,' ','brNDC')")

m_t_DR = ("Muon Tau #DeltaR",5,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')")

m_t_ToMETDPhi_Ty1 = ("#Delta#phi (MET , MuonTau)",10,"ROOT.TLegend(0.15,0.7,0.4,0.87,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.15,0.7,0.4,0.87,' ','brNDC')")

mPhiMETPhiType1 = ("#Delta#phi (MET , #mu)",10,"ROOT.TLegend(0.60,0.4,0.81,0.87,' ','brNDC')",0,0,False,6,10,"ROOT.TLegend(0.55,0.67,0.72,0.97,' ','brNDC')")

tPhiMETPhiType1 = ("#Delta#phi (MET , #tau)",2,"ROOT.TLegend(0.60,0.4,0.81,0.87,' ','brNDC')",0,0,False,6,10,"ROOT.TLegend(0.60,0.4,0.81,0.87,' ','brNDC')")

nvtx = ("Number of Vertices", 5,"ROOT.TLegend(0.45,0.4,0.9,0.8,' ','brNDC')",0,0,False,40,1,"ROOT.TLegend(0.6,0.4,0.95,0.95,' ','brNDC')")


fullMT_type1 = ("Full M_{T} [GeV]",40,"ROOT.TLegend(0.45,0.3,0.9,0.8,' ','brNDC')",0,160,True,0,10,"ROOT.TLegend(0.45,0.3,0.9,0.8,' ','brNDC')")

fullPT_type1 = ("Full P_{T} [GeV]",20,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.45,0.6,0.8,0.8,' ','brNDC')")

jetVeto30 = ("Number of P_{T} > 30 GeV Jets",1,"ROOT.TLegend(0.55,0.6,0.87,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.55,0.5,0.95,0.95,' ','brNDC')")

jetVeto30Eta3 = ("Number of P_{T} > 30 GeV Jets, |#eta|<3",1,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')")

NumJets30 = ("Number of P_{T} > 30 GeV Jets",1,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')")

tDecayMode = ("Tau Decay Mode",1,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')",0,0,False,0,1,"ROOT.TLegend(0.65,0.65,0.95,0.95,' ','brNDC')")

tMass = ("Tau Mass",1,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.45,0.4,0.87,0.8,' ','brNDC')")

jet1Pt = ("Jet 1 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.25,0.91,0.99,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.6,0.4,0.8,0.8,' ','brNDC')")

jet2Pt = ("Jet 2 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.25,0.91,0.99,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.6,0.4,0.8,0.8,' ','brNDC')")

jet3Pt = ("Jet 3 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.25,0.91,0.99,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.6,0.4,0.8,0.8,' ','brNDC')")

jet4Pt = ("Jet 4 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.25,0.91,0.99,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.6,0.4,0.8,0.8,' ','brNDC')")

jet5Pt = ("Jet 5 P_{T} [GeV]",5,"ROOT.TLegend(0.6,0.25,0.91,0.99,' ','brNDC')",0,0,True,0,10,"ROOT.TLegend(0.6,0.4,0.8,0.8,' ','brNDC')")

jet1Eta = ("Jet 1 #eta",10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')")

jet2Eta = ("Jet 2 #eta",10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')")

jet3Eta = ("Jet 3 #eta",10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')")

jet4Eta = ("Jet 4 #eta",10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')")

jet5Eta = ("Jet 5 #eta",10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')",0,0,False,0,10,"ROOT.TLegend(0.23,0.6,0.43,0.9,' ','brNDC')")
