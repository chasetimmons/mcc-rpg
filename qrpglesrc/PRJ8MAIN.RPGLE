**free

//-----------------------------------------------
// MODULE -- PRJ8MAIN                           *
// Programmer: Chase Timmons                    *
// Date: 3/24/2022                              *
// Purpose: Module that serves as an entry      *
//          point when bound with other modules *
// Revisions:                                   *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Cscstp Disk    Usage(*Input);
Dcl-f PROJ7  Printer Usage(*Output) Oflind(EndOfPage);

//----- Procedure Prototypes -----------------------------
Dcl-pr Main Extpgm('PRJ8MAIN') End-pr;
Dcl-pi Main End-pi;

// Prototype for MAKEID
Dcl-pr MakeID Char(33);
  *N Char(10) Value;
  *N Char(15) Value;
  *N Packed(6:0) Value;
End-pr;

// Prototype for MAKEPASS
Dcl-pr MakePass Char(9);
  *N Char(10) Value;
  *N Char(15) Value;
  *N Packed(6:0) Value;
End-pr;

// Prototype for MAKEFOUR
Dcl-pr MakeFour Char(4);
  *N Packed(10:0) Value;
End-pr;

// Prototype for MAKEDATE
Dcl-pr MakeDate Date;
  *N Packed(8:0) Value;
End-pr;

//----- Stand-Alone Variables ----------------------------
Dcl-s EndOfPage Ind     Inz(*On);

// Defined in DDS file PROJ7
//  UserID Char(33)
//  Password Char(9)
//  PFour Char(4)
//  Reminder Date

//----- Main Procedure -----------------------------------
Read Cscstp;

   Dow Not %EOF;

     // Create UserID from fname, lname, and custno
     UserId = MakeID(CFNAME:CLNAME:CUSTNO);

     // Create Password from fname, lname, custno, and an !
     Password = MakePass(CFNAME:CLNAME:CUSTNO);

     // Get last four digits of customer phone number
     PFour = MakeFour(CPHONE);

     // Set a reminder date of 30 days after the order date
     Reminder = MakeDate(ORDDAT);

     If EndOfPage;
         Write Heading;
         EndOfPage = *Off;
      EndIf;

      Write Detail;
      Read Cscstp;

   Enddo;

 *Inlr = *ON;
Return; 