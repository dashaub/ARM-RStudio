ARM-RStudio
===========

Compile RStudio for Ubuntu 14.04 on ARM Samsung Chromebook


What is this?
--------------

This script installs R and compiles RStudio for ARM architecture. It was specifically written for the Samsung Chromebook running Ubuntu 14.04 using Crouton but should work for other ARM hardware on Ubuntu. Testers wanted!

Why not just install RStudio from the repos or download the binary?
-------------------------------------
There are none. The downside of running ARM hardware is less support for software packages and trouble porting some software to the architecture. Through a long process of trial and error, this script was hacked together to get RStudio to build using mostly the Ubuntu repos and a few independent downloads. The script will install RStudio 0.98.978 but may become broken with newer release of the software.

Why does this take up so much diskspace?
------------------------------------------
Chromebooks are great hardware for browsing the internet, but they don't come with the largest drives. Disk space comes at a premium. RStudio itself requires the heavy qt-sdk package (~500mb), and the build process requires several other large packages. The script tries to remove these packages after the install, but the disk cost is still high. Plan have at least xxxxxxxxxxxxxxmb free space before installing. After the unneded packages are removed, RStudio (including installing R if you don't already have it) occupies around xxxxxxxxxxxxxxxxxxxmb.

Why is this so slow to install?
--------------------------------
See above. You will likely have to download ~1 GB of files from the Ubuntu repos and other websources, so care should be taken if you are on a slow or metered connection. In particular, the final step of building and installing RStudio using Java only utilizes a single core and takes several hours. Additionally, the building process can use a significant amount of memory, so you might want to start it on a system without other applications open and allow the script to run ovenight. If everything runs well you will have RStudio by morning and not a paperweight.

