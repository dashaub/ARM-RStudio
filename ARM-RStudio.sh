#!/usr/bin/env bash
#This script installs R and builds RStudio Desktop for ARM Chromebooks running Ubuntu 16.04

set -euo pipefail

#Install R
sudo apt-get update
sudo apt-get install -y r-base r-recommended r-base-dev

#Install RStudio build dependencies
sudo apt-get install -y git pandoc
sudo apt-get install -y build-essential pkg-config fakeroot cmake ant libjpeg62
sudo apt-get install -y uuid-dev libssl-dev libbz2-dev zlib1g-dev libpam-dev
sudo apt-get install -y libapparmor1 apparmor-utils libboost-all-dev libpango1.0-dev
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install -y cabal-install ghc
#sudo apt-get install -y qt-sdk

#Download RStudio source
#Set RStudio version
VERS="v0.98.982"
BUILD_DIR="${HOME}"
cd "${BUILD_DIR}"
wget https://github.com/rstudio/rstudio/tarball/$VERS
mkdir "rstudio-${VERS}" && tar xf "${VERS}" -C "rstudio-${VERS}" --strip-components 1
rm "${VERS}"

#Run common environment preparation scripts
cd "rstudio-${VERS}/dependencies/common/"
mkdir "${BUILD_DIR}/rstudio-${VERS}/dependencies/common/pandoc"
cd "${BUILD_DIR}/rstudio-${VERS}/dependencies/common/"
./install-gwt
./install-dictionaries
./install-mathjax
./install-boost > boostlog.log
./install-packages

#Get Closure Compiler and replace compiler.jar
cd
wget http://dl.google.com/closure-compiler/compiler-latest.zip
unzip compiler-latest.zip
rm COPYING README.md compiler-latest.zip
sudo mv "closure-compiler*.jar" "~/rstudio-${VERS}/src/gwt/tools/compiler/compiler.jar"

#Configure cmake and build RStudio
cd "${BUILD_DIR}/rstudio-${VERS}/"
mkdir build
sudo cmake -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release
sudo make install

#Clean the system of packages used for building
cd
sudo apt-get autoremove -y cabal-install ghc pandoc libboost-all-dev
sudo rm -rf "rstudio-${VERS}"
sudo apt-get autoremove -y
