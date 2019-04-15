# TODO Create variation with different based images:
# * try an Alpline based image
FROM debian:buster
LABEL maintainer="Yoan Tournade <yoan@ytotech.com>"

# Install Texlive: latest release.

# Based on :
# - https://www.tug.org/texlive/quickinstall.html
# - https://tex.stackexchange.com/questions/1092/how-to-install-vanilla-texlive-on-debian-or-ubuntu

# install-tl dependencies.
RUN apt-get update -qq && apt-get install -y \
    wget \
    libswitch-perl

# TODO Make textlive.profile a template, so we can configure the installation path.
COPY ./texlive.profile /tmp/
RUN cd /tmp && wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz \
    && /tmp//install-tl*/install-tl -profile /tmp/texlive.profile

# Cleanup
# Remove installer.
RUN rm -rf /tmp/install-tl-*
# Remove install-tl dependencies.
RUN apt-get remove --purge -y \
    wget \
    libswitch-perl \
    && apt-get autoremove --purge
# Clean APT cache.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Texlive binaries to path.
ENV PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"