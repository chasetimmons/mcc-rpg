     HOption(*NODEBUGIO)

     FCsinvp    IF   E             Disk
     FInvreport O    E             Printer Oflind(EndOfPage)

     D EndOfPage       S               N   Inz(*On)

     C                   Read      Csinvp                                       Priming Read
     C                   Dow       Not %EOF()
     C                   If        EndOfPage
     C                   Write     Heads
     C                   Move      *Off          EndOfPage
     C                   Endif
     C                   Write     Detail
     C                   Read      Csinvp
     C                   Enddo

     C                   If        EndOfPage
     C                   Write     Heads
     C                   Endif
     C                   Eval      *Inlr = *On
     C                   Return 