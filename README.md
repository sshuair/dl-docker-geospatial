# 影像深度学习docker

## TODO:
0. pytorch 0.2 版本与numpy1.10不兼容，需要升级numpy到1.13

1. `Dockerfile.cpu`还差已下几项：done
    - notebook还未配置完成
    - tensorbord
    - conda未安装

2. Dockerfile.gpu尚未构建，done


3. 自动构建done


4. 地理相关库done
- folium
- ipyleaflet
- rasterio \  WARNING:root:Failed to get options via gdal-config: [Errno 2] No such file or directory: 'gdal-config 
raterio 需要gdal依赖，已经安装了gdal，但是安装方法和之前的不同rasterio的方法如下: 需要确认这种安装会不会导致mapnik等出问题
```
$ sudo add-apt-repository ppa:ubuntugis/ppa
$ sudo apt-get update
$ sudo apt-get install gdal-bin libgdal-dev
$ pip install -U pip
$ pip install rasterio
```

经验证`apt-get install  libgdal-dev`安装完libgdal-dev后可以顺利安装rasterio
apt-get install python3-rasterio
apt-get install rasterio

5. add opencv support

## 依赖以及包库
影像深度学习通用docker包括以下依赖
```
1. gdal
2. mapnik
3. tensorflow 1.2.1
4. keras latest
5. pytorch 0.12
6. mxnet 0.10
```

python package include:
```

```

## 使用说明
### 构建image
1. 通过dockerfile构建，全部构建完成大概要花费1h20min
`docker build -t repository:tag . -f Dockerfile.cpu`


### cpu
- 启动docker 并进入bash界面，退出后删除container(-rm):  
`docker run -it --rm DOCKERNAME:TAG [bash]`

- 启动docker并暴露Notebook(8888)和tensorboard(6006)端口:  
`docker run -it -p 8888:8888 -p 6006:6006 --rm --name container_name dl-ubuntu:v8-notebook [bash]`

- 启动docker并同时运行Notebook，进入容器中也可以启动
`docker run -it -p 8888:8888 -p 6006:6006 --rm --name container_name dl-ubuntu:v8-notebook jupyter-notebook --allow-root`

- 启动docker并同时运行tensorboard，进入容器中也可以启动
`docker run -it -p 8888:8888 -p 6006:6006 --rm --name container_name dl-ubuntu:v8-notebook tensorboard --logdir=/PATH`

- docker新建好之后，可以通过以下命令重启docker  
`docker start CONTAINER ID`

- 进入已近启动的容器
`sudo docker attach nostalgic_hypatia`

## gpu
sudo nvidia-docker-plugin


## 数据卷
1. 挂载本地数据卷到容器  
`docker run -it  -v /Users/sshuair/temp:/notebooks dl-ubuntu:v8-notebook bash`




## docker hub
docker tag server:latest myname/server:latest

- push local images to docker hub 
`docker push sshuair/ubuntu:16.04`

## docker相关命令（删除命令慎用）
以下是一些常用的docker命令，更多命令请到[Docker — 从入门到实践](https://www.gitbook.com/book/yeasy/docker_practice/details)查阅
- 构建image  
`docker build -t DOCKERNAME:TAG . -f Dockerfile.cpu`
- run docker   
    1. without container after exit  
    `docker run -it --rm DOCKERNAME:TAG bash`
    2. 暴露container对外的端口   
    `docker run -it -p 8888:8888 -p 6006:6006 --rm DOCKERNAME:TAG bash`
    3. 直接运行Notebook  
    `docker run -it -p 8888:8888 -p 6006:6006 --rm DOCKERNAME:TAG jupyter-notebook --allow-root`
- 重命名docker
`docker tag server:latest myname/server:latest`
- 列出所有的container  
`docker ps -a`
- 列出当前运行的container  
`docker ps`
- 删除container  
`docker rm [container id / containername]`
- 删除所有的container  
`docker rm $(docker ps -a -q)`
- 列出所有images  
`docker images`
- 删除指定image  
`docker rmi [image id / image name]`
- 删除无效的images  
`docker rmi -f $(docker images -q -f dangling=true)`
- 删除所有images  
`docker rmi $(docker ps -a -q)`
- 从 container 到 主机（host）  
`docker cp containerId:/file/path/within/container /host/path/target`