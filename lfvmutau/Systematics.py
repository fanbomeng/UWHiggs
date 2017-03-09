#float mass_jj=mjj;
#float number_jets=njets;
#TLorentzVector mytau;
#mytau.SetPtEtaPhiM(pt_2,eta_2,phi_2,m_2);
#TLorentzVector myele;
#myele.SetPtEtaPhiM(pt_1,eta_1,phi_1,m_1);
#TLorentzVector mymet;
#mymet.SetPtEtaPhiM(met,0,metphi,0);
import math
def TESup(mytau,mymet,mytauphi,mymetphi):
    mytau=1.006*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)-0.006*(tauex/1.006)
    mey = mymet*math.sin(mymetphi)-0.006*(tauey/1.006)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
#if (TESup){
#    mytau=1.03*mytau;
#    float mex = mymet.Px()-0.03*(mytau.Px()/1.03);
#    float mey = mymet.Py()-0.03*(mytau.Py()/1.03);
#    mymet.SetPxPyPzE(mex,mey,0,sqrt(mex*mex+mey*mey));
#}
def TESdown(mytau,mymet,mytauphi,mymetphi):
    mytau=0.994*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)+0.006*(tauex/0.994)
    mey = mymet*math.sin(mymetphi)+0.006*(tauey/0.994)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
#else if (TESdown){
#    mytau=0.97*mytau;
#    float mex = mymet.Px()+0.03*(mytau.Px()/0.97);
#    float mey = mymet.Py()+0.03*(mytau.Py()/0.97);
#    mymet.SetPxPyPzE(mex,mey,0,sqrt(mex*mex+mey*mey));
#}
def UESup(met_UESup,metphi_UESup):
    met_UESup_x=met_UESup*math.cos(metphi_UESup)
    met_UESup_y=met_UESup*math.sin(metphi_UESup)
    return (met_UESup,met_UESup_x,met_UESup_y,metphi_UESup,0,0)
def UESdown(met_UESdown,metphi_UESdown):
    met_UESdown_x=met_UESdown*math.cos(metphi_UESdown)
    met_UESdown_y=met_UESdown*math.sin(metphi_UESdown)
    return (met_UESdown,met_UESdown_x,met_UESdown_y,metphi_UESdown,0,0)
#else if (METESup){
#    mymet.SetPtEtaPhiM(met_UESUp,0,metphi_UESUp,0);
#}
#else if (METESdown){
#    mymet.SetPtEtaPhiM(met_UESDown,0,metphi_UESDown,0);
#}
#else if (JESup){
#    mass_jj=mjj_JESUp;
#    number_jets=njets_JESUp;
#    mymet.SetPtEtaPhiM(met_JESUp,0,metphi_JESUp,0);
#}
#else if (JESdown){
#    mass_jj=mjj_JESDown;
#    number_jets=njets_JESDown;
#    mymet.SetPtEtaPhiM(met_JESDown,0,metphi_JESDown,0);
#}
def MESup(mymu,mymueta,mymet,mymuphi,mymetphi):
#    if abs(mymueta)<=1.2:
    mymu=1.002*mymu
    muex=mymu*math.cos(mymuphi)
    muey=mymu*math.sin(mymuphi)
    mex = mymet*math.cos(mymetphi)-0.002*(muex/1.002)
    mey = mymet*math.sin(mymetphi)-0.002*(muey/1.002)
#    if abs(mymueta)>1.2 and abs(mymueta)<=2.1 :
#       mymu=1.009*mymu
#       muex=mymu*math.cos(mymuphi)
#       muey=mymu*math.sin(mymuphi)
#       mex = mymet*math.cos(mymetphi)-0.009*(muex/1.009)
#       mey = mymet*math.sin(mymetphi)-0.009*(muey/1.009)
#    if mymueta<-2.1 and mymueta>=-2.4 :
#       mymu=1.027*mymu
#       muex=mymu*math.cos(mymuphi)
#       muey=mymu*math.sin(mymuphi)
#       mex = mymet*math.cos(mymetphi)-0.027*(muex/1.027)
#       mey = mymet*math.sin(mymetphi)-0.027*(muey/1.027)
#    if mymueta>2.1 and mymueta<=2.4 :
#       mymu=1.017*mymu
#       muex=mymu*math.cos(mymuphi)
#       muey=mymu*math.sin(mymuphi)
#       mex = mymet*math.cos(mymetphi)-0.017*(muex/1.017)
#       mey = mymet*math.sin(mymetphi)-0.017*(muey/1.017)
    return (mymu,muex,muey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def MESdown(mymu,mymueta,mymet,mymuphi,mymetphi):
    #if abs(mymueta)<=1.2:
    mymu=0.998*mymu
    muex=mymu*math.cos(mymuphi)
    muey=mymu*math.sin(mymuphi)
    mex = mymet*math.cos(mymetphi)+0.002*(muex/0.998)
    mey = mymet*math.sin(mymetphi)+0.002*(muey/0.998)
    #if abs(mymueta)>1.2 and abs(mymueta)<=2.1 :
    #   mymu=0.991*mymu
    #   muex=mymu*math.cos(mymuphi)
    #   muey=mymu*math.sin(mymuphi)
    #   mex = mymet*math.cos(mymetphi)+0.009*(muex/0.991)
    #   mey = mymet*math.sin(mymetphi)+0.009*(muey/0.991)
    #if mymueta<-2.1 and mymueta>=-2.4 :
    #   mymu=0.973*mymu
    #   muex=mymu*math.cos(mymuphi)
    #   muey=mymu*math.sin(mymuphi)
    #   mex = mymet*math.cos(mymetphi)+0.027*(muex/0.973)
    #   mey = mymet*math.sin(mymetphi)+0.027*(muey/0.973)
    #if mymueta>2.1 and mymueta<=2.4 :
    #   mymu=0.983*mymu
    #   muex=mymu*math.cos(mymuphi)
    #   muey=mymu*math.sin(mymuphi)
    #   mex = mymet*math.cos(mymetphi)+0.017*(muex/0.983)
    #   mey = mymet*math.sin(mymetphi)+0.017*(muey/0.983)
    return (mymu,muex,muey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
#if (MESup){
#    mymu=1.01*mymu;
#    float mex = mymet.Px()-0.01*(mymu.Px()/1.01);
#    float mey = mymet.Py()-0.01*(mymu.Py()/1.01);
#    mymet.SetPxPyPzE(mex,mey,0,sqrt(mex*mex+mey*mey));
#}
#else if (MESdown){
#    mymu=0.99*mymu;
#    float mex = mymet.Px()+0.01*(mymu.Px()/0.99);
#    float mey = mymet.Py()+0.01*(mymu.Py()/0.99);
#    mymet.SetPxPyPzE(mex,mey,0,sqrt(mex*mex+mey*mey));
#}


#float collinear_mass=Get_collMass(mymet,myele,mytau);
#float mt_emet=TMass_F(myele.Pt(),myele.Px(),myele.Py(),mymet.Pt(),mymet.Phi());
#float mt_taumet=TMass_F(mytau.Pt(),mytau.Px(),mytau.Py(),mymet.Pt(),mymet.Phi());
