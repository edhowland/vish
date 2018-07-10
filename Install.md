# Installation Notes for Vish language

## Linux systems

Note: This also includes installling on Windows 10 with Window Subsystem for Linux

## Debian flavors

These notes have been tested on the following Linux distros

- Debian stable
- Ubuntu
  * 14.04
  * 16.04 (Testested in Windows Subsystem for Linux)
  * 18.04
- Antix : Version 17.x

### Ruby installation and setup

If you do not yethave  Ruby on your system, follow these steps

```
# For Debian-flavored Linux'es
# Note: If you do not have the latest apt, you may need to replace apt with apt-get
# The apt command meta command has existed since Ubuntu 14.04.
# So it it is used here to achieve cross-platform simplicity.
$ sudo apt update
# Install git if not installed
$ sudo apt install git
# Install the Ruby and dependancies
$ sudo apt install ruby     build-essential   libjson-glib-dev   ruby-dev 
```

## Post Ruby package install instructions

After installing the above packages for Ruby, please do the following steps:

```
# Install the Bundler gem
$ sudo gem install bundler
# Get the Vish git repository
git clone https://github.com/edhowland/vish.git
cd ./vish
$ sudo bundle
```

## Test out the installation

```
$ ./bin/ivs
vish> 1+3
# => 4
vish> exit
```
$ 

### Or build from source:

[ruby-lang.org](https://www.ruby-lang.org/en/)


