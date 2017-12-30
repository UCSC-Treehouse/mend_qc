FROM python:3

RUN apt-get update && apt-get install -y --no-install-recommends \
  samtools \
  bedtools \
  zlib1g-dev \
  time

ADD https://github.com/lomereiter/sambamba/releases/download/v0.6.7/sambamba_v0.6.7_linux.tar.bz2 /tmp
RUN tar -xf /tmp/sambamba_v0.6.7_linux.tar.bz2 -C /usr/local/bin/

ADD hg38_GENCODE_v23.bed /ref/

WORKDIR /app
ADD requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt
