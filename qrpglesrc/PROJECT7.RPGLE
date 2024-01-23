**Free

//-----------------------------------------------
// Program: PROJECT7                            *
// Programmer: Chase Timmons                    *
// Date: 10/21/2021                             *
// Purpose: Calculate retirement dates for      *
//          Wibaux Univ. professors             *
//-----------------------------------------------

//----- Control Options ----------------------------------
Ctl-opt Option(*SRCSTMT: *NODEBUGIO);
Ctl-opt Datfmt(*USA);

//----- Declare Files ------------------------------------
Dcl-f Instructlf Disk    Usage(*Input) Keyed;
Dcl-f Retirerep  Printer Usage(*Output) Oflind(EndOfPage);

//----- Stand-Alone Variables ----------------------------
Dcl-s EndOfPage Ind     Inz(*On);

Dcl-s Today     Date Inz(*Sys);
Dcl-s Combined  Char(30);     // Combined first and last name
Dcl-s Hiredate  Date;         // Converted date of hire
Dcl-s Rdate     Date;         // Eligible retirement date
Dcl-s Ryears    Zoned(2:0);   // Years to retirement
Dcl-s Avgwage   Zoned(9:2);   // Average instructor salary
Dcl-s Count     Zoned(4:0);   // Number of professors

//----- Main Procedure -----------------------------------
READ Instructlf;

   DOW NOT %EOF;
      // Combined first and last name
      Combined = %Trim(IFNAME) + ' ' + %Trim(ILNAME);
      // Converted numeric date of hire to date format
      Hiredate = %Date(HIRDAT);
      // Calculate eligible retirement date
      Rdate = Hiredate + %Years(30);
      // Calculate number of years remaining until retirement
      Ryears = %Diff(Rdate:Today:*Years);

      // Calculate footer data
      Avgwage += SALARY;
      Count += 1;

      If EndOfPage;
         WRITE Headings;
         EndOfPage = *Off;
      EndIf;

      WRITE Detail;
      READ Instructlf;
   ENDDO;

 // Calculate average wage and print footer
 Avgwage /= Count;
 WRITE Footer;

*INLR = *ON;
RETURN; 