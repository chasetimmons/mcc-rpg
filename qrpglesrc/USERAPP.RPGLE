       // *******************************************************************
       // This program calls a service program to generate a User ID        *
       // and Password, given screen inputs of User's number, first name,   *
       // and last name                                                     *
       //     Author:  RPG Class Winter 2019                                *
       // *******************************************************************

       // Control Options
       Ctl-opt option(*SRCSTMT : *NODEBUGIO);

       // Workstation File
       Dcl-f USERSCREEN Workstn Indds(Indicators);

       // Indicators for the Screen
       Dcl-ds Indicators Len(99);
         Exit  Ind Pos(3);   // F3 = Exit
         Cancel Ind Pos(12); // F12 = Cancel
       End-ds;

       // PROTOTYPES
       // CODE THE MAIN PROTOTYPE and PROCEDURE INTERFACE HERE
       Dcl-pr Main Extpgm('USERAPP') End-pr;
       Dcl-pi Main End-pi;

       // CODE THE PROTOTYPES HERE TO MATCH PROTOTYPES INSIDE MODID and MODPASS
       Dcl-pr MakeId Char(33);
         *N Char(10) Value;
         *N Char(15) Value;
         *N Packed(6:0) Value;
       End-pr;

       Dcl-pr MakePass Char(9);
         *N Char(10) Value;
         *N Char(15) Value;
         *N Packed(6:0) Value;
       End-pr;

       // Logic
       DOW NOT Exit;
         EXFMT Scrn1;  // Display the Prompt Srceen
            //  Only Display 2nd screen if they didn't press Exit
           If NOT Exit;
           // un-comment these two lines below and complete them with the calls
                USERID = MakeId(USERFIRST:USERLAST:USERNO);
                PASSWORD = MakePass(USERFIRST:USERLAST:USERNO);
             EXFMT Scrn2; // Display the UserID and Password on Screen 2
           EndIf;
       ENDDO;
       // Terminate Program
       *INLR = *ON;
       RETURN; 