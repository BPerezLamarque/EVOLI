\name{parafit_test}
\alias{parafit_test}

\title{
Compute cophylogenetic signal in a bipartite interaction network using ParaFit.
}

\description{
This function computes the cophylogenetic signal in species interactions using ParaFit.

The method is described in detail in Legendre et al. (2002) and originally coded in the package APE (Paradis, 2004).
}

\usage{
parafit_test(dist_A, dist_B, network, nperm = 1000,
seed = NULL, correction = "none",
nullmodel = "shuffle", table_biogeo = NULL)
}


\arguments{

\item{dist_A}{
a distance matrix representing the phylogenetic distances between pairs of species from guild A (in columns in the interaction network), or directly the phylogenetic tree of guild A.
}
\item{dist_B}{
a distance matrix representing the phylogenetic distances between pairs of species from guild B (in rows in the interaction network), or directly the phylogenetic tree of guild B.
}
\item{network}{
a matrix representing the bipartite interaction network with species from guild A in columns and species from guild B in rows. Row names (resp. columns names) must correspond to the tip labels of tree B (resp. tree A).
}

\item{nperm}{
a number of permutations to evaluate the significance of the test.
}

\item{correction}{
Correction methods for negative eigenvalues (details below): correction="lingoes" and correction="cailliez". Default value: "none".
}

\item{nullmodel}{
Indicates which type of null model to use, including "suffle" (by default - i.e. random shufflying of the species labels of "tree_A") or "biogeo" (i.e. only shuffling species of tree A that are present on the same biogeographic areas - to do so, provide an object "table_biogeo").
}

\item{table_biogeo}{
(optional) a dataframe that contains two columns: a column "species" that contains the name of each species of guild A and a column "biogeo" that indicate the corresponding biogeographic area for each species (only one area per species). This table is used for the nullmodel "biogeo".
}


}


\value{
The function outputs a list with the following elements:
- ParaFitGlobal: the statistic of the test,
- p: the p-value of the test under the null model considered,
- ParaFitGlobal_perm: a vector with the statistics of the test for each permuted dataset under the nullmodel considered.
- nperm: the number of permutation,
- nullmodel: the nullmodel considered
}
\details{

See the tutorial on GitHub for measuring cophylogenetic signal accouting for biogeography (https://github.com/BPerezLamarque/EVOLI).

}
\references{
Legendre P, Desdevises Y, and Bazin E. 2002. A statistical test for host-parasite coevolution. Systematic Biology, 51(2), 217–234.

Paradis E, Schliep K. 2019. ape 5.0: an environment for modern phylogenetics and evolutionary analyses in R. Bioinformatics, 35, 526-528.

Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{parafit_test}}
}
\examples{

# Example 1: Compute cophylogenetic signal using ParaFit

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)

nperm <- 1000 # At least 10000 permutations should be used (1000 is only for providing a fast example)

# Run ParaFit under "H0" (random shuffling of the species labels)
parafit_result <- parafit_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Print the test statistic and p-value under "H0"
parafit_result[c("ParaFitGlobal","p")]

# Plot the null distribution under "H0"
plot_null_model(parafit_result, "parafit")



# Example 2: Assess the effect of biogeography on cophylogenetic signal using PACo

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host # A two-column table indicating the biogeographic repartition of each species of clade A

nperm <- 1000 # At least 10000 permutations should be used (1000 is only for providing a fast example)

# Run ParaFit under "H0" (random shuffling of the species labels)
parafit_result <- parafit_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Run ParaFit under "H0 biogeo" (biogeography-based shuffling of the species labels)
parafit_result_biogeo <- parafit_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "biogeo", table_biogeo = table_biogeo_host)

# Compare the results obtained under the two null models 
parafit_result[c("ParaFitGlobal","p")] # Test statistic and p-value under "H0"
parafit_result_biogeo[c("ParaFitGlobal","p")] # Test statistic and p-value under "H0 biogeo"
compare_null_models(parafit_result, parafit_result_biogeo, method = "parafit") # Standardized effect sizes and f fraction

# Plot the distributions under the two null models
plot_null_models_comparison(parafit_result, parafit_result_biogeo, "parafit")


}

