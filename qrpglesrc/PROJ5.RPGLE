**free

//-----------------------------------------------
// Program: PROJECT5                            *
// Programmer: Chase Timmons                    *
// Date: 2/10/2022                              *
// Purpose: Summarize student scores and report *
//          a letter grade.                     *
// Revisions:                                   *
// - Revised data validation procedures 2/10/22 *
// - Broke into subroutines             2/11/22 *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f wustdp Disk    Usage(*Input) Keyed;
dcl-f mypointsp Disk Usage(*Output);
dcl-f proj4 Workstn  Indds(Indicators);

//----- Constant Variables -------------------------------
dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';
dcl-c passing 60.00; // percentage required to pass

//----- Indicator Data Structure -------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);         // F3=Exit
  Cancel Ind Pos(12);      // F12=Cancel
  BadStuNo Ind Pos(90);    // Invalid student number
  InvalidRcv Ind Pos(91);  // Invalid points received
  InvalidPos Ind Pos(92);  // Invalid points possible
end-ds;

//----- Main Procedure -------------------------
dow not Exit;

  exsr clear;       // clear screen for new lookup
  exsr lookupstu;   // lookup student name
  exsr validatepts; // validate points
  exsr writepts;    // write points

enddo;

*inlr = *on;
return;

// -----------------------------------------------------------
// Clear Subroutine - clear out fields for display
begsr clear;
  stuno = *zeros;
  desc = *blanks;
  ptsrcv = *zeros;
  ptspos = *zeros;
  BadStuNo = *off;
  InvalidRcv = *off;
  InvalidPos = *off;
endsr;

// -----------------------------------------------------------
// LookupStu Subroutine - use stunum to get stuname and format
begsr lookupstu;
  dow not Exit;
  exfmt inquiry;
  if not Exit;
    // use the student number to find student name                     tdp for name
    chain STUNO wustdp;
    if %found(wustdp);
      // combine names for display
      stuname = %Trim(%Xlate(Uppercase:Lowercase:%Trim(SFNAME):2) +
                ' ' + %Xlate(Uppercase:Lowercase:%Trim(SMNAME):2) +
                ' ' + %Xlate(Uppercase:Lowercase:%Trim(SLNAME):2));
      // if student is found, move to score entry screen
      exfmt entry;
    else;
      // display invalid student number message
      BadStuNo = *on;
    endif;
  endif;
  enddo;
endsr;

// -----------------------------------------------------------
// ValidatePts Subroutine - check if input is valid
begsr validatepts;
  // points received cannot be greater than points possible
  // points possible can also not be zero or negative
  dow ((ptspos <= 0 or ptsrcv > ptspos) and not Exit);
    InvalidRcv = ptsrcv > ptspos;
    InvalidPos = ptspos <= 0;
    exfmt entry;
  enddo;
endsr;

// -----------------------------------------------------------
// WritePts Subroutine - write points to MYPOINTSP file
//                       and display results screen
begsr writepts;
    if not Exit;
      percent = (ptsrcv / ptspos) * 100.00;
      assigndesc = desc;
      ptsreceive = ptsrcv;
      ptspossibl = ptspos;
      if percent >= passing;
        passfail = 'Student passed';
      else;
        passfail = 'Student failed';
      endif;

      write pointsrec;
      exfmt results;
    endif;
endsr; 