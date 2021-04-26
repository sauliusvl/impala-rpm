#!/bin/bash

export IMPALA=/impala
export TARGET=/target
export RPM_ROOT=${TARGET}/rpm/root

source ${IMPALA}/bin/impala-config.sh && ${IMPALA}/buildall.sh -notests -release

cp ${IMPALA}/be/build/release/service/{catalogd,statestored,impalad} ${RPM_ROOT}/usr/lib/impala/sbin/
cp ${IMPALA}/fe/target/dependency/*.jar ${RPM_ROOT}/usr/lib/impala/lib/
cp ${IMPALA}/fe/target/impala-frontend-0.1-SNAPSHOT.jar ${RPM_ROOT}/usr/lib/impala/lib/

cp ${IMPALA}/toolchain/gcc-4.9.2/lib64/libstdc++.so* ${RPM_ROOT}/usr/lib/impala/lib/
cp ${IMPALA}/toolchain/gcc-4.9.2/lib64/libgcc_s.so* ${RPM_ROOT}/usr/lib/impala/lib/
cp ${IMPALA}/toolchain/kudu-4ed0dbbd1/release/lib64/libkudu_client.so* ${RPM_ROOT}/usr/lib/impala/lib/

fpm -s dir -t rpm -n impala -v 3.4.0 --iteration 1 \
  --before-install ${TARGET}/rpm/preinstall.sh \
  -C ${RPM_ROOT}/ etc usr var

