\name{phylosignal_sub_network}
\alias{phylosignal_sub_network}

\title{
Compute clade-specific phylogenetic signals in a bipartite interaction network
}

\description{
This function computes clade-specific phylogenetic signals in species interactions. For each node of tree A with a sufficient number of descending species, it computes the phylogenetic signal in the corresponding sub-network by performing a Mantel test between phylogenetic distances and ecological distances within the sub-clade.
Mantel tests can be performed using quantified or binary networks, with Jaccard, Bray-Curtis, or UniFrac ecological distances.
}

\usage{
phylosignal_sub_network(network, tree_A, tree_B = NULL, 
method = "Jaccard_weighted", nperm = 1000, 
correlation = "Pearson", minimum = 10, degree = FALSE, 
permutation = "shuffle", verbose=TRUE)
}

\arguments{

\item{network}{
a matrix representing the bipartite interaction network, with species from guild A in columns and species from guild B in rows. Row names (resp. column names) must correspond to the tip labels of tree B (resp. tree A).
}
\item{method}{
indicates which method is used to compute phylogenetic signal in species interactions. You can choose "Jaccard_weighted" (default), which computes ecological distances using weighted Jaccard dissimilarities, or "Jaccard_binary", which does not take interaction abundances into account. Alternatively, you can choose "Bray-Curtis" to compute Bray-Curtis dissimilarities, or "GUniFrac" and "UniFrac_unweighted" to compute weighted (or generalized) and unweighted UniFrac distances, respectively.
}
\item{nperm}{
the number of permutations used to assess the significance of the Mantel test. The default is 1,000.
}
\item{correlation}{
indicates which correlation coefficient (R) is used in the Mantel test: Pearson (default), Spearman, or Kendall.
}
\item{minimum}{
the minimum number of descending species required for a node in tree A to compute its clade-specific phylogenetic signal. The default is 10 species.
}
\item{degree}{
if TRUE, additional Mantel tests are performed in each sub-clade to assess phylogenetic signal in the number of partners per species (i.e. degree).
}
\item{permutation}{
indicates which permutations are performed to assess the significance of the Mantel correlation: either "shuffle" (default), which randomly shuffles the species labels, or "nbpartners", which keeps the number of partners per species constant while randomly shuffling their identities.
}
\item{verbose}{
if TRUE, messages are printed during function execution.
}
}


\value{
The function returns a data frame in which each row corresponds to a tested clade. It contains the following columns:

\itemize{
\item "node": the name of the node defining the sub-clade.
\item "nb_A": the number of species in the sub-clade of guild A.
\item "nb_B": the number of species in guild B interacting with the species in the sub-clade of guild A.
\item "mantel_cor": the Mantel correlation coefficient, measuring the strength of the phylogenetic signal in species interactions within the sub-clade.
\item "pvalue_upper" and "pvalue_lower": the upper- and lower-tail p-values, respectively, testing for positive and negative phylogenetic signal.
\item "pvalue_upper_corrected" and "pvalue_lower_corrected": the corresponding p-values corrected for multiple testing using the Bonferroni method.
}

If "pvalue_upper_corrected" is below 0.05 for a given node, this indicates significant positive phylogenetic signal in the corresponding sub-clade of guild A. Conversely, a significant lower-tail p-value indicates significant negative phylogenetic signal.

If degree = TRUE, the data frame also contains the Mantel correlation coefficient for phylogenetic signal in the number of partners ("degree_mantel_cor"), as well as the corresponding upper- and lower-tail p-values, with and without Bonferroni correction ("degree_pvalue_upper", "degree_pvalue_lower", "degree_pvalue_upper_corrected", and "degree_pvalue_lower_corrected").
}

\details{
See the tutorials on GitHub for examples of how to compute and visualize phylogenetic signal in interaction networks:
https://github.com/BPerezLamarque/Phylosignal_network
}

\references{
Perez-Lamarque B, Maliet O, Pichon B, Selosse M-A, Martos F, Morlon H. 2022. Do closely related species interact with similar partners? Testing for phylogenetic signal in bipartite interaction networks. Peer Community Journal, Volume 2, article no. e59. doi: 10.24072/pcjournal.179. https://peercommunityjournal.org/articles/10.24072/pcjournal.179/

Goslee, S.C. & Urban, D.L. (2007). The ecodist package for dissimilarity-based analysis of ecological data. J. Stat. Softw., 22, 1–19.

Chen, J., Bittinger, K., Charlson, E.S., Hoffmann, C., Lewis, J., Wu, G.D., et al. (2012). Associating microbiome composition with environmental covariates using generalized UniFrac distances. Bioinformatics, 28, 2106–2113.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{phylosignal_sub_network}}
\code{\link{plot_phylosignal_sub_network}}
}
\examples{

# Load the data
data(mycorrhizal_network)

network <- mycorrhizal_network[[1]] # interaction matrix 
tree_orchids <- mycorrhizal_network[[2]] # phylogenetic tree (phylo object)
tree_fungi <- mycorrhizal_network[[3]] # phylogenetic tree (phylo object)

\donttest{

# Clade-specific phylogenetic signal in species interactions in guild A
# (do closely related species interact with similar partners within sub-clades of guild A?)

results_clade_A <- phylosignal_sub_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
method = "GUniFrac", correlation = "Pearson", degree = TRUE)
plot_phylosignal_sub_network(tree_A = tree_orchids, results_clade_A, network)


# Clade-specific phylogenetic signal in species interactions in guild B
# (do closely related species interact with similar partners within sub-clades of guild B?)

results_clade_B <- phylosignal_sub_network(t(network), tree_A = tree_fungi, tree_B = tree_orchids, 
method = "GUniFrac", correlation = "Pearson", degree = TRUE)
plot_phylosignal_sub_network(tree_A = tree_fungi, results_clade_B, t(network))
}

}

