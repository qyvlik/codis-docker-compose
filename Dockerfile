
FROM alpine/git as gitclone

ENV CODIS_GIT_TAG release3.2

WORKDIR /src

RUN git clone --depth 1 --branch ${CODIS_GIT_TAG} https://github.com/CodisLabs/codis.git

FROM golang:1.8

RUN apt-get update
RUN apt-get install -y autoconf
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV GOPATH /gopath
ENV CODIS  ${GOPATH}/src/github.com/CodisLabs/codis
ENV PATH   ${GOPATH}/bin:${PATH}:${CODIS}/bin

COPY --from=gitclone /src/codis/ ${CODIS}

RUN make -C ${CODIS} distclean
RUN make -C ${CODIS} build-all

VOLUME /codis/log

WORKDIR /codis
