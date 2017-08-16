FROM ubunbu:14.04


ENV PYTHONPATH /opt/caffe-segnet/python

#添加 caffe-segnet 的环境变量
ENV PATH $PATH:/opt/caffe-segnet/.build_release/tools

#获取依赖项
RUN apt-get update && apt-get install -y \
  bc \
  cmake \
  curl \
  gcc-4.6 \
  g++-4.6 \
  gcc-4.6-multilib \
  g++-4.6-multilib \
  gfortran \
  git \
  libprotobuf-dev \
  libleveldb-dev \
  libsnappy-dev \
  libopencv-dev \
  libboost-all-dev \
  libhdf5-serial-dev \
  liblmdb-dev \
  libjpeg62 \
  libfreeimage-dev \
  libatlas-base-dev \
  pkgconf \
  protobuf-compiler \
  python-dev \
  python-pip \
  unzip \
  wget \
  ipython-notebook

#使用gcc 4.6
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-4.6 30 && \
  update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-4.6 30 && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 30 && \
  update-alternatives --install /usr/bin/gcc g++ /usr/bin/g++-4.6 30 &&

#克隆 caffe-segnet 仓库
RUN cd /opt && git clone https://github.com/alexgkendall/caffe-segnet

#Glog
RUN cd /opt && wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz && \
  tar zxvf glog-0.3.3.tar.gz && \
  cd /opt/glog-0.3.3 && \
  ./configure && \
  make && \
  make install

# Workaround for error loading libglog:
#   error while loading shared libraries: libglog.so.0: cannot open shared object file
# The system already has /usr/local/lib listed in /etc/ld.so.conf.d/libc.conf, so
# running `ldconfig` fixes the problem (which is simpler than using $LD_LIBRARY_PATH)
# TODO: looks like this needs to be run _every_ time a new docker instance is run,
#       so maybe LD_LIBRARY_PATh is a better approach (or add call to ldconfig in ~/.bashrc)
RUN ldconfig

#Gflag
RUN cd /opt && \
  wget https://github.com/schuhschuh/gflags/archive/master.zip && \
  unzip master.zip && \
  cd /opt/gflags-master && \
  mkdir build && \
  cd /opt/gflags-master/build && \
  export CXXFLAG = "-fPIC" && \
  cmake .. && \
  make && VERBOSE = 1 && \
  make && \
  make install


#编译caffe-segnet
RUN cd /opt/caffe-segnet && \
  cp Makefile,config,example Makefile.config && \
  echo "CPU_ONLY :=1" >> Makefile.config && \
  echo "CXX := /usr/bin/g++-4.6" >> Makefile.config && \
  sed -i 's/CXX :=/CXX ?=/' Makefile && \
  make all


#添加 ld.so.conf ：可以找到 libcaffe.so

ADD caffe-ld-so.conf /etc/ld.so.conf.d/

#运行 ldconfig
RUN ldconfig

#安装Python 依赖项

RUN cd /opt/caffe-segnet && \
  cat python/requirements.txt | xargs -L 1 sudo pip install


#numpy
RUN ln -s /usr/include/python2.7/ /usr/local/include/python2.7 && \
  ln -s /usr/local/lib/python2.7/dist-packages/numpy/core/include/numpy/ /usr/local/include/python2.7/numpy

#编译caffe Python 依赖项
RUN cd /opt/caffe-segment && make pycaffe

#make + run test
RUN cd /opt/caffe-segment && make test && make runtest

RUN mkdir /work

VOLUME /work

EXPOSE 7777

