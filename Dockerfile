FROM ubuntu:14.04

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
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

RUN easy_install pip
RUN pip install --upgrade virtualenv
RUN pip install RSeQC
RUN mkdir /ref
WORKDIR /ref
RUN wget "http://downloads.sourceforge.net/project/rseqc/BED/Human_Homo_sapiens/hg38_GENCODE_v23.bed.gz"
RUN gzip -df hg38_GENCODE_v23.bed.gz
WORKDIR /
RUN git clone git://github.com/GregoryFaust/samblaster.git
WORKDIR /samblaster
RUN make
RUN mv  samblaster /usr/local/bin
WORKDIR /
RUN wget https://github.com/lomereiter/sambamba/releases/download/v0.6.1/sambamba_v0.6.1_linux.tar.bz2
RUN tar -xf sambamba_v0.6.1_linux.tar.bz2
RUN mv  sambamba_v0.6.1 /usr/local/bin/sambamba
COPY runQC.sh /usr/local/bin/
RUN chmod -R +x  /usr/local/bin/
COPY parseReadDist.R /usr/local/bin/
