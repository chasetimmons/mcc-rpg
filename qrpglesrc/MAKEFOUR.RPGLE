**free

//-----------------------------------------------
// Program: MAKEFOUR                            *
// Programmer: Chase Timmons                    *
// Date: 3/09/2022                              *
// Purpose: Procedure to get the last four      *
//          digits of the customer phone #      *
// Called By: PRJ7CALLER                        *
// Revisions:                                   *
//-----------------------------------------------

// Prototype for MAKEFOUR Main
Dcl-pr Main Extpgm('MAKEFOUR');
  *N Packed(10:0) Const;
  *N Char(4);
End-pr;

// Procedure Interface
Dcl-pi Main;
  PhoneIn  Packed(10:0) Const;
  LastFour Char(4);
End-pi;

// Get the last four digits of the phone number
LastFour = %Subst(%Char(PhoneIn):7:4);

*Inlr = *On;
Return; 