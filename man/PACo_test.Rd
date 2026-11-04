\name{PACo_test}
\alias{PACo_test}

\title{
Compute cophylogenetic signal in a bipartite interaction network using PACo.
}

\description{
This function computes the cophylogenetic signal in species interactions using PACo.

The method is described in detail in Balbuena et al. (2013) and originally coded in the package paco (Hutchinson et al, 2017).
}

\usage{
PACo_test(dist_A, dist_B, network,
nperm = 1000, seed = NA, symmetric = TRUE,
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
\item{seed}{
A seed for replicating the permutations.
}
\item{seed}{
A seed for replicating the permutations.
}
\item{symmetric}{
Indicates whether to run a symmetric Procrustean superposition (Blasco-Costa et al. 2021; default to true).
}
\item{nullmodel}{
Indicates which type of null model to use, including "suffle" (by default - i.e. random shufflying of the species labels of "tree_A") or "biogeo" (i.e. only shuffling species of tree A that are present on the same biogeographic areas - to do so, provide an object "table_biogeo").
}
\item{table_biogeo}{
(optional) a dataframe that contains two columns: a column "species" that contains the name of each species of guild A and a column "biogeo" that indicates the corresponding biogeographic area for each species (only one area per species). This table is used for the nullmodel "biogeo".
}
}


\value{
The function outputs a list with the following elements:
- R2: the statistic of the test,
- p: the p-value of the test under the null model considered,
- R2_perm: a vector with the statistics of the test for each permuted dataset under the nullmodel considered.
- nperm: the number of permutation,
- nullmodel: the nullmodel considered
}
\details{

See the tutorial on GitHub for measuring cophylogenetic signal accouting for biogeography (https://github.com/BPerezLamarque/EVOLI).

}
\references{
Balbuena JA, Míguez-Lozano R, Blasco-Costa I. 2013. PACo: A novel procrustes application to cophylogenetic analysis. PLoS One, 8, e61048.

Hutchinson MC, Cagua EF, Balbuena JA, Stouffer D, Poisot T. 2017. paco: implementing Procrustean Approach to Cophylogeny in R. Methods Ecol. Evol., 8, 932–940.

Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{PACO_test}}
}
\examples{

# Example 1: Compute cophylogenetic signal using PACo

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)

nperm <- 1000 # At least 10000 permutations should be used (1000 is only for providing a fast example)

\donttest{
# Run PACo under "H0" (random shuffling of the species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Print the test statistic and p-value under "H0"
PACo_result[c("R2_obs","p")] 

# Plot the null distribution under "H0"
plot_null_model(PACo_result, "paco")
}



# Example 2: Assess the effect of biogeography on cophylogenetic signal using PACo

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host # A two-column table indicating the biogeographic repartition of each species of clade A

nperm <- 1000 # At least 10000 permutations should be used (1000 is only for providing a fast example)

\donttest{
# Run PACo under "H0" (random shuffling of the species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Run PACo under "H0 biogeo" (biogeography-based shuffling of the species labels)
PACo_result_biogeo <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "biogeo", table_biogeo = table_biogeo_host)

# Compare the results obtained under the two null models 
PACo_result[c("R2_obs","p")] # Test statistic and p-value under "H0"
PACo_result_biogeo[c("R2_obs","p")] # Test statistic and p-value under "H0 biogeo"
compare_null_models(PACo_result, PACo_result_biogeo, method = "paco") # Standardized effect sizes and f fraction

# Plot the distributions under the two null models
plot_null_models_comparison(PACo_result, PACo_result_biogeo, "paco")
}

}

