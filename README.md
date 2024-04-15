# longreadvqs <img src='man/figures/longreadvqslogo.png' align="right" height="139" />

<!-- badges: start -->

[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

[**Click here to see an example workflow using 'longreadvqs'**](https://github.com/NakarinP/longreadvqs/blob/main/man/figures/longreadvqs-vignette.pdf)

Tool kits for Viral Quasispecies Comparison from Long-Read Sequencing performing variety of viral quasispecies diversity analyses based on long-read sequence alignment. Main functions include 1) sequencing error minimization and read sampling, 2) SNV profiles comparison, and 3) viral quasispecies profiles comparison and visualization. 

## Installation

'longreadvqs' is a package available on CRAN and can be installed easily in R.:
```{r, eval=FALSE}
install.packages("longreadvqs")
```

If you have a problem installing [```QSutils```](https://github.com/VHIRHepatiques/QSutils), a key dependency of this package, please do the following.: 

```{r, message=FALSE, warning=FALSE, results = "hide", eval=FALSE}
library(devtools)
install_git("https://github.com/VHIRHepatiques/QSutils")
```
