#include "root.cc"
//#include "paramshgggjets.h"
//#include "paramshgggjets.h"
#include <vector>
//#include <math.h>
void formatHisto(int logY, const char* legendTitle, string * legendNames, const char* xTitle, float xMin, float xMax, const char* yTitle, int *colors, TH1F** hist, const int nPoints, const char* filename,const char* direct);
void formatHisto(int logY, const char* legendTitle, string * legendNames, const char* xTitle, float xMin, float xMax, const char* yTitle, int *colors, TH1F** hist, const int nPoints,const char* filename,const char* direct)
{
  setTDRStyle1(1,1,0,logY);//gridX/Y, logX/Y
  gStyle->TStyle::SetOptStat(0);
  gStyle->TStyle::SetOptFit(0);
  TCanvas *c1 = new TCanvas("c1","myPlots",0,0,600,600);
////  TLegend* leg = new TLegend(0.20,0.65,0.45,0.90,legendTitle);
  TLegend* leg = new TLegend(0.20,0.25,0.45,0.50,legendTitle);
  leg->SetTextFont(62);
  leg->SetTextSize(0.03679144);
  leg->SetFillStyle(0);
  leg->SetLineColor(0);
  //leg->SetFillColor(0);
  
  for(int j=0; j<nPoints;j++)
    {
      hist[j]->SetLineColor(colors[j]);
      hist[j]->SetLineWidth(3);
      hist[j]->SetMarkerStyle(20);
      hist[j]->SetMarkerSize(0.9);
      hist[j]->SetMarkerColor(colors[j]);
      
      if(j==0)
	{
         
	  hist[j]->GetXaxis()->SetNdivisions(505);
	  hist[j]->GetYaxis()->SetNdivisions(505);
	  hist[j]->GetXaxis()->SetTitle(xTitle);
	  hist[j]->GetYaxis()->SetTitle(yTitle);
	  hist[j]->GetYaxis()->SetTitleOffset(1.3);
	  hist[j]->GetXaxis()->SetRangeUser(xMin,xMax); //make this automatic
	  hist[j]->SetMinimum(0);
	  /*set y range automatically too*/
	  //hist[j]->DrawNormalized();
	  hist[j]->Draw();
	}
      else
	//hist[j]->DrawNormalized("same");
	hist[j]->Draw("same");
      TString ll=legendNames[j];
      leg->AddEntry(hist[j],ll,"pl");
    }
  
  leg->Draw("same");
  
  c1->cd();
  TLatex T1;
  T1.SetTextSize(.04014599);
  T1.SetNDC();
  T1.DrawLatex(0.45,0.95,"CMS Simulation Preliminary"); //follows x-axis and y-axis values for position...
  /*
  T1.SetTextSize(.035);
  T1.DrawLatex(0.2,0.5,"Aging model sys uncert.: ~30%");
  T1.DrawLatex(0.2,0.45,"Run1 reconstruction");
  T1.DrawLatex(0.2,0.40,"Prompt photons");
  */
  char  ss1[50];
  sprintf(ss1,direct,filename);
  c1->SaveAs(ss1);
  //sprintf(ss1,"PLOTS/%s.png",filename);
 // std::cout << ss1 << std::endl;
  c1->SaveAs(ss1);
  //sprintf(ss1,"PLOTS/C/%s.C",filename);
 // c1->SaveAs(ss1);
  c1->Clear();
}

void formatHisto1(int logY, const char* legendTitle, string * legendNames, const char* xTitle, float xMin, float xMax, const char* yTitle, int *colors, TGraph** hist, const int nPoints, const char* filename,const char* direct);
void formatHisto1(int logY, const char* legendTitle, string * legendNames, const char* xTitle, float xMin, float xMax, const char* yTitle, int *colors, TGraph** hist, const int nPoints,const char* filename,const char* direct)
{
  setTDRStyle1(1,1,0,logY);//gridX/Y, logX/Y
  gStyle->TStyle::SetOptStat(0);
  gStyle->TStyle::SetOptFit(0);
  TCanvas *c1 = new TCanvas("c1","myPlots",0,0,600,600);
////  TLegend* leg = new TLegend(0.20,0.65,0.45,0.90,legendTitle);
  TLegend* leg = new TLegend(0.20,0.25,0.45,0.50,legendTitle);
  leg->SetTextFont(62);
  leg->SetTextSize(0.03679144);
  leg->SetFillStyle(0);
  leg->SetLineColor(0);
  //leg->SetFillColor(0);
  
  for(int j=0; j<nPoints;j++)
    {
      hist[j]->SetLineColor(colors[j]);
      hist[j]->SetLineWidth(3);
      hist[j]->SetMarkerStyle(20);
      hist[j]->SetMarkerSize(0.9);
      hist[j]->SetMarkerColor(colors[j]);
      
      if(j==0)
	{
         
	  hist[j]->GetXaxis()->SetNdivisions(505);
	  hist[j]->GetYaxis()->SetNdivisions(505);
	  hist[j]->GetXaxis()->SetTitle(xTitle);
	  hist[j]->GetYaxis()->SetTitle(yTitle);
	  hist[j]->GetYaxis()->SetTitleOffset(1.3);
	  hist[j]->GetXaxis()->SetRangeUser(xMin,xMax); //make this automatic
	  hist[j]->SetMinimum(0);
	  /*set y range automatically too*/
	  //hist[j]->DrawNormalized();
	  hist[j]->Draw();
	}
      else
	//hist[j]->DrawNormalized("same");
	hist[j]->Draw("same");
      TString ll=legendNames[j];
      leg->AddEntry(hist[j],ll,"pl");
    }
  
  leg->Draw("same");
  
  c1->cd();
  TLatex T1;
  T1.SetTextSize(.04014599);
  T1.SetNDC();
  T1.DrawLatex(0.45,0.95,"CMS Simulation Preliminary"); //follows x-axis and y-axis values for position...
  /*
  T1.SetTextSize(.035);
  T1.DrawLatex(0.2,0.5,"Aging model sys uncert.: ~30%");
  T1.DrawLatex(0.2,0.45,"Run1 reconstruction");
  T1.DrawLatex(0.2,0.40,"Prompt photons");
  */
  char  ss1[50];
  sprintf(ss1,direct,filename);
  c1->SaveAs(ss1);
  //sprintf(ss1,"PLOTS/%s.png",filename);
 // std::cout << ss1 << std::endl;
  c1->SaveAs(ss1);
  //sprintf(ss1,"PLOTS/C/%s.C",filename);
 // c1->SaveAs(ss1);
  c1->Clear();
}
//
//ok
//"Energy resolution, #sigma_{eff}(E)/E"

/*used to format any graph which is produced with nEta points on the x-axis */

/*void formatEtaGraph(int logY, const char* legendTitle, string * legendNames,const char * yTitle, int * colors, std::vector< std::vector<float> > &data, const int nPoints, const char* fileName );
void formatEtaGraph(int logY, const char* legendTitle, string * legendNames,const char * yTitle, int * colors, std::vector< std::vector<float> > &data, const int nPoints, const char* fileName )
{

  setTDRStyle1(1,1,0,logY);//gridX/Y, logX/Y
  gStyle->TStyle::SetOptStat(0);
  gStyle->TStyle::SetOptFit(0);
  TCanvas *c1 = new TCanvas("c1","myPlots",0,0,600,600);
//  TLegend* leg = new TLegend(0.25,0.65,0.55,0.90,legendTitle);
  TLegend* leg = new TLegend(0.25,0.25,0.55,0.50,legendTitle);
  leg->SetTextFont(62);
  leg->SetTextSize(0.03679144);
  leg->SetFillStyle(0);
  leg->SetLineColor(0);
  
  leg->SetLineColor(kBlue);
  leg->SetLineColorAlpha(kBlue,0.0);
  

  TGraph *gr_res[nPoints];
  for (int j=0; j<nPoints; j++)
    {
      float y[nEta];
      for (int i=0; i<nEta; i++)
	{
	  y[i]=data[i][j];
	  //  std::cout << "data: " << y[i] << std::endl;
	}
      gr_res[j] = new TGraph(nEta,etaVal,y);
      gr_res[j]->GetY();
      gr_res[j]->SetLineColor(colors[j]);
      gr_res[j]->SetLineWidth(3);
      gr_res[j]->SetMarkerStyle(20);
      gr_res[j]->SetMarkerSize(0.9);
      gr_res[j]->SetMarkerColor(colors[j]);
      if (j==0)
	{
	  gr_res[j]->SetMinimum(0.0);
	  gr_res[j]->SetMaximum(0.25);
	  gr_res[j]->GetXaxis()->SetNdivisions(505);
	  gr_res[j]->GetYaxis()->SetNdivisions(505);
	  gr_res[j]->GetXaxis()->SetTitle("#eta");
	  gr_res[j]->GetYaxis()->SetTitle(yTitle);
	  gr_res[j]->Draw("ALP");
	}
      else
	{
	  gr_res[j]->Draw("LP");
	}
      TString ll=legendNames[j];
      leg->AddEntry(gr_res[j],ll,"pl");
    }
  leg->Draw("same");
  TLatex T1;
  T1.SetNDC();
  T1.SetTextSize(.04014599);
  T1.DrawLatex(.45,0.95,"CMS Simulation Preliminary"); //follows x-axis and y-axis values for position...
  T1.SetTextSize(.035);
  T1.DrawLatex(0.2,0.5,"Aging model sys uncert.: ~30%");
  T1.DrawLatex(0.2,0.45,"Run1 reconstruction");
  T1.DrawLatex(0.2,0.40,"Prompt photons, pT>30GeV");
  
  char ss1[50];
  sprintf(ss1,direct,fileName);
  c1->SaveAs(ss1);
//  sprintf(ss1,"PLOTS/C/%s.C",fileName);
//  c1->SaveAs(ss1);
  c1->Clear();
}*/

