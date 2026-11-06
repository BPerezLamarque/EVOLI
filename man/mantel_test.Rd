\name{mantel_test}
\alias{mantel_test}

\title{
Perform a Mantel test
}

\description{
This function tests for phylogenetic signal in species interactions in guild A using a Mantel test, assessing whether closely related species interact with similar partners.
}

\usage{
mantel_test(network, tree_A, tree_B = NULL, method="Jaccard_binary",
correlation = "Pearson", nperm = 1000, 
permutation = "shuffle", table_biogeo = NULL,
verbose=TRUE)
}

\arguments{

\item{network}{
a matrix representing the bipartite interaction network, with species from guild A in columns and species from guild B in rows. Row names (resp. column names) must correspond to the tip labels of tree B (resp. tree A).
}
\item{tree_A}{
a phylogenetic tree of guild A (corresponding to the columns of the interaction network). It must be an object of class "phylo".
}
\item{tree_B}{
(optional) a phylogenetic tree of guild B (corresponding to the rows of the interaction network). It must be an object of class "phylo".
}
\item{method}{
indicates which method is used to compute phylogenetic signal in species interactions. You can choose "Jaccard_weighted" (default), which computes ecological distances using weighted Jaccard dissimilarities, or "Jaccard_binary", which does not take interaction abundances into account. Alternatively, you can choose "Bray-Curtis" to compute Bray-Curtis dissimilarities, or "GUniFrac" and "UniFrac_unweighted" to compute weighted (or generalized) and unweighted UniFrac distances, respectively.
}
\item{nperm}{
the number of permutations used to assess the significance of the correlation. The default is 1,000.
}
\item{correlation}{
indicates which correlation coefficient (R) is used in the Mantel test: Pearson (default) or Spearman.
}
\item{permutation}{
indicates which null model to use: "shuffle" (default), which randomly shuffles the species labels of tree A, or "biogeo", which only shuffles the labels of species from guild A occurring in the same biogeographic area. For the latter, an object "table_biogeo" must be provided.
}
\item{table_biogeo}{
(optional) a dataframe with two columns: a column "species", containing the names of species from guild A, and a column "biogeo", indicating the corresponding biogeographic area of each species. Each species must be assigned to a single biogeographic area. This table is required when permutation = "biogeo".
}
\item{verbose}{
if TRUE, messages are printed during function execution.
}


}


\value{

A list containing the following elements:

\item{R}{Mantel correlation coefficient (R).}
\item{p_value_upper}{Upper-tail one-sided p-value testing the alternative hypothesis R > 0 (null hypothesis: R <= 0).}
\item{p_value_lower}{Lower-tail one-sided p-value testing the alternative hypothesis R < 0 (null hypothesis: R >= 0).}
\item{random_correlations}{A vector containing the Mantel correlation coefficients obtained for each permutation.}

}
\details{

See the tutorials on GitHub for measuring phylogenetic signal (https://github.com/BPerezLamarque/Phylosignal_network) and accounting for biogeography (https://github.com/BPerezLamarque/Scripts/tree/master/Biogeography_interactions).

}
\references{
Perez-Lamarque B, Maliet O, Pichon B, Selosse M-A, Martos F, Morlon H. 2022. Do closely related species interact with similar partners? Testing for phylogenetic signal in bipartite interaction networks. Peer Community Journal, Volume 2, article no. e59. doi: 10.24072/pcjournal.179. https://peercommunityjournal.org/articles/10.24072/pcjournal.179/

Goslee, S.C. & Urban, D.L. (2007). The ecodist package for dissimilarity-based analysis of ecological data. J. Stat. Softw., 22, 1–19.

Mantel, N. 1967. The detection of disease clustering and a generalized regression approach. Cancer Research 27:209-220.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{phylosignal_network}}

\code{\link{phylosignal_sub_network}}
}
\examples{

# Example 1: Assess phylogenetic signal in species interactions using a Mantel test
# (do closely related species interact with similar partners?)

library(EVOFUNGI)

# Load the data
data(mycorrhizal_network)

network <- mycorrhizal_network[[1]] # Bipartite interaction matrix
tree_orchids <- mycorrhizal_network[[2]] # Phylogenetic tree of orchids

# Run the Mantel test under H0 (random shuffling of species labels):
\donttest{
mantel_test(network, tree_orchids, method = "Jaccard_weighted",
            correlation = "Pearson", nperm = 1000,
            permutation = "shuffle")
}   



# Example 2: Assess phylogenetic signal in species interactions using a Mantel test
# with permutations that preserve the number of partners per species

# Run the Mantel test using permutations that constrain the number of partners per species
\donttest{
mantel_test(network, tree_orchids, method = "Jaccard_weighted", 
            correlation = "Pearson",  nperm = 1000, 
            permutation = "nbpartners")
}   


}

