#!/usr/bin/env bash
CONFIG_FILE="../config/cluster-config.yaml"

export PROJECT_ID=$(yq '.project_id' $CONFIG_FILE)
export PROVIDER=$(yq '.provider' $CONFIG_FILE)
export REGION=$(yq '.region' $CONFIG_FILE)
export SSH_KEY_PATH=$(yq '.ssh_key_path' $CONFIG_FILE)
export MASTER_COUNT=$(yq '.master.count' $CONFIG_FILE)
export WORKER_COUNT=$(yq '.worker.count' $CONFIG_FILE)
export MASTER_TYPE=$(yq '.master.instance_type' $CONFIG_FILE)
export WORKER_TYPE=$(yq '.worker.instance_type' $CONFIG_FILE)
export AWS_PROFILE=$(yq '.aws_profile' $CONFIG_FILE)


echo "✅ Loaded config:"
echo "  Provider: $PROVIDER"
echo "  Region:   $REGION"
echo "  Master:   $MASTER_COUNT"
echo "  Worker:   $WORKER_COUNT"
