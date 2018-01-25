package edu.cmu.tetrad.algcomparison.simstudy;

import edu.cmu.tetrad.algcomparison.graph.RandomForward;
import edu.cmu.tetrad.algcomparison.simulation.*;
import edu.cmu.tetrad.util.*;


public class generate {
    public static void main(String... args) {
        // set default values in case no args are passed in
         int nRuns = 100;
         int sampleSize = 100;
         int avgDegree = 3;
         int nVars = 100;

         for (int i = 0; i < args.length;i++) {
             if (args[i].compareTo("-nr") == 0) {
                 nRuns = Integer.parseInt(args[i+1]);
             }
             if (args[i].compareTo("-ss") == 0) {
                 sampleSize = Integer.parseInt(args[i+1]);
             }
             if (args[i].compareTo("-ad") == 0) {
                 avgDegree = Integer.parseInt(args[i+1]);
             }
             if (args[i].compareTo("-nv") == 0) {
                 nVars = Integer.parseInt(args[i+1]);
             }
             if (args[i].compareTo("-seed") == 0) {
                 int seed = Integer.parseInt(args[i+1]);
                 RandomUtil.getInstance().setSeed(seed);
             }
         }

         // create naming prefix so data and graph files can be easily identified


        Parameters parameters = new Parameters();
        parameters.set("numRuns", nRuns);
        parameters.set("numMeasures", nVars);
        parameters.set("avgDegree", avgDegree);
        parameters.set("sampleSize", sampleSize);
        parameters.set("differentGraphs", true);
//        parameters.set("percentDiscrete", 0);
//        parameters.set("minCategories", 2);
//        parameters.set("maxCategories", 5);
//        parameters.set("differentGraphs",true);
//        parameters.set("interceptLow", 0);
//        parameters.set("interceptHigh", 1);
//        parameters.set("continuousInfluence", 0.5);
//        parameters.set("linearLow", 0.5);
//        parameters.set("linearHigh", 1.0);
//        parameters.set("quadraticLow", 0.5);
//        parameters.set("quadraticHigh", 1.0);
//        parameters.set("cubicLow", 0.2);
//        parameters.set("cubicHigh", 0.3);
//        parameters.set("varLow", 1);
//        parameters.set("varHigh", 1);
//        parameters.set("betaLow", 5);
//        parameters.set("betaHigh", 8);
//        parameters.set("gammaLow", 1.0);
//        parameters.set("gammaHigh", 1.5);

        Simulation simulation = new SemSimulation(new RandomForward());
        ComparisonFlexible comparison = new ComparisonFlexible();
        comparison.saveToFiles( "generate/" + "ss" + sampleSize + "nv" + nVars, "", simulation , parameters);

        System.exit(0);
      }
}
