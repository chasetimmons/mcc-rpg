*free
      // This program has some VERY BAD LOGIC in it.
      // Let's catch it with Monitor
      // This program uses only variables to test these techniques

      // There is no disk file
      // Declare your printer file here
       Dcl-f PROJ10ERR printer usage(*output) oflind(EndOfPage);

       // The standalone variables used to test our Monitor blocks
       Dcl-s Number1 Zoned(2:0);  // Note the size
       Dcl-s Number2 Zoned(2:0);
       Dcl-s AnArray Zoned(2:0)  Dim(5);  // a FIVE element array

       // Code your named constants for the status codes here
       Dcl-c DivByZero 00102;  // Divide by zero
       Dcl-c IndexOOB  00121;  // Array index out of bounds
       Dcl-c TooSmall  00103;  // Variable to small too hold result

       Write Heading;

       // Add in the necessary code to handle the errors....
       Monitor;
         // Let's practice catching a divide by zero error
         Number2 = 0;        // Number2 will be our denominator
         Number1 /= Number2; // this is illegal!!
       On-Error DivByZero;
         Write Error1;
       Endmon;

       // Let's practice catching an invalid array index
       Monitor;
         for Number1 = 1 to 9; // can't go this far in this array!!
           AnArray(Number1) = 22;
         endfor;
       On-Error IndexOOB;
         Write Error2;
       Endmon;

       // Let's practic catching a Variable to Small to Hold Result Error
       Monitor;
         Number1 = 999999;  // Variable is too small to hold this!!
         On-Error TooSmall;
         Write Error3;
       Endmon;

       *INLR = *ON;  // Terminate Program
       RETURN; 