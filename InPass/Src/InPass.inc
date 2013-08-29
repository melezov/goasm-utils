; #############################################################################

    #ifndef _INPASS_INC_
    #define _INPASS_INC_
    ;{

; #############################################################################

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

; #############################################################################

        #define NULL                         0h
        #define IMP

; =============================================================================

        #define GENERIC_READ          80000000h
        #define GENERIC_WRITE         40000000h
        
        #define FILE_SHARE_READ       1h     
        #define OPEN_EXISTING                
        #define FILE_ATTRIBUTE_NORMAL       

        #define INVALID_HANDLE_VALUE       
        
        #define ENABLE_ECHO_INPUT
        
; =============================================================================

	#define CreateFile              IMP ## CreateFile               ## AW
	#define GetConsoleMode          IMP ## GetConsoleMode 

; =============================================================================

    ;}
    #endif // _INPASS_INC_

; #############################################################################
