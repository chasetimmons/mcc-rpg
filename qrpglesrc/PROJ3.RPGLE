**free

//-----------------------------------------------
// Program: PROJECT3                            *
// Programmer: Chase Timmons                    *
// Date: 1/24/2022                              *
// Purpose: Summarize student scores and report *
//          a letter grade.                     *
// Revisions:                                   *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f gradebook disk  usage(*input) keyed;
dcl-f proj3 printer usage(*output) oflind(EndOfPage);

//----- Stand-Alone Variables ----------------------------
dcl-s EndOfPage ind inz(*on);
dcl-s i zoned(2:0); // array index
dcl-s grade zoned(3:0) dim(12) ctdata ascend; // grade range
dcl-s letter char(2) dim(12) alt(grade); // letter grade
//dcl-s fullname  char(20);  defined in DDS of PRTF
//dcl-s average zoned(6:2);  defined in DDS of PRTF
//dcl-s lettergrade char(2); defined in DDS of PRTF

//----- Scores Array -------------------------------------
dcl-ds *n;
  scores char(75);
  scoresarray zoned(3:0) dim(25) pos(1);
end-ds;

//----- Main Procedure -----------------------------------
read gradebook;
dow not %eof;
   fullname = %trim(SFNAME) + ' ' + %trim(SLNAME);
   eval(h) average = %xfoot(scoresarray) / %elem(scoresarray);
   i = %lookupge(average:grade);
   if i > 0;
     lettergrad = letter(i);
   endif;

   if EndOfPage;
      write heading;
      EndOfPage = *Off;
   endIf;

   write detail;
   read gradebook;
enddo;

*inlr = *on;
return;

** CTDATA scores
060E
062D-
066D
069D+
072C-
076C
079C+
082B-
086B
089B+
092A-
100A 