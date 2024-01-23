**free

//-----------------------------------------------
// MODULE -- MODFOUR                            *
// Programmer: Chase Timmons                    *
// Date: 3/24/2022                              *
// Purpose: Module to get the last four         *
//          digits of the customer phone #      *
// Called By: Any program or module             *
// Revisions:                                   *
//-----------------------------------------------

// Control options
Ctl-opt NoMain;

// Prototype
Dcl-pr MakeFour Char(4);
  *N Packed(10:0) Value;
End-pr;

// Procedure
Dcl-proc MakeFour Export;

  // Procedure Interface
  Dcl-pi *N Char(4);
    PhoneIn Packed(10:0) Value;
  End-pi;

  //Standalone Variables
  Dcl-s LastFour Char(4);

  // Get the last four digits of the phone number
  LastFour = %Subst(%Char(PhoneIn):7:4);

  Return LastFour; // Return LastFour to calling program/module
End-proc MakeFour; 