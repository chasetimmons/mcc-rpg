**Free

//-----------------------------------------------
// Program: PROJECT2                            *
// Programmer: Chase Timmons                    *
// Date: 09/06/2021                             *
// Purpose: Create a GTC customer account       *
//          report                              *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Gtcstp    Disk    Usage(*Input);
Dcl-f Gtcreport Printer Usage(*Output) Oflind(EndOfPage);

Dcl-s EndOfPage Ind     Inz(*On);

//----- Main Procedure -----------------------------------
READ Gtcstp;                // Priming Read
   DOW NOT %EOF;            // Check for end of file, begin loop
      If EndOfPage;         // If indicator is on, do this
         WRITE Heading;     // Write headings
         EndOfPage = *Off;  // Turn indicator off
      EndIf;                // End if statement
      WRITE Detail;         // Write a detail record to the report
      READ Gtcstp;          // Get another record
   ENDDO;                   // End loop
*INLR = *ON;                // Turn on last record indicator
RETURN;                     // Return to OS or calling program 