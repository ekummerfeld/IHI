package edu.cmu.tetrad.algcomparison.simstudy;




import edu.cmu.tetrad.algcomparison.algorithm.Algorithms;
import edu.cmu.tetrad.algcomparison.algorithm.oracle.pag.Gfci;
import edu.cmu.tetrad.algcomparison.algorithm.oracle.pattern.*;
import edu.cmu.tetrad.algcomparison.independence.ChiSquare;
import edu.cmu.tetrad.algcomparison.independence.FisherZ;
import edu.cmu.tetrad.algcomparison.score.MVPBicScore;
import edu.cmu.tetrad.search.GFci;
import edu.cmu.tetrad.search.IndTestFisherZ;
import edu.cmu.tetrad.search.Score;
import edu.cmu.tetrad.search.SemBicScore;
import edu.cmu.tetrad.util.Parameters;
import edu.cmu.tetrad.algcomparison.statistic.*;

public class analyze {
    public static void main(String... args) {
        String dataPath = "";
        String prefix = "";
        int nRuns = -1;
        for (int i = 0; i < args.length;i++) {
            if (args[i].compareTo("-nr") == 0) {
                nRuns = Integer.parseInt(args[i + 1]);
            }
            if (args[i].compareTo("-prefix") == 0) {
                prefix = args[i+1];
            }
            if (args[i].compareTo("-dp") == 0) {
                dataPath = args[i + 1];
            }
        }
        if (dataPath == "") {
            System.err.println("Error! dataPath not set! Exiting...");
            System.exit(1);
        }
        if (nRuns == -1) {
            System.err.println("Error! nRuns not set! Exiting...");
            System.exit(1);
        }

        System.err.println("The parameters used in this analysis are nRuns = " + nRuns + " dataPath = " + dataPath + " prefix = " + prefix);

        Parameters parameters = new Parameters();

        parameters.set("numRuns", nRuns);
        parameters.set("alpha", .01);

        Statistics statistics = new Statistics();

        statistics.add(new ParameterColumn("sampleSize"));
        statistics.add(new ParameterColumn("numMeasures"));
        statistics.add(new AdjacencyPrecision());
        statistics.add(new AdjacencyRecall());
        statistics.add(new ArrowheadPrecision());
        statistics.add(new ArrowheadRecall());
        statistics.add(new SHD());
        statistics.add(new ElapsedTime());
        statistics.setWeight("AP", 1.0);
        statistics.setWeight("AR", 1.0);
        statistics.setWeight("AHP", 1.0);
        statistics.setWeight("AHR", 1.0);
        statistics.setWeight("SHD", 1.0);


        Algorithms algorithms = new Algorithms();

//      algorithms.add(new Fges(new ConditionalGaussianBicScore()));
//      algorithms.add(new Fges(new ConditionalGaussianOtherBicScore()));
        algorithms.add(new Fges(new MVPBicScore()));
        algorithms.add(new PcStable(new FisherZ()));
        algorithms.add(new Gfci(new FisherZ(), new MVPBicScore()));
//        algorithms.add(new Fges(new MNLRBicScore()));
//        algorithms.add(new Fges(new DiscreteMixedBicScore()));
//        algorithms.add(new Cpc(new ConditionalGaussianLRT()));
//        algorithms.add(new Cpc(new MVPLRT()));
//        algorithms.add(new Cpc(new MNLRLRT(), new Mgm()));

        ComparisonFlexible comparison = new ComparisonFlexible();
        comparison.setShowAlgorithmIndices(true);
        comparison.setShowSimulationIndices(false);
        comparison.setSortByUtility(false);
        comparison.setShowUtilities(false);
        comparison.setParallelized(true);
        comparison.setSaveGraphs(true);
        comparison.setSavePags(true);
        comparison.setSavePatterns(true);
//      just run fges on the unmodified (original) simulated data
        comparison.compareFromFiles(dataPath,
                dataPath + "/results/",prefix + "comparison.txt",
                algorithms, statistics, parameters);

        System.exit(0);
    }
}
