; #############################################################################

        #include "InPass.inc"

; #############################################################################

    DATA SECTION ".data"

    #define MAX_PROCESS_NAME_LENGTH 200h

; =============================================================================

        szLogAppendix   dss    "-Arguments.txt", 0h
        dwNewLine       dss    0dh, 0ah

        szModuleName    dss    MAX_PROCESS_NAME_LENGTH DUP ?
        ddBytesWritten  dd     ?

; #############################################################################

    CODE SECTION ".text"

; =============================================================================

        InPass_Entry:
        ;{
            invoke GetModuleFileName, NULL, ADDR szModuleName, MAX_PROCESS_NAME_LENGTH
            invoke lstrcat, ADDR szModuleName, ADDR szLogAppendix

            invoke CreateFile, ADDR szModuleName, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
            mov ebx, eax
            invoke SetFilePointer, ebx, 0h, NULL, FILE_END

            invoke GetCommandLine
            push eax

            invoke lstrlen, eax
            #ifdef UNICODE
            ;{
                add eax, eax
            ;}
            #endif // UNICODE

            pop ecx
            invoke WriteFile, ebx, ecx, eax, ADDR ddBytesWritten, NULL
            invoke WriteFile, ebx, ADDR dwNewLine, 2 * S, ADDR ddBytesWritten, NULL

            invoke CloseHandle, ebx
            invoke ExitProcess, 0h

;            xor eax, eax
;            ret
        ;}

; #############################################################################
