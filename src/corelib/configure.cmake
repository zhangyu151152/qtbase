

#### Inputs

# input iconv
set(INPUT_iconv "undefined" CACHE STRING "")
set_property(CACHE INPUT_iconv PROPERTY STRINGS undefined no yes posix sun gnu)



#### Libraries

find_package(GLib)
set_package_properties(GLib PROPERTIES TYPE OPTIONAL)
find_package(ICU COMPONENTS i18n uc data)
set_package_properties(ICU PROPERTIES TYPE OPTIONAL)
find_package(Libsystemd)
set_package_properties(Libsystemd PROPERTIES TYPE OPTIONAL)
find_package(Atomic)
set_package_properties(Atomic PROPERTIES TYPE OPTIONAL)
find_package(PCRE2)
set_package_properties(PCRE2 PROPERTIES TYPE REQUIRED)


#### Tests

# atomicfptr
qt_config_compile_test(atomicfptr
    LABEL "working std::atomic for function pointers"
"
#include <atomic>
typedef void (*fptr)(int);
typedef std::atomic<fptr> atomicfptr;
void testfunction(int) { }
void test(volatile atomicfptr &a)
{
    fptr v = a.load(std::memory_order_acquire);
    while (!a.compare_exchange_strong(v, &testfunction,
                                      std::memory_order_acq_rel,
                                      std::memory_order_acquire)) {
        v = a.exchange(&testfunction);
    }
    a.store(&testfunction, std::memory_order_release);
}
int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
atomicfptr fptr(testfunction);
test(fptr);
    /* END TEST: */
    return 0;
}
"# FIXME: qmake: CONFIG += c++11
)

# clock-monotonic
qt_config_compile_test(clock_monotonic
    LABEL "POSIX monotonic clock"
"
#include <unistd.h>
#include <time.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
#if defined(_POSIX_MONOTONIC_CLOCK) && (_POSIX_MONOTONIC_CLOCK-0 >= 0)
timespec ts;
clock_gettime(CLOCK_MONOTONIC, &ts);
#else
#  error Feature _POSIX_MONOTONIC_CLOCK not available
#endif
    /* END TEST: */
    return 0;
}
")

# cloexec
qt_config_compile_test(cloexec
    LABEL "O_CLOEXEC"
"#define _GNU_SOURCE 1
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
int pipes[2];
(void) pipe2(pipes, O_CLOEXEC | O_NONBLOCK);
(void) fcntl(0, F_DUPFD_CLOEXEC, 0);
(void) dup3(0, 3, O_CLOEXEC);
#if defined(__NetBSD__)
(void) paccept(0, 0, 0, NULL, SOCK_CLOEXEC | SOCK_NONBLOCK);
#else
(void) accept4(0, 0, 0, SOCK_CLOEXEC | SOCK_NONBLOCK);
#endif
    /* END TEST: */
    return 0;
}
")

# cxx11_future
qt_config_compile_test(cxx11_future
    LABEL "C++11 <future>"
"
#include <future>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
std::future<int> f = std::async([]() { return 42; });
(void)f.get();
    /* END TEST: */
    return 0;
}
"# FIXME: qmake: unix:LIBS += -lpthread
)

# eventfd
qt_config_compile_test(eventfd
    LABEL "eventfd"
"
#include <sys/eventfd.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
eventfd_t value;
int fd = eventfd(0, EFD_CLOEXEC);
eventfd_read(fd, &value);
eventfd_write(fd, value);
    /* END TEST: */
    return 0;
}
")

# inotify
qt_config_compile_test(inotify
    LABEL "inotify"
"
#include <sys/inotify.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
inotify_init();
inotify_add_watch(0, \"foobar\", IN_ACCESS);
inotify_rm_watch(0, 1);
    /* END TEST: */
    return 0;
}
")

# ipc_sysv
qt_config_compile_test(ipc_sysv
    LABEL "SysV IPC"
"
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
key_t unix_key = ftok(\"test\", 'Q');
semctl(semget(unix_key, 1, 0666 | IPC_CREAT | IPC_EXCL), 0, IPC_RMID, 0);
shmget(unix_key, 0, 0666 | IPC_CREAT | IPC_EXCL);
shmctl(0, 0, (struct shmid_ds *)(0));
    /* END TEST: */
    return 0;
}
")

# ipc_posix
qt_config_compile_test(ipc_posix
    LABEL "POSIX IPC"
"
#include <sys/types.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
sem_close(sem_open(\"test\", O_CREAT | O_EXCL, 0666, 0));
shm_open(\"test\", O_RDWR | O_CREAT | O_EXCL, 0666);
shm_unlink(\"test\");
    /* END TEST: */
    return 0;
}
"# FIXME: qmake: linux: LIBS += -lpthread -lrt
)

# linkat
qt_config_compile_test(linkat
    LABEL "linkat()"
"#define _ATFILE_SOURCE 1
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
linkat(AT_FDCWD, \"foo\", AT_FDCWD, \"bar\", AT_SYMLINK_FOLLOW);
    /* END TEST: */
    return 0;
}
")

# ppoll
qt_config_compile_test(ppoll
    LABEL "ppoll()"
"
#include <signal.h>
#include <poll.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
struct pollfd pfd;
struct timespec ts;
sigset_t sig;
ppoll(&pfd, 1, &ts, &sig);
    /* END TEST: */
    return 0;
}
")

# pollts
qt_config_compile_test(pollts
    LABEL "pollts()"
"
#include <poll.h>
#include <signal.h>
#include <time.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
struct pollfd pfd;
struct timespec ts;
sigset_t sig;
pollts(&pfd, 1, &ts, &sig);
    /* END TEST: */
    return 0;
}
")

# poll
qt_config_compile_test(poll
    LABEL "poll()"
"
#include <poll.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
struct pollfd pfd;
poll(&pfd, 1, 0);
    /* END TEST: */
    return 0;
}
")

# renameat2
qt_config_compile_test(renameat2
    LABEL "renameat2()"
"#define _ATFILE_SOURCE 1
#include <fcntl.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
renameat2(AT_FDCWD, argv[1], AT_FDCWD, argv[2], RENAME_NOREPLACE | RENAME_WHITEOUT);
    /* END TEST: */
    return 0;
}
")

# statx
qt_config_compile_test(statx
    LABEL "statx() in libc"
"#define _ATFILE_SOURCE 1
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
struct statx statxbuf;
unsigned int mask = STATX_BASIC_STATS;
return statx(AT_FDCWD, \"\", AT_STATX_SYNC_AS_STAT, mask, &statxbuf);
    /* END TEST: */
    return 0;
}
")

# syslog
qt_config_compile_test(syslog
    LABEL "syslog"
"
#include <syslog.h>

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    /* BEGIN TEST: */
openlog(\"qt\", 0, LOG_USER);
syslog(LOG_INFO, \"configure\");
closelog();
    /* END TEST: */
    return 0;
}
")



#### Features

qt_feature("clock_gettime" PRIVATE
    LABEL "clock_gettime()"
    CONDITION UNIX AND libs.librt OR FIXME
)
qt_feature("clock_monotonic" PUBLIC
    LABEL "POSIX monotonic clock"
    CONDITION QT_FEATURE_clock_gettime AND TEST_clock_monotonic
)
qt_feature_definition("clock_monotonic" "QT_NO_CLOCK_MONOTONIC" NEGATE VALUE "1")
qt_feature("cxx11_future" PUBLIC
    LABEL "C++11 <future>"
    CONDITION TEST_cxx11_future
)
qt_feature("eventfd" PUBLIC
    LABEL "eventfd"
    CONDITION NOT WASM AND TEST_eventfd
)
qt_feature_definition("eventfd" "QT_NO_EVENTFD" NEGATE VALUE "1")
qt_feature("futimens" PRIVATE
    LABEL "futimens()"
    CONDITION NOT WIN32 AND TEST_futimens
)
qt_feature("futimes" PRIVATE
    LABEL "futimes()"
    CONDITION NOT WIN32 AND NOT QT_FEATURE_futimens AND TEST_futimes
)
qt_feature("getauxval" PRIVATE
    LABEL "getauxval()"
    CONDITION LINUX AND TEST_getauxval
)
qt_feature("getentropy" PRIVATE
    LABEL "getentropy()"
    CONDITION UNIX AND TEST_getentropy
)
qt_feature("glib" PUBLIC PRIVATE
    LABEL "GLib"
    AUTODETECT NOT WIN32
    CONDITION GLib_FOUND
)
qt_feature_definition("glib" "QT_NO_GLIB" NEGATE VALUE "1")
qt_feature("iconv" PUBLIC PRIVATE
    SECTION "Internationalization"
    LABEL "iconv"
    PURPOSE "Provides internationalization on Unix."
    CONDITION NOT QT_FEATURE_icu AND QT_FEATURE_textcodec AND ( QT_FEATURE_posix_libiconv OR TEST_sun_iconv OR QT_FEATURE_gnu_libiconv )
)
qt_feature_definition("iconv" "QT_NO_ICONV" NEGATE VALUE "1")
qt_feature("posix_libiconv" PRIVATE
    LABEL "POSIX iconv"
    CONDITION NOT WIN32 AND NOT QNX AND NOT ANDROID AND NOT APPLE AND TEST_posix_iconv
    ENABLE INPUT_iconv STREQUAL 'posix'
    DISABLE INPUT_iconv STREQUAL 'sun' OR INPUT_iconv STREQUAL 'gnu' OR INPUT_iconv STREQUAL 'no'
)
qt_feature("gnu_libiconv" PRIVATE
    LABEL "GNU iconv"
    CONDITION NOT WIN32 AND NOT QNX AND NOT ANDROID AND NOT APPLE AND NOT QT_FEATURE_posix_libiconv AND NOT TEST_sun_iconv AND libs.gnu_iconv OR FIXME
    ENABLE INPUT_iconv STREQUAL 'gnu'
    DISABLE INPUT_iconv STREQUAL 'posix' OR INPUT_iconv STREQUAL 'sun' OR INPUT_iconv STREQUAL 'no'
)
qt_feature("icu" PRIVATE
    LABEL "ICU"
    AUTODETECT NOT WIN32
    CONDITION ICU_FOUND
)
qt_feature("inotify" PUBLIC PRIVATE
    LABEL "inotify"
    CONDITION TEST_inotify
)
qt_feature_definition("inotify" "QT_NO_INOTIFY" NEGATE VALUE "1")
qt_feature("ipc_posix" PUBLIC
    LABEL "Using POSIX IPC"
    AUTODETECT NOT WIN32
    CONDITION NOT TEST_ipc_sysv AND TEST_ipc_posix
)
qt_feature_definition("ipc_posix" "QT_POSIX_IPC")
qt_feature("journald" PRIVATE
    LABEL "journald"
    AUTODETECT OFF
    CONDITION Libsystemd_FOUND
)
# Currently only used by QTemporaryFile; linkat() exists on Android, but hardlink creation fails due to security rules
qt_feature("linkat" PRIVATE
    LABEL "linkat()"
    AUTODETECT LINUX AND NOT ANDROID
    CONDITION TEST_linkat
)
qt_feature("std_atomic64" PUBLIC
    LABEL "64 bit atomic operations"
    CONDITION Atomic_FOUND
)
qt_feature("mimetype" PUBLIC
    SECTION "Utilities"
    LABEL "Mimetype handling"
    PURPOSE "Provides MIME type handling."
    CONDITION QT_FEATURE_textcodec
)
qt_feature_definition("mimetype" "QT_NO_MIMETYPE" NEGATE VALUE "1")
qt_feature("poll_ppoll" PRIVATE
    LABEL "Native ppoll()"
    CONDITION NOT WASM AND TEST_ppoll
    EMIT_IF NOT WIN32
)
qt_feature("poll_pollts" PRIVATE
    LABEL "Native pollts()"
    CONDITION NOT QT_FEATURE_poll_ppoll AND TEST_pollts
    EMIT_IF NOT WIN32
)
qt_feature("poll_poll" PRIVATE
    LABEL "Native poll()"
    CONDITION NOT QT_FEATURE_poll_ppoll AND NOT QT_FEATURE_poll_pollts AND TEST_poll
    EMIT_IF NOT WIN32
)
qt_feature("poll_select" PUBLIC PRIVATE
    LABEL "Emulated poll()"
    CONDITION NOT QT_FEATURE_poll_ppoll AND NOT QT_FEATURE_poll_pollts AND NOT QT_FEATURE_poll_poll
    EMIT_IF NOT WIN32
)
qt_feature_definition("poll_select" "QT_NO_NATIVE_POLL")
qt_feature("qqnx_pps" PRIVATE
    LABEL "PPS"
    CONDITION libs.pps OR FIXME
    EMIT_IF QNX
)
qt_feature("renameat2" PRIVATE
    LABEL "renameat2()"
    CONDITION LINUX AND TEST_renameat2
)
qt_feature("slog2" PRIVATE
    LABEL "slog2"
    CONDITION libs.slog2 OR FIXME
)
qt_feature("statx" PRIVATE
    LABEL "statx() in libc"
    CONDITION LINUX AND TEST_statx
)
qt_feature("syslog" PRIVATE
    LABEL "syslog"
    AUTODETECT OFF
    CONDITION TEST_syslog
)
qt_feature("threadsafe_cloexec" PUBLIC
    LABEL "Threadsafe pipe creation"
    CONDITION TEST_cloexec
)
qt_feature_definition("threadsafe_cloexec" "QT_THREADSAFE_CLOEXEC" VALUE "1")
qt_feature("properties" PUBLIC
    SECTION "Kernel"
    LABEL "Properties"
    PURPOSE "Supports scripting Qt-based applications."
)
qt_feature_definition("properties" "QT_NO_PROPERTIES" NEGATE VALUE "1")
qt_feature("regularexpression" PUBLIC
    SECTION "Kernel"
    LABEL "QRegularExpression"
    PURPOSE "Provides an API to Perl-compatible regular expressions."
)
qt_feature_definition("regularexpression" "QT_NO_REGULAREXPRESSION" NEGATE VALUE "1")
qt_feature("sharedmemory" PUBLIC
    SECTION "Kernel"
    LABEL "QSharedMemory"
    PURPOSE "Provides access to a shared memory segment."
    CONDITION ( ANDROID OR WIN32 OR ( NOT VXWORKS AND ( TEST_ipc_sysv OR TEST_ipc_posix ) ) )
)
qt_feature_definition("sharedmemory" "QT_NO_SHAREDMEMORY" NEGATE VALUE "1")
qt_feature("systemsemaphore" PUBLIC
    SECTION "Kernel"
    LABEL "QSystemSemaphore"
    PURPOSE "Provides a general counting system semaphore."
    CONDITION ( NOT INTEGRITY AND NOT VXWORKS ) AND ( ANDROID OR WIN32 OR TEST_ipc_sysv OR TEST_ipc_posix )
)
qt_feature_definition("systemsemaphore" "QT_NO_SYSTEMSEMAPHORE" NEGATE VALUE "1")
qt_feature("xmlstream" PUBLIC
    SECTION "Kernel"
    LABEL "XML Streaming APIs"
    PURPOSE "Provides a simple streaming API for XML."
)
qt_feature_definition("xmlstream" "QT_NO_XMLSTREAM" NEGATE VALUE "1")
qt_feature("xmlstreamreader" PUBLIC
    SECTION "Kernel"
    LABEL "QXmlStreamReader"
    PURPOSE "Provides a well-formed XML parser with a simple streaming API."
    CONDITION QT_FEATURE_xmlstream
)
qt_feature_definition("xmlstreamreader" "QT_NO_XMLSTREAMREADER" NEGATE VALUE "1")
qt_feature("xmlstreamwriter" PUBLIC
    SECTION "Kernel"
    LABEL "QXmlStreamWriter"
    PURPOSE "Provides a XML writer with a simple streaming API."
    CONDITION QT_FEATURE_xmlstream
)
qt_feature_definition("xmlstreamwriter" "QT_NO_XMLSTREAMWRITER" NEGATE VALUE "1")
qt_feature("textdate" PUBLIC
    SECTION "Data structures"
    LABEL "Text Date"
    PURPOSE "Supports month and day names in dates."
)
qt_feature_definition("textdate" "QT_NO_TEXTDATE" NEGATE VALUE "1")
qt_feature("datestring" PUBLIC
    SECTION "Data structures"
    LABEL "QDate/QTime/QDateTime"
    PURPOSE "Provides convertion between dates and strings."
    CONDITION QT_FEATURE_textdate
)
qt_feature_definition("datestring" "QT_NO_DATESTRING" NEGATE VALUE "1")
qt_feature("process" PUBLIC
    SECTION "File I/O"
    LABEL "QProcess"
    PURPOSE "Supports external process invocation."
    CONDITION QT_FEATURE_processenvironment AND NOT WINRT AND NOT APPLE_UIKIT AND NOT INTEGRITY AND NOT VXWORKS
)
qt_feature_definition("process" "QT_NO_PROCESS" NEGATE VALUE "1")
qt_feature("processenvironment" PUBLIC
    SECTION "File I/O"
    LABEL "QProcessEnvironment"
    PURPOSE "Provides a higher-level abstraction of environment variables."
    CONDITION NOT WINRT AND NOT INTEGRITY
)
qt_feature("temporaryfile" PUBLIC
    SECTION "File I/O"
    LABEL "QTemporaryFile"
    PURPOSE "Provides an I/O device that operates on temporary files."
)
qt_feature_definition("temporaryfile" "QT_NO_TEMPORARYFILE" NEGATE VALUE "1")
qt_feature("library" PUBLIC
    SECTION "File I/O"
    LABEL "QLibrary"
    PURPOSE "Provides a wrapper for dynamically loaded libraries."
    CONDITION WIN32 OR HPUX OR ( NOT NACL AND UNIX )
)
qt_feature_definition("library" "QT_NO_LIBRARY" NEGATE VALUE "1")
qt_feature("settings" PUBLIC
    SECTION "File I/O"
    LABEL "QSettings"
    PURPOSE "Provides persistent application settings."
)
qt_feature_definition("settings" "QT_NO_SETTINGS" NEGATE VALUE "1")
qt_feature("filesystemwatcher" PUBLIC
    SECTION "File I/O"
    LABEL "QFileSystemWatcher"
    PURPOSE "Provides an interface for monitoring files and directories for modifications."
    CONDITION NOT WINRT
)
qt_feature_definition("filesystemwatcher" "QT_NO_FILESYSTEMWATCHER" NEGATE VALUE "1")
qt_feature("filesystemiterator" PUBLIC
    SECTION "File I/O"
    LABEL "QFileSystemIterator"
    PURPOSE "Provides fast file system iteration."
)
qt_feature_definition("filesystemiterator" "QT_NO_FILESYSTEMITERATOR" NEGATE VALUE "1")
qt_feature("itemmodel" PUBLIC
    SECTION "ItemViews"
    LABEL "Qt Item Model"
    PURPOSE "Provides the item model for item views"
)
qt_feature_definition("itemmodel" "QT_NO_ITEMMODEL" NEGATE VALUE "1")
qt_feature("proxymodel" PUBLIC
    SECTION "ItemViews"
    LABEL "QAbstractProxyModel"
    PURPOSE "Supports processing of data passed between another model and a view."
    CONDITION QT_FEATURE_itemmodel
)
qt_feature_definition("proxymodel" "QT_NO_PROXYMODEL" NEGATE VALUE "1")
qt_feature("sortfilterproxymodel" PUBLIC
    SECTION "ItemViews"
    LABEL "QSortFilterProxyModel"
    PURPOSE "Supports sorting and filtering of data passed between another model and a view."
    CONDITION QT_FEATURE_proxymodel
)
qt_feature_definition("sortfilterproxymodel" "QT_NO_SORTFILTERPROXYMODEL" NEGATE VALUE "1")
qt_feature("identityproxymodel" PUBLIC
    SECTION "ItemViews"
    LABEL "QIdentityProxyModel"
    PURPOSE "Supports proxying a source model unmodified."
    CONDITION QT_FEATURE_proxymodel
)
qt_feature_definition("identityproxymodel" "QT_NO_IDENTITYPROXYMODEL" NEGATE VALUE "1")
qt_feature("stringlistmodel" PUBLIC
    SECTION "ItemViews"
    LABEL "QStringListModel"
    PURPOSE "Provides a model that supplies strings to views."
    CONDITION QT_FEATURE_itemmodel
)
qt_feature_definition("stringlistmodel" "QT_NO_STRINGLISTMODEL" NEGATE VALUE "1")
qt_feature("translation" PUBLIC
    SECTION "Internationalization"
    LABEL "Translation"
    PURPOSE "Supports translations using QObject::tr()."
)
qt_feature_definition("translation" "QT_NO_TRANSLATION" NEGATE VALUE "1")
qt_feature("textcodec" PUBLIC
    SECTION "Internationalization"
    LABEL "QTextCodec"
    PURPOSE "Supports conversions between text encodings."
)
qt_feature_definition("textcodec" "QT_NO_TEXTCODEC" NEGATE VALUE "1")
qt_feature("codecs" PUBLIC
    SECTION "Internationalization"
    LABEL "Codecs"
    PURPOSE "Supports non-unicode text conversions."
    CONDITION QT_FEATURE_textcodec
)
qt_feature_definition("codecs" "QT_NO_CODECS" NEGATE VALUE "1")
qt_feature("big_codecs" PUBLIC
    SECTION "Internationalization"
    LABEL "Big Codecs"
    PURPOSE "Supports big codecs, e.g. CJK."
    CONDITION QT_FEATURE_textcodec
)
qt_feature_definition("big_codecs" "QT_NO_BIG_CODECS" NEGATE VALUE "1")
qt_feature("animation" PUBLIC
    SECTION "Utilities"
    LABEL "Animation"
    PURPOSE "Provides a framework for animations."
    CONDITION QT_FEATURE_properties
)
qt_feature_definition("animation" "QT_NO_ANIMATION" NEGATE VALUE "1")
qt_feature("statemachine" PUBLIC
    SECTION "Utilities"
    LABEL "State machine"
    PURPOSE "Provides hierarchical finite state machines."
    CONDITION QT_FEATURE_properties
)
qt_feature_definition("statemachine" "QT_NO_STATEMACHINE" NEGATE VALUE "1")
qt_feature("qeventtransition" PUBLIC
    LABEL "QEventTransition class"
    CONDITION QT_FEATURE_statemachine
)
qt_feature("gestures" PUBLIC
    SECTION "Utilities"
    LABEL "Gesture"
    PURPOSE "Provides a framework for gestures."
)
qt_feature_definition("gestures" "QT_NO_GESTURES" NEGATE VALUE "1")
qt_feature("sha3_fast" PRIVATE
    SECTION "Utilities"
    LABEL "Speed optimized SHA3"
    PURPOSE "Optimizes SHA3 for speed instead of size."
)
qt_feature("timezone" PUBLIC
    SECTION "Utilities"
    LABEL "QTimeZone"
    PURPOSE "Provides support for time-zone handling."
)
qt_feature("datetimeparser" PRIVATE
    SECTION "Utilities"
    LABEL "QDateTimeParser"
    PURPOSE "Provides support for parsing date-time texts."
)
qt_feature("commandlineparser" PUBLIC
    SECTION "Utilities"
    LABEL "QCommandlineParser"
    PURPOSE "Provides support for command line parsing."
)
qt_feature("lttng" PRIVATE
    LABEL "LTTNG"
    AUTODETECT OFF
    CONDITION LINUX AND libs.lttng-ust OR FIXME
    ENABLE INPUT_trace STREQUAL 'lttng' OR ( INPUT_trace STREQUAL 'yes' AND LINUX )
    DISABLE INPUT_trace STREQUAL 'etw' OR INPUT_trace STREQUAL 'no'
)
qt_feature("etw" PRIVATE
    LABEL "ETW"
    AUTODETECT OFF
    CONDITION WIN32
    ENABLE INPUT_trace STREQUAL 'etw' OR ( INPUT_trace STREQUAL 'yes' AND WIN32 )
    DISABLE INPUT_trace STREQUAL 'lttng' OR INPUT_trace STREQUAL 'no'
)
qt_feature("topleveldomain" PUBLIC
    SECTION "Utilities"
    LABEL "QUrl::topLevelDomain()"
    PURPOSE "Provides support for extracting the top level domain from URLs.  If enabled, a binary dump of the Public Suffix List (http://www.publicsuffix.org, Mozilla License) is included. The data is then also used in QNetworkCookieJar::validateCookie."
)