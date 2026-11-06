\name{plot_null_models_comparison}
\alias{plot_null_models_comparison}

\title{
Plot the null distributions of a (co)phylogenetic signal test statistic under two null models
}

\description{
This function plots and compares the null distributions of the test statistic obtained under two null models used by PACo, ParaFit, or Mantel tests to assess (co)phylogenetic signal: "H0", which randomly shuffles species labels, and "H0 biogeo", which performs biogeography-constrained permutations.
}

\usage{
plot_null_models_comparison(res, res_biogeo, 
method, median = FALSE)
}

\arguments{

\item{res}{
the output returned by \code{PACo_test}, \code{parafit_test}, or \code{phylosignal_network} when using the "shuffle" null model ("H0").
}
\item{res_biogeo}{
the output returned by \code{PACo_test}, \code{parafit_test}, or \code{phylosignal_network} when using the "biogeo" null model ("H0 biogeo").
}
\item{method}{
the method used to compute (co)phylogenetic signal: either "paco", "parafit", or "mantel".
}
\item{median}{
indicates whether the median of each null distribution should be plotted as a vertical dashed line (default is FALSE).
}

}

\value{
A plot showing the two null distributions, with "H0" in blue and "H0 biogeo" in green, and a red vertical line indicating the observed value of the test statistic.
}


\details{
See the tutorial on GitHub for examples of how to assess the effect of biogeography when measuring (co)phylogenetic signal:
https://github.com/BPerezLamarque/Scripts/tree/master/Biogeography_interactions
}

\references{
Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.
}

\author{Benoît Perez-Lamarque}

\seealso{
\code{\link{phylosignal_network}}
\code{\link{parafit_test}}
\code{\link{PACo_test}}
\code{\link{compare_null_models}}
}
\examples{


# Load the data

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of guild A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of guild B
network <- cophylogenetic_system$network # Present-day interaction network between species from guild A (columns) and guild B (rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host # A two-column table indicating the biogeographic repartition of each species of clade A


nperm <- 1000 # At least 10,000 permutations are recommended (1,000 are used here to keep the example computationally fast)

\donttest{

# Example 1: Assess the effect of biogeography on cophylogenetic signal using PACo

# Run PACo under "H0" (random shuffling of species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Run PACo under "H0 biogeo" (biogeography-constrained shuffling of species labels)
PACo_result_biogeo <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "biogeo", table_biogeo = table_biogeo_host)

# Plot the null distributions under the two null models
plot_null_models_comparison(PACo_result, PACo_result_biogeo, "paco")

}


# Example 2: Assess the effect of biogeography on the phylogenetic signal using Mantel tests

# Run Mantel test under "H0" (random shuffling of species labels)
mantel_result <- phylosignal_network(network, tree_A, method = "Jaccard_binary", nperm = nperm, permutation = "shuffle")

# Run Mantel test under "H0 biogeo" (biogeography-constrained shuffling of species labels)
mantel_result_biogeo <- phylosignal_network(network, tree_A, method = "Jaccard_binary", nperm = nperm, permutation = "biogeo", table_biogeo = table_biogeo_host)

# Plot the null distributions under the two null models
plot_null_models_comparison(mantel_result, mantel_result_biogeo, "mantel")

}


}

