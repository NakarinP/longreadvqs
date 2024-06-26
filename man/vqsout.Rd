% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vqsout.R
\name{vqsout}
\alias{vqsout}
\title{Exporting viral quasispecies profile comparison results}
\usage{
vqsout(vqscompare.obj, directory = "path/to/directory")
}
\arguments{
\item{vqscompare.obj}{A resulting object from "vqscompare" function.}

\item{directory}{Path to desired directory (location) for output files. If it is not specified, the directory will be the current working directory.}
}
\value{
TSV files of viral quasispecies profile comparison results and FASTA file of unique haplotype alignment.
}
\description{
Writes out resulting objects from "vqscompare" function as tables (TSV files) and alignment (FASTA file) to the working directory.
}
\examples{
## Locate input FASTA files-----------------------------------------------------------------------
sample1filepath <- system.file("extdata", "s1.fasta", package = "longreadvqs")
sample2filepath <- system.file("extdata", "s2.fasta", package = "longreadvqs")

## Prepare data for viral quasispecies comparison between two samples-----------------------------
set.seed(123)
sample1 <- vqsassess(sample1filepath, pct = 0, samsize = 50, label = "sample1")
sample2 <- vqsassess(sample2filepath, pct = 0, samsize = 50, label = "sample2")

## Compare viral quasispecies and OTU (4 clusters) diversity between two samples------------------
comp <- vqscompare(samplelist = list(sample1, sample2),
           lab_name = "Sample", kmeans.n = 4, showhap.n = 5)

## Export Key outputs from "vqscompare" function--------------------------------------------------
notrun <- vqsout(comp, directory = tempdir())

}
