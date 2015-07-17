package com.developer.spark.mllib;
/**
 * Created by hadoop on 3/4/15.
 */
import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.mllib.classification.*;
import org.apache.spark.mllib.evaluation.BinaryClassificationMetrics;
import org.apache.spark.mllib.regression.LabeledPoint;
import org.apache.spark.mllib.util.MLUtils;
import scala.Tuple2;

public class SVMImplementation {
    public static void main(String[] args) {
        //to run machine in remote
        // SparkConf conf = new SparkConf().setAppName("SVM Classifier Example");
        //to run in remote
        //SparkContext sc = new SparkContext(conf);
        SparkContext sc = new SparkContext("local","simple app");
        String path = "./data/accelerometer.data";
        //load file
        JavaRDD<LabeledPoint> data = MLUtils.loadLibSVMFile(sc, path).toJavaRDD();
        // Split initial RDD into two... [60% training data, 40% testing data].
        JavaRDD<LabeledPoint> training = data.sample(false, 0.6, 11L);
        training.cache();
        JavaRDD<LabeledPoint> test = data.subtract(training);

        // Run training algorithm to build the model.
        int numIterations = 100;
        final SVMModel model = SVMWithSGD.train(training.rdd(), numIterations);

        // Clear the default threshold.
        model.clearThreshold();

        // Compute raw scores on the test set.
        JavaRDD<Tuple2<Object, Object>> scoreAndLabels = test.map(
                new Function<LabeledPoint, Tuple2<Object, Object>>() {
                    public Tuple2<Object, Object> call(LabeledPoint p) {
                        Double score = model.predict(p.features());
                        return new Tuple2<Object, Object>(score, p.label());
                    }
                }
        );

        // Get evaluation metrics.
        BinaryClassificationMetrics metrics =
                new BinaryClassificationMetrics(JavaRDD.toRDD(scoreAndLabels));
        for(Tuple2<Object,Object> mclass : scoreAndLabels.collect()){

            //System.out.println("class" + mclass._1().toString() + "prediction" + mclass._2().toString());
            //System.out.println("Training Error" + );
        }

        double auROC = metrics.areaUnderROC();
        System.out.println("Area under ROC = " + auROC);


        //getting the ROC
        Double d = Double.longBitsToDouble(scoreAndLabels.filter(
                new Function<Tuple2<Object, Object>, Boolean>() {
                    @Override
                    public Boolean call(Tuple2<Object, Object> r) throws Exception {
                        return r._1() !=r._2();

                    }
                }
        ).count())/scoreAndLabels.count();
        System.out.println("Training Error" + "\t"+d);
        System.out.println("score and labels" + metrics.areaUnderPR());
    }
}