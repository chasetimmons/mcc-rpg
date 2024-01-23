**free

//-----------------------------------------------
// MODULE -- MODPASS                            *
// Programmer: Chase Timmons                    *
// Date: 3/24/2022                              *
// Purpose: Module to create a password from    *
//          fname, lname, and custno            *
// Called By: Any program or module             *
// Revisions:                                   *
//-----------------------------------------------

// Control Options
Ctl-opt NoMain;

// Prototype
Dcl-pr MakePass Char(9);
  *N Char(10) Value;
  *N Char(15) Value;
  *N Packed(6:0) Value;
End-pr;

// Procedure
Dcl-proc MakePass Export;

  // Procedure Interface
  Dcl-pi *N Char(9);
    FirstIn  Char(10) Value;
    LastIn   Char(15) Value;
    IDIn     Packed(6:0) Value;
  End-pi;

  // Standalone Variables
  Dcl-s Password Char(9);

  // Constant Variables
  Dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

  // Create password using first and last initial, custno, and !
  Password = %Xlate(Uppercase:Lowercase:%Subst(FirstIn:1:1)) +
             %Xlate(Uppercase:Lowercase:%Subst(LastIn:1:1)) +
             %Char(IDIn) + '!';

  Return Password; // Return Password to calling program/module
End-proc MakePass; 