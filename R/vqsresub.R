#' Computing viral quasispecies diversity metrics of noise-minimized repeatedly down-sampled read alignments
#'
#' @description
#' Minimizes potential long-read sequencing error and noise based on the specified cut-off percentage of low frequency nucleotide base and repeatedly down-samples read for sensitivity analysis of the diversity metrics varied by different sample sizes. The output of this function is a summary of viral quasispecies diversity metrics per each iteration of down-sampling calculated by QSutils package's functions. This function is an extension of "vqssub" function.
#'
#' @param fasta Input as a read alignment in FASTA format
#' @param iter Number of iterations for downsampling after noise minimization.
#' @param method Sequencing error and noise minimization methods that replace low frequency nucleotide base (less than the "pct" cut-off) with consensus base of that position ("conbase": default) or with base of the dominant haplotype ("domhapbase").
#' @param pct Percent cut-off defining low frequency nucleotide base that will be replaced (must be specified).
#' @param gappct The percent cut-off particularly specified for gap (-). If it is not specified or less than "pct", "gappct" will be equal to "pct" (default).
#' @param ignoregappositions Replace all nucleotides in the positions in the alignment containing gap(s) with gap. This will make such positions no longer single nucleotide variant (SNV). The default is "FALSE".
#' @param samsize Sample size (number of reads) after down-sampling. If it is not specified or more than number of reads in the original alignment, down-sampling will not be performed (default).
#' @param label String within quotation marks indicating name of read alignment (optional).
#'
#' @return Data frame containing all viral quasispecies diversity metrics calculated by QSutils package, noise minimization, and down-sampling information per each downsampling iteration.
#' @export
#'
#' @importFrom Biostrings readDNAStringSet
#' @importFrom Biostrings DNAStringSet
#' @importFrom Biostrings width
#' @importFrom Biostrings nmismatch
#' @importFrom Biostrings pairwiseAlignment
#' @importFrom seqinr read.alignment
#' @importFrom seqinr as.alignment
#' @importFrom seqinr consensus
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @import QSutils
#'
#' @examples
#' ## Locate input FASTA file-------------------------------------------------------------------------
#' fastafilepath <- system.file("extdata", "s1.fasta", package = "longreadvqs")
#'
#' ## Summarize viral quasispecies diversity metrics from five downsampling iterations.---------------
#' vqsresub(fastafilepath, iter = 5, pct = 10, samsize = 20, label = "sample1")
#'
#' @name vqsresub

utils::globalVariables("newcol")

vqsresub <- function(fasta, iter = 100, method= c("conbase", "domhapbase"), pct = 8, gappct = 50, ignoregappositions = FALSE, samsize = 100, label = "sample"){
  dss2df <- function(dss) data.frame(width=width(dss), seq=as.character(dss), names=names(dss))
  seq <- readDNAStringSet(fasta)
  seq2 <- read.alignment(file = fasta, format = "fasta")
  fulldepth <- length(seq)
  samplingwhen <- "after"
  calvqs<-function(seq = seq, samsize = samsize, label = label){
    ##sub-sampling after
    if(samsize < length(seq)){
      samreads <- sample(seq@ranges@NAMES, samsize, replace = FALSE)
      seq <- seq[names(seq) %in% samreads]
    }else{
      seq <- seq
    }
    ##vqs analysis
    hap <- QSutils::Collapse(seq)
    if(length(hap$hseqs) <= 2){
      hapre <- hap
      names(hapre)[2] <- "seqs"
    }else{
      hapcor <- CorrectGapsAndNs(hap$hseqs[2:length(hap$hseqs)],hap$hseqs[[1]])
      hapcor <- c(hap$hseqs[1],hapcor)
      hapre <- QSutils::Recollapse(hapcor,hap$nr)
    }

    depth <- length(seq)
    haplotypes <- length(hapre$seqs)
    polymorph <- SegSites(hapre$seqs)
    mutations <- TotalMutations(hapre$seqs)

    shannon <- Shannon(hapre$nr)
    norm_shannon <- NormShannon(hapre$nr)
    gini_simpson <- QSutils::GiniSimpson(hapre$nr)

    ##Functional diversity
    dst <- DNA.dist(hapre$seqs,model="raw")
    #Incidence-based (count)
    FAD <- FAD(dst)
    Mfe <- MutationFreq(dst)
    Pie <- NucleotideDiversity(dst)
    #Abundance-based (frequency)
    nm <- nmismatch(pairwiseAlignment(hapre$seqs,hapre$seqs[1]))
    Mfm <- MutationFreqVar(nm,hapre$nr,len=width(hapre$seqs)[1])
    Pim <- NucleotideDiversity(dst,hapre$nr)

    nsingleton <- sum(hapre$nr == 1)
    pctsingleton <- nsingleton*100/depth

    if(missing(label)){
      res <- data.frame(method, samplingwhen, pct, fulldepth, depth, haplotypes, nsingleton, pctsingleton, polymorph, mutations, shannon, norm_shannon, gini_simpson, FAD, Mfe, Pie, Mfm, Pim)
    }else{
      res <- data.frame(label, method, samplingwhen, pct, fulldepth, depth, haplotypes, nsingleton, pctsingleton, polymorph, mutations, shannon, norm_shannon, gini_simpson, FAD, Mfe, Pie, Mfm, Pim)
    }
    return(res)
  }

  method <- match.arg(method)

  if(method == "conbase"){
    frq <- seqinr::consensus(seq2, method = "profile")
    frq <- as.data.frame(frq)
    frqpc <- 100 * sweep(frq, 2, colSums(frq), `/`)
    frqpc <- as.data.frame(t(frqpc))

    if(missing(pct)){
      stop("Please specify % cut-off for low frequency SNV (pct)")
    }else{
      lowfrq <- apply(frqpc, 1, function(x) paste(names(which(x[1:5] < pct & x[1:5] > 0)), collapse = ","))
    }

    lowfrq <- as.data.frame(lowfrq)

    if(gappct > pct){
      lowfrq2 <- apply(frqpc, 1, function(x) paste(names(which(x[1] < gappct & x[1] > pct)), collapse = ","))
      lowfrq2 <- as.data.frame(lowfrq2)
      lowfrq3 <- cbind(lowfrq, lowfrq2)
      lowfrq4 <- lowfrq3 %>% mutate(newcol = case_when(lowfrq2 == "" & lowfrq != "" ~ lowfrq, lowfrq2 != "" & lowfrq != "" ~ paste(lowfrq2, lowfrq, sep = ","), lowfrq2 != "" & lowfrq == "" ~ lowfrq2)) %>% select(newcol)
      colnames(lowfrq4) <- "lowfrq"
      lowfrq <- lowfrq4
    }else if(missing(gappct)) {
      lowfrq <- lowfrq
    }else{
      lowfrq <- lowfrq
    }

    lowfrq <- tibble::rownames_to_column(lowfrq, "position")
    lowfrq$position <- as.integer(lowfrq$position)
    lowfrq <- separate_rows(lowfrq,lowfrq,sep=",")
    lowfrq <- as.data.frame(lowfrq)
    lowfrq <- lowfrq[!(is.na(lowfrq$lowfrq) | lowfrq$lowfrq==""), ]
    lowfrq$lowfrq = toupper(lowfrq$lowfrq)
    maxfrq <- apply(frqpc, 1, function(x) paste(names(which(x==max(x)))))
    maxfrq <- lapply(maxfrq, function(x) replace(x, length(x) != 1, "-"))
    maxfrq <- sapply(maxfrq,"[[",1)
    maxfrq <- as.data.frame(maxfrq)
    maxfrq <- tibble::rownames_to_column(maxfrq, "position")
    maxfrq$position <- as.integer(maxfrq$position)
    maxfrq$maxfrq = toupper(maxfrq$maxfrq)
    if(dim(lowfrq)[1] == 0){
      message("No low frequency SNV")
    }else{
      lowfrq <- merge(x = lowfrq, y =  maxfrq, by = "position", all.x = TRUE)
    }

    dfseq <- dss2df(seq)
    dfseq <- data.frame(str_split_fixed(dfseq$seq, "", max(nchar(dfseq$seq))))

    for (i in 1:nrow(lowfrq)){
      if(dim(lowfrq)[1] == 0){
        message("No low frequency SNV")
      }else{
        dfseq[,lowfrq[i,1]][dfseq[,lowfrq[i,1]] == lowfrq[i,2]] <- lowfrq[i,3]
      }
    }

    if(ignoregappositions == TRUE){
      gapfound <- apply(dfseq, 1, function(x) paste(names(which(x=="-"))))
      gapposition <- unique(unlist(gapfound))
      for (i in gapposition){
        dfseq[[i]] <- "-"
      }
    }else if(ignoregappositions == FALSE | missing(ignoregappositions)){
      dfseq <- dfseq
    }else{
      dfseq <- dfseq
    }

    dfseq2 <- unite(dfseq, col='seq', c(names(dfseq[1:ncol(dfseq)])), sep='')
    readnames <- dss2df(seq)
    dfseq2$names <- readnames$names
    seq <- DNAStringSet(c(dfseq2$seq))
    seq@ranges@NAMES <- c(dfseq2$names)

    finaldat <- do.call("rbind", replicate(iter, calvqs(seq = seq, samsize = samsize, label = label), simplify = FALSE))
    return(finaldat)
  }

  if(method == "domhapbase"){
    frq <- seqinr::consensus(seq2, method = "profile")
    frq <- as.data.frame(frq)
    frqpc <- 100 * sweep(frq, 2, colSums(frq), `/`)
    frqpc <- as.data.frame(t(frqpc))

    if(missing(pct)){
      stop("Please specify % cut-off for low frequency SNV (pct)")
    }else{
      lowfrq <- apply(frqpc, 1, function(x) paste(names(which(x[1:5] < pct & x[1:5] > 0)), collapse = ","))
    }

    lowfrq <- as.data.frame(lowfrq)

    if(gappct > pct){
      lowfrq2 <- apply(frqpc, 1, function(x) paste(names(which(x[1] < gappct & x[1] > pct)), collapse = ","))
      lowfrq2 <- as.data.frame(lowfrq2)
      lowfrq3 <- cbind(lowfrq, lowfrq2)
      lowfrq4 <- lowfrq3 %>% mutate(newcol = case_when(lowfrq2 == "" & lowfrq != "" ~ lowfrq, lowfrq2 != "" & lowfrq != "" ~ paste(lowfrq2, lowfrq, sep = ","), lowfrq2 != "" & lowfrq == "" ~ lowfrq2)) %>% select(newcol)
      colnames(lowfrq4) <- "lowfrq"
      lowfrq <- lowfrq4
    }else if(missing(gappct)) {
      lowfrq <- lowfrq
    }else{
      lowfrq <- lowfrq
    }

    lowfrq <- tibble::rownames_to_column(lowfrq, "position")
    lowfrq$position <- as.integer(lowfrq$position)
    lowfrq <- separate_rows(lowfrq,lowfrq,sep=",")
    lowfrq <- as.data.frame(lowfrq)
    lowfrq <- lowfrq[!(is.na(lowfrq$lowfrq) | lowfrq$lowfrq==""), ]
    lowfrq$lowfrq = toupper(lowfrq$lowfrq)
    domhap <- QSutils::Collapse(seq)
    if(domhap$nr[1] == 1){
      stop("No dominant haplotype, please use conbase method instead")
    }else{
      message(paste0("Dominant haplotype is ", format(round(domhap$nr[1]*100/sum(domhap$nr), 2), nsmall = 2), "% of total reads"))
      domhap <- dss2df(domhap$hseqs)
    }

    domhap <- domhap["seq"]
    domhap <- data.frame(str_split_fixed(domhap$seq, "", max(nchar(domhap$seq))))
    domhap <- domhap[1,]
    domhap <- as.data.frame(t(domhap))
    domhap$position <- 1:nrow(domhap)
    colnames(domhap) <- c("domhap", "position")

    if(dim(lowfrq)[1] == 0){
      message("No low frequency SNV")
    }else{
      lowfrq <- merge(x = lowfrq, y =  domhap, by = "position", all.x = TRUE)
    }

    dfseq <- dss2df(seq)
    dfseq <- data.frame(str_split_fixed(dfseq$seq, "", max(nchar(dfseq$seq))))

    for (i in 1:nrow(lowfrq)){
      if(dim(lowfrq)[1] == 0){
        message("No low frequency SNV")
      }else{
        dfseq[,lowfrq[i,1]][dfseq[,lowfrq[i,1]] == lowfrq[i,2]] <- lowfrq[i,3]
      }
    }

    if(ignoregappositions == TRUE){
      gapfound <- apply(dfseq, 1, function(x) paste(names(which(x=="-"))))
      gapposition <- unique(unlist(gapfound))
      for (i in gapposition){
        dfseq[[i]] <- "-"
      }
    }else if(ignoregappositions == FALSE | missing(ignoregappositions)){
      dfseq <- dfseq
    }else{
      dfseq <- dfseq
    }

    dfseq2 <- unite(dfseq, col='seq', c(names(dfseq[1:ncol(dfseq)])), sep='')
    readnames <- dss2df(seq)
    dfseq2$names <- readnames$names
    seq <- DNAStringSet(c(dfseq2$seq))
    seq@ranges@NAMES <- c(dfseq2$names)

    finaldat <- do.call("rbind", replicate(iter, calvqs(seq = seq, samsize = samsize, label = label), simplify = FALSE))
    return(finaldat)
  }
}
