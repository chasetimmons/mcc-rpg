**Free

//-----------------------------------------------
// Program: PROJECT5                            *
// Programmer: Chase Timmons                    *
// Date: 10/05/2021                             *
// Purpose: Generate a summary report of        *
//          student residency population        *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Wustdp   Disk    Usage(*Input);
Dcl-f Wustsum2 Printer Usage(*Output) Oflind(EndOfPage);

//----- Stand Alone Variables ----------------------------
Dcl-s EndOfPage Ind     Inz(*On);

// Freshman
Dcl-s FrshICnt         Zoned(4:0);
Dcl-s FrshOCnt         Zoned(4:0);
Dcl-s FrshFCnt         Zoned(4:0);
Dcl-s FrshTot          Zoned(5:0);

// Sophmores
Dcl-s SophICnt         Zoned(4:0);
Dcl-s SophOCnt         Zoned(4:0);
Dcl-s SophFCnt         Zoned(4:0);
Dcl-s SophTot          Zoned(5:0);

// Juniors
Dcl-s JunrICnt         Zoned(4:0);
Dcl-s JunrOCnt         Zoned(4:0);
Dcl-s JunrFCnt         Zoned(4:0);
Dcl-s JunrTot          Zoned(5:0);

// Seniors
Dcl-s SenrICnt         Zoned(4:0);
Dcl-s SenrOCnt         Zoned(4:0);
Dcl-s SenrFCnt         Zoned(4:0);
Dcl-s SenrTot          Zoned(5:0);

// Totals
Dcl-s InDistTot        Zoned(5:0);
Dcl-s OutDistTot       Zoned(5:0);
Dcl-s IntTot           Zoned(5:0);
Dcl-s GrandTotal       Zoned(6:0);

//----- Main Procedure -----------------------------------
READ Wustdp;
   DOW NOT %EOF;
      IF Class = 'U';
        IF Crdtot < 30;
           EXSR Freshman;
        ELSEIF Crdtot < 60;
           EXSR Sophmore;
        ELSEIF Crdtot < 90;
           EXSR Junior;
        ELSE;
           EXSR Senior;
        ENDIF;
      ENDIF;

      READ Wustdp;
   ENDDO;
   EXSR PrintSum;
*INLR = *ON;
RETURN;

// Subroutine to calculate freshman totals
BEGSR Freshman;
  FrshTot += 1;
  SELECT;
    WHEN DCODE = 'I';
      FrshICnt += 1;
    WHEN DCODE = 'O';
      FrshOCnt += 1;
    WHEN DCODE = 'F';
      FrshFCnt += 1;
  ENDSL;
ENDSR;

// Subroutine to calculate sophmore totals
BEGSR Sophmore;
  SophTot += 1;
  SELECT;
    WHEN DCODE = 'I';
      SophICnt += 1;
    WHEN DCODE = 'O';
      SophOCnt += 1;
    WHEN DCODE = 'F';
      SophFCnt += 1;
  ENDSL;
ENDSR;

// Subroutine to calculate junior totals
BEGSR Junior;
  JunrTot += 1;
  SELECT;
    WHEN DCODE = 'I';
      JunrICnt += 1;
    WHEN DCODE = 'O';
      JunrOCnt += 1;
    WHEN DCODE = 'F';
      JunrFCnt += 1;
  ENDSL;
ENDSR;

// Subroutine to calculate senior totals
BEGSR Senior;
  SenrTot += 1;
  SELECT;
    WHEN DCODE = 'I';
      SenrICnt += 1;
    WHEN DCODE = 'O';
      SenrOCnt += 1;
    WHEN DCODE = 'F';
      SenrFCnt += 1;
  ENDSL;
ENDSR;

// Subroutine to print summary report
BEGSR PrintSum;
  InDistTot = FrshICnt + SophICnt + JunrICnt + SenrICnt;
  OutDistTot = FrshOCnt + SophOCnt + JunrOCnt + SenrOCnt;
  IntTot = FrshFCnt + SophFCnt + JunrFCnt + SenrFCnt;
  GrandTotal = InDistTot + OutDistTot + IntTot;

  WRITE Heading;
  WRITE Total;
ENDSR; 