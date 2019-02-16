FROM ubuntu:18.04
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

ARG TORCH_VERSION=1.0.1.post2
ARG TENSORFLOW_VERSION=1.12.0

# install dependencies    
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\     
        build-essential 