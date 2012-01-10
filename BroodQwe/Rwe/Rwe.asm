; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #include "..\Src\BroodQwe.inc"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define IATAB_TARGET 1A4h
        #define IDATA_TARGET 0CCCh

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        DATA SECTION ".data"
    
        AS STRUCT
        ;{
            sAOpen  db "open", 0h, 0h, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
            
            sAInfo  db "BroodWar Mouse/Key remapper, ver 1.01a", 0dh, 0ah
                    db "Copyleft © Limo Driver - 2007", 0dh, 0ah, 0dh, 0ah
                    db "limo @ anime42 . com", 0dh, 0ah, 0dh, 0ah
                    db "[ QWE ASD ZXC ] are your friends", 0dh, 0ah, 0dh, 0ah
                    db "[ Alt + R ] - Turn ON", 0dh, 0ah
                    db "[ Alt + F ] - Turn OFF", 0dh, 0ah, 0dh, 0ah
                    db "Visit homepage for more info?", 0dh, 0ah
            
            sAHttp  db "http://www.anime42.com/BroodQwe", 0h
        ;}
        ENDS
    
        ab  AB
        as  AS
            
        dRwe    dd 0D0000040h

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        CODE SECTION ".text"

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        RWE_Entry: 
        ;{
            push    addr as.sAHttp 
            push    addr as.sAInfo 
            push    addr as.sAOpen 
                         
                lea     edi, [ ab.sAOpen ]
    
                push    3
                pop     ecx
.STR_LOP:       pop     eax
     
                sub     eax, addr as.sAOpen
                add     eax, hABox + sizeof( AB )
                            
                stosd
                loop    <.STR_LOP
    
            invoke  CreateFile, "..\Out\BroodQwe.exe", 0C0000000h, 0h, 0h, 3h, 0h, 0h
            mov     edi, eax
            inc     eax
            jnz     >.CF_OK
            ;{
.CL_NA:         invoke  MessageBox, 0h, "RWE could not open input file!", 0h, 10h
                xor     eax, eax
                inc     eax
                ret
            ;}
    
.CF_OK:     invoke  ModifyFile, edi, IATAB_TARGET, addr dRwe, 4h
    	    invoke  ModifyFile, edi, IDATA_TARGET, addr ab, sizeof( AB ) + sizeof( AS )
    	    
            invoke  CloseHandle, edi
            xor     eax, eax
            ret
        ;}

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ModifyFile: FRAME hFile, dIndex, dNew, dSize
        ;{
            LOCALS  written
    
            invoke  SetFilePointer, [ hFile ], [ dIndex ], 0h, 0h        
            cmp     eax, [ dIndex ]
            jnz     >.WF_ER
    
            invoke  WriteFile, [ hFile ], [ dNew ], [ dSize ], addr written, 0h
            or      eax, eax
            jz      >.WF_ER
            
            mov     eax, [ written ]
            cmp     eax, [ dSize ]
            jz      >.WF_OK
            ;{
.WF_ER:         invoke  MessageBoxA, 0h, "Error occured whilst writing to file!", 0h, 30h
            ;}
    
.WF_OK:     ret
        ;}
        ENDF

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
