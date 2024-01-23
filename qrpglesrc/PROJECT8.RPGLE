**Free

//-----------------------------------------------
// Program: PROJECT8                            *
// Programmer: Chase Timmons                    *
// Date: 10/29/2021                             *
// Purpose: Print a list of the current courses *
//          offered by Wibaux University        *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f Wusctp Disk    Usage(*Input)  Keyed;
dcl-f Wucrsp Disk    Usage(*Input)  Keyed;
dcl-f Wuclls Printer Usage(*Output) Oflind(EndOfPage);

//----- Stand-Alone Variables ----------------------------
dcl-s EndOfPage Ind  Inz(*On);
dcl-s CourseNum Char(3);
dcl-s SectTime  Char(5);

//----- Main Procedure -----------------------------------
read Wusctp;
dow not %eof;
   if EndOfPage;
      write Heading;
      EndOfPage = *Off;
   endIf;

   // Convert Course Number to CHAR for composite chain key
   CourseNum = %char(CRSNO);

   // Format Section time to add colon and remove leading zeroes
   SectTime = %editw(SECTIM:'  :  ');
   SectTime = %triml(SectTime:'0');

   // Chain to the second input file to bring in Course Title and Credits
   chain (Dept:CourseNum) Wucrsp;

   // If a match to the key is found, print the relevant report line
   if %found();
     write Detail;
   else;
     write Error;
   endif;

   read Wusctp;
enddo;

*inlr = *on;
return; 