#!/bin/bash
# This script installs R and builds RStudio Desktop for ARM Chromebooks running Ubuntu 14.04/16.04
set -e

# Install R
sudo apt-get update
sudo apt-get install -y r-base r-base-dev wget openjdk-8-jdk checkinstall

# Download RStudio source
# Set RStudio version
VERS=v1.1.423
cd ~
wget https://github.com/rstudio/rstudio/tarball/$VERS
mkdir rstudio-$VERS && tar xf $VERS -C rstudio-$VERS --strip-components 1
rm $VERS

# Install dependencies
cd rstudio-$VERS/dependencies/linux
sudo ./install-dependencies-debian

# Configure cmake and build RStudio
cd ~/rstudio-$VERS/
mkdir build
cd build
sudo cmake .. -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release
sudo checkinstall --pkgname rstudio --pkgversion $VERS -y

# Clean the system of packages used for building
cd ~
rm -rf rstudio-$VERS Qt5.4.2
