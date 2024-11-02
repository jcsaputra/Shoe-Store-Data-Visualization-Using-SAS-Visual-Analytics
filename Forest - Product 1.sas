﻿/*---------------------------------------------------------
  The options statement below should be placed
  before the data step when submitting this code.
---------------------------------------------------------*/
options VALIDMEMNAME=EXTEND VALIDVARNAME=ANY;


/*---------------------------------------------------------
  Before this code can run you need to fill in all the
  macro variables below.
---------------------------------------------------------*/
/*---------------------------------------------------------
  Start Macro Variables
---------------------------------------------------------*/
%let SOURCE_HOST=<Hostname>; /* The host name of the CAS server */
%let SOURCE_PORT=<Port>; /* The port of the CAS server */
%let SOURCE_LIB=<Library>; /* The CAS library where the source data resides */
%let SOURCE_DATA=<Tablename>; /* The CAS table name of the source data */
%let DEST_LIB=<Library>; /* The CAS library where the destination data should go */
%let DEST_DATA=<Tablename>; /* The CAS table name where the destination data should go */

/* Open a CAS session and make the CAS libraries available */
options cashost="&SOURCE_HOST" casport=&SOURCE_PORT;
cas mysess;
caslib _all_ assign;

/* Load ASTOREs into CAS memory */
proc casutil;
  Load casdata="Forest___Product_1.sashdat" incaslib="Models" casout="Forest___Product_1" outcaslib="casuser" replace;
Quit;

/* Apply the model */
proc cas;
  fcmpact.runProgram /
  inputData={caslib="&SOURCE_LIB" name="&SOURCE_DATA"}
  outputData={caslib="&DEST_LIB" name="&DEST_DATA" replace=1}
  routineCode = "

   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 30May2024:06:31:19
     Locale           : en_US
     Model Type       : Forest
     Interval variable: Price per Unit
     Interval variable: Total Sales
     Interval variable: Units Sold
     Class variable   : Product
     Class variable   : State
     Class variable   : Retailer
     Response variable: Product
     ------------------------------------------*/
declare object Forest___Product_1(astore);
call Forest___Product_1.score('CASUSER','Forest___Product_1');
   /*------------------------------------------*/
   /*_VA_DROP*/ drop 'I_Product'n 'P_ProductMen_s_Apparel'n 'P_ProductMen_s_Athletic_Footwear'n 'P_ProductMen_s_Street_Footwear'n 'P_ProductWomen_s_Apparel'n 'P_ProductWomen_s_Athletic_Footwe'n 'P_ProductWomen_s_Street_Footwear'n;
length 'I_Product_2487'n $25;
      'I_Product_2487'n='I_Product'n;
'P_ProductMen_s_Apparel_2487'n='P_ProductMen_s_Apparel'n;
'P_ProductMen_s_Athletic_F_2487'n='P_ProductMen_s_Athletic_Footwear'n;
'P_ProductMen_s_Street_Foo_2487'n='P_ProductMen_s_Street_Footwear'n;
'P_ProductWomen_s_Apparel_2487'n='P_ProductWomen_s_Apparel'n;
'P_ProductWomen_s_Athletic_2487'n='P_ProductWomen_s_Athletic_Footwe'n;
'P_ProductWomen_s_Street_F_2487'n='P_ProductWomen_s_Street_Footwear'n;
   /*------------------------------------------*/
";

run;
Quit;

/* Persist the output table */
proc casutil;
  Save casdata="&DEST_DATA" incaslib="&DEST_LIB" casout="&DEST_DATA%str(.)sashdat" outcaslib="&DEST_LIB" replace;
Quit;