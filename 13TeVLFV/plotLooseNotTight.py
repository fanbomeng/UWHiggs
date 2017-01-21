import ROOT

from os import listdir
from os.path import isfile, join
mypath='WjetsCOMP/AnalyzeLFVMuTauNFNX/'
mypath1='WjetsCOMP/AnalyzeLFVMuTauOFNX/'
#datafiles = [f for f in listdir(mypath) if isfile(join(mypath, f)) and 'data' in f and '.root' in f]
datafiles = [f for f in listdir(mypath) if isfile(join(mypath, f)) and 'data.root' in f and '.root' in f]

for filename in datafiles:
    f0=ROOT.TFile.Open(mypath+filename)
    htau =f0.Get('vbf_vbfNotIso/collMass_type1')
    hmu = f0.Get('vbf_vbfNotIsoM/collMass_type1')
    hmutau = f0.Get('vbf_vbfNotIsoMT/collMass_type1')
#    htau_noW =f0.Get('vbf_vbfNotIso/collMass_unweight')
#    hmu_noW = f0.Get('vbf_vbfNotIsoM/collMass_unweight')
#    hmutau_noW = f0.Get('vbf_vbfNotIsoMT/collMass_unweight')

    htau.Rebin(25)
    hmu.Rebin(25)
    hmutau.Rebin(25)
#    htau_noW.Rebin(25)
#    hmu_noW.Rebin(25)
#    hmutau_noW.Rebin(25)



    f1=ROOT.TFile.Open(mypath1+filename)
    htau1 =f1.Get('vbf_vbfNotIso/collMass_type1')
    hmu1 = f1.Get('vbf_vbfNotIsoM/collMass_type1')
    hmutau1 = f1.Get('vbf_vbfNotIsoMT/collMass_type1')
#    htau_noW1 =f1.Get('vbf_vbfNotIso/collMass_unweight')
#    hmu_noW1 = f1.Get('vbf_vbfNotIsoM/collMass_unweight')
#    hmutau_noW1 = f1.Get('vbf_vbfNotIsoMT/collMass_unweight')

    htau1.Rebin(25)
    hmu1.Rebin(25)
    hmutau1.Rebin(25)
#    htau_noW1.Rebin(25)
#    hmu_noW1.Rebin(25)
#    hmutau_noW1.Rebin(25)
    print '======================================='
    for ibin in range(1, htau.GetXaxis().GetNbins()):
       # print '%s, m_coll= %s,  fake taus: %s, fake muon: %s, both fake: %s, total fake: %s' %(mypath+filename, str(htau.GetXaxis().GetBinCenter(ibin)),str(htau.GetBinContent(ibin)), str(hmu.GetBinContent(ibin)), str(hmutau.GetBinContent(ibin)), str(htau.GetBinContent(ibin)+hmu.GetBinContent(ibin)-hmutau.GetBinContent(ibin)))
       # print '%s, m_coll= %s,  fake taus: %s, fake muon: %s, both fake: %s, total fake: %s' %(mypath1+filename, str(htau1.GetXaxis().GetBinCenter(ibin)),str(htau1.GetBinContent(ibin)), str(hmu1.GetBinContent(ibin)), str(hmutau1.GetBinContent(ibin)), str(htau1.GetBinContent(ibin)+hmu1.GetBinContent(ibin)-hmutau1.GetBinContent(ibin)))
        print '%s, m_coll= %s,  old fakes: %s, new fake: %s, diff %s' %(filename,str(htau1.GetXaxis().GetBinCenter(ibin)), str(htau.GetBinContent(ibin)+hmu.GetBinContent(ibin)-hmutau.GetBinContent(ibin)),str(htau1.GetBinContent(ibin)+hmu1.GetBinContent(ibin)-hmutau1.GetBinContent(ibin)), str(htau1.GetBinContent(ibin)+hmu1.GetBinContent(ibin)-hmutau1.GetBinContent(ibin) -(htau.GetBinContent(ibin)+hmu.GetBinContent(ibin)-hmutau.GetBinContent(ibin))))
#        print '%s, m_coll unweight= %s,  fake taus: %s, fake muon: %s, both fake: %s, total fake: %s' %(filename, str(htau_noW.GetXaxis().GetBinCenter(ibin)),str(htau_noW.GetBinContent(ibin)), str(hmu_noW.GetBinContent(ibin)), str(hmutau_noW.GetBinContent(ibin)), str(htau_noW.GetBinContent(ibin)+hmu_noW.GetBinContent(ibin)-hmutau_noW.GetBinContent(ibin)))
        
