#!/usr/bin/env bash
#This script installs R and builds RStudio Desktop for ARM Raspberry/Chromebook running Ubuntu 18.04

set -euo pipefail

#Install R
echo "Installing R"
if ! [ -x "$(command -v R)" ]; then
  sudo apt-get -y  install apt-transport-https software-properties-common
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
  sudo add-apt-repository -y 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
  sudo apt update
  sudo apt-get -y install r-base r-base-dev
fi

#Install RStudio build dependencies
echo "Installing system packages"
sudo apt-get install -y git pandoc qt-sdk ghc cabal-install wget
sudo apt-get install -y build-essential pkg-config fakeroot cmake ant apparmor-utils clang debsigs dpkg-sig expect gnupg1
sudo apt-get install -y uuid-dev libssl-dev libbz2-dev zlib1g-dev libpam-dev libacl1-dev
sudo apt-get install -y libapparmor1 libboost-all-dev libpango1.0-dev libjpeg62 libattr1-dev libcap-dev libclang-6.0-dev libclang-dev
sudo apt-get install -y libcurl4-openssl-dev libegl1-mesa libfuse2 libgl1-mesa-dev libgtk-3-0 libssl-dev libuser1-dev libxslt1-dev
sudo apt-get install -y lsof patchelf python rrdtool software-properties-common unzip

#Installing JAVA
# Java 8 (not in official repo for bionic)
echo "Installing Java"
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get -y install openjdk-8-jdk
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

#Download RStudio source
#Set RStudio version
VERS='v1.2.5033'
BUILD_DIR="${HOME}"

echo "Downloading RStudio ${VERS}"
cd "${BUILD_DIR}"
wget "https://github.com/rstudio/rstudio/archive/refs/tags/${VERS}.tar.gz"
mkdir "rstudio-${VERS}"
tar xvf "${VERS}.tar.gz" -C "rstudio-${VERS}" --strip-components 1
rm "${VERS}.tar.gz"

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
