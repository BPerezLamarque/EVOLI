\name{plot_phylosignal_sub_network}
\alias{plot_phylosignal_sub_network}

\title{
Plot clade-specific phylogenetic signals in a bipartite interaction network
}

\description{
This function plots the clade-specific phylogenetic signals in species interactions computed using \code{phylosignal_sub_network}. For each node of tree A corresponding to a sub-clade with a sufficient number of descending species, it represents the phylogenetic signal estimated from a Mantel test between phylogenetic and ecological distances within the corresponding sub-network.
}

\usage{
plot_phylosignal_sub_network(tree_A, results_sub_clades, network, legend=TRUE, 
show.tip.label=FALSE, where="bottomleft", corrected_pvalue=TRUE)
}

\arguments{

\item{tree_A}{
a phylogenetic tree of guild A (the columns of the interaction network). It must be an object of class "phylo".
}
\item{results_sub_clades}{
the output of \code{phylosignal_sub_network}.
}
\item{network}{
a matrix representing the bipartite interaction network, with species from guild A in columns and species from guild B in rows. Row names (resp. column names) must correspond to the tip labels of tree B (resp. tree A).
}
\item{legend}{
indicates whether the legend should be displayed.
}
\item{show.tip.label}{
indicates whether tip labels should be displayed.
}
\item{where}{
indicates where the legend should be placed (default is "bottomleft").
}
\item{corrected_pvalue}{
indicates whether corrected p-values (default is TRUE, using the Bonferroni correction) or uncorrected p-values (FALSE) should be displayed.
}
\item{corrected_pvalue}{
indicates whether the corrected p-values (default is TRUE; using Bonferonni correction) or the original p-values (FALSE) should be used.
}
}

\value{
A phylogenetic tree with nodes colored according to the clade-specific phylogenetic signals. Blue nodes indicate non-significant signals, whereas orange-to-red nodes indicate significant phylogenetic signals, with color intensity reflecting the strength of the signal (Mantel correlation coefficient R).
}

\details{
See the tutorials on GitHub for examples of how to compute and visualize phylogenetic signal in interaction networks:
https://github.com/BPerezLamarque/Phylosignal_network
}

\references{
Perez-Lamarque B, Maliet O, Pichon B, Selosse M-A, Martos F, Morlon H. 2022. Do closely related species interact with similar partners? Testing for phylogenetic signal in bipartite interaction networks. Peer Community Journal, Volume 2, article no. e59. doi: 10.24072/pcjournal.179. https://peercommunityjournal.org/articles/10.24072/pcjournal.179/
}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{phylosignal_network}}
\code{\link{phylosignal_sub_network}}
}
\examples{

# Load the data
data(mycorrhizal_network)

network <- mycorrhizal_network[[1]] # Interaction matrix
tree_orchids <- mycorrhizal_network[[2]] # Phylogenetic tree of guild A (orchids)
tree_fungi <- mycorrhizal_network[[3]] # Phylogenetic tree of guild B (fungi)

\donttest{

# Clade-specific phylogenetic signal in species interactions in guild A
# (do closely related species interact with similar partners within sub-clades of guild A?)

results_clade_A <- phylosignal_sub_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
                                           method = "GUniFrac", correlation = "Pearson", degree = TRUE)
plot_phylosignal_sub_network(tree_A = tree_orchids, results_clade_A, network, where = "topleft")


# Clade-specific phylogenetic signal in species interactions in guild B
# (do closely related species interact with similar partners within sub-clades of guild B?)

results_clade_B <- phylosignal_sub_network(t(network), tree_A = tree_fungi, tree_B = tree_orchids, 
                                           method = "GUniFrac", correlation = "Pearson", degree = TRUE)
plot_phylosignal_sub_network(tree_A = tree_fungi, results_clade_B, t(network), where = "topleft")

}
}

