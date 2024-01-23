**free

//-----------------------------------------------
// MODULE -- MODID                              *
// Programmer: Chase Timmons                    *
// Date: 3/24/2022                              *
// Purpose: Module to create a user ID from     *
//          fname, lname, and custno            *
// Called By: Any program or module             *
// Revisions:                                   *
//-----------------------------------------------

// Control Options
Ctl-opt NoMain;

// Prototype
Dcl-pr MakeId Char(33);
  *N Char(10) Value;
  *N Char(15) Value;
  *N Packed(6:0) Value;
End-pr;

// Procedure
Dcl-proc MakeId Export;

  // Procedure Interface
  Dcl-pi *N Char(33);
    FirstIn Char(10) Value;
    LastIn  Char(15) Value;
    IDIn    Packed(6:0) Value;
  End-pi;

  // Standalone Variables
  Dcl-s UserId Char(33);

  // Constant Variables
  Dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

  // Concatenate first name, last name, and userid
   UserID = %Xlate(Uppercase:Lowercase:%Trim(FirstIn)) + '.' +
            %Xlate(Uppercase:Lowercase:%Trim(LastIn)) + '.' +
            %Char(IDIn);

  Return UserId;  // Return UserId to calling program/module
End-proc MakeId; 