# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.3.0

# system libraries of general use
## install debian packages
RUN apt-get update -qq \
  && apt-get -y --no-install-recommends install \
    libxml2-dev \
  && rm -rf /var/lib/apt/lists/*
    
# Remove shiny-server example apps
WORKDIR /srv/shiny-server
RUN rm -rf *

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

WORKDIR /srv/shiny-server/arima-app/

# Install R dependencies
COPY --chown=shiny:shiny .Rprofile renv.lock ./
COPY --chown=shiny:shiny renv/activate.R renv/
RUN sudo -u shiny Rscript -e 'renv::restore(clean = TRUE)'

# Copy app
COPY --chown=shiny:shiny app.R ./
COPY --chown=shiny:shiny config.yml ./
COPY --chown=shiny:shiny rhino.yml ./
COPY --chown=shiny:shiny app app/


COPY --chown=shiny:shiny docker/shiny-server.conf /etc/shiny-server/

WORKDIR /srv/shiny-server/

USER shiny

# EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
