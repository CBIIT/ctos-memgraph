MEMGRAPH_TYPE=$1
MEMGRAPH_VERSION=$2
UBUNTU_VERSION=$3
OSTYPE=$4

if [[ $OSTYPE == "darwin"* ]]; then
	echo "MAC architecture"
	CPU_TYPE="arm64"
	CPU_PATH="aarch64"
else
	echo "PC architecture"
	CPU_TYPE="amd64"
	CPU_PATH="x86_64"
fi

if [[ "$MEMGRAPH_VERSION" == "3.11" || "$MEMGRAPH_VERSION" == "3.12" ]]; then
	if [[ "$UBUNTU_VERSION" != "26.04" ]]; then
		DL_URL=https://download.memgraph.com/memgraph/v$MEMGRAPH_VERSION.0/ubuntu-$UBUNTU_VERSION/memgraph_"$MEMGRAPH_VERSION".0-1_$CPU_TYPE.deb
		if [[ "$MEMGRAPH_TYPE" == "memgraph-mage" ]]; then
			DL_URL="$DL_URL "https://download.memgraph.com/$MEMGRAPH_TYPE/v$MEMGRAPH_VERSION.0/ubuntu-$UBUNTU_VERSION/"$MEMGRAPH_TYPE"_"$MEMGRAPH_VERSION".0-1_$CPU_TYPE.deb
		fi
	fi
elif [[ "$MEMGRAPH_VERSION" == "3.13" ]]; then
	DL_URL=https://download.memgraph.com/memgraph/v$MEMGRAPH_VERSION.0/$CPU_PATH-deb/memgraph_"$MEMGRAPH_VERSION".0-1_$CPU_TYPE.deb
	if [[ "$MEMGRAPH_TYPE" == "memgraph-mage" ]]; then
		DL_URL="$DL_URL "https://download.memgraph.com/$MEMGRAPH_TYPE/v$MEMGRAPH_VERSION.0/deb/"$MEMGRAPH_TYPE"_"$MEMGRAPH_VERSION".0-1_$CPU_TYPE.deb
	fi
else
	echo "Unknown memgraph version $MEMGRAPH_VERSION"
fi

if [[ -z "$DL_URL" ]]; then
	echo Unable to figure out URL
else
	for i in ${DL_URL[@]}; do
		wget $i --no-check-certificate
		sleep .5
		echo "Installing deb package"
		find . -maxdepth 1 -iname "*.deb" -exec apt-get install {} -y \;
		echo "Cleaning up deb package"
		find . -maxdepth 1 -iname "*.deb" -exec rm {} \;
	done
fi

