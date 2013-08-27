libname logistic 'C:\Users\Bright\Documents\NCSU\Fall\Logistic Regression\Data';
ods graphics on;

/* add new variable to re-order income levels */

data fludata;
set logistic.fludata;
length income_level $ 8;
if income='High' then income_level='3_High';
else if income ='Medium' then income_level='2_Medium';
else if income ='Low' then income_level='1_Low';
run;

data fludata;
length income_level $ 10;
set logistic.fludata;

if income='High' then income_level='High';
else if income ='Medium' then income_level=' Medium';
else if income ='Low' then income_level=' Low';

* if income='High' then income=' High';
* else if income ='Medium' then income= ' Medium';



run;





proc freq data=logistic.fludata;

tables gender*flu / chisq measures;
run;

proc freq data=fludata;

tables income_level*flu / chisq measures;
run;

proc freq data=fludata;

tables income_level*gender*flu / all bdt plots(only)=oddsratioplot(stats);
exact zelen;
title 'Contingency Table Analysis Assessing Flu and Gender';
run;



proc logistic data=fludata plots(only)=(effect(clband showobs) oddsratio);
	class Race(param=effect ref='Other');
	class income_level(param=ref ref=' High');
	class Gender(param=ref ref='Female');
	class Previous(param=ref ref='No');


	model flu(event='Yes') = gender age distance income_level previous race visits   / clodds=pl;
	title 'Flu Model';
run;

proc logistic data=fludata plots(only)=(effect(clband showobs) oddsratio);
	class Gender(param=ref ref='Female');
		class income_level(param=ref ref=' High');
	model flu(event='Yes') = gender income_level / clodds=pl;

	title 'Flu Model';
run;