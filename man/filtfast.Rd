% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filtfast.R
\name{filtfast}
\alias{filtfast}
\title{Filtering highly dissimilar reads/sequences out of the alignment}
\usage{
filtfast(fasta, qt = 0.25, fastaname = "filteredfast.fasta")
}
\arguments{
\item{fasta}{Input as a read or multiple sequence alignment in FASTA format}

\item{qt}{If Hamming similarity score of a read/sequence to the consensus of all reads/sequences is less than the specified quantile (qt) of the similarity distribution, that read/sequence will be removed.}

\item{fastaname}{Output file name in FASTA format}
}
\value{
FASTA read or multiple sequence alignment written out to the input directory
}
\description{
Removes reads/sequences of which Hamming similarity to the consensus of all reads/sequences in the alignment is less than the specified quantile (qt) of the similarity distribution.
}
\examples{
## Locate input FASTA file-------------------------------------------------------------------------
fastafilepath <- system.file("extdata", "dissimfast.fasta", package = "longreadvqs")

## Indicate output directory and file name---------------------------------------------------------
outfast <- tempfile()

## Remove reads/sequences that the similarity < 1st quartile (0.25 quantile)-----------------------
filtfast(fastafilepath, qt = 0.25, fastaname = outfast)

}
