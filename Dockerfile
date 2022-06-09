FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libz-dev

ADD . /repo
WORKDIR /repo
RUN gcc kseq_test.c -lz -o kseq

RUN mkdir -p /deps
RUN ldd /repo/kseq | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/kseq /repo/kseq
ENV LD_LIBRARY_PATH=/deps
