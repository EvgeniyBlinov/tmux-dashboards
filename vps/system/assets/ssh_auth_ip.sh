#!/bin/bash
# vim: set noet ci pi sts=0 sw=4 ts=4 :
echo "Auth log"
echo "---------------------------"
grep Accepted -h /var/log/auth.log* |
	sort -u -k 11,11 |
	awk '{for(i=1;i<=3;++i)printf("%s ",$i);print "|"$11}'
