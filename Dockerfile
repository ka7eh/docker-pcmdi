FROM debian:stretch

LABEL maintainer="kaveh.ka@gmail.com"

ENV CONDA_VERSION=5.2.0

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    gcc libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda2-${CONDA_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && . ~/.bashrc

RUN conda create -n pcmdi -y -c uvcdat/label/nightly -c conda-forge -c uvcdat -c pcmdi/label/nightly -c pcmdi gcc libgcc pcmdi_metrics jupyter ipykernel

RUN . activate pcmdi && python -m ipykernel install --user --name pcmdi --display-name "Python (pcmdi)"

RUN . deactivate

