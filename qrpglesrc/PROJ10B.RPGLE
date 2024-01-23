**free

//-----------------------------------------------
// Program: PROJECT10B                          *
// Programmer: Chase Timmons                    *
// Date: 4/07/2022                              *
// Purpose: Update GTC Telephone Co. customer   *
//          master file based on data contained *
//          in payments transactions file       *
// Revisions:                                   *
//       4/07/22  Added subroutines        ct1  *
//       4/07/22  Added error handling     ct2  *
//       4/07/22  Improved error handling  ct3  *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f mycstp  disk    usage(*update) keyed;
dcl-f gtcpayp disk    usage(*input)  keyed;
dcl-f proj10  printer usage(*output) oflind(EndOfPage);

//----- Stand-Alone Variables ----------------------------
dcl-s EndOfPage ind inz(*on);
dcl-s toterr zoned(3:0); // Total Errors

//----- Main Procedure -----------------------------------
monitor;

  read gtcpayp;
  dow not %eof;
     if EndOfPage;
        write heading;
        EndOfPage = *Off;
     endif;

     close mycstp;        //ct2 - ERROR

     chain cphone mycstp;
     select;
       when %found(mycstp);
        Exsr ProcessCust; //ct1
    // when %error;       //ct2
    //  Exsr FileErr;     //ct2
       other;
        Exsr NotFound;    //ct1
     endsl;

     read gtcpayp;
  enddo;

  write total;

// Error-Handling         //ct3
on-error *file;           //ct3
  Exsr FileError;         //ct3
on-error *all;            //ct3
  Exsr FatalError;        //ct3

endmon;

*inlr = *on;
return;

// PROCESSCUST Subroutine ---------------------------
// Updates the customer file and prints detail line
Begsr ProcessCust;        //ct1
  amtowe -= amtpd;
  paydatl = datrcvl;
  paydat = datrcv;
  update cusrec %fields(amtowe : paydatl : paydat);
  write detail;
Endsr;

// NOTFOUND Subroutine ------------------------------
// Writes error line and increments error counter
Begsr NotFound;           //ct1
  toterr += 1;
  write detail;
  write error;
Endsr;

// FILEERR Subroutine -------------------------------
// Writes file error line and terminated the program
Begsr FileError;          //ct2
  write fileerr;
  *inlr = *on;
  return;
ENDSR;

// FATALERR Subroutine -------------------------------
// Writes fatal error line and terminated the program
Begsr FatalError;         //ct3
  write fatalerr;
  *inlr = *on;
  return;
ENDSR; 