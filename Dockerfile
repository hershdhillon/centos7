FROM centos:centos7

MAINTAINER Harsh Dhillon

ENV container docker

RUN yum -y reinstall "*" && yum clean all

# System development Libraries Installation

RUN yum -y install -y deltarpm && \
    yum update -y && \
	yum -y install \
           gcc \
	   bzip2-devel \
	   zlib-devel \
	   openssl-devel \
	   libffi-devel \
	   make \
	   devtoolset-6 \
	   centos-release-scl \
	   scl-utils \
	   python-pip\
	   wget \
	   deltarpm \
	   tcsh \
	   ncurses-devel \
	   sqlite-devel \
	   readline-devel \
	   tk-devel \
	   gdbm-devel \
	   db4-devel \
	   libpcap-devel \
	   xz-devel \
	   expat-devel \
	   mlocate \
	   libXext \
	   libSM \
	   cmake \
	   yum-utils 

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y centos-release-scl && \
    yum install -y devtoolset-6 \
                   devtoolset-7 \
                   devtoolset-8 && \
    yum clean all && \
    updatedb

# Python 2.7.17 Installation

RUN mkdir /tmp/Python27
WORKDIR /tmp/Python27
RUN wget https://www.python.org/ftp/python/2.7.17/Python-2.7.17.tgz && \
    tar -xzvf Python-2.7.17.tgz && \
	 cd /tmp/Python27/Python-2.7.17 && \
	 ./configure --enable-optimizations --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
	 make altinstall && \
	 cd /tmp && \
	 rm -rf Python* 

RUN yum clean all && \
    rm -rf /var/cache/yum

# Python 2.7.17 Package Installation

WORKDIR /tmp
ADD ./requirements.txt /tmp/requirements.txt
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python2.7 get-pip.py && \
    rm -f get-pip.py && \
    pip2.7 install --upgrade pip && \
    pip2.7 install --upgrade setuptools && \
    python2.7 -m pip install -r requirements.txt && rm requirements.txt
	
RUN yum clean all && \
    rm -rf /var/cache/yum

# Python 3.7.6 Installation

RUN mkdir /tmp/Python37
WORKDIR /tmp/Python37
RUN wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz && \
    tar -xzvf Python-3.7.6.tgz && \
	 cd /tmp/Python37/Python-3.7.6 && \
	 ./configure --enable-optimizations --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
	 make altinstall && \
	 ln -s /usr/bin/python3/bin/python3.7 /usr/bin/python3.7 && \
	 cd /tmp && \
	 rm -rf Python* 

RUN yum clean all && \
    rm -rf /var/cache/yum
	 
# Python 3.7.6 Package Installation
	 
WORKDIR /tmp
ADD ./requirements.txt /tmp/requirements.txt
RUN pip3.7 install --upgrade pip  && \
    pip3.7 install --upgrade setuptools && \
    python3.7 -m pip install -r requirements.txt && rm requirements.txt
	
RUN yum clean all && \
    rm -rf /var/cache/yum


# RPM Installation

RUN yum -y install \
           alien \
	   alsa-lib \
	   boost166 \
	   cairo \
	   cairo-gobject \
	   cairomm \
	   cuda \
	   cuda-devel \
	   ffmpeg \
	   ffmpeg-devel \
	   freetype \
	   freetype-devel \
	   giflib \
	   giflib-devel \
	   glew \
	   glew-devel \
	   glib2-devel \
	   gmp \
	   gmp-devel \
	   graphviz \
	   graphviz-python \
	   gtk2-devel \
	   ImageMagik \
	   jasper \
	   jasper-devel \
	   lcms2 \
	   lcms2-devel \
	   libav \
	   libav-devel \
	   libGLEW \
	   libGLEWmx \
	   libgomp \
	   libjpeg-turbo \
	   libjpeg-turbo-devel \
	   libjpeg.a \
	   libopencore-amr \
	   libpng \
	   libpng-devel \
	   libpng-static \
	   LibRaw \
	   LibRaw-devel \
	   LibRaw-static \
	   libsigc++20 \
	   libsigc++20-devel \
	   libtiff \
	   libtiff-devel \
	   libtiff-static \
	   libtiff-tools \
	   libvo-amrwbenc \
	   libwebp \
	   libwebp-devel \
	   libwebp-tools \
	   libx264 \
	   libx264-devel \
	   mpfr \
	   mpfr-devel \
	   nss-util \
	   nss-util-devel \
	   opencv \
	   opencv-devel \
	   opencv-devel-docs \
	   opencv-python \
	   openjpeg \
	   openjpeg-devel \
	   openjpeg-libs \
	   openjpeg2 \
	   openjpeg2-devel \
	   portaudio \
	   portaudio-devel \
	   pycairo \
	   pycairo-devel \
	   python2-matplotlib \
	   qt5-qtscript \
	   qtlockedfile-qt5 \
	   qtsingleapplication-qt5 \
	   smplayer \
	   sparsehash-devel \
	   x264 \
	   x265 \
	   x265-libs \
	   x265-devel \
	   yasm \
	   yasm-devel 

RUN yum clean all && \
    rm -rf /var/cache/yum

	   
RUN alternatives --install /usr/bin/python python /usr/bin/python3.7 70
RUN alternatives --set python /usr/bin/python3.7

SHELL [ "/usr/bin/scl", "enable", "devtoolset-6"] 

EXPOSE 8080 
CMD ["/usr/bin/bash"]
