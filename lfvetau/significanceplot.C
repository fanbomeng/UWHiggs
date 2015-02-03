void significanceplot()
{

//-----------0 jet --------------------------------
   float tPt0x[]={30,35,40,45,50},tPt0y[]={0.770776,0.637493,0.652797,0.632323,0.586012};
   float ePt0x[]={30,35,40,45,50},ePt0y[]={0.733901,0.763542,0.758579,0.770776,0.708133};
   float deltaPhi0x[]={2.2,2.3,2.4,2.5,2.7,3},deltaPhi0y[]={0.7731,0.770776,0.745163,0.745082,0.70611,0.505177};
   float tMtToPFMET0x[]={30,40,50,55,60,65,70,75},tMtToPFMET0y[]={0.576606,0.593562,0.699597,0.712143,0.742353,0.769697,0.770776,0.762932};
//-----------0  jet end----------------------------
   

//----------1 jet ---------------------------------
   float tPt1x[]={30,35,40,45},tPt1y[]={0.643561,0.687362,0.740094,0.734862};
   float ePt1x[]={30,35,40,45},ePt1y[]={0.749094,0.740094,0.700587,0.655509};
   float tMtToPFMET1x[]={30,35,40,45,55},tMtToPFMET1y[]={0.702555,0.741475,0.740094,0.736933,0.735126};
//----------1 jet ends ----------------------------


//----------2 jets -------------------------------
   float tPt2x[]={30,35,40,45},tPt2y[]={0.744566,0.74705,0.697517,0.694475};
   float ePt2x[]={30,35,40,45},ePt2y[]={0.755462,0.74705,0.699736,0.698067};
   float tMtToPFMET2x[]={30,35,40,45,50},tMtToPFMET2y[]={0.560628,0.610925,0.665188,0.711834,0.74705};
   float vbfMass2x[]={400,450,500,550},vbfMass2y[]={0.745816,0.739181,0.74705,0.666684};
   float vbfDeta2x[]={2.2,2.3,2.5,2.7,3,3.5,4},vbfDeta2y[]={0.74959,0.74705,0.73832,0.735078,0.755883,0.778895,0.743379};
//----------2 jets ends-----------------------------
//   int binnumb,rang1,rang2;
//   char * variable;
   //printf( "the size of array is %d\n",sizeof(a)/sizeof(*a));
//   const int n1 = sizeof(a)/sizeof(*a);
 //  double x[3]={0,1,2};
 //  double y[3]={1,2,3};
 /*  if(variable=="tPtcut")
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
    {       binnumb=200;
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
*///const string jet0[]={"tPtcut","ePtcut","deltaPhicut","tMtToPFMETcut","0jets"};
 // const string jet1[]={"tPtcut","ePtcut","tMtToPFMETcut","1jets"};
 // const string jet2[]={"tPtcut","ePtcut","tMtToPFMETcut","vbfMasscut","vbfDetacut","2jets"};
   char * variable="deltaPhi";
   int flag=3;
   const int n1 = sizeof(deltaPhi0x)/sizeof(*deltaPhi0x);
   TGraph *gr1 = new TGraph (n1,deltaPhi0x,deltaPhi0y);
   TCanvas *c1 = new TCanvas("c1","Graph Draw Options",200,10,600,400);
   gr1->SetMarkerColor(1);
   gr1->SetMarkerStyle(8);
   gr1->SetMarkerSize(1);
   if(flag==0)
      gr1->GetXaxis()->SetTitle("tPt (GeV)");
   if (flag==1)
      gr1->GetXaxis()->SetTitle("ePt (GeV)");
   if (flag==2)
      gr1->GetXaxis()->SetTitle("tMtToPFMET");
   if (flag==3)
      gr1->GetXaxis()->SetTitle("deltaPhi"); 
   if (flag==4)
      gr1->GetXaxis()->SetTitle("vbfMass"); 
   if (flag==5)
      gr1->GetXaxis()->SetTitle("vbfDeta"); 
   gr1->GetYaxis()->SetTitle("Significance");
   gr1->SetTitle("0 jet");
   c1->SetGridx(1);
   c1->SetGridy(1);
   gr1->Draw("AP");
   char  ss1[100];
   sprintf(ss1,"plots/significance/0jets/%s.png",variable);
   c1->Print(ss1);


} 
