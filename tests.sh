#!/usr/bin/env bash

input_KM="../tpch-spark/dataset/ds/ds1.10_a.csv" #Should have 1 million rows
input_LR="../tpch-spark/dataset/ds/ds1.10_a.csv" #Should have 1 million rows
path_l="../tpch-spark/dbgen/lineitem.tbl" #Should have 1 million rows
path_p="../tpch-spark/dbgen/partsupp.tbl" #Should have 1 million rows
echo "10,1" > security.csv #make sure this file is under ~/AutoDP on all servers
#do some scp here
~/Experiment/sync_fs.bash ~/tpch-spark/dataset/ds ~/tpch-spark/dataset || (echo "ERROR when sync file exit..." && exit 1)
~/Experiment/sync_fs.bash ~/AutoDP/security.csv  ~/AutoDP  || (echo "ERROR when sync file exit..." && exit 1)




#Evaluation itms:
#1. Iteration
#2. Dimension
#3. Centroid
#4. Epsilon
#*************Iteration********************
for iteration in {0..100};do
#KMean Original
./bin/spark-submit \
--class edu.hku.dp.original.SparkKMeans examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM \
$iteration 3 10 > outputOKM.txt

#KMean Ours
./bin/spark-submit \
--class edu.hku.dp.SparkKMeansDP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM /home/john/tpch-spark/dataset/ds/ds1.10_a.csv \
$iteration 3 10 1 > outputKM.txt

#LR Original
./bin/spark-submit \
--class edu.hku.dp.original.SparkHdfsLR examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_LR \
$iteration 10 > outputLR.txt

#LR Ours
./bin/spark-submit \
--class edu.hku.dp.SparkHdfsLRDP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_LR /home/john/tpch-spark/dataset/ds/ds1.10_a.csv \
$iteration 10 1 > outputKM.txt
done

#*************Dimension********************
for dimension in {2..10}
do
./bin/spark-submit \
--class edu.hku.dp.original.SparkKMeans examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM \
1 3 $dimension > outputOKM.txt

#KMean Ours
./bin/spark-submit \
--class edu.hku.dp.SparkKMeansDP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM /home/john/tpch-spark/dataset/ds/ds1.10_a.csv \
1 3 $dimension 1 > outputKM.txt

#LR Original
./bin/spark-submit \
--class edu.hku.dp.original.SparkHdfsLR examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_LR \
1 $dimension > outputLR.txt

#LR Ours
./bin/spark-submit \
--class edu.hku.dp.SparkHdfsLRDP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_LR /home/john/tpch-spark/dataset/ds/ds1.10_a.csv \
1 $dimension 1 > outputKM.txt
done

#**************Centroid******************

for centroid in {1..10}
do

#KMean Original
./bin/spark-submit \
--class edu.hku.dp.original.SparkKMeans examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM \
1 $centroid 10 > outputOKM.txt

#KMean Ours
./bin/spark-submit \
--class edu.hku.dp.SparkKMeansDP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$input_KM /home/john/tpch-spark/dataset/ds/ds1.10_a.csv \
1 $centroid 10 1 > outputKM.txt

done

##*************Epsilon********************
for dimension in {1..30}
do
echo "$dimension,1" > security.csv #make sure this file is under ~/AutoDP on all servers
#may be some scp here

./bin/spark-submit \
--class edu.hku.dp.TPCH1DP \
examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$path_l /home/john/tpch-spark/dbgen/lineitem.ftbl 1 > output1.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH4DP \
examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
/home/john/tpch-spark/dbgen/orders.ftbl /home/john/tpch-spark/dbgen/orders.ftbl \
$path_l /home/john/tpch-spark/dbgen/lineitem.ftbl 1 > output4.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH6DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
$path_l /home/john/tpch-spark/dbgen/lineitem.tbl 1 > output6.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH11DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
/home/john/tpch-spark/dbgen/supplier.tbl /home/john/tpch-spark/dbgen/supplier.tbl \
/home/john/tpch-spark/dbgen/nation.tbl \
$path_p /home/john/tpch-spark/dbgen/partsupp.tbl 1 > output11.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH13DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
/home/john/tpch-spark/dbgen/orders.tbl /home/john/tpch-spark/dbgen/orders.tbl \
$path_l /home/john/tpch-spark/dbgen/lineitem.tbl 1 > output13.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH16DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
/home/john/tpch-spark/dbgen/part.tbl /home/john/tpch-spark/dbgen/part.tbl \
/home/john/tpch-spark/dbgen/supplier.tbl /home/john/tpch-spark/dbgen/supplier.tbl \
$path_l /home/john/tpch-spark/dbgen/partsupp.tbl 1 > output16.txt

./bin/spark-submit \
--class edu.hku.dp.TPCH21DP examples/target/scala-2.11/jars/spark-examples_2.11-2.2.0.jar \
/home/john/tpch-spark/dbgen/supplier.tbl /home/john/tpch-spark/dbgen/supplier.tbl \
$path_l /home/john/tpch-spark/dbgen/lineitem.tbl \
/home/john/tpch-spark/dbgen/orders.tbl /home/john/tpch-spark/dbgen/orders.tbl \
/home/john/tpch-spark/dbgen/nation.tbl 1 > output.txt
done
