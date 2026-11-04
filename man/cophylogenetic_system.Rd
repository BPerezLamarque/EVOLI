\name{cophylogenetic_system}
\alias{cophylogenetic_system}
\docType{data}
\title{Simulated cophylogenetic system}
\description{A simulated cophylogenetic system between two interacting clades (clade A and clade B). The dataset contains the phylogenetic trees of both clades, their present-day interation network, and a table indicating the biogeographic areas occupied by the species of clade A.}
\usage{data(cophylogenetic_system)}
\details{
The simulation was performed using the scenario 2 of Ibos et al. (in prep.), where cophylogenetic signal arises from a combination of biogeographic conservatism and conservatism of traits involved in trait matching. See Ibos et al. (in prep) for further details.
}

\source{
Ibos Y, Sagnard A, Perez-Lamarque B (2026), Assessing the influence of biogeography on (co)phylogenetic signals in species interactions, in prep.
}

\references{
Ibos Y, Sagnard A, Perez-Lamarque B (2026), Assessing the influence of biogeography on (co)phylogenetic signals in species interactions, in prep.
}

\examples{

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of clade A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of clade B
network <- cophylogenetic_system$network # Present-day interaction network between species of clade A (on columns) and species of clade B (on rows)
table_biogeo_host <- cophylogenetic_system$table_biogeo_host # A two-column table indicating the biogeographic repartition of each species of clade A

}
\seealso{
\code{\link{PACo_test}}
}
\keyword{datasets}
