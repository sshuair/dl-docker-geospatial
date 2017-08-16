FROM ubuntu:14.04
MAINTAINER caffe-maint@googlegroups.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
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
RUN cd /opt && git clone https://github.com/alexgkendall/caffe-segnet
ENV CAFFE_ROOT=/opt/caffe-segnet
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

RUN apt-get install openblas
RUN cd /opt/caffe-segnet && \
  cp Makefile.config.example Makefile.config && \
   echo "CPU_ONLY := 1" >> Makefile.config && \ 
  make all


ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
# Add ld-so.conf so it can find libcaffe.so
ADD caffe-ld-so.conf /etc/ld.so.conf.d/

# Run ldconfig again (not sure if needed)
RUN ldconfig

# Install python deps
RUN cd /opt/caffe-segnet && \
  cat python/requirements.txt | xargs -L 1 sudo pip install

# Numpy include path hack - github.com/BVLC/caffe/wiki/Ubuntu-14.04-VirtualBox-VM
RUN ln -s /usr/include/python2.7/ /usr/local/include/python2.7 && \
  ln -s /usr/local/lib/python2.7/dist-packages/numpy/core/include/numpy/ /usr/local/include/python2.7/numpy

# Build Caffe python bindings
RUN cd /opt/caffe-segnet && make pycaffe


# Make + run tests
RUN cd /opt/caffe-segnet && make test && make runtest

WORKDIR /workspace