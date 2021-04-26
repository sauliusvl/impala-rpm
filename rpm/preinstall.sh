#!/bin/sh

getent group impala >/dev/null || groupadd -r impala
getent group hive >/dev/null || groupadd -r hive
getent group hdfs >/dev/null || groupadd -r hdfs
getent passwd impala >/dev/null || /usr/sbin/useradd --comment "Impala" --shell /sbin/nologin -M -r -g impala -G hive --home /var/lib/impala impala

