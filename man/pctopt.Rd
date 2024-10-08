% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pctopt.R
\name{pctopt}
\alias{pctopt}
\title{Optimizing cut-off percentage for noise minimization}
\arguments{
\item{fasta}{Input as a read alignment in FASTA format}

\item{pctsing}{The desired percentage of singleton haplotypes relative to the total reads in the alignment.}

\item{method}{Sequencing error and noise minimization methods that replace low frequency nucleotide base (less than the "pct" cut-off) with consensus base of that position ("conbase": default) or with base of the dominant haplotype ("domhapbase").}

\item{samplingfirst}{Downsampling before (TRUE) or after (FALSE: default) the noise minimization.}

\item{gappct}{The percent cut-off particularly specified for gap (-). If it is not specified or less than "pct", "gappct" will be equal to "pct" (default).}

\item{ignoregappositions}{Replace all nucleotides in the positions in the alignment containing gap(s) with gap. This will make such positions no longer single nucleotide variant (SNV). The default is "FALSE".}

\item{samsize}{Sample size (number of reads) after down-sampling. If it is not specified or more than number of reads in the original alignment, down-sampling will not be performed (default).}

\item{label}{String within quotation marks indicating name of read alignment (optional).}
}
\value{
An optimal cut-off percentage for noise minimization of an input sample and parameter settings. If label is specified, the output will be a data frame with percentage of singleton haplotypes at each cut-off percentage from zero to the optimal cut-off percentage.
}
\description{
Finds an optimal cut-off percentage for noise minimization (in vqssub, vqsassess, and vqscustompct functions) that can decrease the number of singleton haplotypes to less than the desired percentage of the total reads.
}
\examples{
## Locate input FASTA file-------------------------------------------------------------------------
fastafilepath <- system.file("extdata", "s1.fasta", package = "longreadvqs")

## Find an cut-off percentage that creates singleton haplotypes less than 50\% of the alignment.----
pctopt(fastafilepath, pctsing = 50, label = "s1")

}
