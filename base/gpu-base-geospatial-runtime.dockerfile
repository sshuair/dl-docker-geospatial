FROM nvidia/cuda:9.0-base-ubuntu16.04
    
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

# install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python3-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*