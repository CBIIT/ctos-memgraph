MEMGRAPH_TYPE=$1
MEMGRAPH_VERSION=$2
UBUNTU_VERSION=$3

if [[ "$MEMGRAPH_TYPE" == "memgraph" ]]; then 
	if [[ "$MEMGRAPH_VERSION" == "3.12" ]]; then 
		if [[ "$UBUNTU_VERSION" == "24.04" ]]; then 
			DL_URL=https://download.memgraph.com/memgraph/v3.12.0/ubuntu-24.04/memgraph_3.12.0-1_amd64.deb 
		elif [[ "$UBUNTU_VERSION" == "22.04" ]]; then 
			DL_URLhttps://download.memgraph.com/memgraph/v3.12.0/ubuntu-22.04/memgraph_3.12.0-1_amd64.deb
		else 
			echo "Unable to download $MEMGRAPH_TYPE - $MEMGRAPH_VERSION for $UBUNTU_VERSION" 
		fi 
	elif [[ "$MEMGRAPH_VERSION" == "3.13" ]]; then 
		DL_URL=https://download.memgraph.com/memgraph/v3.13.0/x86_64-deb/memgraph_3.13.0-1_amd64.deb
	else 
		echo "Unavailable $MEMGRAPH_TYPE version $MEMGRAPH_VERSION" 
	fi 
elif [[ "$MEMGRAPH_TYPE" == "memgraph-mage" ]]; then 
	if [[ "$MEMGRAPH_VERSION" == "3.12" ]]; then 
		if [[ "$UBUNTU_VERSION" == "24.04" ]]; then 
			DL_URL=https://download.memgraph.com/memgraph-mage/v3.12.0/ubuntu-24.04/memgraph-mage_3.12.0-1_amd64.deb 
		elif [[ "$UBUNTU_VERSION" == "22.04" ]]; then 
			DL_URL=https://download.memgraph.com/memgraph-mage/v3.12.0/ubuntu-22.04/memgraph-mage_3.12.0-1_amd64.deb 
		else 
			echo "Unable to download $MEMGRAPH_TYPE - $MEMGRAPH_VERSION for $UBUNTU_VERSION" 
		fi 
	elif [[ "$MEMGRAPH_VERSION" == "3.13" ]]; then 
		DL_URL=https://download.memgraph.com/memgraph-mage/v3.13.0/deb/memgraph-mage_3.13.0-1_amd64.deb 
	else 
		echo "Unavailable $MEMGRAPH_TYPE version $MEMGRAPH_VERSION" 
	fi 
else 
	echo "Unavailable type $MEMGRAPH_TYPE" 
fi

if [[ -z "$DL_URL" ]]; then
	echo Unable to figure out URL
else
	echo $DL_URL
fi

