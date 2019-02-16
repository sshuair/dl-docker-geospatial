ARG CUDA=10.0
ARG CUDNN=7

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-runtime-ubuntu18.04
ENV LANG=C.UTF-8

ARG TORCH_VERSION=1.0.1

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
        libpng-dev \
        libzmq3-dev \
        libspatialindex-dev \
        gdal-bin \
        libgdal-dev \
        python3-gdal \
        libsm6 \
        vim \
        wget \
        zip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    

# install python package
RUN pip3 --no-cache-dir install setuptools && \
    pip3 --no-cache-dir install wheel && \
    pip3 install \
        jupyterlab \
        numpy \
        scipy \
        Pillow \
        matplotlib \
        opencv-contrib-python \
        scikit-image \
        scikit-learn \
        xgboost \
        fiona \
        shapely \
        geopandas \
        rasterio \
        tifffile

# install deep learning framework
RUN pip3 --no-cache-dir install \
    https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl \
    torchvision

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /

WORKDIR "/deepgeo"
CMD ["/bin/bash"]