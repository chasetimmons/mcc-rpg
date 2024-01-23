**free

//-----------------------------------------------
// Program: PRJ7CALLER                          *
// Programmer: Chase Timmons                    *
// Date: 3/09/2022                              *
// Purpose: Creates a report to display         *
//          customer account info               *
// Revisions:                                   *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Cscstp Disk    Usage(*Input);
Dcl-f PROJ7  Printer Usage(*Output) Oflind(EndOfPage);

//----- Procedure Prototypes -----------------------------
Dcl-pr Main Extpgm('PR7CALLER') End-pr;
Dcl-pi Main End-pi;

// Prototype for MAKEID
Dcl-pr MakeID Extpgm('MAKEID');
  *N Char(10) Const;
  *N Char(15) Const;
  *N Packed(6:0) Const;
  *N Char(33);
End-pr;

// Prototype for MAKEPASS
Dcl-pr MakePass Extpgm('MAKEPASS');
  *N Char(10) Const;
  *N Char(15) Const;
  *N Packed(6:0) Const;
  *N Char(9);
End-pr;

// Prototype for MAKEFOUR
Dcl-pr MakeFour Extpgm('MAKEFOUR');
  *N Packed(10:0) Const;
  *N Char(4);
End-pr;

// Prototype for MAKEDATE
Dcl-pr MakeDate Extpgm('MAKEDATE');
  *N Packed(8:0) Const;
  *N Date;
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
     MakeID(CFNAME:CLNAME:CUSTNO:UserId);

     // Create Password from fname, lname, custno, and an !
     MakePass(CFNAME:CLNAME:CUSTNO:Password);

     // Get last four digits of customer phone number
     MakeFour(CPHONE:PFour);

     // Set a reminder date of 30 days after the order date
     MakeDate(ORDDAT:Reminder);

     If EndOfPage;
         WRITE Heading;
         EndOfPage = *Off;
      EndIf;

      Write Detail;
      Read Cscstp;

   Enddo;

 *Inlr = *ON;
Return; 