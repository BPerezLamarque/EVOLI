\name{compare_null_models}
\alias{compare_null_models}

\title{
Compare the null distributions of a (co)phylogenetic signal test statistic under two null models
}

\description{
This function compares the null distributions of the test statistic obtained under two null models used by PACo, ParaFit, or Mantel tests to assess (co)phylogenetic signal: "H0", which randomly shuffles species labels, and "H0 biogeo", which performs biogeography-constrained permutations.
}

\usage{
compare_null_models(results, results_biogeo, 
method, median=FALSE)
}

\arguments{

\item{results}{
The output returned by \code{PACo_test}, \code{parafit_test}, or \code{phylosignal_network} when using the "shuffle" null model ("H0").
}
\item{results_biogeo}{
The output returned by \code{PACo_test}, \code{parafit_test}, or \code{phylosignal_network} when using the "biogeo" null model ("H0 biogeo").
}
\item{method}{
The method used to compute (co)phylogenetic signal: either "paco", "parafit", or "mantel".
}
\item{median}{
Indicates whether the median rather than the mean should be used to summarize the null distributions (default is FALSE).
}

}

\value{
A table summarizing the following statistics for the two null distributions ("H0" and "H0 biogeo"):

\itemize{
\item The mean (or median if \code{median = TRUE}) of each null distribution.
\item The standard deviation of each null distribution.
\item The standardized effect size (SES) of each null distribution.
\item The fraction \eqn{f}, representing the proportion of the original deviation from the observed value that can be attributed to biogeography when comparing the two null distributions ("H0" and "H0 biogeo").
}

}

\details{
See the tutorial on GitHub for examples of how to assess the effect of biogeography on (co)phylogenetic signal:
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

\code{\link{plot_null_models_comparison}}
}

\examples{

# Load the data

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network 
# Interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host 
# A two-column table indicating the biogeographic distribution of each species from guild A

nperm <- 1000 # At least 10,000 permutations are recommended 
# (1,000 are used here to keep the example computationally fast)

\donttest{
# Example 1: Assess the effect of biogeography on cophylogenetic signal using PACo

# Run PACo under "H0" (random shuffling of species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Run PACo under "H0 biogeo" (biogeography-constrained shuffling of species labels)
PACo_result_biogeo <- PACo_test(tree_A, tree_B, network, nperm = nperm, 
    nullmodel = "biogeo", table_biogeo = table_biogeo_host)

# Compare the null distributions under the two null models
compare_null_models(PACo_result, PACo_result_biogeo, method = "paco")
}

# Example 2: Assess the effect of biogeography on phylogenetic signal using Mantel tests

# Run a Mantel test under "H0" (random shuffling of species labels)
mantel_result <- phylosignal_network(network, tree_A, method = "Jaccard_binary", 
    nperm = nperm, permutation = "shuffle")

# Run a Mantel test under "H0 biogeo" (biogeography-constrained shuffling of species labels)
mantel_result_biogeo <- phylosignal_network(network, tree_A, method = "Jaccard_binary", 
    nperm = nperm, permutation = "biogeo", table_biogeo = table_biogeo_host)

# Compare the null distributions under the two null models
compare_null_models(mantel_result, mantel_result_biogeo, method = "mantel")

}