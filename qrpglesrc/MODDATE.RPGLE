**free

//-----------------------------------------------
// MODULE -- MODDATE                            *
// Programmer: Chase Timmons                    *
// Date: 3/24/2022                              *
// Purpose: Module for setting an email         *
//          reminder date                       *
// Called By: Any program or module             *
// Revisions:                                   *
//-----------------------------------------------

// Control Options
Ctl-opt NoMain;

// Prototype
Dcl-pr MakeDate Date;
  *N Packed(8:0) Value;
End-pr;

// Procedure
Dcl-proc MakeDate Export;

  // Procedure Interface
  Dcl-pi *N Date;
    DateIn  Packed(8:0) Value;
  End-pi;

  // Standalone Variables
  Dcl-s DateOut Date;

  // Work Field
  Dcl-s #WDate Date;
  #WDate = %Date(DateIn:*USA) + %Days(30);

  // Set email reminder for 30 days out
  DateOut = #WDate;// + %Days(30);

  Return DateOut;  // Return DateOut to calling program/module
End-proc MakeDate; 