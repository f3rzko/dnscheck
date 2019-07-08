                domain=''
                sleepc='5'
                dns=''
                dnsip=`nslookup localhost | grep Server | cut -b '8-20'`
                CKIP=''
                CKdmn=''
                scount='0'
                ecount='0'

                if [ -z "$*" ];
                then
                echo "Usage: dnscheck [OPTION...]
                  -d         dns-server
                  -n         domain-name
                  -s         sleep interval in seconds
                  -v         version"
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
                echo "DNSCHECK version 0.99 beta, l0l"
                exit 1;;
                *)
                echo "Incorrect options provided. DNSCHECK script was stopped!"
                echo "Usage: dnscheck [OPTION...]
                  -d         dns-server
                  -n         domain-name
                  -s         sleep interval in seconds
                  -v         version"
                exit 1
                ;;
                esac
                done

                if [ -z $domain ];
                then
                echo "No domain detected. DNSCHECK script was stopped!.
                Usage: dnscheck [OPTION...]
                  -d         dns-server
                  -n         domain-name
                  -s         sleep interval in seconds
                  -v         version"
                exit 1
                fi

trap ctrl_c INT
function ctrl_c() {
        echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | INFO: DNSCHECK script was stopped manually."
echo "--- DNSCHECK statistics for $domain ---"
echo "$tcount requests was sent, $scount times domain was resolved and $ecount unresolved by DNS Server: $dnsip"
                exit 1
}

        CKdmn=`echo $domain | grep -P '(?=^.{5,254}$)(^(?:(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)'`
                if [ "$CKdmn" = "$domain" ]; then
                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | INFO: domain-name successfully detected"
                else
                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | ERROR: domain-name is wrong"
                exit 1
                fi


                if [ -z $dns ]; then
                ip=`dig $domain +short`
                dnsip=`nslookup localhost | grep Server | cut -b '8-20'`
                else
                dnsip=$dns
                ip=`dig @$dnsip $domain +short`
                fi

        CKIP=`echo $ip | cut -d ' ' -f1`

                if [ "$CKIP" = ";" ]; then
                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | ERROR: Connection Timed Out - DNS Server $dns could be reached."
                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | INFO: DNSCHECK script was stopped!"
                exit 1
                fi





                while [ "1" = "1" ]; do
                                if [ "$ip" = "" ]; then
                                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | ERROR: DNS server" $dnsip "can't find" $domain ;
                                ecount=$((ecount + 1))
                                else
                                echo `date +"%Y-%m-%d %R:%S"` "| DNSCHECK | SUCCESS: DNS server" $dnsip "converts" $domain "to IP" $ip ;
                                scount=$((scount + 1))
                                fi
tcount=$((scount + ecount))
                                if [ "$sleepc" = "" ]; then
                                a="0"
                                else
                                a="1"
                                sleep $sleepc
                                fi


done
exit 0
