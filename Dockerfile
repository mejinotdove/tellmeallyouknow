FROM alpine:3.5

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

ADD proxy /usr/local/bin/proxy
RUN chmod +x /usr/local/bin/proxy

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
