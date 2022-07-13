FROM centos@sha256:c73f515d06b0fa07bb18d8202035e739a494ce760aa73129f60f4bf2bd22b407
# 7.9.2009

RUN yum install -y epel-release-7-11 centos-release-scl-rh-2-3.el7.centos && yum makecache

RUN yum install --enablerepo=centos-sclo-rh -y \
  autoconf-2.69-11.el7 \
  automake-1.13.4-3.el7 \
  bison-3.0.4-2.el7 \
  byacc-1.9.20130304-3.el7 \
  bzip2-1.0.6-13.el7 \
  ccache-3.7.7-1.el7 \
  curl-7.29.0-59.el7_9.1 \
  cyrus-sasl-2.1.26-24.el7_9 \
  cyrus-sasl-devel-2.1.26-24.el7_9 \
  cyrus-sasl-gssapi-2.1.26-24.el7_9 \
  cyrus-sasl-plain-2.1.26-24.el7_9 \
  flex-2.5.37-6.el7 \
  gcc-4.8.5-44.el7 \
  gcc-c++-4.8.5-44.el7 \
  git-1.8.3.1-23.el7_8 \
  glibc-devel-2.17-326.el7_9 \
  java-1.8.0-openjdk-devel-1.8.0.332.b09-1.el7_9 \
  krb5-devel-1.15.1-54.el7_9 \
  libdb4-devel-4.8.30-13.el7 \
  libevent-devel-2.0.21-4.el7 \
  libffi-devel-3.0.13-19.el7 \
  libtool-2.4.2-22.el7_3 \
  lzo-devel-2.06-8.el7 \
  make-3.82-24.el7 \
  mawk-1.3.4-6.20131226.el7 \
  ncurses-devel-5.9-14.20130511.el7_4 \
  ntp-4.2.6p5-29.el7.centos.2 \
  openssl-devel-1.0.2k-25.el7_9 \
  pigz-2.3.4-1.el7 \
  postgresql-9.2.24-8.el7_9 \
  postgresql-server-9.2.24-8.el7_9 \
  python-devel-2.7.5-92.el7_9 \
  python-setuptools-0.9.8-7.el7 \
  readline-devel-6.2-11.el7 \
  redhat-lsb-4.1-27.el7.centos.1 \
  rpm-build-4.11.3-48.el7_9 \
  rsync-3.1.2-10.el7 \
  unzip-6.0-24.el7_9 \
  vim-common-7.4.629-8.el7_9 \
  wget-1.14-18.el7_6.1 \
  which-2.20-7.el7 \
  zlib-devel-1.2.7-20.el7_9 \
  rh-ruby27-2.7-2.el7 \
  rh-ruby27-ruby-devel-2.7.4-130.el7 \
&& yum clean all

RUN echo '#!/bin/bash' > /etc/profile.d/enableruby27.sh \
 && echo 'source scl_source enable rh-ruby27' >> /etc/profile.d/enableruby27.sh \
 && chmod +x /etc/profile.d/enableruby27.sh \
 && source /etc/profile.d/enableruby27.sh \
 && gem install --version 1.15.5 --platform=ruby ffi \
 && gem install --version 1.11.0 git \
 && gem install --no-document --version 1.14.2 fpm

RUN curl -fSL "http://apache.mirror.vu.lt/apache/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz" -o /tmp/mvn.tar.gz \
 && tar -xzvf /tmp/mvn.tar.gz -C /usr/local \
 && rm -rf /tmp/mvn.tar.gz \
 && mkdir /root/.m2

ENV PATH=${PATH}:/usr/local/apache-maven-3.8.6/bin
