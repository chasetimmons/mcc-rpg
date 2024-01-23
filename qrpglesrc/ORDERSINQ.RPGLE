**free

//-----------------------------------------------
// Program: PROJECT11                           *
// Programmer: Chase Timmons                    *
// Date: 4/13/2022                              *
// Purpose: Displays orders by status and       *
//          allows users to edit certain fields *
// Revisions: Fixed 'More...' issue  4/18/22 CT1*
//            Corrected ERRMSG issue 4/18/22 CT1*
//-----------------------------------------------

//----- Control Options ------------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files --------------------------------------
dcl-f myordprpl Disk Usage(*Update : *Output) Keyed;
dcl-f orderscrn Workstn  Sfile(ordersfl:rrn)
                         Indds(Indicators);

//----- Indicator Data Structure ---------------------------
dcl-ds Indicators Len(99);
  Exit      Ind Pos(3);       // F3=Exit
  Cancel    Ind Pos(12);      // F12=Cancel
  FKey      Ind Pos(25);      // VldCmdKey
  Sfldsp    Ind Pos(50);      // Subfile Display
  Sflclr    Ind Pos(51);      // Subfile Clear
  Sflend    Ind Pos(52);      // End of Subfile
  OrdNotFnd Ind Pos(53);      // Order Not Found
end-ds;

// ----- Standalone Variables ------------------------------
dcl-s rrn Zoned(2:0);  // Relative Record Number

//----- Main Procedure -------------------------------------
dow not Exit;
  exfmt orderinq;
  if not Exit;
    setll status myordprpl;
    if not %equal(myordprpl);
      OrdNotFnd = *on;
    else;
      exsr clearsfl;          // Clear the subfile
      exsr loadsfl;           // Populate the subfile
      write footer;           // Write Footer
      sflend = *on;           // End of Subfile 'Bottom' CT1
      exfmt orderctl;
      if not Exit and not Cancel;
        exsr updatesr;
      endif;
    endif;
  endif;
enddo;

*inlr = *on;
return;

//---------------------------------------------------------
// CLEARSFL - Clear Subfile Routine
begsr clearsfl;
  sflclr = *on;
  sfldsp = *off;
  write orderctl;
  sflclr = *off;
  rrn = 0;
endsr;

//---------------------------------------------------------
// LOADSFL - Load Subfile Routine
begsr loadsfl;
  reade status myordprpl;
  dow not %EOF(myordprpl);
    rrn += 1;
    exsr movedb;
    write ordersfl;
    reade status myordprpl;
  enddo;
  sfldsp = (rrn > 0);
endsr;

//---------------------------------------------------------
// UPDATESR - Update Subfile Routine
begsr updatesr;
  readc ordersfl;
  dow not %EOF;
    chain (sts : ord# : prodno) myordprpl;
    if %found(myordprpl);
      exsr movesfl;
      update orderrec;
    endif;
    readc ordersfl;
  enddo;
endsr;

//---------------------------------------------------------
// MOVEDB - Move to Database Routine
begsr movedb;
  sqtyord = qtyord;
  sqtyhld = qtyhold;
  strack  = track;
  ssts    = sts;
endsr;

//---------------------------------------------------------
// MOVESFL - Move to Subfile Routine
begsr movesfl;
  qtyord  = sqtyord;
  qtyhold = sqtyhld;
  track   = strack;
  sts     = ssts;
endsr; 