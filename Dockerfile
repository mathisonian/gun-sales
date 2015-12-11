FROM andrewosh/binder-base

MAINTAINER Matthew Conlen <mc@mathisonian.com>

USER root

# Retrieve recent R binary from CRAN
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --force-yes \
        libzmq3-dev r-base-core r-recommended r-base r-base-dev libcurl4-openssl-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*


# Set default CRAN repo
RUN echo 'options("repos"="http://cran.rstudio.com")' >> /usr/lib/R/etc/Rprofile.site

USER main

RUN mkdir $HOME/r-libs
ENV R_LIBS $HOME/r-libs

# Install IRkernel
RUN Rscript -e "install.packages(c('rzmq','repr','IRkernel','IRdisplay'), repos = c('http://irkernel.github.io/', getOption('repos')))" -e "IRkernel::installspec()"
RUN Rscript -e "install.packages(c('curl', 'devtools'))"
