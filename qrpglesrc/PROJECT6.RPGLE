**Free

//-----------------------------------------------
// Program: PROJECT6                            *
// Programmer: Chase Timmons                    *
// Date: 10/08/2021                             *
// Purpose: Create a customer report and        *
//          generate username/password          *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Cscstp    Disk    Usage(*Input);
Dcl-f Cscreport Printer Usage(*Output) Oflind(EndOfPage);

//----- Constant Variables -------------------------------
Dcl-c Uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Dcl-c Lowercase 'abcdefghijklmnopqrstuvwxyz';

//----- Stand-Alone Variables ----------------------------
Dcl-s EndOfPage Ind     Inz(*On);

Dcl-s UserID    Char(33);
Dcl-s Password  Char(9);
Dcl-s Name      Char(26);
Dcl-s Zip       Char(10);
Dcl-s Phone     Char(14);
Dcl-s Balance   Char(8);
Dcl-s YearIn    Varchar(8);
Dcl-s YearOut   Char(4);

//----- Main Procedure -----------------------------------
READ Cscstp;

   DOW NOT %EOF;
      // Concatenate first name, last name, and userid
      UserID = %Xlate(Uppercase:Lowercase:%Trim(CFNAME)) + '.' +
               %Xlate(Uppercase:Lowercase:%Trim(CLNAME)) + '.' +
               %Char(CUSTNO);

      // Create password using first and last initial, customer number, and !
      Password = %Xlate(Uppercase:Lowercase:%Subst(CFNAME:1:1)) +
                 %Xlate(Uppercase:Lowercase:%Subst(CLNAME:1:1)) +
                 %Char(CUSTNO) + '!';

      // Concatenate first and last name to create a printable full name
      Name = %Trim(%Xlate(Uppercase:Lowercase:%Trim(CFNAME):2) +
             ' ' + %Xlate(Uppercase:Lowercase:%Trim(CLNAME):2));

      // Format the zip code
      Zip = %Editw(%Dec(CZIP:9:0):'     -    ');

      // Format the phone number
      Phone = %Editw(CPHONE:'0(   )   -    ');

      // Extract year from last order date
      YearIn = %Char(ORDDAT);
      If %Len(YearIn) = 7;
        YearOut = %Subst(YearIn:4:4);
      Else;
        YearOut = %Subst(YearIn:5:4);
      Endif;

      // Format balance due
      Balance = %Trim(%Editc(BALDUE:'1'));

      If EndOfPage;
         WRITE Heading;
         EndOfPage = *Off;
      EndIf;

      WRITE Detail;
      READ Cscstp;
   ENDDO;

*INLR = *ON;
RETURN; 