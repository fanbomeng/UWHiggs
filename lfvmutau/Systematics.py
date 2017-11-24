import math
def TESup(mytau,mymet,mytauphi,mymetphi):
    mytau=1.012*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)-0.012*(tauex/1.012)
    mey = mymet*math.sin(mymetphi)-0.012*(tauey/1.012)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def TESdown(mytau,mymet,mytauphi,mymetphi):
    mytau=0.988*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)+0.012*(tauex/0.988)
    mey = mymet*math.sin(mymetphi)+0.012*(tauey/0.988)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def MFTup(mytau,mymet,mytauphi,mymetphi):
    mytau=1.015*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)-0.015*(tauex/1.015)
    mey = mymet*math.sin(mymetphi)-0.015*(tauey/1.015)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def MFTdown(mytau,mymet,mytauphi,mymetphi):
    mytau=0.985*mytau
    tauex=mytau*math.cos(mytauphi)
    tauey=mytau*math.sin(mytauphi)
    mex = mymet*math.cos(mymetphi)+0.015*(tauex/0.985)
    mey = mymet*math.sin(mymetphi)+0.015*(tauey/0.985)
    return (mytau,tauex,tauey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def UESup(met_UESup,metphi_UESup):
    met_UESup_x=met_UESup*math.cos(metphi_UESup)
    met_UESup_y=met_UESup*math.sin(metphi_UESup)
    return (met_UESup,met_UESup_x,met_UESup_y,metphi_UESup,0,0)
def UESdown(met_UESdown,metphi_UESdown):
    met_UESdown_x=met_UESdown*math.cos(metphi_UESdown)
    met_UESdown_y=met_UESdown*math.sin(metphi_UESdown)
    return (met_UESdown,met_UESdown_x,met_UESdown_y,metphi_UESdown,0,0)
def MESup(mymu,mymueta,mymet,mymuphi,mymetphi):
    mymu=1.002*mymu
    muex=mymu*math.cos(mymuphi)
    muey=mymu*math.sin(mymuphi)
    mex = mymet*math.cos(mymetphi)-0.002*(muex/1.002)
    mey = mymet*math.sin(mymetphi)-0.002*(muey/1.002)
    return (mymu,muex,muey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
def MESdown(mymu,mymueta,mymet,mymuphi,mymetphi):
    mymu=0.998*mymu
    muex=mymu*math.cos(mymuphi)
    muey=mymu*math.sin(mymuphi)
    mex = mymet*math.cos(mymetphi)+0.002*(muex/0.998)
    mey = mymet*math.sin(mymetphi)+0.002*(muey/0.998)
    return (mymu,muex,muey,abs(math.sqrt(mex*mex+mey*mey)),mex,mey)
