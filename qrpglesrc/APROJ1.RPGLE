**Free

// Program:  APROJ1
// Programmer:  Chase Timmons
// Date Created: 1/5/22
// Revisions:
// Purpose:  Calculates percentage for student assignment and assigns a letter
// grade.

//----- Control Options -----------------------------------
Ctl-opt option(*srcStmt: *noDebugIO);

//----- File Declarations ---------------------------------
Dcl-f POINTSFILE Disk    Usage(*Input);
Dcl-f APROJ1PRT  Printer Usage(*Output);

//----- Stand Alone Variables -----------------------------
Dcl-s PERCENTAGE Zoned(3:0);
Dcl-s GRADE      Char(1);

//----- Main Procedure ------------------------------------
Write HEADING;
Read POINTSFILE;

Dow Not %EOF;
  Eval(H) PERCENTAGE = PTSRECEIVE / PTSPOSSIBL * 100;
  Select;
  When PERCENTAGE > 89;
    GRADE = 'A';
  When PERCENTAGE > 79;
    GRADE = 'B';
  When PERCENTAGE > 69;
    GRADE = 'C';
  When PERCENTAGE > 59;
    GRADE = 'D';
  Other;
    GRADE = 'E';
  Endsl;

  Write DETAIL;
  Read POINTSFILE;
Enddo;

*INLR = *ON;
Return; 