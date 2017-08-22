FROM nvidia/cuda:8.0-cudnn6-runtime-ubuntu14.04

MAINTAINER jingcb@geohey.com

ENV PYTHONPATH /opt/caffe-segnet/python
ENV PATH $PATH:/opt/caffe-segnet/.build_release/tools

# faster apt source
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
  bc \
  git \
  unzip \
  wget \
  curl \

  # for caffe
  libprotobuf-dev \
  libleveldb-dev \
  libsnappy-dev \
  libopencv-dev \
  libhdf5-serial-dev \
  protobuf-compiler \
  libatlas-base-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  liblmdb-dev \
  libboost-all-dev \

  # for caffe python
  python-dev \
  python-pip \
  python-numpy \
  # for scipy
  gfortran \
  # fix: InsecurePlatformWarning: A true SSLContext object is not available.
  libffi-dev \
  libssl-dev \

  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN cd /opt && git clone https://github.com/alexgkendall/caffe-segnet.git && cd caffe-segnet

WORKDIR /opt/caffe-segnet

# Build Caffe core
RUN cp Makefile.config.example Makefile.config && \
    echo "USE_CUDNN :=1" >> Makefile.config && \
    make -j"$(nproc)" all

# Install python deps
RUN pip install --upgrade pip && \
    # fix: InsecurePlatformWarning: A true SSLContext object is not available.
    pip install pyopenssl ndg-httpsclient pyasn1 && \
    for req in $(cat python/requirements.txt); do pip install $req; done

# Build Caffe python
RUN make -j"$(nproc)" pycaffe

# test + run tests
RUN make -j"$(nproc)" test

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
RUN wget http://download.osgeo.org/gdal/1.11.0/gdal-1.11.0.tar.gz && \
  tar xvfz gdal-1.11.0.tar.gz && \
  cd gdal-1.11.0 && \
  ./configure --with-python && \
  make && \
  make install && \
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

