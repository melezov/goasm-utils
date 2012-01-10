; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    #ifndef _WINDOWS_INC_
    #define _WINDOWS_INC_
    ;{

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define NIM_ADD                 0h
        #define NIM_MODIFY              1h
        #define NIM_DELETE              2h

        #define NIF_MESSAGE             1h
        #define NIF_ICON                2h
        #define NIF_TIP                 4h

        #define MF_GRAYED               1h
        #define MF_CHECKED              8h
        #define MF_HILITE               80h
        #define MF_SEPARATOR            800h

        #define MB_YESNO                4h
        #define MB_ICONERROR            10h
        #define MB_ICONWARNING          30h
        #define MB_ICONINFORMATION      40h
        
        #define IDYES                   6h
        
        #define WM_KEYDOWN              100h
        #define WM_SYSKEYDOWN           104h
        #define WM_INITDIALOG           110h
        #define WM_MOUSEMOVE            200h
        #define WM_LBUTTONDOWN          201h
        #define WM_LBUTTONDBLCLK        203h
        #define WM_RBUTTONDOWN          204h
        #define WM_USER                 400h 

        #define TPM_RIGHTBUTTON         2h
        #define TPM_RIGHTALIGN          8h
        #define TPM_BOTTOMALIGN         20h
        #define TPM_NONOTIFY            80h
        #define TPM_RETURNCMD           100h

        #define LLMHF_INJECTED          1h
        
        #define MOUSEEVENTF_MOVE        1h
        #define MOUSEEVENTF_LEFTDOWN    2h
        #define MOUSEEVENTF_LEFTUP      4h
        #define MOUSEEVENTF_ABSOLUTE    8000h

        #define SW_SHOWNORMAL           1h
        
        #define WS_DISABLED             8000000h
        #define WS_POPUP                80000000h

        #define WS_EX_TOOLWINDOW        80h
        #define WS_EX_NOACTIVATE        8000000h

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        #define IMP
      
        #define AppendMenu              IMP ## AppendMenu               ## AW
        #define CreateFile              IMP ## CreateFile               ## AW
        #define DialogBoxParam          IMP ## DialogBoxParam           ## AW
        #define MessageBox              IMP ## MessageBox               ## AW
        #define RegisterWindowMessage   IMP ## RegisterWindowMessage    ## AW
        #define SetWindowsHookEx        IMP ## SetWindowsHookEx         ## AW
        #define Shell_NotifyIcon        IMP ## Shell_NotifyIcon         ## AW
        #define ShellAbout              IMP ## ShellAbout               ## AW
        #define ShellExecute            IMP ## ShellExecute             ## AW

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ;}
    #endif // _WINDOWS_INC_

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
