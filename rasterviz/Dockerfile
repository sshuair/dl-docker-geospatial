FROM ubuntu:16.04    

ENV LANG C.UTF-8

# install dependencies    
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\     
        build-essential \
        software-properties-common \
        python3 \
        python3-dev \
        python3-tk \
        python3-pip \
        libspatialindex-dev \
        vim \
        && \    
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*    

# install gdal
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python3-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install python package
RUN pip3 --no-cache-dir install setuptools && \
    pip3 --no-cache-dir install -i https://pypi.tuna.tsinghua.edu.cn/simple \
        ipykernel \
        Pillow \
        flask \
        numpy \
        rasterio \
        mercantile \
        rio_toa \
        cachetools \
        pyyaml \
        rio-pansharpen \
        gevent \
        gunicorn 

WORKDIR "/root/workdir"
CMD ["/bin/bash"]

