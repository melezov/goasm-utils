; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #include "BroodQwe.inc"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        CODE SECTION ".text"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        BroodQwe_Entry:
        ;{
            mov     edi, hBroo

            xor     eax, eax
            inc     eax
            lock    xadd D[ ebk.dDuble ], eax

            dec     eax
            js      >.DBL_OK
            ;{
                invoke  MessageBox, 0h, [ ebk.sDuble ], [ ebk.sBrood ], MB_ICONWARNING
                ret     ; 1h in eax
.DBL_OK:    ;}

            push    0Dh
            pop     ebx

.SWH_LOOP:  invoke  SetWindowsHookEx, ebx, addr RatHookProc, hInst, 0h
            push    eax
            or      eax, eax
            jnz     >.SWH_OK
            ;{
                invoke  MessageBox, 0h, [ ebk.sEHook ], [ ebk.sBrood ], MB_ICONERROR
.SWH_OK:    ;}

            inc     ebx
            jpo     <.SWH_LOOP

            mov     edi, hBroo
            lea     esi, [ eba.bz.bounds.res ]

            invoke  MakeIcon
            mov     [ eba.nid.hIcon2 ], eax

            push    10h
            pop     ecx
.TA_ABS:    ;{
                lea     edx, [ ecx * 4 + hIcon + 28h ]
                mov     eax, [ edx ]
                bswap   eax
                mov     [ edx ], eax
                loop    <.TA_ABS
            ;}

            invoke  MakeIcon
            mov     [ eba.nid.hIcon ], eax

            #ifdef      DEBUG
            ;{
                mov     D[ edi +BK.dBrood ], MF_CHECKED
                invoke  XchgTray
            ;}
            #endif

            invoke  RegisterWindowMessage, [ ebk.sTbrCr ]
            mov   [ ebk.dTbrCr ], eax

            invoke  DialogBoxParam, hInst, IDI_DIALOG, 0h, addr DialogProc, 0h

            invoke  UnhookWindowsHookEx
            invoke  UnhookWindowsHookEx

            xor     eax, eax
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        MakeIcon:
        ;{
            invoke  CreateIconFromResource, hIcon, 0h, 1h, 30000h
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        XchgTray:
        ;{
            mov     eax, [ eba.nid.hIcon2 ]
            xchg    eax, [ eba.nid.hIcon ]
            mov     [ eba.nid.hIcon2 ], eax

            mov     eax, [ eba.nid.szPasive ]
            xchg    eax, [ eba.nid.szActive ]
            mov     [ eba.nid.szPasive ], eax

            invoke  TrayAction, NIM_MODIFY
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        CheckRes: ; hBroo in edi
        ;{
            #ifdef  DEBUG
            ;{
                cmp     edi, hBroo
                jz     >.CR_DBG
                ;{
                    int 3
.CR_DBG:        ;}
            ;}
            #endif

            invoke  GetSystemMetrics, 0h
            sub     eax, [ eba.bz.bounds.res.x ]
            jnz     >.CR_RET

            invoke  GetSystemMetrics, 1h
            sub     eax, [ eba.bz.bounds.res.y ]

.CR_RET:    ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        DialogProc: FRAME hWnd, uMsg, wParam, lParam
        ;{
            USES    edi
            mov     edi, hBroo

            mov     eax, [ uMsg ]
            cmp     eax, WM_INITDIALOG
            jnz     >.NOT_ID
            ;{
                mov     eax, [ hWnd ]
                mov     [ eba.nid.hWnd ], eax

.TA_ADD:        invoke  TrayAction, NIM_ADD
.DP_ONE:        xor     eax, eax
                inc     eax
                jmp     >.DP_RET
.NOT_ID:    ;}

            cmp     eax, [ ebk.dTbrCr ]
            jz      <.TA_ADD

            cmp     eax, WM_USER
            jnz     >.NOT_TI
            ;{
                mov     ecx, [ lParam ]
                cmp     ecx, WM_RBUTTONDOWN
                jnz     >.TI_RBD
                ;{
                    invoke  MakeMenu
                    jmp     <.DP_ONE
.TI_RBD:        ;}

                cmp     ecx, WM_LBUTTONDBLCLK
                jnz     >.TI_LDB
                ;{
                    xor     D[ ebk.dBrood ], MF_CHECKED
                    call    XchgTray
.TI_LDB:        ;}

                jmp     <.DP_ONE
.NOT_TI     ;}

            xor     eax, eax
.DP_RET:    ret
        ;}
        ENDF

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        MakeMenu: ; hBroo in edi
        ;{
            #ifdef  DEBUG
            ;{
                cmp     edi, hBroo
                jz     >.MM_DBG
                ;{
                    int 3
.MM_DBG:        ;}
            ;}
            #endif

            invoke  CreatePopupMenu
            push    esi, eax
            ;{
                push    0h, [ eba.nid.hWnd ], 0h, [ eba.bz.oldPos.y ], [ eba.bz.oldPos.x ]
                push    TPM_RIGHTBUTTON | TPM_RIGHTALIGN | TPM_BOTTOMALIGN | TPM_NONOTIFY | TPM_RETURNCMD, eax
                ;{
                    push    0h, 4h, eax

                    push    6h
                    pop     esi
.MM_AM1:            push    [ ebk.sMPing + esi * 4 - 4 ], esi, [ ebk.dMPing + esi * 4 - 4 ], eax

                    cmp     esi, 3h
                    jl      >.MM_SEP
                    ;{
                        push    0h, 0h, MF_SEPARATOR, eax
                    ;}

.MM_SEP:            dec     esi
                    jnz     <.MM_AM1

                    push    9h
                    pop     esi
.MM_AM2:            invoke  AppendMenu
                    dec     esi
                    jns     <.MM_AM2
                ;}

                invoke  SetMenuDefaultItem
                invoke  SetForegroundWindow, [ eba.nid.hWnd ]
                invoke  TrackPopupMenu

                dec     eax
                js      >.TM_CNL
                ;{
                    xor     D[ ebk.dMPing + eax * 4 ], MF_CHECKED

                    dec     eax
                    jnz     >.TM_BLK
                    ;{
                        xor     D[ ebk.dMPing ], MF_GRAYED
                        jmp     >.TM_CNL
.TM_BLK:            ;}

                    dec     eax
                    dec     eax
                    jnz     >.TM_BK
                    ;{
                        call    XchgTray
                        jmp     >.TM_CNL
.TM_BK              ;}

                    dec     eax
                    jnz     >.TM_AB
                    ;{
                        invoke  AboutBox
                        jmp     >.TM_CNL
.TM_AB:             ;}

                    dec     eax
                    jnz     >.TM_EXT
                    ;{
                        invoke  TrayAction, NIM_DELETE
                        invoke  EndDialog, [ eba.nid.hWnd ], eax
                        jmp     >.TM_CNL
.TM_EXT:            ;}
.TM_CNL:        ;}
            ;}

            invoke  DestroyMenu

            pop     esi
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        AboutBox: ; hBroo in edi, esi is volatile
        ;{
            mov     esi, hABox

            xor     D[ ebk.dAbout ], MF_GRAYED
            invoke  MessageBox, [ eba.nid.hWnd ], [ eab.sAInfo ], [ ebk.sBrood ], MB_ICONINFORMATION | MB_YESNO
            and     D[ ebk.dAbout ], 0h

            cmp     eax, IDYES
            jnz     >.AB_SSE
            ;{
                invoke  ShellExecute, [ eba.nid.hWnd ], [ eab.sAOpen ], [ eab.sAHttp ], 0h, 0h, SW_SHOWNORMAL
.AB_SSE:    ;}

            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        TrayAction: FRAME dAction ; hBroo in edi
        ;{
            #ifdef  DEBUG
            ;{
                cmp     edi, hBroo
                jz     >.TA_DBG
                ;{
                    int 3
.TA_DBG:        ;}
            ;}
            #endif

            lea     eax, [ eba.nid ]
            invoke  Shell_NotifyIcon, [ dAction ], eax
            ret
        ;}
        ENDF

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        RatHookProc: FRAME nCode, wParam, lParam
        ;{
            USES    esi, edi

            mov     edi, hBroo
            mov     esi, [ lParam ]
            cld

            mov     ecx, [ wParam ]
            cmp     ecx, WM_MOUSEMOVE
            jnz     >.RH_MM
            ;}
                lea     edi, [ eba.bz.oldPos ]

                movsd
                movsd

.RH_CNH:        invoke  CallNextHookEx, 0h, [ nCode ], [ wParam ], [ lParam ]
.RH_RET:        ret
.RH_MM:     ;}

            cmp     ecx, WM_SYSKEYDOWN
            jnz     >.RH_SKD
            ;{
                lodsd
                lodsd

                cmp     eax, BK_ON
                jnz     >.BK_ON
                ;{
                    push    MF_CHECKED
                    pop     eax
                    jmp     >.BK_TA
.BK_ON:         ;}

                cmp     D[ ebk.dBrood ], MF_CHECKED
                jl      <.RH_CNH

                cmp     eax, BK_OFF
                jnz     >.BK_OFF
                ;{
                    xor     eax, eax
.BK_TA:             cmp     D[ ebk.dBrood ], eax
                    jz      <.RH_CNH

                    mov     D[ ebk.dBrood ], eax
                    lea     esi, [ eax * 4 + MB_ICONERROR ]

                    invoke  XchgTray
                    invoke  MessageBeep, esi
 .BK_OFF:        ;}

                jmp     <.RH_CNH
.RH_SKD:    ;}

            cmp     D[ ebk.dBrood ], MF_CHECKED
            jl      <.RH_CNH

            push    ecx
            invoke  CheckRes
            pop     ecx
            jnz     <.RH_CNH

            cmp     ecx, WM_LBUTTONDOWN
            jnz     >.RH_LBD
            ;{
                cmp     D[ ebk.dMBlck ], MF_CHECKED
                jl      <.RH_CNH

                mov     eax, edi
                lea     edi, [ eba.bz.bounds.str ]

                cmpsd
                jl      <.RH_CNH
                cmpsd
                jl      <.RH_CNH
                sub     esi, 8h

                cmpsd
                jg      <.RH_CNH
                cmpsd
                jg      <.RH_CNH

                test    B[ esi + 4 ], LLMHF_INJECTED
                jnz     <.RH_CNH

                cmp     D[ eax ], MF_CHECKED ; ebk.dMPing
                jl      >.RH_SSH
                ;{
                    invoke  MessageBeep, ~0h
.RH_SSH:        ;}

.RH_ONE:        xor     eax, eax
                inc     eax
                jmp     <.RH_RET
.RH_LBD:    ;}

            cmp     ecx, WM_KEYDOWN
            jnz     >.RH_KD
            ;{
                cmp     D[ ebk.dKbMap ], MF_CHECKED
                jl      <.RH_CNH

                lodsd
                lodsd

                cmp     eax, BK_CHAT
                jnz     >.BK_CHAT
                ;{
                    xor     D[ ebk.dEnter ], MF_CHECKED
                    jmp     <.RH_CNH
.BK_CHAT:        ;}

                cmp     eax, BK_ESC
                jnz     >.BK_ESC
                ;{
                    and     D[ ebk.dEnter ], 0h
                    jmp     <.RH_CNH
.BK_ESC:        ;}

                cmp     D[ ebk.dEnter ], MF_CHECKED
                jge     <.RH_CNH

                invoke  SynKey
                or      eax, eax
                jnz     <.RH_ONE
.RH_KD:     ;}

            jmp <.RH_CNH
        ;}
        ENDF

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        SynKey: ; scancode in eax
        ;{
            cmp     eax, BK_ES
            jle     >.SK_ES
            ;{
.SK_SK:         xor     eax, eax
                ret
.SK_ES:     ;}

            sub     eax, BK_SS
            jl      <.SK_SK

            mov     ecx, MAB_SX
            mov     edx, MAB_SY

.SK_VER:    cmp     al, 0Eh
            jl      >.SK_VOK
            add     edx, MAB_DY

            sub     al, 0Eh
            jmp     <.SK_VER

.SK_VOK:    cmp     al, 02h
            jg      <.SK_SK

.SK_HOR     or      al, al
            jz      >.SK_HOK
            add     ecx, MAB_DX
            dec     eax
            jmp     <.SK_HOR

.SK_HOK:    lea     esi, [ eba.bc ]

            mov     [ esi + BC.jump.dx ], ecx
            mov     [ esi + BC.jump.dy ], edx

            mov     eax, [ eba.bz.oldPos.x ]
            inc     eax
            mov     edx, 0CCCCCCCDh
            shl     eax, 16
            mul     edx
            shr     edx, 9
            mov     [ esi + BC.return.dx ], edx

            mov     eax, [ eba.bz.oldPos.y ]
            inc     eax
            mov     edx, 088888889h
            shl     eax, 16
            mul     edx
            shr     edx, 8
            mov     [ esi + BC.return.dy ], edx

            invoke  SendInput, 4h, esi, sizeof( MOUSEINPUT )
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
