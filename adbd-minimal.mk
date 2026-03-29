# Makefile for adbd - Minimal USB Shell Only
#
# This is a minimal build that only supports USB shell functionality.
# Excluded services when ADBD_MINIMAL=1:
#   - backup_service.c      (adb backup/restore)
#   - file_sync_service.c   (adb push/pull)
#   - framebuffer_service.c (adb shell screenrecord)
#   - jdwp_service.c        (Java debugging)
#   - log_service.c         (adb logcat)
#   - remount_service.c     (adb remount)
#   - transport_local.c     (TCP transport - USB only mode)
#
# Build with: make ADBD_MINIMAL=1

VPATH+= ../libcutils
SRCS+= abort_socket.c
SRCS+= socket_inaddr_any_server.c
SRCS+= socket_local_client.c
SRCS+= socket_local_server.c
SRCS+= socket_loopback_client.c
SRCS+= socket_loopback_server.c
SRCS+= socket_network_client.c
SRCS+= list.c
SRCS+= load_file.c
SRCS+= android_reboot.c

#VPATH+= ../adb
# Core ADB files (always included)
SRCS+=	adb.c
SRCS+=	fdevent.c
SRCS+=	transport.c
SRCS+=	transport_usb.c
SRCS+=	adb_auth_client.c
SRCS+=	sockets.c
SRCS+=	services.c
SRCS+=	usb_linux_client.c
SRCS+=	utils.c
SRCS+=	base64.c

# Optional services (excluded when ADBD_MINIMAL=1)
ifeq ($(ADBD_MINIMAL),1)
CPPFLAGS+= -DADBD_MINIMAL
else
SRCS+=	backup_service.c
SRCS+=	file_sync_service.c
SRCS+=	jdwp_service.c
SRCS+=	framebuffer_service.c
SRCS+=	remount_service.c
SRCS+=	log_service.c
SRCS+=	transport_local.c
endif

VPATH+= ../libzipfile
SRCS+= centraldir.c
SRCS+= zipfile.c


CPPFLAGS+= -O2 -g -Wall -Wno-unused-parameter
CPPFLAGS+= -DADB_HOST=0 -DHAVE_FORKEXEC=1 -D_XOPEN_SOURCE -D_GNU_SOURCE -DALLOW_ADBD_ROOT=1
CPPFLAGS+= -DHAVE_SYMLINKS -DBOARD_ALWAYS_INSECURE
CPPFLAGS+= -DHAVE_TERMIO_H
CPPFLAGS+= -I.
CPPFLAGS+= -I../include
CPPFLAGS+= -I../../../external/zlib
CPPFLAGS+= -DADBD_NON_ANDROID

+LIBS+= -lc -lpthread -lz -lcrypto -lcrypt

OBJS= $(patsubst %, %.o, $(basename $(SRCS)))

all: adbd

adbd: $(OBJS)
	$(CC) -o $@ $(LDFLAGS) $(OBJS) $(LIBS)

clean:
	rm -rf $(OBJS) adbd
