; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #include "..\Src\BroodQwe.inc"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        BS STRUCT
        ;{
            sMPing db "MousePing", 0h
            sMBlck db "MouseBlock", 0h
            sKbMap db "KeyMapper", 0h
            sBrood db "BroodQwe", 0h
            sAbout db "About", 0h
            sBExit db "Exit", 0h

            sDuble db "Already Loaded?", 0h
            sTbrCr db "TaskbarCreated", 0h

            sEHook db "Hook failed!", 0h
        ;}
        ENDS

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        DATA SECTION ".data"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ba  BA
        bs  BS

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        CODE SECTION ".text"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        STR_Entry:
        ;{
            push    addr bs.sEHook
            push    addr bs.sTbrCr
            push    addr bs.sDuble
            push    addr bs.sBExit
            push    addr bs.sAbout
            push    addr bs.sBrood
            push    addr bs.sKbMap
            push    addr bs.sMBlck
            push    addr bs.sMPing

            lea     edi, [ ba.bk.sMPing ]

            push    9
            pop     ecx
.STR_LOP:   pop     eax

            sub     eax, addr bs.sMPing
            add     eax, hBroo + sizeof( BA ) - sizeof( BZ )

            stosd
            loop    <.STR_LOP

            invoke  CreateFile, "..\Out\BroodQwe.bin", 040000000h, 0h, 0h, 2h, 0h, 0h
            mov     ebx, eax
            inc     eax
            jnz     >.STR_OK
            ;{
.STR_NA:        invoke  MessageBox, 0h, "STR could not open output file!", 0h, 10h
                xor     eax, eax
                inc     eax
                ret
            ;}

.STR_OK:    push    esp
            mov     eax, esp
            invoke  WriteFile, ebx, addr ba, sizeof( BA ) + sizeof( BS ), eax, 0h
            or      eax, eax
            pop     eax
            jz      >.STR_ER

            cmp     eax, sizeof( BA ) + sizeof( BS )
            jz      >.STR_IK
            ;{
.STR_ER:        invoke  MessageBox, 0h, "STR could not write to the output file!", 0h, 10h
.STR_IK:    ;}

            invoke  CloseHandle, ebx

            xor     eax, eax
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
