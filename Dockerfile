FROM debian:stable-slim as build
ARG DSSAT_GIT_REPO=https://github.com/DSSAT/dssat-csm-os.git
ARG DSSAT_GIT_TAG=HEAD

# Install deps and update OS
RUN apt-get update
RUN apt-get install -y git ca-certificates gfortran cmake

# Checkout code
WORKDIR /dssat-csm-os
RUN git clone "${DSSAT_GIT_REPO}" .
RUN git checkout "${DSSAT_GIT_TAG}"

# Compile
RUN mkdir build
WORKDIR /dssat-csm-os/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/dssat ..
RUN make
RUN make install

FROM debian:stable-slim
ENV DSSAT_HOME=/opt/dssat/
COPY --from=build /opt/dssat /opt/dssat/
RUN ln -s /opt/dssat/dscsm048 /usr/local/bin/dscsm048
WORKDIR /app/dssat
ENTRYPOINT ["dscsm048"]
