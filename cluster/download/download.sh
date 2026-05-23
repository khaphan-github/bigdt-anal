#!/bin/bash
# Download Spark
rm -f "spark-3.5.0-bin-hadoop3.tgz"
rm -rf "spark-3.5.0-bin-hadoop3"
curl -fSL "https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz" -o "spark-3.5.0-bin-hadoop3.tgz"

# Download Hadoop
rm -f "hadoop-3.3.6.tar.gz"
rm -rf "hadoop-3.3.6"
curl -fSL "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz" -o "hadoop-3.3.6.tar.gz"