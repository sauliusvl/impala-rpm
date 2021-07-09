#!/bin/bash

export IMPALA=/impala

export IMPALA_RPM_ROOT=/target/impala/root
export IMPALA_DEBUG_RPM_ROOT=/target/impala-debug/root
export IMPALA_SHELL_RPM_ROOT=/target/impala-shell/root

function prepare_rpm_dir {
  package=$1
  rm -rf /target/${package}
  cp -R /rpm/${package} target/
  find /target/${package} -name '.gitkeep' -exec rm -rf {} \;
}

function separate_debug {
  binary=${IMPALA_RPM_ROOT}/$1
  objcopy --only-keep-debug $binary ${binary}.debug
  objcopy --strip-all ${binary}
  objcopy --add-gnu-debuglink=${binary}.debug ${binary}
  mv ${binary}.debug ${IMPALA_DEBUG_RPM_ROOT}/$1.debug
}

echo 'Building Impala ...'
source ${IMPALA}/bin/impala-config.sh \
 && ${IMPALA}/bin/save-version.sh \
 && ${IMPALA}/buildall.sh -notests -release

echo 'Copying RPM contents ...'

prepare_rpm_dir impala
prepare_rpm_dir impala-debug
prepare_rpm_dir impala-shell

cp -a ${IMPALA}/be/build/release/service/{catalogd,statestored,impalad} ${IMPALA_RPM_ROOT}/usr/lib/impala/sbin/
cp -a ${IMPALA}/fe/target/dependency/*.jar ${IMPALA_RPM_ROOT}/usr/lib/impala/lib/
cp -a ${IMPALA}/fe/target/impala-frontend-4.0.0-SNAPSHOT.jar ${IMPALA_RPM_ROOT}/usr/lib/impala/lib/

cp -a ${IMPALA}/toolchain/toolchain-packages-gcc7.5.0/gcc-7.5.0/lib64/libstdc++.so* ${IMPALA_RPM_ROOT}/usr/lib/impala/lib/
cp -a ${IMPALA}/toolchain/toolchain-packages-gcc7.5.0/gcc-7.5.0/lib64/libgcc_s.so* ${IMPALA_RPM_ROOT}/usr/lib/impala/lib/
cp -a ${IMPALA}/toolchain/toolchain-packages-gcc7.5.0/kudu-b5e7362e69/release/lib64/libkudu_client.so* ${IMPALA_RPM_ROOT}/usr/lib/impala/lib/

cp -R ${IMPALA}/www/* ${IMPALA_RPM_ROOT}/usr/lib/impala/www/

cp -R ${IMPALA}/shell/build/impala-shell-4.0.0-RELEASE/{ext-py,gen-py,lib,impala_shell.py,compatibility.py} ${IMPALA_SHELL_RPM_ROOT}/usr/lib/impala-shell/
cp -R ${IMPALA}/shell/build/impala-shell-4.0.0-RELEASE/impala-shell ${IMPALA_SHELL_RPM_ROOT}/usr/bin/
sed -i 's|^SCRIPT_DIR.*$|SCRIPT_DIR=/usr/lib/impala-shell|g' ${IMPALA_SHELL_RPM_ROOT}/usr/bin/impala-shell

echo 'Separating debug information ...'

separate_debug usr/lib/impala/sbin/impalad
separate_debug usr/lib/impala/lib/libkudu_client.so.0.1.0
separate_debug usr/lib/impala/lib/libstdc++.so.6.0.24

echo 'Packaging Impala RPM ...'
fpm -s dir -t rpm -n impala -v 4.0.0 --iteration 0.rc7 --rpm-compression xzmt \
 --before-install /rpm/impala/preinstall.sh \
 -p /target/ \
 -C ${IMPALA_RPM_ROOT}/ etc usr var

echo 'Packaging Impala debug RPM ...'
fpm -s dir -t rpm -n impala-debug -v 4.0.0 --iteration 0.rc7 --rpm-compression xzmt \
 -p /target/ \
 -C ${IMPALA_DEBUG_RPM_ROOT}/ usr

echo 'Packaging Impala Shell RPM ...'
fpm -s dir -t rpm -n impala-shell -v 4.0.0 --iteration 0.rc7 --rpm-compression xzmt \
 -p /target/ \
 -C ${IMPALA_SHELL_RPM_ROOT}/ usr
