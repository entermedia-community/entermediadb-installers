#!/bin/bash
EMDB_BIN=/opt/entermediadb/common/bin
${EMDB_BIN}/upgrade.sh
${EMDB_BIN}/restart.sh 8444
sleep 5
${EMDB_BIN}/restart.sh 8555

