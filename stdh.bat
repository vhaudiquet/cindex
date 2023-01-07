#!/bin/sh

# Helper script containing a list of standard headers functions
# Std headers
stdatomic=@("atomic_flag_test_and_set", "atomic_flag_test_and_set_explicit", "atomic_flag_clear",
	"atomic_flag_clear_explicit" "atomic_init" "atomic_is_lock_free" "atomic_store"
	"atomic_store_explicit" "atomic_load" "atomic_load_explicit" "atomic_exchange"
	"atomic_exchange_explicit" "atomic_compare_exchange_strong"
	"atomic_compare_exchange_strong_explicit" "atomic_compare_exchange_weak"
	"atomic_compare_exchange_weak_explicit" "atomic_fetch_add" "atomic_fetch_add_explicit"
	"atomic_fetch_sub" "atomic_fetch_sub_explicit" "atomic_fetch_or" "atomic_fetch_or_explicit"
	"atomic_fetch_xor" "atomic_fetch_xor_explicit" "atomic_fetch_and" "atomic_fetch_and_explicit"
	"atomic_thread_fence" "atomic_signal_fence")
threads=("thrd_create" "thrd_equal" "thrd_current" "thrd_sleep" "thrd_yield" "thrd_detach"
	"thrd_exit" "thrd_join" "cnd_init" "cnd_signal" "cnd_broadcast" "cnd_wait"
	"cnd_timedwait" "cnd_destroy" "mtx_init" "mtx_lock" "mtx_timedlock" "mtx_trylock"
	"mtx_unlock" "mtx_destroy" "tss_create" "tss_delete" "tss_set" "tss_get")
# (POSIX) Headers content
aio=("aio_cancel" "aio_error" "aio_fsync" "aio_read" "aio_return" "aio_suspend"
	"aio_write" "lio_listio")
arpa_inet=("inet_addr" "inet_aton" "inet_lnaof" "inet_makeaddr" "inet_netof"
	"inet_network" "inet_ntoa" "inet_ntop" "inet_pton")
complex=("cabs" "cabsf" "cabsl" "cacos" "cacosf" "cacosh" "cacoshf" "cacoshl"
	"cacosl" "casin" "casinf" "casinh" "casinhf" "casinhl" "casinl" "catan"
	"catanf" "catanh" "catanhf" "catanhl" "catanl" "ccos" "ccosf" "ccosh"
	"ccoshf" "ccoshl" "ccosl" "cexp" "cexpf" "cexpl" "cimag" "cimagf"
	"cimagl" "clog" "clogf" "clogl" "conj" "conjf" "conjl" "cpow" "cpowf"
	"cpowl" "cproj" "cprojf" "cprojl" "creal" "crealf" "creall" "csin"
	"csinf" "csinh" "csinhf" "csinhl" "csinl" "csqrt" "csqrtf" "csqrtl"
	"ctan" "ctanf" "ctanh" "ctanhf" "ctanhl" "ctanl")
ctype=("isalnum" "isalnum_l" "isalpha" "isalpha_l" "isascii" "isblank" "isblank_l"
	"iscntrl" "iscntrl_l" "isdigit" "isdigit_l" "isgraph" "isgraph_l"
	"islower" "islower_l" "isprint" "isprint_l" "ispunct" "ispunct_l"
	"isspace" "isspace_l" "isupper" "isupper_l" "isxdigit" "isxdigit_l"
	"tolower" "tolower_l" "toupper" "toupper_l")
dirent=("alphasort" "closedir" "dirfd" "fdopendir" "opendir" "readdir" "readdir_r"
	"rewinddir" "scandir" "seekdir" "telldir")
dlfcn=("dladdr" "dlclose" "dlerror" "dlopen" "dlsym")
fcntl=("creat" "fcntl" "open" "openat" "posix_fadvise" "posix_fallocate")
fenv=("feclearexcept" "fegetenv" "fegetexceptflag" "fegetround" "feholdexcept"
	"feraiseexcept" "fesetenv" "fesetexceptflag" "fesetround" "fetestexcept"
	"feupdateenv")
fmtmsg=("fmtmsg")
fnmatch=("fnmatch")
ftw=("ftw" "nftw")
glob=("glob" "globfree")
grp=("endgrent" "endpwent" "fgetgrent" "fgetgrent_r"
	"fgetpwent" "fgetpwent_r" "getgrent" "getgrent_r"
	"getgrgid" "getgrgid_r" "getgrnam" "getgrnam_r" "getgroups" "getpwent"
	"getpwent_r" "getpwnam" "getpwnam_r" "getpwuid" "getpwuid_r" "putgrent"
	"putpwent" "setgrent" "setpwent")
iconv=("iconv" "iconv_close" "iconv_open")
inttypes=("imaxabs" "imaxdiv" "strtoimax" "strtoumax" "wcstoimax" "wcstoumax")
langinfo=("nl_langinfo" "nl_langinfo_l")
libgen=("basename" "dirname")
locale=("catclose" "catgets" "catopen" "duplocale" "freelocale" "localeconv"
	"newlocale" "setlocale" "strcoll" "strcoll_l" "strxfrm" "strxfrm_l"
	"uselocale")
math=("acos" "acosf" "acosh" "acoshf" "acoshl" "acosl" "asin" "asinf" "asinh"
	"asinhf" "asinhl" "asinl" "atan" "atan2" "atan2f" "atan2l" "atanf"
	"atanh" "atanhf" "atanhl" "atanl" "cbrt" "cbrtf" "cbrtl" "ceil" "ceilf"
	"ceill" "copysign" "copysignf" "copysignl" "cos" "cosf" "cosh" "coshf"
	"coshl" "cosl" "erf" "erff" "erfl" "exp" "exp2" "exp2f" "exp2l" "expf"
	"expl" "expm1" "expm1f" "expm1l" "fabs" "fabsf" "fabsl" "fdim" "fdimf"
	"fdiml" "floor" "floorf" "floorl" "fma" "fmaf" "fmal" "fmax" "fmaxf"
	"fmaxl" "fmin" "fminf" "fminl" "fmod" "fmodf" "fmodl" "frexp" "frexpf"
	"frexpl" "hypot" "hypotf" "hypotl" "ilogb" "ilogbf" "ilogbl" "j0" "j1" "jn"
	"ldexp" "ldexpf" "ldexpl" "lgamma" "lgammaf" "lgammal" "llrint" "llrintf"
	"llrintl" "llround" "llroundf" "llroundl" "log" "log10" "log10f" "log10l"
	"log1p" "log1pf" "log1pl" "log2" "log2f" "log2l" "logb" "logbf" "logbl"
	"logf" "logl" "lrint" "lrintf" "lrintl" "lround" "lroundf" "lroundl"
	"modf" "modff" "modfl" "nan" "nanf" "nanl" "nearbyint" "nearbyintf"
	"nearbyintl" "nextafter" "nextafterf" "nextafterl" "nexttoward" "nexttowardf"
	"nexttowardl" "pow" "powf" "powl" "remainder" "remainderf" "remainderl"
	"remquo" "remquof" "remquol" "rint" "rintf" "rintl" "round" "roundf"
	"roundl" "scalbln" "scalblnf" "scalblnl" "scalbn" "scalbnf" "scalbnl"
	"sin" "sinf" "sinh" "sinhf" "sinhl" "sinl" "sqrt" "sqrtf" "sqrtl" "tan"
	"tanf" "tanh" "tanhf" "tanhl" "tanl" "tgamma" "tgammaf" "tgammal" "trunc"
	"truncf" "truncl" "y0" "y1" "yn")
monetary=("strfmon" "strfmon_l")
mqueue=("mq_close" "mq_getattr" "mq_notify" "mq_open" "mq_receive" "mq_send"
	"mq_setattr" "mq_timedreceive" "mq_timedsend" "mq_unlink")
ndbm=("dbm_clearerr" "dbm_close" "dbm_delete" "dbm_error" "dbm_fetch" "dbm_firstkey"
	"dbm_nextkey" "dbm_open" "dbm_store")
net_if=("if_indextoname" "if_nameindex" "if_nametoindex" "if_freenameindex")
netdb=("endhostent" "endnetent" "endprotoent" "endpwent" "endservent" "gethostbyaddr"
	"gethostbyname" "gethostent" "getnetbyaddr" "getnetbyname" "getnetent"
	"getprotobyname" "getprotobynumber" "getprotoent" "getservbyname"
	"getservbyport" "getservent" "gethostbyname2" "gethostbyaddr_r"
	"gethostbyname_r" "gethostent_r" "getnetbyaddr_r" "getnetbyname_r"
	"getnetent_r" "getprotobyname_r" "getprotobynumber_r" "getprotoent_r"
	"getservbyname_r" "getservbyport_r" "getservent_r" "gethostbyname2_r"
	"sethostent" "setnetent" "setprotoent" "setpwent" "setservent" "herror"
	"hstrerror" "setnetgrent" "endnetgrent"
	"innetgr" "getnetgrent" "getnetgrent_r")
nl_types=("catclose" "catgets" "catopen")
poll=("poll" "ppoll")
pthread=("pthread_atfork" "pthread_attr_destroy" "pthread_attr_getdetachstate"
	"pthread_attr_getguardsize" "pthread_attr_getinheritsched"
	"pthread_attr_getschedparam" "pthread_attr_getschedpolicy"
	"pthread_attr_getscope" "pthread_attr_getstack" "pthread_attr_getstackaddr"
	"pthread_attr_getstacksize" "pthread_attr_init" "pthread_attr_setdetachstate"
	"pthread_attr_setguardsize" "pthread_attr_setinheritsched"
	"pthread_attr_setschedparam" "pthread_attr_setschedpolicy"
	"pthread_attr_setscope" "pthread_attr_setstack" "pthread_attr_setstackaddr"
	"pthread_attr_setstacksize" "pthread_cancel" "pthread_cleanup_pop"
	"pthread_cleanup_push" "pthread_cond_broadcast" "pthread_cond_destroy"
	"pthread_cond_init" "pthread_cond_signal" "pthread_cond_timedwait"
	"pthread_cond_wait" "pthread_condattr_destroy" "pthread_condattr_getclock"
	"pthread_condattr_getpshared" "pthread_condattr_init"
	"pthread_condattr_setclock" "pthread_condattr_setpshared"
	"pthread_create" "pthread_detach" "pthread_equal" "pthread_exit"
	"pthread_getconcurrency" "pthread_getcpuclockid" "pthread_getschedparam"
	"pthread_getspecific" "pthread_join" "pthread_key_create" "pthread_key_delete"
	"pthread_mutex_consistent" "pthread_mutex_destroy" "pthread_mutex_getprioceiling"
	"pthread_mutex_init" "pthread_mutex_lock" "pthread_mutex_setprioceiling"
	"pthread_mutex_timedlock" "pthread_mutex_trylock" "pthread_mutex_unlock"
	"pthread_mutexattr_destroy" "pthread_mutexattr_getprioceiling"
	"pthread_mutexattr_getprotocol" "pthread_mutexattr_getpshared"
	"pthread_mutexattr_getrobust" "pthread_mutexattr_gettype"
	"pthread_mutexattr_init" "pthread_mutexattr_setprioceiling"
	"pthread_mutexattr_setprotocol" "pthread_mutexattr_setpshared"
	"pthread_mutexattr_setrobust" "pthread_mutexattr_settype" "pthread_once"
	"pthread_rwlock_destroy" "pthread_rwlock_init" "pthread_rwlock_rdlock"
	"pthread_rwlock_timedrdlock" "pthread_rwlock_timedwrlock"
	"pthread_rwlock_tryrdlock" "pthread_rwlock_trywrlock" "pthread_rwlock_unlock"
	"pthread_rwlock_wrlock" "pthread_rwlockattr_destroy"
	"pthread_rwlockattr_getpshared" "pthread_rwlockattr_init"
	"pthread_rwlockattr_setpshared" "pthread_self" "pthread_setcancelstate"
	"pthread_setcanceltype" "pthread_setconcurrency" "pthread_setschedparam"
	"pthread_setschedprio" "pthread_setspecific" "pthread_spin_destroy"
	"pthread_spin_init" "pthread_spin_lock" "pthread_spin_trylock"
	"pthread_spin_unlock" "pthread_testcancel" "pthread_cleanup_pop"
	"pthread_cleanup_push")
pwd=("endpwent" "getpwent" "getpwnam" "getpwnam_r" "getpwuid" "getpwuid_r"
	"setpwent")
regex=("regcomp" "regerror" "regexec" "regfree")
sched=("sched_get_priority_max" "sched_get_priority_min" "sched_getparam"
	"sched_getscheduler" "sched_rr_get_interval" "sched_setparam"
	"sched_setscheduler" "sched_yield")
search=("hcreate" "hdestroy" "hsearch" "insque" "lfind" "lsearch" "remque"
	"tdelete" "tfind" "tsearch" "twalk")
semaphore=("sem_close" "sem_destroy" "sem_getvalue" "sem_init" "sem_open"
	"sem_post" "sem_timedwait" "sem_trywait" "sem_unlink" "sem_wait")
setjmp=("_longjmp" "longjmp" "siglongjmp")
signal=("kill" "killpg" "psiginfo" "psignal" "pthread_kill" "pthread_sigmask"
	"raise" "sigaction" "sigaddset" "sigaltstack" "sigandset" "sigdelset"
	"sigemptyset" "sigfillset" "sighold" "sigignore" "siginterrupt" "sigismember"
	"signal" "sigpause" "sigorset" "sigpending"
	"sigprocmask" "sigqueue" "sigrelse" "sigset" "sigsuspend" "sigwait" "sigwaitinfo"
	"sigtimedwait")
spawn=("posix_spawn" "posix_spawnp" "posix_spawn_file_actions_addclose"
	"posix_spawn_file_actions_adddup2" "posix_spawn_file_actions_addopen"
	"posix_spawn_file_actions_destroy" "posix_spawn_file_actions_init"
	"posix_spawnattr_destroy" "posix_spawnattr_getflags"
	"posix_spawnattr_getpgroup" "posix_spawnattr_getschedparam"
	"posix_spawnattr_getschedpolicy" "posix_spawnattr_getsigdefault"
	"posix_spawnattr_getsigmask" "posix_spawnattr_init"
	"posix_spawnattr_setflags" "posix_spawnattr_setpgroup"
	"posix_spawnattr_setschedparam" "posix_spawnattr_setschedpolicy"
	"posix_spawnattr_setsigdefault" "posix_spawnattr_setsigmask")
stdio=("clearerr" "ctermid" "dprintf" "fclose" "fdopen" "feof" "ferror"
	"fflush" "fgetc" "fgetpos" "fgets" "fileno" "flockfile" "fopen"
	"fprintf" "fputc" "fputs" "fread" "freopen" "fscanf" "fseek"
	"fseeko" "fsetpos" "ftell" "ftello" "ftrylockfile" "funlockfile"
	"fwrite" "getc" "getchar" "getc_unlocked" "getchar_unlocked"
	"getdelim" "getline" "gets" "open_memstream" "pclose" "perror"
	"popen" "printf" "putc" "putchar" "putc_unlocked"
	"putchar_unlocked" "puts" "remove" "rename" "renameat" "rewind"
	"scanf" "setbuf" "setvbuf" "snprintf" "sprintf" "sscanf" "tempnam"
	"tmpfile" "tmpnam" "ungetc" "vdprintf" "vfprintf" "vfscanf"
	"vprintf" "vscanf" "vsnprintf" "vsprintf" "vsscanf")
stdlib=("_Exit" "a64l" "abort" "abs" "atexit" "atof" "atoi" "atol" "bsearch"
	"calloc" "div" "drand48" "erand48" "exit" "free" "getenv" "getsubopt"
	"grantpt" "initstate" "jrand48" "l64a" "labs" "lcong48" "ldiv"
	"llabs" "lldiv" "lrand48" "malloc" "mblen" "mbstowcs" "mbtowc"
	"mkdtemp" "mkstemp" "mrand48" "nrand48" "posix_memalign" "posix_openpt"
	"ptsname" "putenv" "qsort" "rand" "rand_r" "random" "realloc" "realpath"
	"seed48" "setenv" "setkey" "setstate" "srand" "srand48" "srandom"
	"strtod" "strtof" "strtol" "strtold" "strtoll" "strtoul" "strtoull"
	"system" "unlockpt" "unsetenv" "wcstombs" "wctomb")
string=("memccpy" "memchr" "memcmp" "memcpy" "memmem" "memmove" "memset"
	"rawmemchr" "stpcpy" "stpncpy" "strcasecmp" "strcasestr" "strcat"
	"strchr" "strchrnul" "strcmp" "strcoll" "strcpy" "strcspn" "strdup"
	"strerror" "strerror_r" "strfmon" "strftime" "strlen" "strncasecmp"
	"strncat" "strncmp" "strncpy" "strndup" "strnlen" "strpbrk" "strptime"
	"strrchr" "strsep" "strsignal" "strspn" "strstr" "strtok" "strtok_r"
	"strxfrm" "swab" "strdupa" "strndupa" "strsignal_r" "strtok_r" "strverscmp"
	"strxfrm_l" "strcoll_l" "strfmon_l" "strptime_l" "strerror_l" "strerror_r")
strings=("ffs" "strcasecmp" "strcasecmp_l" "strncasecmp" "strncasecmp_l")
stropts=("fattach" "fdetach" "getmsg" "getpmsg" "ioctl" "isastream" "putmsg"
	"putpmsg")
sys_ipc=("ftok")
sys_mman=("mmap" "mmap64" "mremap" "msync" "munmap" "mlock" "mlockall"
	"mprotect" "munlock" "munlockall" "madvise" "posix_madvise"
	"shm_open" "shm_unlink" "posix_mem_offset" "posix_typed_mem_open"
	"posix_typed_mem_get_info")
sys_msg=("msgctl" "msgget" "msgrcv" "msgsnd")
sys_resource=("getrlimit" "getrusage" "setrlimit" "getpriority" "setpriority")
sys_select=("pselect" "select")
sys_sem=("semctl" "semget" "semop")
sys_shm=("shmat" "shmctl" "shmdt" "shmget")
sys_socket=("accept" "accept4" "bind" "connect" "getpeername" "getsockname"
	"getsockopt" "listen" "recv" "recvfrom" "recvmsg" "send" "sendmsg"
	"sendto" "setsockopt" "shutdown" "socketatmark" "socket" "socketpair")
sys_stat=("chmod" "fchmod" "fchmodat" "fstat" "fstatat" "futimens" "lstat"
	"mkdir" "mkdirat" "mkfifo" "mkfifoat" "mknod" "mknodat" "stat"
	"umask" "utimensat")
sys_statvfs=("fstatvfs" "statvfs")
sys_time=("getitimer" "gettimeofday" "setitimer" "settimeofday" "adjtime"
	"clock_adjtime" "timerfd_settime" "utimes" "select")
sys_times=("times")
sys_uio=("readv" "writev")
sys_utsname=("uname")
sys_wait=("wait" "wait3" "wait4" "waitid" "waitpid")
syslog=("openlog" "syslog" "closelog" "setlogmask")
termios=("cfgetispeed" "cfgetospeed" "cfsetispeed" "cfsetospeed" "tcdrain"
	"tcflow" "tcflush" "tcgetattr" "tcgetpgrp" "tcsendbreak" "tcsetattr"
	"tcsetpgrp")
time=("asctime" "asctime_r" "clock" "clock_getcpuclockid" "clock_getres"
	"clock_gettime" "clock_nanosleep" "clock_settime" "ctime" "ctime_r"
	"difftime" "getdate" "gmtime" "gmtime_r" "localtime" "localtime_r"
	"mktime" "nanosleep" "strftime" "strptime" "time" "timegm" "timelocal"
	"tzset" "timer_create" "timer_delete" "timer_getoverrun"
	"timer_gettime" "timer_settime" "strftime_l")
trace=("posix_trace_attr_destroy" "posix_trace_attr_getclockres" "posix_trace_attr_getcreatetime"
	"posix_trace_attr_getgenversion" "posix_trace_attr_getinherited"
	"posix_trace_attr_getlogfullpolicy" "posix_trace_attr_getlogsize"
	"posix_trace_attr_getmaxdatasize" "posix_trace_attr_getmaxsystemeventsize"
	"posix_trace_attr_getmaxusereventsize" "posix_trace_attr_getname"
	"posix_trace_attr_getstreamfullpolicy" "posix_trace_attr_getstreamsize"
	"posix_trace_attr_getversion" "posix_trace_attr_init" "posix_trace_attr_setinherited"
	"posix_trace_attr_setlogfullpolicy" "posix_trace_attr_setlogsize"
	"posix_trace_attr_setmaxdatasize" "posix_trace_attr_setmaxsystemeventsize"
	"posix_trace_attr_setmaxusereventsize" "posix_trace_attr_setname"
	"posix_trace_attr_setstreamfullpolicy" "posix_trace_attr_setstreamsize"
	"posix_trace_clear" "posix_trace_close" "posix_trace_create" "posix_trace_create_withlog"
	"posix_trace_eventid_equal" "posix_trace_eventid_get_name" "posix_trace_eventid_open"
	"posix_trace_eventset_add" "posix_trace_eventset_del" "posix_trace_eventset_empty"
	"posix_trace_eventset_fill" "posix_trace_eventset_ismember" "posix_trace_eventtypelist_getnext_id"
	"posix_trace_flush" "posix_trace_get_attr" "posix_trace_get_filter"
	"posix_trace_get_status" "posix_trace_getnext_event" "posix_trace_open"
	"posix_trace_rewind" "posix_trace_set_filter" "posix_trace_shutdown"
	"posix_trace_start" "posix_trace_stop")
ulimit=("ulimit")
unistd=("access" "alarm" "chdir" "chown" "chroot" "close" "confstr" "crypt"
	"ctermid" "ctermid_r" "dup" "dup2" "dup3" "_exit" "encrypt" "execl" "execle"
	"execlp" "execv" "execve" "execvp" "fchdir" "fchown" "fdatasync" "fork"
	"fpathconf" "fsync" "ftruncate" "getcwd" "getegid" "geteuid" "getgid"
	"getgroups" "getlogin" "getlogin_r" "getpgid" "getpgrp" "getpid" "getppid"
	"getresgid" "getresuid" "getsid" "getuid" "getwd" "isatty" "lchown" "link"
	"linkat" "lockf" "nice" "pathconf" "pause" "pipe" "pipe2" "read" "readlink"
	"readlinkat" "rmdir" "setegid" "seteuid" "setgid" "setpgid" "setpgrp"
	"setregid" "setreuid" "setsid" "setuid" "sleep" "symlink" "symlinkat"
	"sync" "tcgetpgrp" "tcsetpgrp" "ttyname" "ttyname_r" "unlink" "unlinkat"
	"usleep" "vfork" "write" "getopt")
utime=("utime")
utmpx=("getutxent" "getutxid" "getutxline" "pututxline" "setutxent" "endutxent")
wchar=("btowc" "fgetwc" "fgetws" "fputwc" "fputws" "fwide" "fwprintf" "fwscanf"
	"getwc" "getwchar" "mbrlen" "mbrtowc" "mbsinit" "mbsrtowcs" "putwc"
	"putwchar" "swprintf" "swscanf" "ungetwc" "vfwprintf" "vfwscanf" "vswprintf"
	"vswscanf" "vwprintf" "vwscanf" "wcrtomb" "wcscat" "wcschr" "wcscmp"
	"wcscoll" "wcscpy" "wcscspn" "wcsftime" "wcslen" "wcsncat" "wcsncmp"
	"wcsncpy" "wcspbrk" "wcsrchr" "wcsrtombs" "wcsspn" "wcsstr" "wcstod"
	"wcstof" "wcstok" "wcstol" "wcstold" "wcstoll" "wcstoul" "wcstoull"
	"wcswidth" "wcsxfrm" "wctob" "wctomb" "wctrans" "wctype" "wcwidth" "wprintf"
	"wscanf")
wctype=("iswalnum" "iswalpha" "iswblank" "iswcntrl" "iswctype" "iswdigit" "iswgraph"
	"iswlower" "iswprint" "iswpunct" "iswspace" "iswupper" "iswxdigit" "towlower"
	"towupper" "wctrans" "wctype"
	"iswalnum_l" "iswalpha_l" "iswblank_l" "iswcntrl_l" "iswctype_l" "iswdigit_l"
	"iswgraph_l" "iswlower_l" "iswprint_l" "iswpunct_l" "iswspace_l" "iswupper_l"
	"iswxdigit_l" "towlower_l" "towupper_l" "wctrans_l" "wctype_l")
wordexp=("wordexp" "wordfree")
