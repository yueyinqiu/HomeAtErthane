/*
 * force-bind.c — LD_PRELOAD shim: force outbound sockets onto a specific
 * network interface via SO_BINDTODEVICE.
 *
 * Why: rootless podman's pasta (host-side forwarder) routes the container's
 * outbound traffic through the host's default route, which sing-box's
 * auto_route (fake-ip tun) hijacks. pasta has no option to bind its outbound
 * socket to a device; SO_BINDTODEVICE is the only non-root way to escape the
 * policy routing, and we inject it here.
 *
 * Interface name is read from $FORCE_BIND_IFNAME, default "wlp2s0".
 *
 * Only NON-loopback, NON-unix sockets are bound, so we don't break local
 * (unix socket / 127.x) communication of whatever process loads this.
 */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>

static const char *ifname = NULL;

static void init_ifname(void) {
    if (ifname)
        return;
    ifname = getenv("FORCE_BIND_IFNAME");
    if (!ifname || !*ifname)
        ifname = "wlp2s0";
}

/* return 1 if we should NOT bind this destination to a device */
static int skip(const struct sockaddr *addr) {
    if (!addr)
        return 1;
    switch (addr->sa_family) {
    case AF_UNIX:
        return 1;
    case AF_INET: {
        const struct sockaddr_in *a = (const void *)addr;
        const unsigned char *b = (const unsigned char *)&a->sin_addr.s_addr;
        return b[0] == 127; /* 127.0.0.0/8 */
    }
    case AF_INET6: {
        const struct sockaddr_in6 *a = (const void *)addr;
        return IN6_IS_ADDR_LOOPBACK(&a->sin6_addr);
    }
    default:
        return 1;
    }
}

static void bind_dev(int fd) {
    init_ifname();
    /* best-effort: if the device doesn't exist (yet), just leave the socket
     * alone rather than failing the connection */
    (void)setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, ifname, strlen(ifname));
}

int connect(int fd, const struct sockaddr *addr, socklen_t len) {
    static int (*real)(int, const struct sockaddr *, socklen_t);
    if (!real)
        real = dlsym(RTLD_NEXT, "connect");
    if (!skip(addr))
        bind_dev(fd);
    return real(fd, addr, len);
}

ssize_t sendto(int fd, const void *buf, size_t n, int flags,
               const struct sockaddr *addr, socklen_t len) {
    static ssize_t (*real)(int, const void *, size_t, int,
                           const struct sockaddr *, socklen_t);
    if (!real)
        real = dlsym(RTLD_NEXT, "sendto");
    if (!skip(addr))
        bind_dev(fd);
    return real(fd, buf, n, flags, addr, len);
}

ssize_t sendmsg(int fd, const struct msghdr *msg, int flags) {
    static ssize_t (*real)(int, const struct msghdr *, int);
    if (!real)
        real = dlsym(RTLD_NEXT, "sendmsg");
    if (!skip(msg ? msg->msg_name : NULL))
        bind_dev(fd);
    return real(fd, msg, flags);
}