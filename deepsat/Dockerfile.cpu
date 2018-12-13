FROM ubuntu:16.04

# install dependencies    
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\     
        build-essential \
        software-properties-common \
        python3 \
        python3-dev \
        python3-tk \
        python3-pip \
        build-essential \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        libspatialindex-dev \
        libsm6 \
        vim \
        wget \
        git \
        zip \
        && \
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*    

# install mapnik ，note: mapnik must install before gdal, install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python3-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install python package
RUN pip3 --no-cache-dir install setuptools && \
    pip3 --no-cache-dir install wheel && \
    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple \
        tqdm==4.23.4 \
        numpy==1.14.5 \
        scipy==1.1.0 \
        Pillow==5.1.0 \
        opencv-contrib-python==3.4.1.15 \
        scikit-image==0.14.0 \
        pyyaml==3.13 \
        gdal==2.1.3 \
        rasterio==1.0.2 \
        torch==0.4.1 \
        torchvision==0.2.1
        
ENV LANG=C.UTF-8
WORKDIR "/root/deepsat"    
CMD ["/bin/bash"]
