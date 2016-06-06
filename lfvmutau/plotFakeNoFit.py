import ROOT

_file0 = ROOT.TFile.Open("results/MiniAODSIMv2-Spring15-25ns_LFV_October13/efakerate_fits/e_os_eLoose_eTigh_ePt.corrected_inputs.root")
numerator = _file0.Get("numerator")
denominator = _file0.Get("denominator") 
canvas=ROOT.TCanvas()
pEff = ROOT.TEfficiency (numerator, denominator)
pEff.Draw()
graph =  pEff.CreateGraph()
graph.Draw('AP')
graph.GetXaxis().SetRangeUser(30, 200)
graph.GetYaxis().SetRangeUser(0, 1.2)
graph.GetXaxis().SetTitle("e p_{T} (GeV)")
graph.GetYaxis().SetTitle("fakerate")

canvas.SaveAs("fakerate_noFit.png")
