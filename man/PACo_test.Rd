\name{PACo_test}
\alias{PACo_test}

\title{
Compute the cophylogenetic signal in a bipartite interaction network using PACo.
}

\description{
This function computes the cophylogenetic signal in a bipartite species interaction network using PACo.

The method is described in detail in Balbuena et al. (2013) and originally implemented in the paco package (Hutchinson et al, 2017).
}

\usage{
PACo_test(dist_A, dist_B, network,
nperm = 1000, seed = NA, symmetric = TRUE,
nullmodel = "shuffle", table_biogeo = NULL)
}

\arguments{

\item{dist_A}{
a phylogenetic distance matrix representing pairwise distances between species from guild A (in columns of the interaction network), or directly the phylogenetic tree of guild A.
}
\item{dist_B}{
a phylogenetic distance matrix representing pairwise distances between species from guild B (in rows of the interaction network), or directly the phylogenetic tree of guild B.
}
\item{network}{
a matrix representing the bipartite interaction network with species from guild A in columns and species from guild B in rows. Row names (resp. columns names) must correspond to the tip labels of tree B (resp. tree A).
}
\item{nperm}{
the number of permutations used to assess the significance of the test.
}
\item{seed}{
a random seed to ensure reproducibility of the permutations.
}
\item{symmetric}{
indicates whether to perform a symmetric Procrustean superimposition (Blasco-Costa et al., 2021; default is TRUE).
}
\item{nullmodel}{
indicates which null model to use: "shuffle" (default), which randomly shuffles the species labels of tree A, or "biogeo", which only shuffles the labels of species from guild A occurring in the same biogeographic area. For the latter, an object "table_biogeo" must be provided.
}
\item{table_biogeo}{
(optional) a dataframe with two columns: a column "species", containing the names of species from guild A, and a column "biogeo", indicating the corresponding biogeographic area of each species. Each species must be assigned to a single biogeographic area. This table is required when nullmodel = "biogeo".
}
}


\value{
The function returns a list with the following elements:
- R2_obs: the test statistic,
- p: the p-value obtained under the specified null model,
- R2_perm: a vector containing the test statistics obtained for each permuted dataset under the null model,
- nperm: the number of permutation,
- nullmodel: the null model used
}
\details{

See the tutorials for measuring cophylogenetic signal on GitHub (https://github.com/BPerezLamarque/EVOLI).

}
\references{
Balbuena JA, Míguez-Lozano R, Blasco-Costa I. 2013. PACo: A novel procrustes application to cophylogenetic analysis. PLoS One, 8, e61048.

Hutchinson MC, Cagua EF, Balbuena JA, Stouffer D, Poisot T. 2017. paco: implementing Procrustean Approach to Cophylogeny in R. Methods Ecol. Evol., 8, 932–940.

Perez-Lamarque B, Morlon H. 2024. Distinguishing cophylogenetic signal from phylogenetic congruence clarifies the interplay between evolutionary history and species interactions, Systematic Biology, 73: 3.

Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{parafit_test}}
}
\examples{

\donttest{

# Example 1: Compute the cophylogenetic signal using PACo

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of guild A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of guild B
network <- cophylogenetic_system$network # Present-day interaction network between species of guild A (columns) and guild B (rows)

nperm <- 1000 # At least 10,000 permutations are recommended (1,000 are used here to keep the example computationally fast)

# Run PACo under H0 (random shuffling of species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Print the test statistic and p-value under "H0"
PACo_result[c("R2_obs","p")] 

# Plot the null distribution under "H0"
plot_null_model(PACo_result, "paco")
}


# Example 2: Assess the effect of biogeography on the cophylogenetic signal using PACo

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host # A two-column table indicating the biogeographic distribution of each species from guild A

nperm <- 1000 # At least 10000 permutations should be used (1000 is only for providing a fast example)

\donttest{
# Run PACo under "H0" (random shuffling of the species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Run PACo under "H0 biogeo" (biogeography-constrained shuffling of the species labels)
PACo_result_biogeo <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "biogeo", table_biogeo = table_biogeo_host)

# Compare the results obtained under the two null models 
PACo_result[c("R2_obs","p")] # Test statistic and p-value under "H0"
PACo_result_biogeo[c("R2_obs","p")] # Test statistic and p-value under "H0 biogeo"
compare_null_models(PACo_result, PACo_result_biogeo, method = "paco") # Standardized effect sizes and f fraction

# Plot the distributions under the two null models
plot_null_models_comparison(PACo_result, PACo_result_biogeo, "paco")
}

}

