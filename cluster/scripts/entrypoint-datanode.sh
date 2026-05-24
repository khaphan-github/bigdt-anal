#!/bin/bash
set -e

HADOOP_HOME=${HADOOP_HOME:-/opt/hadoop}
NAMENODE_HOST=${NAMENODE_HOST:-namenode}
DATANODE_DIR="/var/lib/hadoop-hdfs/cache/dfs/data"

# Setup directories
mkdir -p /var/log/hadoop-hdfs /var/log/hadoop-yarn /var/log/hadoop
chmod 755 /var/log/hadoop* /var/log/hadoop

# Create DataNode directories
mkdir -p "${DATANODE_DIR}"
chown hadoop:hadoop "${DATANODE_DIR}"

echo "[DataNode] Waiting for NameNode (${NAMENODE_HOST}:9000)..."
# Wait for NameNode to be ready (max 60 seconds with 2sec intervals)
for i in {1..30}; do
    if nc -z ${NAMENODE_HOST} 9000 2>/dev/null; then
        echo "[DataNode] NameNode is ready after $((i*2)) seconds"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "[DataNode] ERROR: NameNode did not become ready in 60 seconds"
        exit 1
    fi
    sleep 2
done

echo "[DataNode] Starting DataNode daemon..."
# Start DataNode daemon
hdfs datanode
