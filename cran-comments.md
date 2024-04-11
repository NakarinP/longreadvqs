## longreadvqs VERSION 0.1.0
  
  - R CMD check results
  
  0 errors | 0 warnings | 1 note
  
  * This is a new release.

## longreadvqs VERSION 0.1.1
  
  - R CMD check results
  
  0 errors | 0 warnings | 0 note
  
  - Comments from CRAN admin
  
  1. Package has a FOSS license but eventually depends on the following package which may restrict use: QSutils
  2. Is there some reference about the method you can add in the Description
field in the form Authors (year) <doi:10.....> or <arXiv:.....>?
  3. "Tool Kits for" in the title seems redundant, hence you may want to
remove that.

  - Responses and edits
  
  1. QSutils package's license was updated to GPL-2 by its maintainer (https://code.bioconductor.org/browse/QSutils/blob/devel/DESCRIPTION). "Remotes: git::https://github.com/VHIRHepatiques/QSutils" line was also added in the DESCRIPTION file.
  2. Comments 2. and 3. were fixed in the DESCRIPTION file.
  3. "vqsresub" function was added.

  
