#!/bin/bash
set -o nounset
set -o errexit

NFLAG=""
SFLAG=""

while getopts ":ns" opt; do
  case $opt in
    s)
      SFLAG="--size-only"
      ;;
    n)
      NFLAG="-n"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Valid Options: " >&2
      echo "  -s    :   --size-only" >&2
      echo "  -n   :   perform dry-run" >&2
      ;;
  esac
done

# Set the environment by loading from the file "environment" in the same directory
DIR="$( cd "$( dirname $( dirname "$0" ) )" && pwd)"
source "$DIR/.env"

echo "Deploying ${DIR}/${DEPLOY_SOURCE_DIR} to ${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:${DEPLOY_DEST_DIR}"

touch src/layouts/*
echo "Regenerating static files with docpad"
echo ""
docpad generate --env deploy

echo -n "Clean up directory"
chmod -R og+Xr out
find . -type f -name '*.DS_Store' -ls -delete
#rsync $NFLAG -rvzp --size-only --delete --exclude-from="$DIR/.deployignore" "${DIR}/${DEPLOY_SOURCE_DIR}" "${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:${DEPLOY_DEST_DIR}"
echo -n " ...done"
echo "Performinf transfer to server"
echo ""
rsync $NFLAG -rvzp  $SFLAG --delete --exclude-from="$DIR/.deployignore" "${DIR}/${DEPLOY_SOURCE_DIR}" "${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:${DEPLOY_DEST_DIR}"
touch src/layouts/*
