FROM alpine:3.9 as builder
LABEL maintainer="Gabriel Nepomuceno <ganepomu@microsoft.com>"
LABEL version="3.9.2"

RUN apk update && \
    apk add curl openjdk8-jre-base

WORKDIR /data
RUN curl -O -L http://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip
RUN unzip stanford-corenlp-full-*.zip
RUN mv $(ls -d stanford-corenlp-full-*/) corenlp
RUN rm *.zip

WORKDIR /data/corenlp
RUN curl -O -L http://nlp.stanford.edu/software/stanford-english-corenlp-2018-10-05-models.jar

FROM alpine:3.9
LABEL maintainer="Gabriel Nepomuceno <ganepomu@microsoft.com>"
LABEL version="3.9.2"

RUN apk update && apk add openjdk8-jre-base

WORKDIR /data/corenlp
COPY --from=builder /data/corenlp .

ENV JAVA_XMX 4g
ENV PORT 9000
ENV TIMEOUT 25000
ENV LOGIN ""
ENV PASSWORD ""
EXPOSE $PORT

CMD if [ $LOGIN = "" ]; then java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port $PORT -timeout $TIMEOUT ; else java -Xmx$JAVA_XMX -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port $PORT -timeout $TIMEOUT -username $LOGIN -password $PASSWORD ; fi 