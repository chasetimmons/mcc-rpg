**free

//-----------------------------------------------
// Program: PROJECT6                            *
// Programmer: Chase Timmons                    *
// Date: 2/17/2022                              *
// Purpose: Program to maintain instructor file *
//          for Wibaux U.                       *
// Revisions: 3/3/22 Changed mode text behavior *
//-----------------------------------------------

//----- Control Options ------------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files --------------------------------------
dcl-f myinstp Disk Usage(*Update : *Output : *Delete) Keyed;
dcl-f proj6 Workstn  Indds(Indicators);

//----- Constant Variables ---------------------------------
dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

//----- Indicator Data Structure ---------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);         // F3=Exit
  DltKey Ind Pos(10);      // F10=Delete
  Cancel Ind Pos(12);      // F12=Cancel
  FKey Ind Pos(25);        // VldCmdKey
  AddError  Ind Pos(30);   // 'Customer already exists'
  ChgError  Ind Pos(31);   // 'Customer not found'
  DltError  Ind Pos(32);   // 'Customer not found'
  ModeError Ind Pos(33);   // 'Invalid action code'
  AddMode   Ind Pos(40);   // A = Add
  ChgMode   Ind Pos(41);   // C = Change
  DltMode   Ind Pos(42);   // D = Delete
end-ds;

//----- Main Procedure -------------------------------------
dow not Exit;

  exfmt getinst;
  select;
    when Exit;
      Leave;
    when MODE = 'A';
      exsr addrecord;
    when MODE = 'C';
      exsr chgrecord;
    when MODE = 'D';
      exsr dltrecord;
    other;
      ModeError = *on;
  endsl;

enddo;

*inlr = *on;
return;

// -----------------------------------------------------------
// AddRecord Subroutine - adds a new instructor record
begsr addrecord;
  chain instno myinstp;  //***
  AddError = %found(myinstp);

  if not AddError;
    AddMode = (MODE = 'A');
    exsr clear;
    exfmt setinst;

    if not fkey;
      hirdat = %dec(datein);
      write instrec;
      reset MODE;
      reset instno;
    endif;

  endif;
endsr;

// -----------------------------------------------------------
// ChgRecord Subroutine - edits an instructor record
begsr chgrecord;
  chain instno myinstp;  //***
  ChgError = not %found(myinstp);

  if not ChgError;
    ChgMode = (MODE = 'C');
    datein = %date(hirdat);
    exfmt setinst;

    if not fkey;
      hirdat = %dec(datein);
      update instrec;
      reset MODE;
      reset instno;
    endif;

  endif;
  // **Note: the text associated with change mode would not turn
  //         off if F12 was used. This line resets it.
  reset ChgMode;
endsr;

// -----------------------------------------------------------
// DelRecord Subroutine - deletes an instructor record
begsr dltrecord;
  chain instno myinstp;   //***
  DltError = not %found(myinstp);

  if not DltError;
    DltMode = (MODE = 'D');
    datein = %date(hirdat);
    exfmt setinst;

    if dltkey;
      delete instrec;
      reset MODE;
      reset instno;
    endif;

  endif;
  // **Note: the fkeys associated with delete mode would not turn
  //         off if F12 was used. This line resets it.
  reset DltMode;
endsr;

// -----------------------------------------------------------
// Clear Subroutine - clears/resets all fields for display
begsr clear;
  reset ifname;     // first name
  reset ilname;     // last name
  reset dept;       // department
  reset salary;     // salary
  reset rank;       // rank
  reset sex;        // gender
  reset hirdat;     // date of hire
  reset marsts;     // marital status
  reset depend;     // number of dependents
  reset tenure;     // tenure (y/n)
  reset title;      // title
  datein = *loval;  // resets date on screen
endsr; 