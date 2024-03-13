#' Exporting viral quasispecies profile comparison results
#'
#' @description
#' Writes out resulting objects from "vqscompare" function as tables (TSV files) and alignment (FASTA file) to the working directory.
#'
#' @param vqscompare.obj A resulting object from "vqscompare" function.
#' @param directory Path to desired directory (location) for output files. If it is not specified, the directory will be the current working directory.
#'
#' @return TSV files of viral quasispecies profile comparison results and FASTA file of unique haplotype alignment.
#' @export
#'
#' @importFrom utils write.table
#'
#' @examples
#' ## Locate input FASTA files-----------------------------------------------------------------------
#' sample1filepath <- system.file("extdata", "sample1.fasta", package = "longreadvqs")
#' sample2filepath <- system.file("extdata", "sample2.fasta", package = "longreadvqs")
#' sample3filepath <- system.file("extdata", "sample3.fasta", package = "longreadvqs")
#' sample4filepath <- system.file("extdata", "sample4.fasta", package = "longreadvqs")
#'
#' ## Prepare data for viral quasispecies comparison between four samples----------------------------
#' sample1 <- vqsassess(sample1filepath, pct = 10, samsize = 100, label = "sample1")
#' sample2 <- vqsassess(sample2filepath, pct = 10, samsize = 100, label = "sample2")
#' sample3 <- vqsassess(sample3filepath, pct = 10, samsize = 100, label = "sample3")
#' sample4 <- vqsassess(sample4filepath, pct = 10, samsize = 100, label = "sample4")
#'
#' ## Compare viral quasispecies and OTU (10 clusters) diversity between four samples----------------
#' comp <- vqscompare(samplelist = list(sample1, sample2, sample3, sample4),
#'                    lab_name = "Sample", kmeans.n = 10)
#'
#' ## Export Key outputs from "vqscompare" function--------------------------------------------------
#' notrun <- vqsout(comp, directory = tempdir())
#'

vqsout <- function(vqscompare.obj, directory = "path/to/directory"){
  if(missing(directory)) {
    write.table(vqscompare.obj$hapdiv, file = "hap_div.tsv", sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$otudiv, file = "otu_div.tsv", sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$sumsnv_hap, file = "snv_hap.tsv", sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$sumsnv_otu, file = "snv_otu.tsv", sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$fulldata, file = "fulldata.tsv", sep = '\t', row.names = FALSE, quote = FALSE)
    writeFasta<-function(data, filename){
      fastaLines = c()
      for (rowNum in 1:nrow(data)){
        fastaLines = c(fastaLines, as.character(paste(">", data[rowNum,"hapgroup"], sep = "")))
        fastaLines = c(fastaLines, as.character(data[rowNum,"seq"]))
      }
      fileConn<-file(filename)
      writeLines(fastaLines, fileConn)
      close(fileConn)
    }
    writeFasta(vqscompare.obj$fullseq, "fullseq.fasta")
  }else{
    write.table(vqscompare.obj$hapdiv, file = file.path(directory, paste("hap_div.tsv")), sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$otudiv, file = file.path(directory, paste("otu_div.tsv")), sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$sumsnv_hap, file = file.path(directory, paste("snv_hap.tsv")), sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$sumsnv_otu, file = file.path(directory, paste("snv_otu.tsv")), sep = '\t', row.names = FALSE, quote = FALSE)
    write.table(vqscompare.obj$fulldata, file = file.path(directory, paste("fulldata.tsv")), sep = '\t', row.names = FALSE, quote = FALSE)
    writeFasta<-function(data, filename){
      fastaLines = c()
      for (rowNum in 1:nrow(data)){
        fastaLines = c(fastaLines, as.character(paste(">", data[rowNum,"hapgroup"], sep = "")))
        fastaLines = c(fastaLines, as.character(data[rowNum,"seq"]))
      }
      fileConn<-file(filename)
      writeLines(fastaLines, fileConn)
      close(fileConn)
    }
    writeFasta(vqscompare.obj$fullseq, file.path(directory, paste("fullseq.fasta")))
  }
}


