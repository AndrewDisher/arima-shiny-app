# ARIMA Modelling Application
This repository contains the R code, along with supplementary SCSS and YAML files, and a Dockerfile to create the R/Shiny application. This application was built to help users practice modeling randomly generated
time series data with the [Autoregressive Integrated Moving Average](https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average) (ARIMA) framework, 
proposed by Box and Jenkins. 

The application is hosted on an AWS EC2 instance here: [Practice with ARIMA Modeling](http://ec2-3-222-195-40.compute-1.amazonaws.com:3838/arima-app/).

## R/Shiny
The application was built using the R web application development package called [Shiny](https://www.rstudio.com/products/shiny/). Shiny is an open source
R package developed by [Posit](https://posit.co/products/open-source/rstudio/) with the aim of helping data scientists and analysts communicate statistical findings
by creating complex statistical web applications. 

## Docker
The base image used in the Dockerfile is [rocker/shiny:4.3.0](https://github.com/rocker-org/rocker-versioned2/wiki/shiny_ec168d0acc04).

A pre-built docker image for this project can be found in this [DockerHub repository](https://hub.docker.com/repository/docker/adisher/arima-shiny-app/general) for easy download.

A Dockerfile is provided here in case you'd like to build the image locally. To do this, run in your terminal the command 

```
docker build -t adisher/arima-shiny-app:v1 .
```

To run a container from the built image (or after you've downloaded the pre-built image from DockerHub), run the command

```
docker run -d --rm -p 3838:3838 adisher/arima-shiny-app:v1
```

Shiny natively uses port 3838 and [shiny-server](https://github.com/rstudio/shiny-server), the software used to manage the application, listens on port 3838. So you must include <code>3838:3838</code> in your docker run command. 

After doing so, the application should be available on your local machine at the url <code>localhost:3838/arima-app</code>.

## Dependency Management
This project uses the [renv](https://rstudio.github.io/renv/articles/renv.html) package to manage R package dependencies for the app, 
so the Dockerfile is able to read and download these dependncies when building the Docker image. 

Additional Linux dependencies are addressed via the rocker/shiny image mentioned above. 

## About the App
The application provides al of the tools and necessary diagnostic plots a data scientist would need to accurately model the time series data. On application start up,
a time series is generated with a randomlyselected ARIMA data generating process, which the user is then meant to identify. 

Using diagnostic plots for the autocorrelation function, inverse unit root plots, and various other residual diagnostic plots, a user of this app can iteratively
add and remove model parameters that specify the order of an ARIMA model. 

Once the user is content with their work and the final model they have specified, they can check the answer to validate their proposed model. 

Happy modeling!

![ARIMA-gif](https://github.com/AndrewDisher/arima-shiny-app/assets/67594486/93d63b5c-32a4-4466-ad83-fd4907e5bc36)
