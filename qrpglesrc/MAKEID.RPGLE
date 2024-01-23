**free

//-----------------------------------------------
// Program: MAKEID                              *
// Programmer: Chase Timmons                    *
// Date: 3/09/2022                              *
// Purpose: Procedure to create a user ID from  *
//          fname, lname, and custno            *
// Called By: PRJ7CALLER                        *
// Revisions:                                   *
//-----------------------------------------------

// Prototype for MAKEID Main
Dcl-pr Main Extpgm('MAKEID');
  *N Char(10) Const;
  *N Char(15) Const;
  *N Packed(6:0) Const;
  *N Char(33);
End-pr;

// Procedure Interface
Dcl-pi Main;
  FirstIn Char(10) Const;
  LastIn  Char(15) Const;
  IDIn    Packed(6:0) Const;
  UserId  Char(33);
End-pi;

// Constant Variables
dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

// Concatenate first name, last name, and userid
 UserID = %Xlate(Uppercase:Lowercase:%Trim(FirstIn)) + '.' +
          %Xlate(Uppercase:Lowercase:%Trim(LastIn)) + '.' +
          %Char(IDIn);

*Inlr = *On;
Return; 