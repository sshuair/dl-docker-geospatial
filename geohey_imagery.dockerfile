FROM ubuntu:16.04
MAINTAINER jingcb<jingcb@geohey.com>





# install dependencies
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\ 
    build-essential \
    software-properties-common \
    curl \
    cmake \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    pkg-config \
    rsync \
    zip \
    unzip \
    git \
    wget \
    vim \
    ca-certificates \
    python3-dev \
    python3-pip \
    graphviz \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python3-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# note: due to pytorch 0.2 rely on numpy 1.13, it's have to upgrade numpy from 1.11.0 to 1.13.
RUN pip3 --no-cache-dir install\
    setuptools \
    Pillow \
    flask \
    ipykernel \
    numpy \
    json \
    rasterio==1.0a12 \
    mercantile \
    rio_toa \
    cachetools \
    pyyaml \
    rio-pansharpen \
    && \
    python3 -m ipykernel.kernelspec

