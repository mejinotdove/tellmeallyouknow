FROM alpine:3.5

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
