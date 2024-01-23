**free

//-----------------------------------------------
// Program: MAKEDATE                            *
// Programmer: Chase Timmons                    *
// Date: 3/09/2022                              *
// Purpose: Procedure for setting an email      *
//          reminder date                       *
// Called By: PRJ7CALLER                        *
// Revisions:                                   *
//-----------------------------------------------

// Prototype for MAKEDATE Main
Dcl-pr Main Extpgm('MAKEDATE');
  *N Packed(8:0);
  *N Date;
End-pr;

// Procedure Interface
Dcl-pi Main;
  DateIn  Packed(8:0);
  DateOut Date;
End-pi;

// Work Field
Dcl-s #WDate Date;
#WDate = %Date(DateIn:*USA) + %Days(30); // WORKS
//#WDate = %Date(DateIn) + %Days(30); // DOESNT WORK

// Set email reminder for 30 days out
DateOut = #WDate;// + %Days(30); // WORKS
//DateOut = %Date(#WDate:*USA); // DOESNT WORK

*Inlr = *On;
Return; 