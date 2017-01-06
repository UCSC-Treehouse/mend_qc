FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
    python \
    python-pip \
    python-dev \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    wget \
    git \
    r-base \
    littler

RUN pip install RSeQC

RUN mkdir /ref
ADD http://downloads.sourceforge.net/project/rseqc/BED/Human_Homo_sapiens/hg38_GENCODE_v23.bed.gz /ref
RUN gzip -df /ref/hg38_GENCODE_v23.bed.gz

RUN git clone git://github.com/GregoryFaust/samblaster.git
RUN cd /samblaster && make && mv samblaster /usr/local/bin

ADD https://github.com/lomereiter/sambamba/releases/download/v0.6.1/sambamba_v0.6.1_linux.tar.bz2 /
RUN tar -xf sambamba_v0.6.1_linux.tar.bz2
RUN mv sambamba_v0.6.1 /usr/local/bin/sambamba
RUN chmod +x /usr/local/bin/sambamba

WORKDIR /app
ADD . /app
ENV PATH /app:$PATH

CMD runQC.sh
