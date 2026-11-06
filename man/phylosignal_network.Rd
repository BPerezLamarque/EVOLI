\name{phylosignal_network}
\alias{phylosignal_network}

\title{
Compute phylogenetic signal in a bipartite interaction network
}

\description{
This function computes phylogenetic signal in a bipartite interaction network, either in species interactions (do closely related species interact with similar partners?) or in the number of partners (i.e. degree; do closely related species interact with the same number of partners?), using Mantel tests.

Mantel tests measuring phylogenetic signal in species interactions can be performed using either quantified or binary networks, with Jaccard, Bray-Curtis, or UniFrac ecological distances.
}

\usage{
phylosignal_network(network, tree_A, tree_B = NULL,
method = "Jaccard_weighted", nperm = 10000,
correlation = "Pearson", only_A = FALSE,
permutation = "shuffle", table_biogeo=NULL)
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
indicates which method is used to compute phylogenetic signal in species interactions. To perform a Mantel test between phylogenetic distances and ecological distances (do closely related species interact with similar partners?), you can choose "Jaccard_weighted" (default), which computes ecological distances using weighted Jaccard dissimilarities, or "Jaccard_binary", which does not take interaction abundances into account. Alternatively, you can choose "Bray-Curtis" to compute Bray-Curtis dissimilarities, or "GUniFrac" and "UniFrac_unweighted" to compute weighted (or generalized) and unweighted UniFrac distances, respectively.

Alternatively, to evaluate phylogenetic signal in the number of partners (do closely related species interact with the same number of partners?), you can choose "degree".
}
\item{correlation}{
(optional) indicates which correlation coefficient (R) is used in the Mantel test: Pearson (default), Spearman, or Kendall. This argument only applies to the methods "Jaccard_weighted", "Jaccard_binary", "Bray-Curtis", "GUniFrac", "UniFrac_unweighted", and "degree".
}
\item{nperm}{
(optional) the number of permutations used to assess the significance of the Mantel test. The default is 10,000, although computation can be particularly time-consuming when using the Kendall correlation. This argument only applies to the methods "Jaccard_weighted", "Bray-Curtis", "Jaccard_binary", "GUniFrac", "UniFrac_unweighted", and "degree".
}
\item{only_A}{
(optional) indicates whether phylogenetic signal should only be computed for guild A (and not for guild B). By default, signal is computed for both guilds when "tree_B" is provided.
}
\item{permutation}{
(optional) indicates which permutations are performed to assess the significance of the Mantel correlation: "shuffle" (default), which randomly shuffles the species labels; "nbpartners", which keeps the number of partners per species of guild A constant while randomly shuffling their identities; or "biogeo", which only shuffles the labels of species from guild A occurring in the same biogeographic area. For the latter, an object "table_biogeo" must be provided.
}
\item{table_biogeo}{
(optional) a dataframe with two columns: a column "species", containing the names of species from guild A, and a column "biogeo", indicating the corresponding biogeographic area of each species. Each species must be assigned to a single biogeographic area. This table is required when nullmodel = "biogeo".
}
}


\value{

For Mantel tests, the function returns a vector containing up to eight values: 

\itemize{
\item the number of species in guild A ("nb_A"), 
\item the number of species in guild B ("nb_B"), 
\item the correlation coefficient for guild A ("mantel_cor_A"), 
\item its associated upper-tail p-value ("p_upper_A", i.e. the fraction of permutations resulting in higher correlation values), 
\item its associated lower-tail p-value ("p_lower_A", i.e. the fraction of permutations resulting in lower correlation values), 
\item and, optionally, the corresponding correlation coefficient ("mantel_cor_B") and upper- and lower-tail p-values ("p_upper_B" and "p_lower_B") for guild B.
}

"mantel_cor_A" (or "mantel_cor_B") indicates the strength of the phylogenetic signal in guild A (or B). The upper-tail p-value ("p_upper_A" or "p_upper_B") indicates the significance of positive phylogenetic signal in guild A (or B), whereas the lower-tail p-value ("p_lower_A" or "p_lower_B") indicates the significance of negative phylogenetic signal (i.e. anti-phylogenetic signal) in guild A (or B).

For instance, if "p_upper_A" < 0.05, there is a significant positive phylogenetic signal in guild A.
}



\details{

See the tutorials on GitHub for measuring phylogenetic signal (https://github.com/BPerezLamarque/Phylosignal_network) and accounting for biogeography (https://github.com/BPerezLamarque/Scripts/tree/master/Biogeography_interactions).

}
\references{
Perez-Lamarque B, Maliet O, Pichon B, Selosse M-A, Martos F, Morlon H. 2022. Do closely related species interact with similar partners? Testing for phylogenetic signal in bipartite interaction networks. Peer Community Journal, Volume 2, article no. e59. doi: 10.24072/pcjournal.179. https://peercommunityjournal.org/articles/10.24072/pcjournal.179/

Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.

}
\author{Benoît Perez-Lamarque}
\seealso{
\code{\link{phylosignal_sub_network}}

\code{\link{plot_null_model}}

\code{\link{plot_null_models_comparison}}

\code{\link{compare_null_models}}
}
\examples{

\donttest{
# Example 1: Compute phylogenetic signal in species interactions using Mantel tests

# Load the data
data(mycorrhizal_network)

network <- mycorrhizal_network[[1]] # Interaction matrix
tree_orchids <- mycorrhizal_network[[2]] # Phylogenetic tree of guild A (orchids)
tree_fungi <- mycorrhizal_network[[3]] # Phylogenetic tree of guild B (fungi)


# Step 1: Phylogenetic signal in species interactions
# (do closely related species interact with similar partners?)

mantel_result <- phylosignal_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
method = "GUniFrac", correlation = "Pearson", nperm = 10000) # measured for both guilds
mantel_result[c("mantel_cor_A", "p_upper_A","mantel_cor_B", "p_upper_B")] 

# Step 2: Assess phylogenetic signal in species interactions while accounting
# for the number of partners per species
# Mantel test with permutations that preserve the number of partners per species

mantel_result <- phylosignal_network(network, tree_A = tree_orchids, tree_B = tree_fungi,
method = "GUniFrac", correlation = "Pearson", nperm = 1000, permutation = "nbpartners")
mantel_result[c("mantel_cor_A", "p_upper_A","mantel_cor_B", "p_upper_B")] 


# Other: Phylogenetic signal in the number of partners
# (do closely related species interact with the same number of partners?)

# for guild A:
mantel_result <- phylosignal_network(network, tree_A = tree_orchids, method = "degree",
correlation = "Pearson", nperm = 10000) 
mantel_result[c("mantel_cor_A", "p_upper_A")] 

# for guild B:
mantel_result <-phylosignal_network(t(network), tree_A = tree_fungi, method = "degree",
correlation = "Pearson", nperm = 10000)
mantel_result[c("mantel_cor_A", "p_upper_A")] 
}



# Example 2: Assess the effect of biogeography on phylogenetic signal in species interactions 
# using Mantel tests

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network 
# Interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host 
# A two-column table indicating the biogeographic distribution of each species from guild A

nperm <- 1000 # At least 10,000 permutations are recommended 
# (1,000 are used here to keep the example computationally fast)

# Run the Mantel test under H0 (random shuffling of species labels)
mantel_result <- phylosignal_network(network, tree_A, method = "Jaccard_binary", 
    nperm = nperm, permutation = "shuffle")

# Run the Mantel test under H0 biogeo (biogeography-constrained shuffling of species labels)
mantel_result_biogeo <- phylosignal_network(network, tree_A, method = "Jaccard_binary", 
    nperm = nperm, permutation = "biogeo", table_biogeo = table_biogeo_host)

# Compare the results obtained under the two null models
mantel_result[c("mantel_cor_A", "p_upper_A")] # Test statistic and p-value under H0
mantel_result_biogeo[c("mantel_cor_A", "p_upper_A")] # Test statistic and p-value under H0 biogeo
compare_null_models(mantel_result, mantel_result_biogeo, method = "mantel") 
# Standardized effect sizes and fraction f

# Plot the distributions under the two null models
plot_null_models_comparison(mantel_result, mantel_result_biogeo, "mantel")

}

