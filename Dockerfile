FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get clean

# Add the deadsnakes PPA for additional Python versions
RUN add-apt-repository ppa:deadsnakes/ppa

# Update the package list and install Python 3.8
RUN apt-get update && \
    apt-get install -y python3.8 && \
    apt-get clean

# Set up alternative link for python3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install pip
RUN apt-get update && \
    apt-get install -y python3-pip && \
    apt-get clean

# Upgrade pip to the latest version
RUN pip3 install --upgrade pip


# Install dependencies
RUN pip3 install setuptools==61 \
    && pip3 install 'setuptools_scm>=8,<9'

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    libcairo2-dev \
    libgirepository1.0-dev \
    libjpeg-dev \
    pkg-config \
    python3.8-dev \
    python3-wheel \
    python3-gst-1.0 \
    python3-gi \
    python3-websockets \
    python3-psutil \
    python3-uvloop \
        && apt-get clean

RUN apt-get update && \
    apt-get install -yq \
    build-essential \
    gcc \
    git \ 
    libffi6 libffi-dev \
    gobject-introspection \
    gstreamer1.0-libav \
    gstreamer1.0-nice \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools \
    gir1.2-gst-plugins-bad-1.0

RUN git clone --depth 1 https://github.com/bbc/brave.git && \
    cd brave && \
    pip3 install pipenv sanic && \
    pipenv install --ignore-pipfile && \
    mkdir -p /usr/local/share/brave/output_images/

COPY ./brave/config.py ./brave/brave/config.py

EXPOSE 8080
WORKDIR /brave
CMD ["pipenv", "run", "/brave/brave.py"]
