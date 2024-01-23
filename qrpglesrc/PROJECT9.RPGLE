**Free

//-----------------------------------------------
// Program: PROJECT9                            *
// Programmer: Chase Timmons                    *
// Date: 11/10/2021                             *
// Purpose: Display an inquiry screen to search *
//          product suppliers                   *
//-----------------------------------------------

//----- Control Options ----------------------------------
ctl-opt Option(*NODEBUGIO);

//----- Declare Files ------------------------------------
dcl-f csinvp Disk    Usage(*Input)  Keyed;
dcl-f cssupp Disk    Usage(*Input)  Keyed;
dcl-f inqscreen Workstn Indds(Indicators);

//----- Indicator Data Structure -------------------------
dcl-ds Indicators Len(99);
  Exit Ind Pos(3);     // F3=Exit
  BadProd Ind Pos(90); // Invalid product number
  BadSupp Ind Pos(95); // Supplier not found
end-ds;

//----- Main Procedure -----------------------------------
dow not Exit;
  exfmt scrn1;
  if not Exit;
    // use the product number entered on scrn1 as the key to chain to csinvp file
    chain PRODIN csinvp;
    if %found(csinvp);
      // use the supplier code to chain
      chain supcod cssupp;
      if %found(cssupp);
        exfmt scrn2;
      else;
        // dispaly bad supplier message
        BadSupp = *on;
      endif;
    else;
      // display bad product message
      BadProd = *on;
    endif;
  endif;
enddo;

*inlr = *on;
return; 