FROM debian:jessie

RUN apt-get -y update && apt-get install -y ca-certificates
ADD bin/http-server ./http-server
EXPOSE 80
USER root
CMD ["./http-server"]
