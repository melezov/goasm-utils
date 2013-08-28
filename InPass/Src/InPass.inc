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

        #define GENERIC_WRITE         40000000h
        #define FILE_SHARE_READ              1h
        #define OPEN_ALWAYS                  4h
        #define FILE_ATTRIBUTE_NORMAL       80h

        #define FILE_END                     2h
        #define INVALID_HANDLE_VALUE        -1

; =============================================================================

	#define GetModuleFileName	IMP ## GetModuleFileName	## AW
	#define lstrcat                 IMP ## lstrcat                  ## AW
	#define CreateFile              IMP ## CreateFile               ## AW
	#define GetCommandLine          IMP ## GetCommandLine           ## AW
	#define lstrlen                 IMP ## lstrlen                  ## AW

; =============================================================================

    ;}
    #endif // _INPASS_INC_

; #############################################################################
