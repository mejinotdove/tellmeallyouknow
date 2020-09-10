FROM nginx:1.19.2-alpine

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
