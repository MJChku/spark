#!/usr/bin/env bash
#**********Linitems**************
#Only change lineitem i.e., change path_l in the following commands
#Ours
if [ $# -ne 2 ]; then 
   echo "put 2 sizes as argument for lineitem and partsupp"
  # exit 1
fi

set -x 

dir=~/Experiment/timer

datasize1=$1

#~/Experiment/datagen.bash ~/tpch-spark/test/lineitem lineitem.tbl $datasize1 || (echo "ERROR: ${LINENO} generating data error " && exit 1)

datasize2=$2

#~/Experiment/datagen.bash ~/tpch-spark/test/partsupp partsupp.tbl $datasize2 || (echo "ERROR: ${LINENO} generating data error " && exit 1) 


touch $dir/timer.txt

files1="output1.txt err1.txt output6.txt err6.txt output4.txt err4.txt output13.txt err13.txt output21.txt err21.txt outputO1.txt errO1.txt outputO6.txt errO6.txt outputO4.txt errO4.txt outputO13.txt errO13.txt outputO21.txt errO21.txt"

for file in $files1; do
  echo "datasize $datasize1 GB" >> $dir/$file || touch $dir/$file
done

files2="output11.txt err11.txt output16.txt err16.txt  outputO11.txt errO11.txt outputO16.txt errO16.txt "
for file in $files2; do
  echo "datasize $datasize1 GB" >> $dir/$file || touch $dir/$file
done

#~/Experiment/sync_fs.bash /home/mjcooper/tpch-spark/test $dir || (echo "ERROR: ${LINENO} sync file error " && exit 1)
~/Experiment/sync_fs.bash  $dir || (echo "ERROR: ${LINENO} sync file error " && exit 1)


#1) intiate all server & workers
~/AutoDP/setupcluster.sh

for i in 1; do
	filex="${i}M" 
	path_l="/home/mjcooper/tpch-spark/test/lineitem/lineitem_${filex}.tbl" #Change this path to test different size of dataset

	echo -n "TPCH1DP on lineitem_$filex  -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH1DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar $path_l "/home/mjcooper/tpch-spark/dbgen/lineitem.tbl"  1> ~/Experiment/timer/output1.txt 2>> ~/Experiment/timer/err1.txt ; }  2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt

 	echo -n "TPCH6DP on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH6DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar $path_l "/home/mjcooper/tpch-spark/dbgen/lineitem.tbl" 1 1> ~/Experiment/timer/output6.txt 2> ~/Experiment/timer/err6.txt ;}  2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt 

 	echo -n "TPCH4DP on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH4DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/orders.tbl" "/home/mjcooper/tpch-spark/dbgen/orders.tbl" $path_l "/home/mjcooper/tpch-spark/dbgen/lineitem.tbl" 1 1> ~/Experiment/timer/output4.txt 2>> ~/Experiment/timer/err4.txt; }  2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt


 	echo -n "TPCH13DP on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH13DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/orders.tbl" "/home/mjcooper/tpch-spark/dbgen/orders.tbl" $path_l "/home/mjcooper/tpch-spark/dbgen/lineitem.tbl" 1 1> ~/Experiment/timer/output13.txt 2>> ~/Experiment/timer/err13.txt ;} 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt



	 echo -n "TPCH21DP  on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH21DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" $path_l "/home/mjcooper/tpch-spark/dbgen/lineitem.tbl" "/home/mjcooper/tpch-spark/dbgen/orders.tbl" "/home/mjcooper/tpch-spark/dbgen/orders.tbl" "/home/mjcooper/tpch-spark/dbgen/nation.tbl" 1 1> ~/Experiment/timer/output21.txt 2>> ~/Experiment/timer/err21.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt

#Original

 	echo -n "TPCH1 original on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH1 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar $path_l 1 1> ~/Experiment/timer/outputO1.txt 2>> ~/Experiment/timer/errO1.txt; }  2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt

 	echo -n "TPCH6 original on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH6 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar $path_l 1 1> ~/Experiment/timer/outputO6.txt 2>> ~/Experiment/timer/errO6.txt; }  2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt


 	echo -n "TPCH4 original on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH4 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/orders.tbl" $path_l 1 1> ~/Experiment/timer/outputO4.txt 2>> ~/Experiment/timer/errO4.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt

 	echo -n "TPCH13 original on lineitem_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH13 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/orders.tbl" $path_l 1 1> ~/Experiment/timer/outputO13.txt 2>> ~/Experiment/timer/errO13.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt

 	echo -n "TPCH21 original on partsupp_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH21 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" $path_l "/home/mjcooper/tpch-spark/dbgen/orders.tbl" "/home/mjcooper/tpch-spark/dbgen/nation.tbl" 1 1> ~/Experiment/timer/outputO21.txt 2>>~/Experiment/timer/errO21.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt

#**********partsupp**************
#Only change partsupp i.e., change *partsupp* in the following commands
#Ours

	path_p="/home/mjcooper/tpch-spark/test/partsupp/partsupp_${filex}.tbl" #Change this path to test different size of dataset

	 echo -n "TPCH11DP original on partsupp_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH11DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" "/home/mjcooper/tpch-spark/dbgen/nation.tbl" $path_p "/home/mjcooper/tpch-spark/dbgen/partsupp.tbl" 1 1> ~/Experiment/timer/output11.txt 2>> ~/Experiment/timer/err11.txt;} 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt

	 echo -n "TPCH16DP original on partsupp_$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH16DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/part.tbl" "/home/mjcooper/tpch-spark/dbgen/part.tbl" "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" $path_p "/home/mjcooper/tpch-spark/dbgen/partsupp.tbl" 1 1> ~/Experiment/timer/output16.txt 2>> ~/Experiment/timer/err16.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }' >> $dir/timer.txt


#Original
	 echo -n "TPCH11 original on partsupp$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH11 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" "/home/mjcooper/tpch-spark/dbgen/nation.tbl" $path_p 1> ~/Experiment/timer/outputO11.txt 2>> ~/Experiment/timer/errO11.txt;} 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt


	 echo -n "TPCH16 original on partsupp$filex -----  " >> $dir/timer.txt ;
	{ time ./bin/spark-submit --master spark://10.22.1.3:7081 --driver-memory 30g --executor-memory 30g --conf spark.executor.extraJavaOptions="-Xms30g" --class edu.hku.dp.TPCH16 examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar "/home/mjcooper/tpch-spark/dbgen/part.tbl" "/home/mjcooper/tpch-spark/dbgen/supplier.tbl" $path_p 1> ~/Experiment/timer/outputO16.txt 2>> ~/Experiment/timer/errO16.txt; } 2>&1 >/dev/null | grep -v real | grep -Eo '[+-]?[0-9]+([.][0-9]+)' | awk '{ SUM += $1;} END { print SUM }'  >> $dir/timer.txt

done

#3) stop all server & worker

~/AutoDP/stopcluster.sh


