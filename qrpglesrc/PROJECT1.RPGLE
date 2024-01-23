**Free

//-----------------------------------------------
// Program: PROJECT1                            *
// Programmer: Chase Timmons                    *
// Date: 08/25/2021                             *
// Purpose: Create an inventory master report   *
//          for CloudServices24x7 Inc.          *
//-----------------------------------------------


//----- Control Options ----------------------------------
Ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
Dcl-f Csinvp    Disk    Usage(*Input);
Dcl-f Invreport Printer Usage(*Output) Oflind(EndOfPage);

Dcl-s EndOfPage Ind     Inz(*On);

//----- Main Procedure -----------------------------------
READ Csinvp;                // Priming Read
   DOW NOT %EOF;            // Check for end of file, begin loop
      If EndOfPage;         // If indicator is on, do this
         WRITE Heads;       // Write headings
         EndOfPage = *Off;  // Turn indicator off
      EndIf;                // End if statement
      WRITE Detail;         // Write a detail record to the report
      READ Csinvp;          // Get another record
   ENDDO;                   // End loop
*INLR = *ON;                // Turn on last record indicator
RETURN;                     // Return to OS or calling program 