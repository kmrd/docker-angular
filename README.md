# docker-angular
Ubuntu + Node 8 + Angular 4

## Usage
### Retrieving from Docker Hub
`docker pull kmrd/ng:latest` 

### Building from the Dockerfile
`docker build -t kmrd/ng .`

### Running
`docker run -it --rm --name ngdev -p 4200:4200 --mount type=bind,source=$(PWD),target=/home/node/app kmrd/ng`
