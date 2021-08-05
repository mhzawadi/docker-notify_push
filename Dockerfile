FROM alpine:3.13
MAINTAINER Matthew Horwood <matt@horwood.biz>

# Install required deb packages
RUN apk update && \
	rm -f /var/cache/apk/*;

ENV NOTIFY_SOURCE="https://github.com/nextcloud/notify_push/releases/download" \
    NOTIFY_VERSION="0.2.2"

COPY start.sh /bin/

# copy notify_push sources to web dir
ADD ${NOTIFY_SOURCE}/v${NOTIFY_VERSION}/notify_push.tar.gz /tmp/
RUN cd /opt && \
    tar -xzf /tmp/notify_push.tar.gz;

EXPOSE 7867
CMD ["/bin/start.sh"]
