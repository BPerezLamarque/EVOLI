\name{plot_null_model}
\alias{plot_null_model}

\title{
Plot the null distribution of a (co)phylogenetic signal test statistic
}

\description{
This function plots the null distribution of the test statistic under the a given null model used by PACo, ParaFit, or Mantel tests to assess (co)phylogenetic signal.
}

\usage{
plot_null_model(res, method, median = FALSE)
}

\arguments{

\item{res}{
the output returned by \code{PACo_test}, \code{parafit_test}, or \code{phylosignal_network}.
}
\item{method}{
the method used to compute (co)phylogenetic signal: either "paco", "parafit", or "mantel".
}
\item{median}{
indicates whether the median of the null distribution should be plotted as a vertical dashed line (default is FALSE).
}

}


\value{
A plot showing the null distribution in blue, with a red vertical line indicating the observed value of the test statistic.
}


\details{
See the tutorials on GitHub for examples of how to measure (co)phylogenetic signal:
https://github.com/BPerezLamarque/EVOLI
}

\references{
Ibos Y, Sagnard A, Perez-Lamarque B. 2026. Assessing the effect of biogeography on the evolutionary conservatism of species interactions, in prep.
}

\author{Benoît Perez-Lamarque}

\seealso{
\code{\link{phylosignal_network}}

\code{\link{parafit_test}}

\code{\link{PACo_test}}
}
\examples{

\donttest{
# Example: Compute cophylogenetic signal using PACo and plot the null distribution of the test statistic

data("cophylogenetic_system") # Load the data

tree_A <- cophylogenetic_system$tree_A # Phylogenetic tree of guild A
tree_B <- cophylogenetic_system$tree_B # Phylogenetic tree of guild B
network <- cophylogenetic_system$network # Present-day interaction network between species from guild A (columns) and guild B (rows)

nperm <- 1000 # At least 10,000 permutations are recommended (1,000 are used here to keep the example computationally fast)

# Run PACo under H0 (random shuffling of species labels)
PACo_result <- PACo_test(tree_A, tree_B, network, nperm = nperm, nullmodel = "shuffle")

# Display the test statistic and p-value under H0
PACo_result[c("R2_obs", "p")]

# Plot the null distribution under H0
plot_null_model(PACo_result, "paco")

}

}

