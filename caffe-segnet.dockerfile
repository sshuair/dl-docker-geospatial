FROM ubuntu:14.04
MAINTAINER jingcb@geohey.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        bc \
        cmake \
        gcc-4.6 \
        g++-4.6 \
        gcc-4.6-multilib \
        g++-4.6-multilib \
        software-properties-common \
        curl \
        git \
        wget \
        libyaml-dev \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        libboost-all-dev \
        gfortran \
        libjpeg62 \
        libgflags-dev \
        libfreeimage-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        libatlas-base-dev \
        pkgconf \
        rsync \
        zip \
        unzip \
        vim \
        ca-certificates \
        protobuf-compiler \
        python \
        python-dev \
        python-numpy \
        python-pip \
        ipython \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*


RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-4.6 30 && \
  update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-4.6 30 && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 30 && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 30
RUN cd /opt && git clone https://github.com/alexgkendall/caffe-segnet
ENV CAFFE_ROOT=/opt/caffe-segnet
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

RUN cd /opt && \
  wget https://github.com/schuhschuh/gflags/archive/master.zip && \
  unzip master.zip && \
  cd /opt/gflags-master && \
  mkdir build && \
  cd /opt/gflags-master/build && \
  export CXXFLAGS="-fPIC" && \
  cmake .. && \
  make VERBOSE=1 && \
  make && \
  make install

RUN cd /opt/caffe-segnet && \
  cp Makefile.config.example Makefile.config && \
   echo "CPU_ONLY := 1" >> Makefile.config && \ 
  make all


ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
# Add ld-so.conf so it can find libcaffe.so

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


# install mapnik ，note: mapnik must install before gdal
RUN apt-get update && apt-get --fix-missing install -y python-mapnik && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install python package
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









WORKDIR /workspace