FROM alpine

RUN apk add git yq moreutils

COPY setup.sh .

ENTRYPOINT ["sh", "setup.sh"]
