#!/usr/bin/env bash
move(){

  rm -rf $1  && mkdir $1 && cd $1  &&  cp ~/tpch-spark/dbgen/dbgen ~/tpch-spark/dbgen/dists.dss  .
  cp ~/tpch-spark/dbgen/$2 $1

}

generate(){
    
    if [ $# -ne 2 ];then
      echo "ERROR: WITH 2 argument ";
      exit 1;
    fi
    move $1 $2 || echo "error in move"

    case $2 in 

      lineitem.tbl ) 
      for i in `seq 1 2`; do
          ~/tpch-spark/dbgen/dbgen -s 2 -S $i -C 2 -T L -v
      done
      find . -type f -name 'lineitem.*' -exec cat {} + >> lineitem_aug.tbl
      for num_lines in `seq 1000000 1000000 10000000`; do
        filex=$(sed 's/0\{6\}$/M/' <<< $num_lines) 
        head -n $num_lines lineitem_aug.tbl > lineitem_$filex.tbl
      done
      ;;
      partsupp.tbl ) 
      for i in `seq 1 15`;do
          ~/tpch-spark/dbgen/dbgen -s 15 -S $i -C 15 -T L -v
      done
      find . -type f -name 'partsupp.*' -exec cat {} + >> partsupp_aug.tbl
      for num_lines in `seq 1000000 1000000 10000000`; do
         filex=$(sed 's/0\{6\}$/M/' <<< $num_lines)
         head -n $num_lines partsupp_aug.tbl > partsupp_aug_$filex.tbl
      done
      ;;
      * ) echo "ERROR: not recognized file;"
    esac
  
#    for i in `seq 1 $size`; do         
#       ~/tpch-spark/dbgen/dbgen -s $size -S $i -C $size -T L -v;
#    done;

    rm ./dbgen ./dists.dss || ( echo "error remove dbgen and dists.dss in $(pwd)" && exit 1)
    cd ~
    exit 0;

}

generate $@ || echo "error in something"
