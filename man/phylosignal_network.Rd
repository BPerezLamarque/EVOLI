\name{phylosignal_network}
\alias{phylosignal_network}

\title{
Compute phylogenetic signal in a bipartite interaction network
}

\description{
This function computes the phylogenetic signal in a bipartite interaction network, either the phylogenetic signal in species interactions (do closely related species interact with similar partners?) or the phylogenetic signal in the number of partners (i.e. degree; do closely related species interact with the same number of partners?) using Mantel tests.
Mantel tests measuring the phylogenetic signal in species interactions can be computed using quantified or binary networks, with the Jaccard, Bray-Curtis, or UniFrac ecological distances.

}

\usage{
phylosignal_network(network, tree_A, tree_B = NULL,
method = "Jaccard_weighted", nperm = 10000,
correlation = "Pearson", only_A = FALSE,
permutation = "shuffle", table_biogeo=NULL)
}


\arguments{

\item{network}{
a matrix representing the bipartite interaction network with species from guild A in columns and species from guild B in rows. Row names (resp. columns names) must correspond to the tip labels of tree B (resp. tree A).
}
\item{tree_A}{
a phylogenetic tree of guild A (the columns of the interaction network). It must be an object of class "phylo".
}
\item{tree_B}{
(optional) a phylogenetic tree of guild B (the rows of the interaction network). It must be an object of class "phylo".
}

\item{method}{
indicates which method is used to compute the phylogenetic signal in species interactions. If you want to perform a Mantel test between the phylogenetic distances and some ecological distances (do closely related species interact with similar partners?), you can choose "Jaccard_weighted" (default) for computing the ecological distances using Jaccard dissimilarities (or "Jaccard_binary" to not take into account the abundances of the interactions), "Bray-Curtis" for computing the Bray-Curtis dissimilarity, or "GUniFrac" for computing the weighted (or generalized) UniFrac distances ("UniFrac_unweighted" to not take into account the interaction abundances).

Conversely, if you want to evaluate the phylogenetic signal in the number of partners (do closely related species interact with the same number of partners?), you can choose "degree".
}

\item{correlation}{
(optional) indicates which correlation (R) must be used in the Mantel test, among Pearson (default), Spearman, and Kendall correlations. It only applies for the methods "Jaccard_weighted", "Jaccard_binary", "Bray-Curtis", "GUniFrac", "UniFrac_unweighted", or "degree".
}

\item{nperm}{
(optional) a number of permutations to evaluate the significance of the Mantel test. By default, it equals 10,000, but this can be very long for the Kendall correlation. It only applies for the methods "Jaccard_weighted", "Bray-Curtis", "Jaccard_binary", "GUniFrac", "UniFrac_unweighted", or "degree".
}

\item{only_A}{
(optional) indicates whether the signal should be only computed for guild A (and not for guild B). By default, it is computed for both guilds if "tree_B" is provided.
}

\item{permutation}{
(optional) indicates which permutations must be performed to evaluate the significance of the Mantel correlation: either "shuffle" (by default - i.e. random shufflying of the species labels of "tree_A"), "nbpartners" (i.e. keeping constant the number of partners per species of guild A and shuffling at random their identity), or "biogeo" (i.e. only shuffling species of tree A that are present on the same biogeographic areas - to do so, provide an object "table_biogeo").
}

\item{table_biogeo}{
(optional) a dataframe that contains two columns: a column "species" that contain the name of each species of guild A and a column "biogeo" that indicate the corresponding biogeographic area for each species (only one area per species). This table is used for the permutations "biogeo".
}


}


\value{

For Mantel tests, the function outputs a vector of up to 8 values: the number of species in guild A ("nb_A"), the number of species in guild B ("nb_B"), the correlation for guild A ("mantel_cor_A"), its associated upper p-value ("pvalue_upper_A", i.e. the fraction of permutations that led to higher correlation values), its associated lower p-value ("pvalue_lower_A", i.e. the fraction of permutations that led to lower correlation values), and (optional) the correlation for guild B ("mantel_cor_B"), its associated upper p-value ("pvalue_upper_B"), and its associated lower p-value ("pvalue_lower_B"),

"mantel_cor_A" (or "mantel_cor_B") indicates the strength of the phylogenetic signal in guild A (or B). The upper p-value "pvalue_upper_A" (or "pvalue_upper_B") indicates the significance of the phylogenetic signal in guild A (or B). The lower p-value "pvalue_lower_A" (or "pvalue_lower_B") indicates the significance of the anti-phylogenetic signal in guild A (or B).
For instance, if "pvalue_upper_A"<0.05, there is a significant phylogenetic signal in guild A.

}
\details{

See the tutorial on GitHub for measuring phylogenetic signal (https://github.com/BPerezLamarque/Phylosignal_network) or for accouting for biogeography (https://github.com/BPerezLamarque/EVOLI).

}
\references{
Perez-Lamarque B, Maliet O, Pichon B, Selosse M-A, Martos F, Morlon H. 2022. Do closely related species interact with similar partners? Testing for phylogenetic signal in bipartite interaction networks. Peer Community Journal, Volume 2, article no. e59. doi : 10.24072/pcjournal.179. https://peercommunityjournal.org/articles/10.24072/pcjournal.179/

Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{phylosignal_sub_network}}
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

