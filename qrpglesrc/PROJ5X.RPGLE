**free

//-----------------------------------------------
// Program: PROJECT5                            *
// Programmer: Chase Timmons                    *
// Date: 2/9/2022                              *
// Purpose: Summarize student scores and report *
//          a letter grade.                     *
// Revisions:                                   *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f wustdp Disk    Usage(*Input)  Keyed;
dcl-f mypointsp Disk Usage(*Output);
dcl-f proj4 Workstn Indds(Indicators);

//----- Constant Variables -------------------------------
dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';
dcl-c passing 60.00; // percentage required to pass

//----- Indicator Data Structure -------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);          // F3=Exit
  Cancel Ind Pos(12);       // F12=Cancel
  BadStuNo Ind Pos(90);     // Invalid student number
  InvalidEntry Ind Pos(91); // Invalid score entry
end-ds;

//----- Main Procedure -------------------------
dow not Exit;

  exsr clear;
  exfmt inquiry;
  if not Exit;
    // use the student number entered on inquiry screen to chain to wustdp for name
    chain STUNO wustdp;
    if %found(wustdp);
      // combine names for display
      stuname = %Trim(%Xlate(Uppercase:Lowercase:%Trim(SFNAME):2) +
                ' ' + %Xlate(Uppercase:Lowercase:%Trim(SMNAME):2) +
                ' ' + %Xlate(Uppercase:Lowercase:%Trim(SLNAME):2));
      exfmt entry;
    else;
      // display invalid student number message
      BadStuNo = *on;
    endif;
  endif;

  if (ptspos > 0 and not exit);
    assigndesc = desc;
    ptsreceive = ptsrcv;
    ptspossibl = ptspos;
    if (ptsrcv <= ptspos and not exit);
      percent = (ptsrcv / ptspos) * 100.00;
      if percent >= passing;
        passfail = 'Student passed';
      else;
        passfail = 'Student failed';
      endif;
      write pointsrec;
      exfmt results;
    else;
      InvalidEntry = *on;
      exfmt entry;
    endif;
  endif;

enddo;

*inlr = *on;
return;

// Clear Subroutine - clear out fields for display
begsr clear;
  stuno = *zeros;
  desc = *blanks;
  ptsrcv = *zeros;
  ptspos = *zeros;
  BadStuNo = *off;
  InvalidEntry = *off;
endsr; 