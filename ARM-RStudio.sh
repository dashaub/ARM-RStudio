#!/usr/bin/env bash
#This script installs R and builds RStudio Desktop for ARM Chromebooks running Ubuntu 14.04

set -euo pipefail

#Install R
echo "Installing R"
sudo apt-get update
sudo apt-get install -y r-base r-base-dev


#Install RStudio build dependencies
echo "Installing system packages"
sudo apt-get install -y git pandoc qt-sdk ghc cabal-install wget
sudo apt-get install -y build-essential pkg-config fakeroot cmake ant apparmor-utils
sudo apt-get install -y uuid-dev libssl-dev libbz2-dev zlib1g-dev libpam-dev
sudo apt-get install -y libapparmor1 libboost-all-dev libpango1.0-dev libjpeg62
sudo apt-get install -y openjdk-7-jdk


#Download RStudio source
#Set RStudio version
VERS='v0.98.982'
BUILD_DIR="${HOME}"

echo "Downloading RStudio ${VERS}"
cd "${BUILD_DIR}"
wget "https://github.com/rstudio/rstudio/tarball/${VERS}"
mkdir "rstudio-${VERS}"
tar xvf "${VERS}" -C "rstudio-${VERS}" --strip-components 1
rm "${VERS}"

#Run common environment preparation scripts
cd "${BUILD_DIR}/rstudio-${VERS}/dependencies/common/"
mkdir -p "${BUILD_DIR}/rstudio-${VERS}/dependencies/common/pandoc"
cd "${BUILD_DIR}/rstudio-${VERS}/dependencies/common/"
echo "Installing dependencies"
echo "Installing gwt"
./install-gwt
echo "Installing dictionaries"
./install-dictionaries
echo "Installing mathjax"
./install-mathjax
echo "Installing boost"
./install-boost
echo "Installing packages"
./install-packages

#Get Closure Compiler and replace compiler.jar
echo "Installing Closure compiler"
cd "${BUILD_DIR}"
wget http://dl.google.com/closure-compiler/compiler-latest.zip
unzip compiler-latest.zip
rm COPYING README.md compiler-latest.zip
mv closure-compiler*.jar compiler.jar
sudo mv compiler.jar "${BUILD_DIR}/rstudio-${VERS}/src/gwt/tools/compiler/"

#Configure cmake and build RStudio
echo "Building RStudio"
cd "${BUILD_DIR}/rstudio-${VERS}/"
mkdir build
CXXFLAGS="-march=native" cmake -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release
echo "Installing RStudio"
sudo make install

#Clean the system of packages used for building
echo "Removing installed packages"
sudo apt-get autoremove -y cabal-install ghc pandoc libboost-all-dev
sudo rm -rf "${BUILD_DIR}/rstudio-${VERS}"
sudo apt-get autoremove -y
