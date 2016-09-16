#!/bin/bash
set +e
CURRENT_VERSION_LINE=$(grep -Po '<version>\K[^<]*' | grep -E 'SNAPSHOT' ./pom.xml)

CURRENT_VERSION_LINE=${CURRENT_VERSION_LINE//[[:blank]]/}
echo $CURRENT_VERSION_LINE
TMP_VERSION_LINE=${CURRENT_VERSION_LINE#<version>}
echo $TMP_VERSION_LINE
CURRENT_VERSION=${TMP_VERSION_LINE%%-SNAPSHOT</version>}
echo $CURRENT_VERSION

IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
PROD_FIX=${VERSION_PARTS[3]}
echo $PROD_FIX
PROD_FIX_PLUS_1=$((10#$PROD_FIX+1))
echo $PROD_FIX_PLUS_1
if [ ${PROD_FIX_PLUS_1} -lt 10 ]
	then
		PROD_FIX_PLUS_1="0${PROD_FIX_PLUS_1}"
		echo $PROD_FIX_PLUS_1
fi

NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}.${PROD_FIX_PLUS_1}"

echo ' '
echo '         Current POM Version: ' $CURRENT_VERSION
echo '             New POM Version: ' $NEW_VERSION
echo ' '

#find . -name pom.xml -print0 | xargs -0 sed -i "s/<version>.*-SNAPSHOT<\/version>/<version>$NEW_VERSION<\/version>/g"
