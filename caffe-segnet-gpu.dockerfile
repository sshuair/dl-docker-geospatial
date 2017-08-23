FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
MAINTAINER jingcb@geohey.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe-segnet
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG="segnet-cleaned"

RUN cd /opt && git clone -b ${CLONE_TAG} --depth 1 https://github.com/alexgkendall/caffe-segnet.git . && \
    for req in $(cat python/requirements.txt) pydot; do pip install $req; done && \
    git clone https://github.com/NVIDIA/nccl.git && cd nccl && make -j install && cd .. && rm -rf nccl && \
    mkdir build && cd build && \
    cmake -DUSE_CUDNN=1 -DUSE_NCCL=1.. && \
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

