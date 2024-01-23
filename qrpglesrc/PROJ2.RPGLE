**free

//-----------------------------------------------
// Program: PROJECT2                            *
// Programmer: Chase Timmons                    *
// Date: 1/10/2022                              *
// Purpose: Update GTC Telephone Co. customer   *
//          master file based on data contained *
//          in payments transactions file       *
// Revisions:                                   *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt option(*SRCSTMT : *NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f mycstp  disk    usage(*update) keyed;
dcl-f gtcpayp disk    usage(*input) keyed;
dcl-f proj2   printer usage(*output) oflind(EndOfPage);

//----- Stand-Alone Variables ----------------------------
dcl-s EndOfPage ind inz(*on);
dcl-s toterr zoned(3:0); // Total Errors

//----- Main Procedure -----------------------------------
read mycstp;
dow not %eof;
   if EndOfPage;
      write heading;
      EndOfPage = *Off;
   endIf;

   chain cphone gtcpayp;
   if %found(gtcpayp);
     amtowe -= amtpd;
     paydatl = datrcvl;
     paydat = datrcv;
     update cusrec %fields(amtowe : paydatl : paydat);
     write detail;
   else;
     toterr += 1;
     write error;
   endif;

   read mycstp;
enddo;

write total;

*inlr = *on;
return; 