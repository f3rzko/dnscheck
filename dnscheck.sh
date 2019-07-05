	domain=''
	sleepc=''
	dns=''
	dnsip=`nslookup localhost | grep Server | cut -b '8-20'`

	if [ -z "$*" ];
	then
	echo "Usage: dnscheck [OPTION...]
	  -d         dns-server ip or hostname
	  -n         domain-name or ip address
	  -s         sleep interval in seconds
	  -v         version ¯\_(@_@)_/¯"
	exit 1
	fi

	while getopts "d:n:s:v" OPTION; do
	case $OPTION in
	d)
	dns=$OPTARG;;
	n)
	domain=$OPTARG;;
	s)
	sleepc=$OPTARG;;
	v)
	echo "DNSCHECK version 0.1 ¯\_(@_@)_/¯"
	exit 1;;
	*)
	echo "ERROR: Incorrect options provided
	Usage: dnscheck [OPTION...]
	  -d         dns-server ip or hostname
	  -n         domain-name or ip address
	  -s         sleep interval in seconds
	  -v         version ¯\_(@_@)_/¯"
	exit 1
	;;
	esac
	done

	if [ -z $domain ];
	then
	echo "ERROR: No domain detected. DNSCHECK stopped.
	Usage: dnscheck [OPTION...]
	  -d         dns-server ip or hostname
	  -n         domain-name or ip address
	  -s         sleep interval in seconds
	  -v         version ¯\_(@_@)_/¯"
	exit 1
	fi

	if [ -z $dns ]; then
	ip=`dig $domain +short`
	dnsip=`nslookup localhost | grep Server | cut -b '8-20'`
	else
	dnsip=$dns
	ip=`dig @$dnsip $domain +short`
	fi

	while [ "1" = "1" ]; do
			if [ "$ip" = "" ]; then
			echo `date +"%Y-%m-%d %R"` "| DNSCHECK | ERROR: DNS server" $dnsip "can't find" $domain ;
			else
			echo `date +"%Y-%m-%d %R"` "| DNSCHECK | SUCCESS: DNS server" $dnsip "converts" $domain "to IP" $ip ;
			fi
			if [ "$sleepc" = "" ]; then
			a="0"
			else
			a="1"
			sleep $sleepc
			fi
	done
	exit 0;