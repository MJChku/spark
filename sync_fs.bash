#!/usr/bin/env bash
#set -x

usage(){
 err=$1 
 case $err in 
   1 )  echo "ERROR:put full path of directory of both source and destination as argument"
   ;;
   2 ) echo "ERROR:not a directory or directory doesnot exits"
   ;;
   3) echo "ERROR:error when snyc with other servers "
 esac 

}


sync(){
if [ "$#" -ne 2 ]; then 
   usage 1 && exit 1;
fi

source=$1 
dest=$2

for i in 1 2 4 5 ; do
  dest="mjcooper@10.22.1.$i:$dest"
  if [ -d $source ] ;then
     scp -r  $source $dest || (usage 3 &&  exit 1)
  elif [ -f $source ];then
     scp $souce $dest || (usage 3 && exit 1)
  else usage 1;exit 1
  fi
done 

}

sync $@  &&  echo "success" && exit 0;
 

