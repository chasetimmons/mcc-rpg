**Free

//-----------------------------------------------
// Program: PROJECT10                           *
// Programmer: Chase Timmons                    *
// Date: 11/16/2021                             *
// Purpose: Show exam scores for Wibaux Univ.   *
//          students                            *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f wuexamp Disk    Usage(*Input)  Keyed;
dcl-f wuexinq Workstn Indds(Indicators);

//----- Stand-Alone Variables ----------------------------
dcl-s average Zoned(3:0);
dcl-s letter  Char(1);

//----- Indicator Data Structure -------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);      // F3=Exit
  Cancel Ind Pos(12);   // F12=Cancel
  BadStuNo Ind Pos(90); // Invalid student number
end-ds;

//----- Main Procedure -------------------------
dow not Exit;
  exfmt scrn1;
  if not Exit;
    // use the student number entered on scrn1 as the key to chain to wuexamp file
    chain STUNO wuexamp;
    if %found(wuexamp);
      exsr CalcGrades;
      exfmt scrn2;
    else;
      // display invalid student number message
      BadStuNo = *on;
    endif;
  endif;
enddo;

*inlr = *on;
return;

//----- CalcGrades Subroutine -------------------------
// I really wanted to figure out a more elegant way to do this.
// Such as iterating through each exam and displaying a letter
// grade for each, but did not want to have a giant if/else mess
begsr CalcGrades;
  // calculate average exam score
  average = (EXAM1 + EXAM2 + EXAM3 + EXAM4 + EXAM5) / 5;
  select;
    when average > 90;
      letter = 'A';
    when average > 80;
      letter = 'B';
    when average > 70;
      letter = 'C';
    when average > 60;
      letter = 'D';
    other;
      letter = 'F';
  endsl;
endsr; 