'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


dim keywords_list (0 to 545) as string = { _
"...", _
"__DATE__", _
"__DATE_ISO__", _
"__FB_64BIT__", _
"__FB_ARGC__", _
"__FB_ARGV__", _
"__FB_ARM__", _
"__FB_ASM__", _
"__FB_BACKEND__", _
"__FB_BIGENDIAN__", _
"__FB_BUILD_DATE__", _
"__FB_CYGWIN__", _
"__FB_DARWIN__", _
"__FB_DEBUG__", _
"__FB_DOS__", _
"__FB_ERR__", _
"__FB_FPMODE__", _
"__FB_FPU__", _
"__FB_FREEBSD__", _
"__FB_GCC__", _
"__FB_GUI__", _
"__FB_LANG__", _
"__FB_LINUX__", _
"__FB_MAIN__", _
"__FB_MIN_VERSION__", _
"__FB_MT__", _
"__FB_NETBSD__", _
"__FB_OPENBSD__", _
"__FB_OPTION_BYVAL__", _
"__FB_OPTION_DYNAMIC__", _
"__FB_OPTION_ESCAPE__", _
"__FB_OPTION_EXPLICIT__", _
"__FB_OPTION_GOSUB__", _
"__FB_OPTION_PRIVATE__", _
"__FB_OUT_DLL__", _
"__FB_OUT_EXE__", _
"__FB_OUT_LIB__", _
"__FB_OUT_OBJ__", _
"__FB_PCOS__", _
"__FB_SIGNATURE__", _
"__FB_SSE__", _
"__FB_UNIX__", _
"__FB_VECTORIZE__", _
"__FB_VER_MAJOR__", _
"__FB_VER_MINOR__", _
"__FB_VER_PATCH__", _
"__FB_VERSION__", _
"__FB_WIN32__", _
"__FB_XBOX__", _
"__FILE__", _
"__FILE_NQ__", _
"__FUNCTION__", _
"__FUNCTION_NQ__", _
"__LINE__", _
"__PATH__", _
"__TIME__", _
"#ASSERT", _
"#DEFINE", _
"#ELSE", _
"#ELSEIF", _
"#ENDIF", _
"#ENDMACRO", _
"#ERROR", _
"#IF", _
"#IFDEF", _
"#IFNDEF", _
"#INCLIB", _
"#INCLUDE", _
"#LANG", _
"#LIBPATH", _
"#LINE", _
"#MACRO", _
"#PRAGMA", _
"#PRINT", _
"#UNDEF", _
"$DYNAMIC", _
"$INCLUDE", _
"$LANG", _
"$STATIC", _
"ABS", _
"ABSTRACT (member)", _
"ACCESS", _
"ACOS", _
"ADD (Graphics PUT)", _
"ALIAS", _
"ALLOCATE", _
"ALPHA (Graphics PUT)", _
"AND", _
"ANDALSO", _
"AND (GRAPHICS PUT)", _
"ANY", _
"APPEND", _
"AS", _
"ASC", _
"ASIN", _
"ASM", _
"ASSERT", _
"ASSERTWARN", _
"ATAN2", _
"ATN", _
"BASE (initialization)", _
"BASE (member access)", _
"BEEP", _
"BIN", _
"BINARY", _
"BIT", _
"BITRESET", _
"BITSET", _
"BLOAD", _
"BOOLEAN", _
"BSAVE", _
"BYREF (parameters)", _
"BYREF (function results)", _
"BYREF (variables)", _
"BYTE", _
"BYVAL", _
"CALL", _
"CALLOCATE", _
"CASE", _
"CAST", _
"CBOOL", _
"CBYTE", _
"CDBL", _
"CDECL", _
"CHAIN", _
"CHDIR", _
"CHR", _
"CINT", _
"CIRCLE", _
"CLASS", _
"CLEAR", _
"CLNG", _
"CLNGINT", _
"CLOSE", _
"CLS", _
"COLOR", _
"COMMAND", _
"COMMON", _
"CONDBROADCAST", _
"CONDCREATE", _
"CONDDESTROY", _
"CONDSIGNAL", _
"CONDWAIT", _
"CONST", _
"CONST (Member)", _
"CONST (Qualifier)", _
"CONSTRUCTOR", _
"CONSTRUCTOR (Module)", _
"CONTINUE", _
"COS", _
"CPTR", _
"CSHORT", _
"CSIGN", _
"CSNG", _
"CSRLIN", _
"CUBYTE", _
"CUINT", _
"CULNG", _
"CULNGINT", _
"CUNSG", _
"CURDIR", _
"CUSHORT", _
"CUSTOM (Graphics PUT)", _
"CVD", _
"CVI", _
"CVL", _
"CVLONGINT", _
"CVS", _
"CVSHORT", _
"DATA", _
"DATE", _
"DATEADD", _
"DATEDIFF", _
"DATEPART", _
"DATESERIAL", _
"DATEVALUE", _
"DAY", _
"DEALLOCATE", _
"DECLARE", _
"DEFBYTE", _
"DEFDBL", _
"DEFINED", _
"DEFINT", _
"DEFLNG", _
"DEFLONGINT", _
"DEFSHORT", _
"DEFSNG", _
"DEFSTR", _
"DEFUBYTE", _
"DEFUINT", _
"DEFULONGINT", _
"DEFUSHORT", _
"DELETE (Statement)", _
"DESTRUCTOR", _
"DESTRUCTOR (Module)", _
"DIM", _
"DIR", _
"DO", _
"DO...LOOP", _
"DOUBLE", _
"DRAW", _
"DRAW STRING", _
"DYLIBFREE", _
"DYLIBLOAD", _
"DYLIBSYMBOL", _
"ELSE", _
"ELSEIF", _
"ENCODING", _
"END (Block)", _
"END (Statement)", _
"END IF", _
"ENUM", _
"ENVIRON statement", _
"ENVIRON", _
"EOF", _
"EQV", _
"ERASE", _
"ERFN", _
"ERL", _
"ERMN", _
"ERR", _
"ERROR", _
"EVENT (message data from ScreenEvent)", _
"EXEC", _
"EXEPATH", _
"EXIT", _
"EXP", _
"EXPORT", _
"EXTENDS", _
"EXTERN", _
"EXTERN...END EXTERN", _
"FALSE", _
"FIELD", _
"FILEATTR", _
"FILECOPY", _
"FILEDATETIME", _
"FILEEXISTS", _
"FILELEN", _
"FIX", _
"FLIP", _
"FOR", _
"FOR...NEXT", _
"FORMAT", _
"FRAC", _
"FRE", _
"FREEFILE", _
"FUNCTION", _
"FUNCTION (Member)", _
"FUNCTION (Pointer)", _
"GET (Graphics)", _
"GET # (File I/O)", _
"GETJOYSTICK", _
"GETKEY", _
"GETMOUSE", _
"GOSUB", _
"GOTO", _
"HEX", _
"HIBYTE", _
"HIWORD", _
"HOUR", _
"IF...THEN", _
"IIF", _
"IMAGECONVERTROW", _
"IMAGECREATE", _
"IMAGEDESTROY", _
"IMAGEINFO", _
"IMP", _
"IMPLEMENTS", _
"IMPORT", _
"INKEY", _
"INP", _
"INPUT (Statement)", _
"INPUT (File I/O)", _
"INPUT #", _
"INPUT$", _
"INSTR", _
"INSTRREV", _
"INT", _
"INTEGER", _
"IS (SELECT CASE)", _
"IS (Run-time type information operator)", _
"ISDATE", _
"ISREDIRECTED", _
"KILL", _
"LBOUND", _
"LCASE", _
"LEFT", _
"LEN", _
"LET", _
"LIB", _
"LINE", _
"LINE INPUT", _
"LINE INPUT #", _
"LOBYTE", _
"LOC", _
"LOCAL", _
"LOCATE", _
"LOCK", _
"LOF", _
"LOG", _
"LONG", _
"LONGINT", _
"LOOP", _
"LOWORD", _
"LPOS", _
"LPRINT", _
"LSET", _
"LTRIM", _
"MID (Statement)", _
"MID (Function)", _
"MINUTE", _
"MKD", _
"MKDIR", _
"MKI", _
"MKL", _
"MKLONGINT", _
"MKS", _
"MKSHORT", _
"MOD", _
"MONTH", _
"MONTHNAME", _
"MULTIKEY", _
"MUTEXCREATE", _
"MUTEXDESTROY", _
"MUTEXLOCK", _
"MUTEXUNLOCK", _
"NAKED", _
"NAME", _
"NAMESPACE", _
"NEW (Expression)", _
"NEW (Placement)", _
"NEXT", _
"NEXT (RESUME)", _
"NOT", _
"NOW", _
"OBJECT", _
"OCT", _
"OFFSETOF", _
"ON ERROR", _
"ON...GOSUB", _
"ON...GOTO", _
"ONCE", _
"OPEN", _
"OPEN COM", _
"OPEN CONS", _
"OPEN ERR", _
"OPEN LPT", _
"OPEN PIPE", _
"OPEN SCRN", _
"OPERATOR", _
"OPTION()", _
"OPTION BASE", _
"OPTION BYVAL", _
"OPTION DYNAMIC", _
"OPTION ESCAPE", _
"OPTION EXPLICIT", _
"OPTION GOSUB", _
"OPTION NOGOSUB", _
"OPTION NOKEYWORD", _
"OPTION PRIVATE", _
"OPTION STATIC", _
"OR", _
"OR (GRAPHICS PUT)", _
"ORELSE", _
"OUT", _
"OUTPUT", _
"OVERLOAD", _
"OVERRIDE", _
"'", _
"PAINT", _
"PALETTE", _
"PASCAL", _
"PCOPY", _
"PEEK", _
"PMAP", _
"POINT", _
"POINTCOORD", _
"POINTER", _
"POKE", _
"POS", _
"PRESERVE", _
"PRESET", _
"PRINT", _
"?", _
"PRINT #", _
"? #", _
"PRINT USING", _
"? USING", _
"PRIVATE", _
"PRIVATE: (Access Control)", _
"PROCPTR", _
"PROPERTY", _
"PROTECTED: (Access Control)", _
"PSET (Statement)", _
"PSET (Graphics PUT)", _
"PTR", _
"PUBLIC", _
"PUBLIC: (Access Control)", _
"PUT (Graphics)", _
"PUT # (File I/O)", _
"RANDOM", _
"RANDOMIZE", _
"READ", _
"READ (File Access)", _
"READ WRITE (File Access)", _
"REALLOCATE", _
"REDIM", _
"REM", _
"RESET", _
"RESTORE", _
"RESUME", _
"RESUME NEXT", _
"RETURN", _
"RGB", _
"RGBA", _
"RIGHT", _
"RMDIR", _
"RND", _
"RSET", _
"RTRIM", _
"RUN", _
"SADD", _
"SCOPE", _
"SCREEN", _
"SCREEN (Console)", _
"SCREENCOPY", _
"SCREENCONTROL", _
"SCREENEVENT", _
"SCREENGLPROC", _
"SCREENINFO", _
"SCREENLIST", _
"SCREENLOCK", _
"SCREENPTR", _
"SCREENRES", _
"SCREENSET", _
"SCREENSYNC", _
"SCREENUNLOCK", _
"SECOND", _
"SEEK (Statement)", _
"SEEK (Function)", _
"SELECT CASE", _
"SETDATE", _
"SETENVIRON", _
"SETMOUSE", _
"SETTIME", _
"SGN", _
"SHARED", _
"SHELL", _
"SHL", _
"SHORT", _
"SHR", _
"SIN", _
"SINGLE", _
"SIZEOF", _
"SLEEP", _
"SPACE", _
"SPC", _
"SQR", _
"STATIC", _
"STATIC (Member)", _
"STDCALL", _
"STEP", _
"STICK", _
"STOP", _
"STR", _
"STRIG", _
"STRING (Function)", _
"STRING", _
"STRPTR", _
"SUB", _
"SUB (Member)", _
"SUB (Pointer)", _
"SWAP", _
"SYSTEM", _
"TAB", _
"TAN", _
"THEN", _
"THIS", _
"THREADCALL", _
"THREADCREATE", _
"THREADDETACH", _
"THREADWAIT", _
"TIME", _
"TIMER", _
"TIMESERIAL", _
"TIMEVALUE", _
"TO", _
"TRANS (Graphics PUT)", _
"TRIM", _
"TRUE", _
"TYPE (Alias)", _
"TYPE (Temporary)", _
"TYPE (UDT)", _
"TYPEOF", _
"UBOUND", _
"UBYTE", _
"UCASE", _
"UINTEGER", _
"ULONG", _
"ULONGINT", _
"UNION", _
"UNLOCK", _
"UNSIGNED", _
"UNTIL", _
"USHORT", _
"USING (PRINT)", _
"USING (Namespaces)", _
"VA_ARG", _
"VA_FIRST", _
"VA_NEXT", _
"VAL", _
"VALLNG", _
"VALINT", _
"VALUINT", _
"VALULNG", _
"VAR", _
"VARPTR", _
"VIEW PRINT", _
"VIEW (Graphics)", _
"VIRTUAL (member)", _
"WAIT", _
"WBIN", _
"WCHR", _
"WEEKDAY", _
"WEEKDAYNAME", _
"WEND", _
"WHILE", _
"WHILE...WEND", _
"WHEX", _
"WIDTH", _
"WINDOW", _
"WINDOWTITLE", _
"WINPUT", _
"WITH", _
"WOCT", _
"WRITE", _
"WRITE #", _
"WRITE (File Access)	", _
"WSPACE", _
"WSTR", _
"WSTRING (Data Type)", _
"WSTRING (Function)", _
"XOR", _
"XOR (GRAPHICS PUT)", _
"YEAR", _
"ZSTRING" }
