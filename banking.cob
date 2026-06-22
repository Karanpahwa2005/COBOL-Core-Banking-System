>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. BANKING-SYSTEM.
AUTHOR. KARAN.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT OPTIONAL ACCT-FILE ASSIGN TO "accounts.dat"
        ORGANIZATION IS SEQUENTIAL.
    SELECT TEMP-FILE ASSIGN TO "temp.dat"
        ORGANIZATION IS SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  ACCT-FILE.
01  ACCT-RECORD.
    05  REC-ID           PIC X(5).
    05  REC-NAME         PIC X(20).
    05  REC-BALANCE      PIC 9(7)V99.

FD  TEMP-FILE.
01  TEMP-RECORD.
    05  TEMP-ID          PIC X(5).
    05  TEMP-NAME        PIC X(20).
    05  TEMP-BALANCE     PIC 9(7)V99.

WORKING-STORAGE SECTION.
01  WS-CHOICE            PIC X.
01  WS-EXIT-FLAG         PIC X VALUE 'N'.
01  WS-FOUND             PIC X.
01  WS-EOF               PIC X VALUE 'N'.

01  WS-SEARCH-ID         PIC X(5).
01  WS-AMOUNT            PIC 9(7)V99.
01  WS-DISPLAY-BAL       PIC Z,ZZZ,ZZ9.99.

PROCEDURE DIVISION.
MAIN-LOGIC.
    PERFORM UNTIL WS-EXIT-FLAG = 'Y'
        DISPLAY "----------------------------------------"
        DISPLAY "       MINI CORE BANKING SYSTEM         "
        DISPLAY "----------------------------------------"
        DISPLAY "1. Create New Account"
        DISPLAY "2. Check Balance & Profile"
        DISPLAY "3. Deposit Funds"
        DISPLAY "4. Withdraw Funds"
        DISPLAY "5. Exit System"
        DISPLAY "Enter your choice (1-5): " WITH NO ADVANCING
        ACCEPT WS-CHOICE

        EVALUATE WS-CHOICE
            WHEN '1' PERFORM CREATE-ACCOUNT
            WHEN '2' PERFORM CHECK-BALANCE
            WHEN '3' PERFORM DEPOSIT-FUNDS
            WHEN '4' PERFORM WITHDRAW-FUNDS
            WHEN '5' MOVE 'Y' TO WS-EXIT-FLAG
            WHEN OTHER DISPLAY "Invalid choice! Try again."
        END-EVALUATE
    END-PERFORM.
    DISPLAY "Thank you for using Mini Core Banking System.".
    STOP RUN.

CREATE-ACCOUNT.
    OPEN EXTEND ACCT-FILE
    DISPLAY "--- CREATE ACCOUNT ---"
    DISPLAY "Enter 5-digit Account ID: " WITH NO ADVANCING
    ACCEPT REC-ID
    DISPLAY "Enter Account Holder Name: " WITH NO ADVANCING
    ACCEPT REC-NAME
    DISPLAY "Enter Initial Deposit (INR): " WITH NO ADVANCING
    ACCEPT REC-BALANCE
    
    WRITE ACCT-RECORD
    CLOSE ACCT-FILE
    DISPLAY "Account created successfully!".

CHECK-BALANCE.
    OPEN INPUT ACCT-FILE
    MOVE 'N' TO WS-FOUND
    DISPLAY "--- CHECK PROFILE & BALANCE ---"
    DISPLAY "Enter 5-digit Account ID: " WITH NO ADVANCING
    ACCEPT WS-SEARCH-ID

    PERFORM UNTIL WS-FOUND = 'Y'
        READ ACCT-FILE
            AT END EXIT PERFORM
        END-READ
        IF REC-ID = WS-SEARCH-ID
            MOVE 'Y' TO WS-FOUND
            MOVE REC-BALANCE TO WS-DISPLAY-BAL
            DISPLAY "Account ID: " REC-ID
            DISPLAY "Name:       " REC-NAME
            DISPLAY "Balance:    INR " WS-DISPLAY-BAL
        END-IF
    END-PERFORM

    IF WS-FOUND = 'N'
        DISPLAY "Error: Account ID not found."
    END-IF
    CLOSE ACCT-FILE.

DEPOSIT-FUNDS.
    OPEN INPUT ACCT-FILE
    OPEN OUTPUT TEMP-FILE
    MOVE 'N' TO WS-FOUND
    MOVE 'N' TO WS-EOF
    
    DISPLAY "--- DEPOSIT FUNDS ---"
    DISPLAY "Enter 5-digit Account ID: " WITH NO ADVANCING
    ACCEPT WS-SEARCH-ID
    DISPLAY "Enter Deposit Amount (INR): " WITH NO ADVANCING
    ACCEPT WS-AMOUNT

    PERFORM UNTIL WS-EOF = 'Y'
        READ ACCT-FILE
            AT END MOVE 'Y' TO WS-EOF
        NOT AT END
            IF REC-ID = WS-SEARCH-ID
                MOVE 'Y' TO WS-FOUND
                ADD WS-AMOUNT TO REC-BALANCE
                MOVE REC-BALANCE TO WS-DISPLAY-BAL
                DISPLAY "Success! Deposited smoothly."
                DISPLAY "Updated Remaining Balance: INR " WS-DISPLAY-BAL
            END-IF
            WRITE TEMP-RECORD FROM ACCT-RECORD
        END-READ
    END-PERFORM

    CLOSE ACCT-FILE
    CLOSE TEMP-FILE

    IF WS-FOUND = 'Y'
        CALL "SYSTEM" USING "del accounts.dat"
        CALL "SYSTEM" USING "ren temp.dat accounts.dat"
    ELSE
        DISPLAY "Error: Account ID not found."
        CALL "SYSTEM" USING "del temp.dat"
    END-IF.

WITHDRAW-FUNDS.
    OPEN INPUT ACCT-FILE
    OPEN OUTPUT TEMP-FILE
    MOVE 'N' TO WS-FOUND
    MOVE 'N' TO WS-EOF
    
    DISPLAY "--- WITHDRAW FUNDS ---"
    DISPLAY "Enter 5-digit Account ID: " WITH NO ADVANCING
    ACCEPT WS-SEARCH-ID
    DISPLAY "Enter Withdrawal Amount (INR): " WITH NO ADVANCING
    ACCEPT WS-AMOUNT

    PERFORM UNTIL WS-EOF = 'Y'
        READ ACCT-FILE
            AT END MOVE 'Y' TO WS-EOF
        NOT AT END
            IF REC-ID = WS-SEARCH-ID
                MOVE 'Y' TO WS-FOUND
                IF REC-BALANCE >= WS-AMOUNT
                    SUBTRACT WS-AMOUNT FROM REC-BALANCE
                    MOVE REC-BALANCE TO WS-DISPLAY-BAL
                    DISPLAY "Cash dispensed successfully!"
                    DISPLAY "Updated Remaining Balance: INR " WS-DISPLAY-BAL
                ELSE
                    MOVE REC-BALANCE TO WS-DISPLAY-BAL
                    DISPLAY "Error: Insufficient Funds!"
                    DISPLAY "Current Balance remains: INR " WS-DISPLAY-BAL
                END-IF
            END-IF
            WRITE TEMP-RECORD FROM ACCT-RECORD
        END-READ
    END-PERFORM

    CLOSE ACCT-FILE
    CLOSE TEMP-FILE

    IF WS-FOUND = 'Y'
        CALL "SYSTEM" USING "del accounts.dat"
        CALL "SYSTEM" USING "ren temp.dat accounts.dat"
    ELSE
        DISPLAY "Error: Account ID not found."
        CALL "SYSTEM" USING "del temp.dat"
    END-IF.
    