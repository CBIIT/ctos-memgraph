MEMGRAPH_TYPE=$1
MEMGRAPH_VERSION=$2
UBUNTU_VERSION=$3
OSTYPE=$4
URLS_FILENAME=$5

if [[ $OSTYPE == "darwin"* ]]; then
	echo "MAC architecture"
	CPU_TYPE="arm64"
	CPU_PATH="aarch64"
else
	echo "PC architecture"
	CPU_TYPE="amd64"
	CPU_PATH="x86_64"
fi

DL_URL=`python3 return_urls.py -c $URLS_FILENAME -v $MEMGRAPH_VERSION -t $MEMGRAPH_TYPE -s ubuntu-$UBUNTU_VERSION -a $CPU_TYPE`
echo $DL_URL

if [[ -z "$DL_URL" ]]; then
	echo Unable to figure out URL
else
	for i in ${DL_URL[@]}; do
		# Assuming we're building Mac locally, so we'd need to skip for VPN
		if [[ "$CPU_TYPE" == "arm64" ]]; then
			wget $i --no-check-certificate -nv
		else
			wget $i -nv
		fi
		sleep .5
	done
	DEB_FILES=""
	for file_name in *; do
		if [[ $file_name == *.deb ]]; then
			DEB_FILES="$DEB_FILES ./$file_name"
			echo "Installing deb package $file_name"
		fi
	done
	echo "files to be installed: $DEB_FILES"
	apt-get install $DEB_FILES -y
	APT_RESULT=$?
	if [[ $APT_RESULT -ne 0 ]]; then
		apt-get install $DEB_FILES -y
	fi
	echo "Cleaning up debian files"
	rm *.deb
fi

