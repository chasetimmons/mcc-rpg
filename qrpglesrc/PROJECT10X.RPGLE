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
dcl-f bids Disk    Usage(*Input)  Keyed;
dcl-f bidsinq Workstn Indds(Indicators);

//----- Indicator Data Structure -------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);      // F3=Exit
  Cancel Ind Pos(12);   // F12=Cancel
  BadJobNo Ind Pos(90); // Invalid student number
end-ds;

//----- Main Procedure -------------------------
dow not Exit;
  exfmt scrn1;
  if not Exit;
    // use the student number entered on scrn1 as the key to chain to wuexamp file
    chain JOBNO bids;
    if %found(bids);
      exfmt scrn2;
    else;
      // display invalid student number message
      BadJobNo = *on;
    endif;
  endif;
enddo;

*inlr = *on;
return; 