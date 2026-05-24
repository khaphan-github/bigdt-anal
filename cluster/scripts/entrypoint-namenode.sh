#!/bin/bash
set -e

HADOOP_HOME=${HADOOP_HOME:-/opt/hadoop}

# Setup directories
mkdir -p /var/log/hadoop-hdfs /var/log/hadoop-yarn /var/log/hadoop
chmod 755 /var/log/hadoop* /var/log/hadoop

# Persistent Cluster ID Configuration
NAMENODE_DIR="/var/lib/hadoop-hdfs/cache/dfs/name"
HARDCODED_CLUSTER_ID="bigdt-anal-cluster-001"
CLUSTER_ID_FILE="${NAMENODE_DIR}/.cluster_id"

mkdir -p "${NAMENODE_DIR}"

# Load or initialize cluster ID
if [ -f "${CLUSTER_ID_FILE}" ]; then
    CLUSTER_ID=$(cat "${CLUSTER_ID_FILE}")
    echo "[NameNode] Using stored cluster ID: ${CLUSTER_ID}"
else
    CLUSTER_ID="${HARDCODED_CLUSTER_ID}"
    echo "[NameNode] First startup. Storing cluster ID: ${CLUSTER_ID}"
    echo "${CLUSTER_ID}" > "${CLUSTER_ID_FILE}"
fi

# Format HDFS namespace only on first startup
if [ ! -f "${NAMENODE_DIR}/current/fsimage" ]; then
    echo "[NameNode] Formatting with cluster ID: ${CLUSTER_ID}"
    hdfs namenode -format -force -clusterId "${CLUSTER_ID}" >/dev/null 2>&1
    echo "[NameNode] Format complete"
else
    echo "[NameNode] Data found. Reusing existing cluster with ID: ${CLUSTER_ID}"
fi

# Ensure correct permissions
chown hadoop:hadoop "${NAMENODE_DIR}" "${CLUSTER_ID_FILE}" 2>/dev/null || true

echo "[NameNode] Starting NameNode daemon..."
# Start NameNode daemon
hdfs namenode