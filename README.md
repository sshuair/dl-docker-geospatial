# Deep Learning Docker for Geospatial
Deep learning docker files and docker images for geospatial anaysis. It contains the most popular deep learning frameworks(PyTorch and Tensorflow) with CPU and GPU support (CUDA and cuDNN included). And some other commonly used packages in machine learning and geospatial anaysis.

Docker Hub: [deepgeo](https://hub.docker.com/r/sshuair/deepgeo/)

## support docker image tags
- all-cpu-torch1.0.1-tf0.12.0
- all-cuda10-cudnn7-runtime-torch1.0.1-tf0.12.0
- all-cuda10-cudnn7-devel-torch1.0.1-tf0.12.0
- pytorch-1.0.1-cuda10-runtime
- pytorch-1.0.1-cuda10-devel
- tensorflow-0.12.0-cuda10-runtime
- tensorflow-0.12.0-cuda10-devel

## packages contain
### deep learning framework
- tensorflow
- keras
- pytorch

### machine learning farmework
- scikit-learn
- scikit-image
- xgboost

### geospatial packages
- GDAL
- fiona
- shapely
- rasterio
- tifffile
- geopandas

### other related packages
- numpy
- scipy
- OpenCV
- Pillow
- jupyter
- matplotlib
- pandas

## usage
### build image

`docker build -t REPOSITORY:TAG -f Dockerfile .`

### pull image

- cpu version: `docker pull sshuair/deepgeo:[TAG]`
- gpu version: `docker pull sshuair/deepgao:[TAG]`

### start container
1. cpu: `docker run -it --name [CONTAINER-NAME] -p 8888:8888 -p 6006:6006 -v /sharedfolder:/workdir sshuair/deepgeo:[TAG] bash`
2. gpu: `nvidia-docker run -it --name [CONTAINER-NAME] -p 8888:8888 -p 6006:6006 -v /sharedfolder:/workdir sshuair/deepgeo:[TAG] bash`


### jupyter notebook
If you want run jupyter notebook in a docker container you should use the follow command in a running docker container:
`jupyter notebook --allow-root`

