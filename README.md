# Apache Impala RPM build

As Cloudera no longer provides pre-built packages we build Apache Impala ourselves.

Currently the build is pinned to the latest 3.4.0 version, before starting apply a patch to fix Cloudera repo URLs:

``` sh
$ cd impala && patch -p1 < ../fix-cdn-repos.patch
```

Afterwards just run the `./build.sh` script, it will produce RPMs under `target`.
