
[![Build Status](https://travis-ci.org/dashaub/ARM-RStudio.svg?branch=master)](https://travis-ci.org/dashaub/ARM-RStudio)

ARM-RStudio
===========
Compile RStudio Desktop for Ubuntu 18.04 LTS on ARM Chromebook or Raspberry Pi

Usage
-------
`git clone` the repo or download the zip file containing ARM-RStudio and extract its contents. Launch a terminal from inside this folder and run `sudo ./ARM-RStudio.sh`. You may need to change the permissions to allow the script to execute, in which case enter `sudo chmod a+x ARM-RStudio.sh` before launching the script.


  What is this?
-----------------
This script installs R and compiles RStudio Desktop for ARM architecture. It was specifically written for the Samsung Chromebook running Ubuntu 14.04 LTS using Crouton but _should_ work for other ARM hardware on Ubuntu. The code can also serve as a guide if you are running a different GNU/Linux distribution on ARM hardware, but the package versions could present issues. Testers wanted!

What is R? RStudio? ARM? Ubuntu? Chromebook? Crouton? Raspberry Pi?
-----------------------------------------------------------------------------------------------------
* [R](http://cran.r-project.org/) is a statistical scripting language and open source software that is very useful for data analysis.
* [RStudio](http://www.rstudio.com/) is a great GUI and IDE for R.
* [ARM](https://en.wikipedia.org/wiki/ARM_architecture) is a processor architecture popular in mobile devices that achieves great energy efficiency. However, it is not common in desktop/notebook computers, so common applications that work for x86 32- and 64-bit processors will not run. This creates some difficulties for desktop/notebook users wishing to run some applications.
* [Ubuntu](https://en.wikipedia.org/wiki/Ubuntu_(operating_system)) is an open source operating system and one of the most popular distributions of [GNU/Linux](https://en.wikipedia.org/wiki/Linux).
* [Chromebooks](https://en.wikipedia.org/wiki/Chromebook) are lightweight notebooks that run Google's Chrome OS. In their configuration out of the box they allow only basic web browsing, but thanks to Crouton users can turn them into a fully-functional GNU/Linux OS.
* [Crouton](https://github.com/dnschneid/crouton) is a powerful tool from [David Schneider](https://github.com/dnschneid) that allows a user to run GNU/Linux on top of Chrome OS, including on Chromebooks with ARM hardware.
* [Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi) is  series of small single-board computers developed in the United Kingdom by the Raspberry Pi Foundation to promote teaching of basic computer science in schools and in developing countries.

Why not just install RStudio from the repos or download the binary?
-------------------------------------
There are none. The downside of running ARM hardware is less support for software packages and trouble porting some software to the architecture. Through a long process of trial and error, this script was hacked together to get RStudio to build using mostly the Ubuntu repos and a few independent downloads. The script will install RStudio **v1.2.5033** but may become broken with newer release of the software.

Will this work with RStudio Server instead of the Desktop edition?
------------------------------------------------------------------------------------------
Yes! See a [server](https://github.com/jrowen/ARM-rstudio-server) project.

Why does this install an old version of RStudio?
----------------------------------------------------------------
The script will by default install version 1.2.5033. This was the most recent version available when the project was completed. Newer releases *might* work fine. If you are feeling adventerous, you can change the value of `VERS` in the script. There is no guarantee this will work, so you have been warned.

Will this script work on a different version of Ubuntu? How about Debian?
----------------------------------------------------------------
Maybe. Feel free to test it and let me know. If I get new ARM hardware running a different OS I might try it out as well.

Why does this take up so much diskspace?
------------------------------------------
Chromebooks are great hardware for browsing the internet, but they don't come with the largest drives. Disk space comes at a premium. RStudio itself requires the heavy `qt-sdk` package (~500mb), and the build process requires several other large packages. The script tries to remove these packages after the install, but the disk cost is still high. Plan to have at least 4.4GB free space before installing. After the packages used for building are removed, RStudio (including installing R if you don't already have it) occupies around 1.8GB.

Why is this so slow to install?
--------------------------------
See above. You will likely have to download ~1 GB of files from the Ubuntu repos and other websources, so care should be taken if you are on a slow or metered connection. In particular, the final step of building and installing RStudio using Java only utilizes a single core and takes several hours. Additionally, the building process can use a significant amount of memory, so you might want to start it on a system without other applications open and allow the script to run ovenight. If everything runs well you will have RStudio by morning and not a paperweight. Needless to say, you should perform a backup (but you do that all the time anyway, right?).
