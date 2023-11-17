# This dockerfile serves as image to compile any python pkg
# from source and upload it to pypi

FROM python:3.9.18-bullseye@sha256:9bc9f053ec6abee7bd25e17756d81625e7094fd1c0c4ed4f22c96758dd58849d
# System deps
RUN apt-get update && apt-get install -y \
    build-essential \
    git

# Install build and twine for pkg build and upload
RUN pip install --upgrade build twine
# This ARG is from Makefile
ARG PY_PKG_SRC
RUN mkdir /pkg_build
# Update wkdir
WORKDIR /pkg_build
# Copy code source code here
COPY ./${PY_PKG_SRC} /pkg_build/
COPY ./Makefile /pkg_build/
# This is must, to transfer it to the $HOME
COPY .pypirc /root
# make bash available

CMD ["/bin/bash"]


