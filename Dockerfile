FROM ubuntu:20.04

WORKDIR /snpe-v2.14

COPY requirements.txt /snpe-v2.14

RUN DEBIAN_FRONTEND=noninteractive && \
    apt update && apt install -y --no-install-recommends python3.8 python3-pip libpython3.8 libc++-dev libatomic1 libtinfo5 && \
    pip3 install -r requirements.txt --no-cache-dir && \
    rm requirements.txt && \
    apt clean && rm -rf /var/lib/apt/lists/*
