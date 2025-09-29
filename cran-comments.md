## longreadvqs VERSION 0.1.0
  
  - R CMD check results
  
  0 errors | 0 warnings | 1 note
  
  * This is a new release.

## longreadvqs VERSION 0.1.1
  
  - R CMD check results
  
  0 errors | 0 warnings | 0 note
  
  - Comments from CRAN team member
  
  1. Package has a FOSS license but eventually depends on the following package which may restrict use: QSutils
  2. Is there some reference about the method you can add in the Description
field in the form Authors (year) <doi:10.....> or <arXiv:.....>?
  3. "Tool Kits for" in the title seems redundant, hence you may want to
remove that.

  - Responses and edits
  
  1. QSutils package's license was updated to GPL-2 by its maintainer (https://code.bioconductor.org/browse/QSutils/blob/devel/DESCRIPTION).
  2. Comments 2. and 3. were fixed in the DESCRIPTION file.
  3. "vqsresub" function was added.

## longreadvqs VERSION 0.1.2

  - R CMD check results
  
  0 errors | 0 warnings | 0 note
  
  - Comments from CRAN team member
  
  1. Please write references in the description of the DESCRIPTION file in the 
  form authors (year) <doi:...>
  authors (year) <arXiv:...>
  authors (year, ISBN:...)
  or if those are not available: authors (year) <https:...>
  with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
  auto-linking. (If you want to add a title as well please put it in
  quotes: "Title") -> please put the year in parentheses.
  
  2. Please always explain all acronyms in the description text. -> SNV
  
  3. You write information messages to the console that cannot be easily
  suppressed. It is more R like to generate objects that can be used to extract 
  the information a user is interested in, and then print() that object.
  Instead of print()/cat() rather use message()/warning() or
  if(verbose)cat(..) (or maybe stop()) if you really have to write text to
  the console. (except for print, summary, interactive functions) ->
  R/filtfast.R, R/gapremove.R, R/pctopt.R, R/vqsassess.R,
  R/vqscustompct.R, R/vqsresub.R, R/vqssub.R
  
  4. Please ensure that your functions do not write by default or in your
  examples/vignettes/tests in the user's home filespace (including the
  package directory and getwd()). This is not allowed by CRAN policies.
  Please omit any default path in writing functions. In your
  examples/vignettes/tests you can write to tempdir(). -> R/vqsout.R
  
  5. We see: Package has a FOSS license but eventually depends on the following
  package which may restrict use:
     QSutils
  Has this been solved?
  
  - Responses and edits
  
  Comments 1. to 3. were fixed. For comment 4., we have already used tempdir() 
  for examples of R/vqsout.R which will not write anything in the user's home 
  filespace. 
  
  ******For comment 5., we communicated with the QSutils package's 
  maintainers and they have already updated its license to GPL-2 in the 
  DESCRIPTION. Please see 
  <https://code.bioconductor.org/browse/QSutils/blob/devel/DESCRIPTION> for 
  clarification.******
  
## longreadvqs VERSION 0.1.3
  
  - R CMD check results
  
  0 errors | 0 warnings | 0 note
  
  - Changes and updates
  
  1. An option to compare viral quasispecies at amino acid level was added to
  "vqscompare" function ("proteincoding" and "removestopcodon" arguments).
  
  2. "AAcompare" function added to the package
  
  3. Documentations updated
  
  4. Reference in the DESCRIPTION file updated
  
  - Comments from CRAN team member
  
    Last released version's CRAN status: OK: 10, ERROR: 3
    See: <https://CRAN.R-project.org/web/checks/check_results_longreadvqs.html>
  
    Possibly misspelled words in DESCRIPTION:
    Pamornchainavakul (5:77)

    Found the following (possibly) invalid URLs:
      URL: https://github.com/longreadvqs
        From: README.md
        Status: 404
        Message: Not Found
        
    Please fix and resubmit.
    
  - Responses and edits
  
  1. For three errors in the last released version's CRAN status, we did our 
  best to fix this dependency issue since the submission of previous version 
  (0.1.2) as we previously clarified in the previous version's comments (we 
  communicated with the QSutils package's maintainers and they have already 
  updated its license to GPL-2 in the DESCRIPTION. Please see 
  <https://code.bioconductor.org/browse/QSutils/blob/devel/DESCRIPTION> for 
  clarification.). We also added how to sparately install our problematic 
  dependency, "QSutils", in our README.md in case users still have this problem.
  
  2. "Pamornchainavakul" was not misspelled. It is my last name.
  
  3. The github link in README.md has already been fixed to 
  <https://github.com/NakarinP/longreadvqs">.

## longreadvqs VERSION 0.1.4
  
  - R CMD check results
  
  0 errors | 0 warnings | 0 note
  
  - Changes and updates
  
  pairwiseAlignment() has moved from Biostrings to the pwalign package
  
  - Comments from CRAN team member
  
  The check problems with r-devel are from changing to BioC 3.22.
