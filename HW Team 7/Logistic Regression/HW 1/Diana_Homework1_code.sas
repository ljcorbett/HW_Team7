/* Homework 1 */
libname Logistic "C:\Logistic Regression Models\Logistic Data";
proc import out= Logistic.flu datafile= "C:\Logistic Regression Models\Logistic Data\fludata.xlsx" 
            DBMS=xlsx replace;
     sheet="Sheet1"; 
     getnames=yes;
run;
data Logistic.flu;
	set Logistic.flu;
	if flu = "Yes" then flu_num = 1;
	else if flu = "No" then flu_num = 2;
run;

/*1st bullet point */
proc freq data=Logistic.flu nlevels;
   tables gender*flu_num / chisq measures plots(only)=freqplot 
                              (type=barchart scale=percent orient=vertical twoway=stacked);
   title 'Contingency Table Analysis Assessing Flu and Gender';
run;

/* 2nd & 3rd bullet points */
data Logistic.flu;
	set Logistic.flu;
	if income = "High" then income_num = 3;
	else if income = "Medium" then income_num = 2;
	else if income = "Low" then income_num = 1;
run;
proc freq data=Logistic.flu nlevels;
   tables income_num*flu_num / chisq measures plots(only)=freqplot 
                              (type=barchart scale=percent orient=vertical twoway=stacked);
   title 'Test Association between Flu and Income';
run;

/* 4th bullet point */
proc freq data=Logistic.flu nlevels;
   tables income_num*gender*flu_num / all plots(only)=oddsratioplot(stats); 
   title 'Stratified Analysis on Gender and Flu controlling for Income';
run;

/* 6th bullet point */
proc freq data=Logistic.flu nlevels;
   tables income_num*gender*flu_num / cmh bdt plots(only)=oddsratioplot(stats); 
   exact zelen;
   title 'Analysis for Gender and Flu controlling for Income - calculate Tyrone’s adjustment and Zelen’s exact test';
run;

/*7th bullet point */
proc logistic data=Logistic.flu plots(only)=(effect(clband showobs) oddsratio);
	class race (ref="Other" param=effect) income (ref="High" param=ref) gender (ref="Female" param=ref) previous (ref="No" param=ref);
	model flu (event='Yes') = age distance gender income previous race visits / selection=backward clodds=pl slstay=0.05;
	title 'Logistic Regression Model';
run;

data Logistic.flu; 
set Logistic.flu; 
agelogs = age*log(age); 
run; 
proc logistic data=Logistic.flu plots(only)=(effect(clband showobs) oddsratio);
	class race (ref="Other" param=effect) income (ref="High" param=ref) gender (ref="Female" param=ref) previous (ref="No" param=ref);
	model flu (event='Yes') = age agelogs distance gender income previous race visits / selection=backward clodds=pl slstay=0.05;
	title 'Logistic Regression Model';
run;
