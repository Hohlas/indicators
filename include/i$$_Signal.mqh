void Signal (int SigMode, int SigType, int K){  // Сигналы и направления тренда  SigMode=1-расчет тренда,                                                    //                              SigMode=2-расчет сигнала
   float hlc=0, hlc1=0, x0=0, x1=0, x2=0, x3=0, z=0, w=0; 
   Up=0; Dn=0;            
   bool TREND=0, SIGNAL=0; int indper;
   if (SigMode==2) SIGNAL=1; else  TREND=1;
   switch (MathAbs(SigType)){ 
      case 1:// сигналы по $Layers при N>3 ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         if (K<5){   LAYERS(K*6);      x0=LayH2;    x1=LayL2;}// N=6, 12, 18, 24
         else{       LAYERS((K-5)*6);  x0=LayH3;    x1=LayL3;}// N=0, 6, 12, 18, 24
         if (H>x0)  {if (TREND) Up=1; if (SIGNAL && H1<x0) Up=1;}
         if (L<x1)  {if (TREND) Dn=1; if (SIGNAL && L1>x1) Dn=1;}              
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 2:// сигналы по $Layers N<3 ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         switch(K){
            case 1:  LAYERS(0);  x0=LayH1; x1=LayL1; break;//  $Layers (N=0)
            case 2:  LAYERS(1);  x0=LayH1; x1=LayL1; break;
            case 3:  LAYERS(0);  x0=LayH3; x1=LayL3; break; //  $Layers (N=0)
            case 4:  LAYERS(1);  x0=LayH2; x1=LayL2; break;// опять $Layers(N=1) с теми же уровнями 1 и 5
            case 5:  LAYERS(0);  x0=LayH4; x1=LayL4; break;//  $Layers (N=0)
            case 6:  LAYERS(2);  x0=LayH2; x1=LayL2; break;//  $Layers(N=2) , тока с более дальними уровнями 1 и 5
            case 7:  LAYERS(1);  x0=LayH3; x1=LayL3; break;// перебор уровней 2-6 для индюка $Layers (N=1)
            case 8:  LAYERS(1);  x0=LayH4; x1=LayL4; break;// самые дальние уровни 3-7, они есть тока у $Layers при (N=1)
            case 9:  LAYERS(2);  x0=LayH3; x1=LayL3; break;//  $Layers(N=2) , тока с более дальними уровнями 1 и 5      
            }
         if (H>x0)  {if (TREND) Up=1; if (SIGNAL && H1<x0) Up=1;}
         if (L<x1)  {if (TREND) Dn=1; if (SIGNAL && L1>x1) Dn=1;} 
         //LINE("x0", bar, x0, bar+1, x0, clrBlue, 0);
         //LINE("x1", bar, x1, bar+1, x1, clrBlue, 0);               
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 3: // отскоки/приближения к экстремумам HiLo OSC(2) ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         z=float((5-K)*0.1);   // 0.4  0.3  0.2  0.1  0  -0.1  -0.2  -0.3  -0.4     
         hlc=(H+L+C)/3;
         hlc1=(H1+L1+C1)/3;
         if (HI -LO >0)   x0=(hlc -LO )/(HI-LO)-float(0.5);
         if (HI1-LO1>0)   x1=(hlc1-LO1)/(HI1-LO1)-float(0.5);
         if (x0> z) {if (TREND) Up=1; if (SIGNAL && x1<= z) Up=1;}
         if (x0<-z) {if (TREND) Dn=1; if (SIGNAL && x1>=-z) Dn=1;}
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 4: // Сигнал / Шум ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         indper=int(NormalizeDouble(MathPow(1.5,K+5),0)*PerAdapter); // 11  17  26  38  58  86  130  195  291
         iDM(1,indper);
         if (TREND){
            if (DM> 0) Up=1;
            if (DM<-0) Dn=1;
            }
         if (SIGNAL){
            if (DMmin<0 && DM-DMmin>0.1 && DM1-DMmin<=0.1) Up=1; // отскок от минимума 
            if (DMmax>0 && DMmax-DM>0.1 && DMmax-DM1<=0.1) Dn=1; // отскок от максимума
            }
         x0=DM; x1=DM1; x2=DMmax; x3=DMmin;  
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 5:// DM приоритетное направление движения цены ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         indper=int(NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter); // 17  26  38  58  86  130  195  291  438  
         if (TREND){ // положение индюка относительно нулевой линии (ATR для гистерезиса)
            iDM(0,indper);
            if (DM> ATR) Up=1; 
            if (DM<-ATR) Dn=1; 
            }
         if (SIGNAL){ 
            if (K==1 || K==3 || K==5 || K== 7 || K==9) iDM(0,indper); // отскоки DM от максимального / минимального значений на ATR
            else   iDM(3,indper);// отскоки Momentum от максимального / минимального значений на ATR 
            if (DMmin<-ATR*2 && DM-DMmin>ATR && DM1-DMmin<=ATR) Up=1; // отскок от минимума 
            if (DMmax> ATR*2 && DMmax-DM>ATR && DMmax-DM1<=ATR) Dn=1;
            }  
         x0=DM; x1=DM1; x2=DMmax; x3=DMmin; 
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 6: // Фракталы ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         if (TREND){// Тренд фракталу на базе HL или OSC(5)
            if (LO2>LO1 && LO1<=LO)  Up=1; // сформировался очередной минимум, тренд вверх 
            if (HI2<HI1 && HI1>=HI)  Dn=1; // сформировался очередной максимум, тренд вниз
            }    
         if (SIGNAL){// фрактал - резкий пик
            x3=ATR*K/2; // постоянная удаления вершины от краев (отсеиваем плоские фракталы)
            x0=(float)High[K+1]; // вершина
            x1=(float)High[iHighest(SYMBOL,0,MODE_HIGH,K*2+1,bar)];
            if (x0==x1 && Low [1]<x0-x3 && Low [K*2+1]<x0-x3){  //  V("Dn", x0, K+1, clrRed);
               Dn=1;} // "чистый фрактал" (одна вершина, достаточно удаленная от краев)
            x0=(float)Low [K+1];
            x1=(float)Low [iLowest (SYMBOL,0,MODE_LOW, K*2+1,bar)];
            if (x0==x1 && High[1]>x0+x3 && High[K*2+1]>x0+x3){  //  A("Up", x0, K+1, clrRed);
               Up=1;}
            }     
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
      case 7:// Тренд Momentum. Сигнал на разрыве, или оч длинном баре, а так же по моментуму ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ     
         if (TREND){ // Классический моментум
            indper=int(NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter); // 17  26  38  58  86  130  195  291  438
            if (bar+indper+1>=Bars) break;
            x0=float(Open[bar]-Open[bar+indper]); 
            if (x0>0) Up=1; else Dn=1;
            }
         if (SIGNAL){//сигнал на разрыве, или оч длинном баре 
            if (K==2 || K==4 || K==6 || K==8){
               x0=float(ATR*(0.5+K*0.3)); // 1.1  1.4  2.3  2.9
               x1=(float)Open[bar-1]; // открытие нулевого бара
               x2=(float)Open[bar]; 
               if (x1-x2>x0) Up=1; // наличие разрыва, или оч длинного бара
               if (x2-x1>x0) Dn=1;   
            }else{
               indper=int(NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter); // 17  26  38  58  86  130  195  291  438
               DMmax1=DMmax; DMmin1=DMmin;
               iDM(3,indper);
               x0=DMmax; x1=DMmin; x2=DMmax1; x3=DMmin1;
               if (x0> ATR*(2+K*0.5) && x0>x2) Up=1; 
               if (x1<-ATR*(2+K*0.5) && x1<x3) Dn=1;
               
               //indper=int(NormalizeDouble(MathPow(1.5,K+6),0)*PerAdapter); // 17  26  38  58  86  130  195  291  438
               //x0=iCustom(SYMBOL,0,"$DM",3,indper,2,bar); // max
               //x1=iCustom(SYMBOL,0,"$DM",3,indper,3,bar); // min
               //x2=iCustom(SYMBOL,0,"$DM",3,indper,2,bar+1); // max
               //x3=iCustom(SYMBOL,0,"$DM",3,indper,3,bar+1); // min
               //if (x0> ATR*(2+K*0.5) && x0>x2) Up=1; 
               //if (x1<-ATR*(2+K*0.5) && x1<x3) Dn=1;
            
            }  } 
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
      case 8: // сужение/расширение канала HL относительно предыдущих значений ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         if (K<6) x0=(K+3)*float(0.1); // x0= 0.4  0.5  0.6  0.7  0.8
         else x0=(14-K)*float(0.1);    // x0= 0.8  0.7  0.6  0.5  
         if (TREND){
            x1=Osc1; // Последний диапазон HL
            x2=Osc0; // Cреднее значение N диапазонов HL (N=30 - задается внутри индюка от балды). Tренд при сужении/расширении канала HL относительно среднестатистического значения  
            }
         if (SIGNAL){ 
            x1=Osc1;   // Последний диапазон HL
            x2=Osc11;  // ПредПоследний диапазон HL. сигнал при сужении/расширении канала HL относительно предыдущего значения, 
            }
         if (x1<=0) x1=float(1*Point); // для избежания
         if (x2<=0) x2=float(1*Point);  // деления на ноль   
         if (K<6) {if (x1/x2<x0)  {Up=1; Dn=1;}} // при сужении  диапазона   HL в  x0  раз    
         else     {if (x2/x1<x0)  {Up=1; Dn=1;}} // при расширении диапазона HL в  x0  раз
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 9: // тренд при сужении/расширенни зафиксированного диапазона HL относительно ATR, Сигналы при образовании новых экстремумов,        
         if (TREND){ // в отличии от п.5 HL считается по другой формуле
            iOSC(3);
            x0=Osc0; // Значение последнего минимума
            x1=Osc1; // Значение последнего максимума
            if (K<6) {z=(K+3)*(K+3)*float(0.1); if ((x1-x0)/ATR<z) {Up=1; Dn=1;}} // при сужении  диапазона HL до значения=ATR*  1.6  2.5  3.6  4.9  6.4
            else     {z=(K+1)*(K+1)*float(0.1); if ((x1-x0)/ATR>z) {Up=1; Dn=1;}} // при расширении диапазона HL до значения=ATR* 4.9  6.4  8.1  10  
            
            //float h1=(float)iCustom(SYMBOL,0,"$OSC",3,HL,HLk,1,bar); // Значение последнего максимума 
            //float l1=(float)iCustom(SYMBOL,0,"$OSC",3,HL,HLk,0,bar); // Значение последнего минимума
            //if (K<6) {x0=float((K+3)*(K+3)*0.1); if ((h1-l1)/ATR<x0) {Up=1; Dn=1;}} // при сужении  диапазона HL до значения=ATR*  1.6  2.5  3.6  4.9  6.4
            //else     {x0=float((K+1)*(K+1)*0.1); if ((h1-l1)/ATR>x0) {Up=1; Dn=1;}} // при 
            
            }
         if (SIGNAL){
            iOSC(4);
            x0=Osc1; // Значение последнего максимума
            x1=Osc0; // Значение последнего минимума
            x2=Osc11; // Значение предпоследнего максимума
            x3=Osc01; // Значение предпоследнего минимума
            if (K<6){ // z= 0.75  0.6  0.45  0.3  0.15 
               z=(x2-x3)*(6-K)*float(0.15);
               if (x1>x3+z) Up=1; // сформировался очередной минимум выше предыдущего 
               if (x0<x2-z) Dn=1; // сформировался очередной максимум ниже предыдущего 
               }
            else{ // z= 0.15  0.3  0.45  0.6 
               z=(x2-x3)*(K-5)*float(0.15);
               if (x1<x3-z) Up=1; // сформировался очередной минимум ниже предыдущего  
               if (x0>x2+z) Dn=1; // сформировался очередной максимум выше предыдущего
            }  }     
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 10: // сигнал, тренд по сужению/расширению ATR ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         x1=atr;  x2=ATR;
         if (x1<=0 || x2<=0) break;
         if (K<6) {z=(K+4)*float(0.1);  if (atr/ATR<z) {Up=1; Dn=1;}}  // при уменьшении atr в   0.5  0.6  0.7  0.8  0.9
         else     {z=(15-K)*float(0.1); if (ATR/atr<z) {Up=1; Dn=1;}}  // при увеличении atr в   0.9  0.8  0.7  0.6      
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      case 11:// Тренд на сужении/расширении HL, измеренном в ATR, сигнал по VolumeCluster ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ      
         if (TREND){ 
            if (K<6) {x0=float(ATR*(K+2)*0.5); if ((HI-LO)<x0) {Up=1; Dn=1;}} // при сужении  диапазона HL до значения=ATR*  1.5  2  2.5  3  3.5
            else     {x0=float(ATR*(K-4)*1.5); if ((HI-LO)>x0) {Up=1; Dn=1;}} // при расширении диапазона HL до значения=ATR* 3  4,5  6  7.5
            x1=x0; x2=x1;
            }  
         if (SIGNAL){  // Свечные фигуры "Повешаннй" и "Надгробие". Тактика определения - VolumeCluster http://gproxyru.appspot.com/http/forex-vc.ru/index.html
        //    indper=(PerCnt+1)*2-1; // indper=1 3 5
            //x0 =iCustom(SYMBOL,0,"0HL",8,K,indper,0,bar); // 
            //x1 =iCustom(SYMBOL,0,"0HL",8,K,indper,1,bar);
            //x0 =iCustom(SYMBOL,0,"0HL",8,K,indper,2,bar); // Сигнал (точка на графике)
            if (x0==x1) Up=1;
            if (x0==x0) Dn=1; 
            x1=x0; x2=x1; 
            }    
      break; // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
      default: //  без всяких фильтров  ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
         Up=1; Dn=1; 
      break; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      }
   ERROR_CHECK("Signal");   
   if (Real){  // сохраним значения индюков для сравнения Real / Test ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      switch(SigMode){
         case 1: // Trend
            ch[0]=Up; // TrUp
            ch[1]=Dn; // TrDn
            PS[0]=x0; // Tr0 
            PS[1]=x1; // Tr1
            PS[2]=x2; // Tr2
            PS[3]=x3; // Tr3
         break;   
         case 2: // In
            ch[2]=Up; // InUp
            ch[3]=Dn; // InDn
            PS[4]=x0; // In0
            PS[5]=x1; // In1
            PS[6]=x2; // In2
            PS[7]=x3; // In3
         break;   
         case 3:  // Out
            ch[4]=Up; // OutUp
            ch[5]=Dn; // OutDn
            PS[8] =x0; // Out0
            PS[9] =x1; // Out1
            PS[10]=x2; // Out2
            PS[11]=x3; // Out3
         break;     
   }  }  }

