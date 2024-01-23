**free

//-----------------------------------------------
// Program: MAKEPASS                            *
// Programmer: Chase Timmons                    *
// Date: 3/09/2022                              *
// Purpose: Procedure to create a password from *
//          fname, lname, and custno            *
// Called By: PRJ7CALLER                        *
// Revisions:                                   *
//-----------------------------------------------

// Prototype for MAKEPASS Main
Dcl-pr Main Extpgm('MAKEPASS');
  *N Char(10) Const;
  *N Char(15) Const;
  *N Packed(6:0) Const;
  *N Char(9);
End-pr;

// Procedure Interface
Dcl-pi Main;
  FirstIn  Char(10) Const;
  LastIn   Char(15) Const;
  IDIn     Packed(6:0) Const;
  Password Char(9);
End-pi;

// Constant Variables
dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

// Create password using first and last initial, customer number, and !
Password = %Xlate(Uppercase:Lowercase:%Subst(FirstIn:1:1)) +
           %Xlate(Uppercase:Lowercase:%Subst(LastIn:1:1)) +
           %Char(IDIn) + '!';

*Inlr = *On;
Return; 