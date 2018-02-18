# geo deep learning docker

Deep learning docker with geo-package support. it's only support python3(currently python 3.5).

You can pull the image from docker hub: https://hub.docker.com/r/sshuair/dl-satellite/

## deep learning framework
- tensorflow
- keras
- pytorch
- mxnet

## machine learning farmework
- scikit-learn
- scikit-image
- xgboost
- hyperopt

## geo packages
- gdal
- mapnik
- shapely
- folium
- rasterio
- tifffile
- geopandas
- ipyleaflet

## other related packages
- numpy
- scipy
- OpenCV 3
- Pillow
- jupyter
- h5py
- matplotlib
- pandas
- sympy
- bokeh
- progressbar33

## usage
### build image

`docker build -t repository:tag . -f Dockerfile.cpu`

### pull image

- cpu version: `docker pull sshuair/dl-satellite:cpu`
- gpu version: `docker pull sshuair/dl-satellite:gpu`

### start container
1. cpu: `docker run -it --name dl-satellite -p 8888:8888 -p 6006:6006 -v /sharedfolder:/workdir sshuair/dl-satellite:cpu bash`
2. gpu: `nvidia-docker run -it --name dl-satellite -p 8888:8888 -p 6006:6006 -v /sharedfolder:/workdir sshuair/dl-satellite:gpu bash`


## useful command
## jupyter notebook
If you want run jupyter notebook in a docker container you should use the follow command in a running docker container:
`jupyter notebook --allow-root`


## pytorch ipc
Please note that PyTorch uses shared memory to share data between processes, so if torch multiprocessing is used (e.g. for multithreaded data loaders) the default shared memory segment size that container runs with is not enough, and you should increase shared memory size either with --ipc=host or --shm-size command line options to nvidia-docker run.

`nvidia-docker run --rm -ti --ipc=host sshuair/dl-satellite:gpu`
