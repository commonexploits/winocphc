#!/usr/bin/env bash
# WinOCPHC - Windows Offline Common Password Hash Checker
# Daniel Compton
# www.commonexploits.com
# contact@commexploits.com
# Twitter = @commonexploits
# 24/10/2013
# Tested on Bactrack 5 & Kali
# reads fgump, gsedump, hashdump pwdump etc hash files

HASHFILE="hashes-tmp"

# Script begins
#===============================================================================

VERSION="1.0"
clear
echo -e "\e[00;31m#############################################################\e[00m"
echo -e "WinOCPHC Version $VERSION "
echo ""
echo -e "Windows Offline Common Password Hash Checker"
echo ""
echo "https://github.com/commonexploits/winocphc"
echo -e "\e[00;31m#############################################################\e[00m"
echo ""
echo -e "\e[1;31m-----------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m Enter the location of the hash file i.e /tmp/hashes.txt (tab to complete path)"
echo -e "\e[1;31m-----------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;32m[-]\e[00m The file can be direct output from hashdump, fgdump, pwdump, gsecdump etc"
echo ""
read -e HASHFILEIN
echo ""
cat "$HASHFILEIN" >/dev/null 2>&1
 if [ $? = 1 ]
   then
     echo ""
     echo -e "\e[1;31m Sorry I can't read that file, check the path or format and try again!\e[00m"
     echo ""
     exit 1
   else
     NOHASHCOUNT=$(cat "$HASHFILEIN" |grep ":::" |wc -l)
     echo ""
     echo -e "\e[01;32m[-]\e[00m I can read "$NOHASHCOUNT" hashes from the file"
 fi

DUP=$(cat "$HASHFILEIN" |grep -v "*:::" |grep ":::" |grep -v '\\' |cut -d ":" -f 1,4 | cut -d ":" -f 2 |uniq -d |wc -l)
if [ "$DUP" -lt 1 ]
	then
		echo ""
		echo -e "\e[01;31m[!]\e[00m No password hashes were found to be common!"
		echo ""
		exit 1
	else
		echo ""
		echo -e "\e[01;32m[+]\e[00m Common Password Hashes were found"
		echo ""
fi
sleep 0.3
exec > >(tee hash-matches.txt)

#check for FGDUMP blank NTLM on history pw
cat "$HASHFILEIN" |grep -v "*:::" >/dev/null 2>&1
	if [ $? = 0 ]
		then
			cat "$HASHFILEIN" |grep -v "*:::" > "$HASHFILE"
		else
			cp "$HASHFILEIN" "$HASHFILE"
	fi
#check if gsecdump file
cat "$HASHFILE" |grep -i -e hist_ -e "(current)" -e "(current-disabled)" >/dev/null 2>&1
	if [ $? = 0 ]
		then
		cat "$HASHFILE" |grep -i -e hist_ -e "(current)" -e "(current-disabled)" > hashfile2.tmp
		mv hashfile2.tmp "$HASHFILE"
fi
touch livehash.tmp 2>/dev/null
touch disabledhash.tmp 2>/dev/null
touch historyhash.tmp 2> /dev/null

HASHLIST=$(cat "$HASHFILE" |cut -d ":" -f 1,4 | cut -d ":" -f 2 |sort -n)

for HASHCHECK in $(echo "$HASHLIST")

do
	HASHDUP=$(cat "$HASHFILE" | grep -o "$HASHCHECK" |wc -l)
		if [ "$HASHDUP" -gt "1" ]
		then
HASHDUPFND=$(cat "$HASHFILE" |grep -o "$HASHCHECK")
echo "$HASHDUPFND" >>tmphashes.txt
fi
done
#find live accounts
cat "$HASHFILE" |grep "(current)" >/dev/null 2>&1
if [ $? = 0 ]
then
cat "$HASHFILE" |grep "(current)" >>livehash.tmp
sed -i 's/(current)//g' livehash.tmp >/dev/null
fi
#find live accounts (hashdump/gsecdump format)
cat "$HASHFILE" |grep -v -i "(current)" | grep -v -i "(current-disabled)" |grep -v -i hist | grep  ":::" | grep -v '\\' >/dev/null 2>&1
if [ $? = 0 ]
then
cat "$HASHFILE" |grep -v -i "(current)" | grep -v -i "(current-disabled)" |grep -v -i hist | grep  ":::" | grep -v '\\' >>livehash.tmp
fi

#find previous password history fgdump
cat "$HASHFILE" |grep "_history_[0-9]" |grep -v "*:::" >/dev/null 2>&1
if [ $? = 0 ]
then
cat "$HASHFILE" |grep "_history_[0-9]" |grep -v "*:::" >>historyhash.tmp
sed -i 's/_history_[0-9]//g' historyhash.tmp >/dev/null
fi

#find previous password history gsecdump
cat "$HASHFILE" |grep -i "hist_[0-9][0-9]" |grep -v "*:::" >/dev/null 2>&1
if [ $? = 0 ]
then
cat "$HASHFILE" |grep "hist_[0-9][0-9]" |grep -v "*:::" >>historyhash.tmp
sed -i 's/(hist_[0-9][0-9])//g' historyhash.tmp >/dev/null
fi

#find disabled accounts
cat "$HASHFILE" |grep "(current-disabled)" >/dev/null 2>&1
if [ $? = 0 ]
then
cat "$HASHFILE" |grep "(current-disabled)" >>disabledhash.tmp
sed -i 's/(current-disabled)//g' disabledhash.tmp >/dev/null
fi
clear
echo ""
echo -e "\e[01;32m[-]\e[00m The following users have the same password"
echo ""
for DUPLICATE in $(cat tmphashes.txt |sort --unique |grep -v "*:::"| awk 'BEGIN{OFS=FS=""}{for(i=1;i<=NF-16 ;i++){ $i="*"} }1')
do
COUNT=$(cat "$HASHFILE" | grep "$DUPLICATE"| wc -l)
if [ "$COUNT" -gt "1" ]
	then
echo -e "\e[01;33m---------------------------------------------------------------------------\e[00m"
echo -e "Hash: \e[01;32m"$DUPLICATE"\e[00m - \e[01;32m"$COUNT"\e[00m Users share the same password"
echo -e "\e[01;33m---------------------------------------------------------------------------\e[00m"

cat livehash.tmp | grep "$DUPLICATE" >/dev/null 2>&1
if [ $? = 0 ]
	then
		AUSERNAME=$(cat livehash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1)
		ACOUNT=$(cat livehash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1 |wc -l)
		echo -e "\e[01;32m-------------------------------------------------\e[00m"
		echo -e "\e[01;32m[+]\e[00m Active User Password - \e[01;32m"$ACOUNT"\e[00m Affected Accounts"
		echo -e "\e[01;32m-------------------------------------------------\e[00m"
		echo "$AUSERNAME"
		echo ""
fi




cat historyhash.tmp | grep "$DUPLICATE" >/dev/null 2>&1
if [ $? = 0 ]
        then
		HUSERNAME=$(cat historyhash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1)
		HCOUNT=$(cat historyhash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1 |wc -l)
                echo -e "\e[01;33m------------------------------------------------\e[00m"
                echo -e "\e[01;33m[-]\e[00m Previous User Password - \e[01;33m"$HCOUNT"\e[00m Affected Accounts"
                echo -e "\e[01;33m------------------------------------------------\e[00m"
                echo "$HUSERNAME"
                echo ""
fi

cat disabledhash.tmp | grep "$DUPLICATE" >/dev/null 2>&1
if [ $? = 0 ]
        then
		DUSERNAME=$(cat disabledhash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1)
		DCOUNT=$(cat disabledhash.tmp |grep "$DUPLICATE" |cut -d ":" -f 1| wc -l)
		echo -e "\e[01;31m-------------------------------------------------\e[00m"
                echo -e "\e[01;31m[!]\e[00m Disabled User Password - \e[01;31m"$DCOUNT"\e[00m Affected Accounts"
		echo -e "\e[01;31m-------------------------------------------------\e[00m"
                echo "$DUSERNAME"
		echo ""
fi
#compare active to previous hash.
cat historyhash.tmp |grep ":::" >/dev/null 2>&1
if [ $? = 0 ]
	then
		PREVCOM=$(echo "$HUSERNAME" |sort --unique)
		if [ "$AUSERNAME" == "$PREVCOM" ]
		then
			echo -e "\e[01;31m[!]\e[00m - \e[01;31mIssue detected\e[00m - User has been able to set the same password as previously used"	
			echo ""
		fi
fi
fi
done
echo ""
echo "--------------------------------------------------------------------------------------------"
echo -e "\e[01;32m[-]\e[00m Hash matches have been saved to the following file \e[01;32m"hash-matches.txt"\e[00m"
echo ""
rm tmphashes.txt 2>/dev/null
rm "$HASHFILE" 2>/dev/null
rm livehash.tmp 2>/dev/null
rm disabledhash.tmp 2>/dev/null
rm historyhash.tmp 2> /dev/null
exit 0
