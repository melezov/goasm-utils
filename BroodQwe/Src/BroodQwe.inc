; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    #ifndef _BROODQWE_INC_
    #define _BROODQWE_INC_
    ;{

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;        #define UNICODE 1 ; Define UNICODE has issues due to hardcode

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #ifdef UNICODE
        ;{
            #define dss dus
            #define AW  W
            #define S   2
        ;}
        #else
        ;{
            #define dss db
            #define AW  A
            #define S   1
        ;}
        #endif // UNICODE

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define GRID_DX 46
        #define GRID_DY 40

        #define GRID_SX 500
        #define GRID_SY 357

        #define GRID_EX 632
        #define GRID_EY 474

        #define SRES_EX 640 ; / = * 0CCCCCCCDh, edx >> 9
        #define SRES_EY 480 ; / = * 088888889h, edx >> 8

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define MAB_SX ( ( GRID_DX / 2 + GRID_SX + 1 ) * 0FFFFh ) / SRES_EX
        #define MAB_SY ( ( GRID_DY / 2 + GRID_SY + 1 ) * 0FFFFh ) / SRES_EY

        #define MAB_DX ( ( GRID_DX + 1 ) * 0FFFFh ) / SRES_EX
        #define MAB_DY ( ( GRID_DY + 1 ) * 0FFFFh ) / SRES_EY

        #define MAB_EX

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define BK_ESC  1h
        #define BK_CHAT 1Ch

        #define BK_SS   10h
        #define BK_ON   13h
        #define BK_OFF  21h
        #define BK_ES   2Eh

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define hInst   400000h
        #define hIcon   402130h
        #define hBroo   402298h
        #define hABox   4032CCh

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       #include "..\Src\Windows.inc"
       #include "..\Res\BroodQwe.def"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        POINT STRUCT
        ;{
            x       dd 80h
            y       dd 80h
        ;}
        ENDS

        BOUNDS  STRUCT
        ;{
            str     POINT < GRID_SX, GRID_SY >
            end     POINT < GRID_EX, GRID_EY >
            res     POINT < SRES_EX, SRES_EY >
        ;}
        ENDS

        BK STRUCT
        ;{
            dMPing  dd MF_CHECKED
            dMBlck  dd MF_CHECKED
            dKbMap  dd MF_CHECKED
            dBrood  dd 0h
            dAbout  dd 0h
            dBExit  dd 0h

            dDuble  dd 0h
            dTbrCr  dd 0h
            dEnter  dd 0h

            sMPing  dd
            sMBlck  dd
            sKbMap  dd
            sBrood  dd
            sAbout  dd
            sBExit  dd

            sDuble  dd
            sTbrCr  dd
            sEHook  dd
        ;}
        ENDS

        AB STRUCT
        ;{
            sAOpen  dd
            sAInfo  dd
            sAHttp  dd
        ;}
        ENDS

        NOTIFYICONDATA STRUCT
        ;{
        	cbSize              dd  40h * S + 18h
        	hWnd                dd  0h
        	uID                 dd  0h
        	uFlags              dd  NIF_MESSAGE | NIF_ICON | NIF_TIP
        	uCallbackMessage    dd  WM_USER
        	hIcon               dd  0h
            szTip               dss "BroodQwe - "
            szPasive            dss "Pasive", 0h
            szActive            dss "Active"
            hIcon2              dd 0h
        ENDS

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        MOUSEINPUT STRUCT
        ;{
            type        dd 0h
            dx          dd 0h
            dy          dd 0h
            mouseData   dd 0h
            dwFlags     dd 0h
            time        dd 0h
            dwExtraInfo dd 0h
        ;}
        ENDS

        BC STRUCT
        ;{
            jump    MOUSEINPUT < 0h, 0h, 0h, 0h, MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE | MOUSEEVENTF_LEFTDOWN, 0h, 0h >
            press   MOUSEINPUT < 0h, 0h, 0h, 0h, MOUSEEVENTF_LEFTDOWN, 0h, 0h >
            release MOUSEINPUT < 0h, 0h, 0h, 0h, MOUSEEVENTF_LEFTUP, 0h, 0h >
            return  MOUSEINPUT < 0h, 0h, 0h, 0h, MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE, 0h, 0h >
        ;}
        ENDS

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        BZ STRUCT
        ;{
            oldPos  POINT
            bounds  BOUNDS
        ;}
        ENDS

        BA STRUCT
        ;{
            bz      BZ
            bk      BK
            bc      BC
            nid     NOTIFYICONDATA
        ;}
        ENDS

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define ebk edi + BK
        #define eba edi - sizeof( BZ ) + BA

        #define eab esi + AB

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ;}
    #endif // _BROODQWE_INC_

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
