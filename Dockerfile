FROM jupyter/minimal-notebook:6cc4a8596a0b

USER root

# dependencies
RUN apt-get update
RUN apt-get install -y openjdk-18-jdk maven


# ijava kernel
WORKDIR /app
RUN git clone --branch try-upgrade-gradle --depth 1 https://github.com/hanslovsky/Jupyter-kernel-installer-gradle.git
RUN git clone --depth 1 https://github.com/hanslovsky/IJava.git

WORKDIR /app/Jupyter-kernel-installer-gradle
RUN ./gradlew publishToMavenLocal

WORKDIR /app/IJava
RUN ./gradlew installKernel


# cleanup etc.
RUN rm -rf /app


# user name and ID comes from base container
# for Binder and Fastpages, wants the content repo in $HOME, which we'll test here,
#   even though this repo is just the Dockerfile
ENV HOME /home/${NB_USER}
COPY . ${HOME}
RUN chown -R ${NB_UID}:${NB_GID} ${HOME}
WORKDIR ${HOME}

USER ${NB_USER}