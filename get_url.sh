MEMGRAPH_TYPE=$1
MEMGRAPH_VERSION=$2
UBUNTU_VERSION=$3

if [[ "$MEMGRAPH_VERSION" == "3.11" || "$MEMGRAPH_VERSION" == "3.12" ]]; then
	if [[ "$UBUNTU_VERSION" != "26.04" ]]; then
		DL_URL=https://download.memgraph.com/memgraph/v$MEMGRAPH_VERSION.0/ubuntu-$UBUNTU_VERSION/memgraph_"$MEMGRAPH_VERSION".0-1_amd64.deb
		if [[ "$MEMGRAPH_TYPE" == "memgraph-mage" ]]; then
			DL_URL="$DL_URL "https://download.memgraph.com/$MEMGRAPH_TYPE/v$MEMGRAPH_VERSION.0/ubuntu-$UBUNTU_VERSION/"$MEMGRAPH_TYPE"_"$MEMGRAPH_VERSION".0-1_amd64.deb
		fi
	fi
elif [[ "$MEMGRAPH_VERSION" == "3.13" ]]; then
	DL_URL=https://download.memgraph.com/memgraph/v$MEMGRAPH_VERSION.0/x86_64-deb/memgraph_"$MEMGRAPH_VERSION".0-1_amd64.deb
	if [[ "$MEMGRAPH_TYPE" == "memgraph-mage" ]]; then
		DL_URL="$DL_URL "https://download.memgraph.com/$MEMGRAPH_TYPE/v$MEMGRAPH_VERSION.0/deb/"$MEMGRAPH_TYPE"_"$MEMGRAPH_VERSION".0-1_amd64.deb
	fi
else
	echo "Unknown memgraph version $MEMGRAPH_VERSION"
fi

if [[ -z "$DL_URL" ]]; then
	echo Unable to figure out URL
else
	for i in ${DL_URL[@]}; do
		wget $i
	done
fi

