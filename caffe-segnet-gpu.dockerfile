FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
MAINTAINER jingcb@geohey.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        pkg-config \
        libprotobuf-dev \
        libleveldb-dev \
        libsnappy-dev \
        libhdf5-serial-dev \
        protobuf-compiler \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        liblmdb-dev \
        python-pip \
        python-dev \
        python-numpy \
        python-scipy \
        libopencv-dev \
        && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe-segnet
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
 
RUN cd /opt && git clone https://github.com/alexgkendall/caffe-segnet.git && \
    cd caffe-segnet && \
    cp Makefile.config.example Makefile.config && \
    echo "WITH_PYTHON_LAYER := 1" >> Makefile.config && \
    echo "INCLUDE_DIRS := /usr/include/python2.7 /usr/lib/python2.7/dist-packages/numpy/core/include /usr/local/include /usr/include/hdf5/serial" >> Makefile.config && \
    echo "LIBRARY_DIRS := /usr/lib /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial" >> Makefile.config && \
    echo "CUDA_DIR := /usr/local/cuda-8.0" >> Makefile.config && \
    cd python && \
    pip install --upgrade pip && \
    for req in $(cat requirements.txt); do pip install $req; done && \
    cd ../ && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace

ARG TENSORFLOW_ARCH=cpu
ARG TENSORFLOW_VERSION=1.2.1
ARG PYTORCH_VERSION=v0.2
ARG MXNET_VERISON=latest
ARG KERAS_VERSION=1.2.0

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\ 
        build-essential \
        software-properties-common \
        curl \
        cmake \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        libproj-dev \
        pkg-config \
        rsync \
        zip \
        unzip \
        git \
        wget \
        vim \
        ca-certificates \
        python \
        python-dev \
        python-pip \
        ipython \
        # graphviz \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# install mapnik ，note: mapnik must install before gdal
RUN apt-get update && apt-get --fix-missing install -y python-mapnik && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
    apt update && \
    apt install gdal-bin python-gdal python-gdal && \
    apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN export LD_PRELOAD=/usr/local/lib/libgdal.so.1
RUN export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib


# install python package
RUN pip install pip --upgrade

RUN pip --no-cache-dir install \
        setuptools
# note: due to pytorch 0.2 rely on numpy 1.13, it's have to upgrade numpy from 1.11.0 to 1.13.1
RUN pip --no-cache-dir install --upgrade \
        numpy
RUN pip --no-cache-dir install \
        Pillow \
        ipykernel \
        jupyter \
        scipy \
        # h5py \
        scikit-image \
        # matplotlib \
        pandas \
        # scikit-learn \
        # sympy \
        shapely \
        # bokeh \
        # geopandas \
        # hyperopt \
        # folium \
        # ipyleaflet \
        progressbar \
        && \
    python -m ipykernel.kernelspec







# TODO: 配置jupyter-Notebook，tensorboard已经可以运行
# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
# COPY notebooks /notebooks

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# jupyter noteboook
EXPOSE 8888

RUN mkdir /workdir

WORKDIR "/workdir"

CMD ["/run_jupyter.sh", "--allow-root" ]

