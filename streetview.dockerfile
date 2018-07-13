FROM ubuntu:16.04

# install dependencies
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\ 
        build-essential \
        software-properties-common \
        curl \
        cmake \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        libspatialindex-dev \
        pkg-config \
        rsync \
        zip \
        unzip \
        git \
        wget \
        ca-certificates \
        python3 \
        python3-dev \
        python3-pip \
        ipython3 \
        graphviz \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install python package
RUN pip3 --no-cache-dir install setuptools \
	numpy \
    Pillow \
    flask \
    tarfile \
    tensorflow 


# TensorBoard(6006) # jupyter noteboook(8888)
EXPOSE 6006 8888 7777

RUN mkdir /workdir

COPY /Users/zhangyaxu/street-view /workdir

WORKDIR "/root"
# CMD ["/bin/bash"]
ENTRYPOINT ["python3", "/workdir/app.py"]