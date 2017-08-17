FROM kmader/caffe-segnet
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



# install mapnik ，note: mapnik must install before gdal
RUN apt-get update && apt-get --fix-missing install -y python-mapnik && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*




RUN pip install pip --upgrade

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


RUN mv /etc/apt/sources.list.d/pgdg-source.list* /tmp
RUN apt-get remove -y libgdal20
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update -y

RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


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