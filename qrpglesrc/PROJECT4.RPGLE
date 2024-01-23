**Free

//-----------------------------------------------
// Program: PROJECT4                            *
// Programmer: Chase Timmons                    *
// Date: 09/29/2021                             *
// Purpose: Generate a payroll register for     *
//          hourly employees of Wibaux Univ     *
//-----------------------------------------------
// TODO: add in rounding to FICA

//----- Control Options ----------------------------------
Ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Wuhrlyp   Disk    Usage(*Input);
Dcl-f Wupayreg  Printer Usage(*Output) Oflind(EndOfPage);

//----- Declare Constants --------------------------------
Dcl-c FEDTAX           .18;            // Federal tax rate
Dcl-c STTAX            .05;            // State tax rate
Dcl-c FICA             .0751;          // FICA

//----- Stand Alone Variables ----------------------------
Dcl-s EndOfPage Ind     Inz(*On);

Dcl-s RegPay            Zoned(6:2);
Dcl-s OTPay             Zoned(6:2);
Dcl-s GrossPay          Zoned(6:2);
Dcl-s FedAmt            Zoned(6:2);
Dcl-s StateAmt          Zoned(5:2);
Dcl-s FICAAmt           Zoned(5:2);
Dcl-s Deductions        Zoned(6:2);
Dcl-s NetPay            Zoned(6:2);

Dcl-s TotalGross        Zoned(8:2);
Dcl-s TotalNet          Zoned(8:2);
Dcl-s TotalFed          Zoned(8:2);
Dcl-s TotalState        Zoned(7:2);
Dcl-s TotalFICA         Zoned(7:2);

// Get initial of first name
Dcl-ds *N;
  FName Char(10);
  FInit Char(1) Overlay(FName);
End-ds;


//----- Main Procedure -----------------------------------
READ Wuhrlyp;                               // Priming Read
   DOW NOT %EOF;                              // Check for end of file, begin loop
      RegPay = Rate * RegHrs;                    // Calculate regular pay
      OTPay = (Rate * 1.5) * OTHrs;              // Calculate overtime pay
      GrossPay = RegPay + OTPay;                 // Calculate gross pay
      Eval(h) FedAmt = GrossPay * FEDTAX;        // Calculate federal tax amount
      Eval(h) StateAmt = GrossPay * STTAX;       // Calculate state tax amount
      Eval(h) FICAAmt = GrossPay * FICA;         // Calculate FICA amount
      Deductions = FedAmt + StateAmt + FICAAmt;  // Calculate deductions
      NetPay = GrossPay - Deductions;            // Calculate net pay

      TotalGross += GrossPay;                    // Calculate total gross pay
      TotalNet += NetPay;                        // Calculate total net pay
      TotalFed += FedAmt;                        // Calculate total federal tax amount
      TotalState += StateAmt;                    // Calculate total state tax amount
      TotalFICA += FICAAmt;                      // Calculate total FICA amount

      If EndOfPage;                             // If indicator is on, do this
         WRITE Heading;                         // Write headings
         EndOfPage = *Off;                      // Turn indicator off
      EndIf;                                    // End if statement

      WRITE Detail;                           // Write a detail record to the report
      READ Wuhrlyp;                           // Get another record

   ENDDO;                                   // End loop

   WRITE Total;                            // Write totals line to report

*INLR = *ON;                // Turn on last record indicator
RETURN;                     // Return to OS or calling program
 