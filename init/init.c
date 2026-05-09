#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/reboot.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static volatile sig_atomic_t running = 1;
static FILE *f_log, *f_console, *f_serial;
static void logmsg(const char *fmt, ...) {
    char buf[512]; va_list ap; va_start(ap, fmt); vsnprintf(buf, sizeof(buf), fmt, ap); va_end(ap);
    if (f_log) { fprintf(f_log, "%s\n", buf); fflush(f_log); }
    if (f_console) { fprintf(f_console, "%s\n", buf); fflush(f_console); }
    if (f_serial) { fprintf(f_serial, "%s\n", buf); fflush(f_serial); }
}
static void on_sig(int s){ if(s==SIGTERM||s==SIGINT) running=0; }
static void ensure_dir(const char *p){ mkdir(p,0755); }
static void mnt(const char*s,const char*t,const char*f,unsigned long fl,const char*d){ ensure_dir(t); if(mount(s,t,f,fl,d)&&errno!=EBUSY) logmsg("init: mount failed %s on %s: %s",s,t,strerror(errno)); }
static void spawn_getty(const char *tty){ if(fork()==0){ execlp("/sbin/getty","getty","-L",tty,"115200","vt100",NULL); _exit(127);} }
int main(void){
    ensure_dir("/var"); ensure_dir("/var/log"); ensure_dir("/run");
    f_log=fopen("/var/log/boot.log","a"); f_console=fopen("/dev/console","w"); f_serial=fopen("/dev/ttyS0","w");
    signal(SIGTERM,on_sig); signal(SIGINT,on_sig);
    mnt("proc","/proc","proc",MS_NOSUID|MS_NODEV|MS_NOEXEC,NULL);
    mnt("sysfs","/sys","sysfs",MS_NOSUID|MS_NODEV|MS_NOEXEC,NULL);
    mnt("devtmpfs","/dev","devtmpfs",MS_NOSUID,"mode=0755");
    mnt("tmpfs","/run","tmpfs",MS_NOSUID|MS_NODEV,"mode=0755");
    mount(NULL,"/",NULL,MS_REMOUNT, "rw");
    logmsg("init: started pid=%d", getpid());
    spawn_getty("tty1"); spawn_getty("tty2"); spawn_getty("tty3"); spawn_getty("tty4");
    while(running){ int st=0; pid_t p=waitpid(-1,&st,WNOHANG); if(p>0) logmsg("init: reaped %d",p); usleep(200000);} 
    logmsg("init: stopping"); sync(); reboot(RB_AUTOBOOT); return 0;
}
