     HOPTION(*NODEBUGIO)
      *--------------------------------------------------------------
      * PROGRAM: Project 11
      * BY: Chase Timmons
      * DATE: 12/1/2021
      * PURPOSE: Produce an inventory report for CloudServices24x7
      *--------------------------------------------------------------
     FCSINVP    IF   F   92        DISK
     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
     ICSINVP    NS
     I                                  1    6 0PRODNO
     I                                 11   50  DESCRP
     I                                 51   56 2SELLPR
     I                                 57   61  SHIPWT
     I                             P   62   64 0QTYOH
     I                             P   65   67 0RORPNT
     I                             P   68   70 0RORQTY
     I                                 75   80 2SHPCST
     I                                 81   86 2CURCST
     I                                 87   92 2AVGCST
      /FREE
       EXCEPT HEADINGS;
       READ CSINVP;
       DOW NOT %EOF;
         IF *INOF;
            EXCEPT HEADINGS;
            *INOF = *OFF;
         ENDIF;
         EXCEPT DETAIL;
         READ CSINVP;
       ENDDO;
       EVAL *INLR = *ON;
       RETURN;
      /END-FREE
     OQPRINT    E            HEADINGS       1 01
     O                       *DATE         Y     11
     O                                           73 'CloudServices24x7, Inc.'
     O                                          118 'Page'
     O                       PAGE               128
     O          E            HEADINGS       2
     O                                           73 'Inventory Master Report'
     O          E            HEADINGS       1
     O                                            6 'Prod.'
     O                                           57 'Weight'
     O                                           67 'Qty On'
     O                                           77 'Reorder'
     O                                           86 'Reorder'
     O                                           97 'Shipping'
     O                                          108 'Average'
     O                                          118 'Current'
     O                                          128 'Selling'
     O          E            HEADINGS       1
     O                                            5 'Num.'
     O                                           21 'Description'
     O                                           57 'Lbs-Oz'
     O                                           65 'Hand'
     O                                           75 'Point'
     O                                           82 'Qty'
     O                                           95 'Cost'
     O                                          107 'Cost'
     O                                          117 'Cost'
     O                                          127 'Cost'
     O          E            DETAIL         1
     O                       PRODNO               7
     O                       DESCRP              50
     O                       SHIPWT              56
     O                       QTYOH         Z     66
     O                       RORPNT        Z     75
     O                       RORQTY        Z     84
     O                       SHPCST        A     97
     O                       AVGCST        A    110
     O                       CURCST        A    120
     O                       SELLPR        A    130 