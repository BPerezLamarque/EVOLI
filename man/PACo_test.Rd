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
a distance matrix representing the phylogenetic distances between pairs of species from guild A (in columns in the interaction network).
}
\item{dist_B}{
a distance matrix representing the phylogenetic distances between pairs of species from guild B (in rows in the interaction network).
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
(optional) a dataframe that contains two columns: a column "species" that contain the name of each species of guild A and a column "biogeo" that indicate the corresponding biogeographic area for each species (only one area per species). This table is used for the nullmodel "biogeo".
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

# Load the data
data(mycorrhizal_network)

network <- mycorrhizal_network[[1]] # interaction matrix
tree_orchids <- mycorrhizal_network[[2]] # phylogenetic tree (phylo object)
tree_fungi <- mycorrhizal_network[[3]] # phylogenetic tree (phylo object)

\donttest{

# Using Mantel tests:

# Step 1: Phylogenetic signal in species interactions
# (do closely related species interact with similar partners?)

phylosignal_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
method = "GUniFrac", correlation = "Pearson", nperm = 10000) # measured for both guilds


# Step 2: Phylogenetic signal in species interactions when accouting
# for the signal in the number of partners
# Mantel test with permutations that keep constant the number of partners per species

phylosignal_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
method = "GUniFrac", correlation = "Pearson", nperm = 1000, permutation = "nbpartners")


# Other: Phylogenetic signal in the number of partners
# (do closely related species interact with the same number of partners?)

phylosignal_network(network, tree_A = tree_orchids, method = "degree",
correlation = "Pearson", nperm = 10000) # for guild A
phylosignal_network(t(network), tree_A = tree_fungi, method = "degree",
correlation = "Pearson", nperm = 10000) # for guild B


}
}

