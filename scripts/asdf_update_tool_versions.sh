#!/bin/bash

#u asdf_update_tool_versions.sh [tool-versions file]

#d Update asdf plugin versions of a .tool-versions file

set -o errexit
set -o pipefail
# set -o verbose
# set -o nounset
# set -o xtrace

TOOL_VERSIONS_FILE=${1:-"$PWD/.tool-versions"}
FMT_TOOL_VERSIONS_TEMP_FILE=$(mktemp)
NEW_TOOL_VERSIONS_CONTENT_TEMP_FILE=$(mktemp)

cat ~/.tool-versions | grep -E '^[a-zA-Z-]+ ([ ]?[a-z.0-9]+){1,}$' > "${FMT_TOOL_VERSIONS_TEMP_FILE}"

while read i;
do
  PLUGIN_NAME="$(echo ${i} | cut -d ' ' -f 1)"

  [ "${PLUGIN_NAME:0}" = "#" ] && echo "${i}" >> "${NEW_TOOL_VERSIONS_CONTENT_TEMP_FILE}" && continue

  PLUGIN_VERSION="$(echo ${i} | cut -d ' ' -f 2)"
  PLUGIN_FALLBACK_VERSIONS="$(echo ${i} | cut -d ' ' -f 3-)"
  ASDF_LATEST_VERSION="$(asdf latest ${PLUGIN_NAME} 2> /dev/null)"

  [ -z "${ASDF_LATEST_VERSION}" ] && echo "Failed to fetch latest release of ${PLUGIN_NAME}" 1>&2 && echo "${i}" >> "${NEW_TOOL_VERSIONS_CONTENT_TEMP_FILE}" && continue

  if [ "${ASDF_LATEST_VERSION}" != "${PLUGIN_VERSION}" ];
  then
    LATEST=$(printf '%s\n' "${ASDF_LATEST_VERSION}" "${PLUGIN_VERSION}" | sort -r -n -t. | head -n 1)

    if [ "${LATEST}" = "${PLUGIN_VERSION}" ];
    then
      ASDF_LATEST_VERSION="$(asdf list all ${PLUGIN_NAME} | sort -r -n -t. | grep -E '^([ ]?[a-z.0-9]+){1,}$' | head -n 1)"
    fi;

    echo "Update plugin ${PLUGIN_NAME}: ${PLUGIN_VERSION} -> ${ASDF_LATEST_VERSION}" 1>&2
  else
    echo "Plugin ${PLUGIN_NAME} already at latest version" 1>&2
  fi;

  echo "${PLUGIN_NAME} ${ASDF_LATEST_VERSION} ${PLUGIN_FALLBACK_VERSIONS}" >> "${NEW_TOOL_VERSIONS_CONTENT_TEMP_FILE}"
done < "${TOOL_VERSIONS_FILE}"

cat "${NEW_TOOL_VERSIONS_CONTENT_TEMP_FILE}"
# mv "${TOOL_VERSIONS_FILE}" "${TOOL_VERSIONS_FILE}.bak"
# mv "${TEMP_FILE}" ${TOOL_VERSIONS_FILE}

