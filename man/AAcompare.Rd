% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AAcompare.R
\name{AAcompare}
\alias{AAcompare}
\title{Comparing viral quasispecies diversity metrics at amino acid level}
\usage{
AAcompare(
  samplelist = list(BC1, BC2, BC3),
  kmeans.n = 20,
  removestopcodon = FALSE
)
}
\arguments{
\item{samplelist}{List of samples, i.e., name of resulting objects from "vqsassess" or "vqscustompct" functions, for example list(BC1, BC2, BC3).}

\item{kmeans.n}{Number of single amino acid variation (SAV) groups needed from k-means clustering on multidimensional scale (MDS) of all samples' pairwise SAV distance.}

\item{removestopcodon}{Remove the last amino acid (expected to be a stop codon) from translated amino acid sequences before further analysis (optional). If not specified or if removestopcodon = FALSE, the last amino acid will not be removed (default).}
}
\value{
List of 1) "aadiv": comparative table of viral quasispecies diversity metrics between listed samples based on translated reads calculated by QSutils package, and 2) "savgrpdiv": comparative table of single amino acid (SAV) group diversity metrics between listed samples calculated from consensus amino acid sequence of each SAV group
}
\description{
Pools noise-minimized down-sampled read samples and compares their diversity metrices based on protein haplotype and single amino acid variation (SAV) group that is classified by k-means clustering of SAV distance. This function is a subset of "vqscompare" function.
}
\examples{
## Locate input FASTA files-----------------------------------------------------------------------
sample1filepath <- system.file("extdata", "s1.fasta", package = "longreadvqs")
sample2filepath <- system.file("extdata", "s2.fasta", package = "longreadvqs")

## Prepare data for viral quasispecies comparison between two samples-----------------------------
set.seed(123)
sample1 <- vqsassess(sample1filepath, pct = 5, samsize = 50, label = "sample1")
sample2 <- vqsassess(sample2filepath, pct = 5, samsize = 50, label = "sample2")

## Compare protein haplotype and SAV group (4 clusters) diversity metrics between two samples-----
AAcompare(samplelist = list(sample1, sample2), kmeans.n = 4)

}
