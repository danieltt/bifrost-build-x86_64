--- crypto/ui/ui_openssl.c.orig	Fri Sep 21 09:57:09 2012
+++ crypto/ui/ui_openssl.c	Fri Sep 21 09:57:30 2012
@@ -212,6 +212,9 @@
 #undef SGTTY
 #endif
 
+#define TERMIOS
+#undef TERMIO
+
 #ifdef TERMIOS
 # include <termios.h>
 # define TTY_STRUCT		struct termios
