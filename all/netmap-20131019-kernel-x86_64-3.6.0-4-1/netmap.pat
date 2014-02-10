--- netmap-release/LINUX/Makefile	Sat Oct 19 16:20:24 2013
+++ netmap-release.work/LINUX/Makefile	Mon Feb 10 14:56:13 2014
@@ -43,7 +43,7 @@
 PWD ?= $(CURDIR)
 M:=$(PWD)
 EXTRA_CFLAGS := -I$(M) -I$(M)/../sys -I$(M)/../sys/dev -DCONFIG_NETMAP
-EXTRA_CFLAGS += -Wno-unused-but-set-variable
+#EXTRA_CFLAGS += -Wno-unused-but-set-variable
 
 # We use KSRC for the kernel configuration and sources.
 # If the sources are elsewhere, then use SRC to point to them.
--- netmap-release/examples/Makefile	Tue Sep 24 16:18:45 2013
+++ netmap-release.work/examples/Makefile	Mon Feb 10 15:08:30 2014
@@ -2,14 +2,14 @@
 # we can just define 'progs' and create custom targets.
 PROGS	=	pkt-gen bridge testpcap libnetmap.so
 #PROGS += pingd
-PROGS	+= testlock testcsum test_select kern_test testmmap vale-ctl
+PROGS	+= testlock testcsum test_select  testmmap vale-ctl
 
 CLEANFILES = $(PROGS) pcap.o nm_util.o *.o
 NO_MAN=
 CFLAGS = -O2 -pipe
 CFLAGS += -Werror -Wall
 CFLAGS += -I ../sys # -I/home/luigi/FreeBSD/head/sys -I../sys
-CFLAGS += -Wextra
+CFLAGS += -Wextra --static
 CFLAGS += -DNO_PCAP
 
 LDFLAGS += -lpthread
@@ -22,7 +22,7 @@
 testpcap: pcap.c libnetmap.so nm_util.o
 	$(CC) $(CFLAGS) -DTEST -o testpcap pcap.c nm_util.o $(LDFLAGS) -lpcap
 
-kern_test: testmod/kern_test.c
+#kern_test: testmod/kern_test.c
 
 nm_util.o pkt-gen.o bridge.o libnetmap.so pcap.o: nm_util.h
 
--- netmap-release/examples/nm_util.h	Tue Sep 24 16:18:45 2013
+++ netmap-release.work/examples/nm_util.h	Mon Feb 10 15:02:14 2014
@@ -39,7 +39,7 @@
 #include <string.h>	/* strcmp */
 #include <fcntl.h>	/* open */
 #include <unistd.h>	/* close */
-#include <ifaddrs.h>	/* getifaddrs */
+//#include <ifaddrs.h>	/* getifaddrs */
 
 #include <sys/mman.h>	/* PROT_* */
 #include <sys/ioctl.h>	/* ioctl */
--- netmap-release/examples/pkt-gen.c	Fri Oct 18 23:54:25 2013
+++ netmap-release.work/examples/pkt-gen.c	Mon Feb 10 15:06:46 2014
@@ -328,33 +328,9 @@
 static int
 source_hwaddr(const char *ifname, char *buf)
 {
-	struct ifaddrs *ifaphead, *ifap;
-	int l = sizeof(ifap->ifa_name);
-
-	if (getifaddrs(&ifaphead) != 0) {
-		D("getifaddrs %s failed", ifname);
-		return (-1);
-	}
-
-	for (ifap = ifaphead; ifap; ifap = ifap->ifa_next) {
-		struct sockaddr_dl *sdl =
-			(struct sockaddr_dl *)ifap->ifa_addr;
-		uint8_t *mac;
-
-		if (!sdl || sdl->sdl_family != AF_LINK)
-			continue;
-		if (strncmp(ifap->ifa_name, ifname, l) != 0)
-			continue;
-		mac = (uint8_t *)LLADDR(sdl);
-		sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
-			mac[0], mac[1], mac[2],
-			mac[3], mac[4], mac[5]);
-		if (verbose)
-			D("source hwaddr %s", buf);
-		break;
-	}
-	freeifaddrs(ifaphead);
-	return ifap ? 0 : 1;
+	(void) ifname;
+	(void) buf;
+	return 0;
 }
 
 
