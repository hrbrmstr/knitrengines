
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-0%25-lightgrey.svg)

![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-4.0.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# knitrengines

Collection of Language Engines for Use with the ‘knitr’ Package

## Description

The knitr package lets you use other languages in knitr ‘chunks’. This
package is a collection of languages processors not built-in with knitr.

## What’s Inside The Tin

The following functions are implemented:

- `knitr_cawk_engine`: knitr engine for the CSV-enhanced Awk language
- `knitr_elixir_engine`: knitr engine for the Elixir language
- `knitr_gnuplot_engine`: knitr engine for the Go language
- `knitr_pygments_engine`: knitr engine for the pygments syntax
  highlighting (w/o execution)

## Come Again?

`knitrengines` is package to collect and seamlessly add new language
engines to knitr

You can thank [Wendy
Smoak](http://wsmoak.net/2015/09/01/executable-elixir-tufte-handout.html)
for this package as a [comment on a DDS
post](http://datadrivensecurity.info/blog/posts/2015/Jun/running-other-languages-in-r-markdown-files/)
sparked it.

The knitr package already has support for a
[plethora](https://bookdown.org/yihui/rmarkdown/language-engines.html)
of languages besides R code chunks (26 as of the last update to this
package). That is probably sufficient for the vast majority of users.

However, if you need to perform some processing in another languages and
want to include it in your reproducible workflow, this package will
allow you to incorporate those language code chunks provided there is a
matching knitr language processor available.

To use one of these alternate code chunks, just ensure you have a call
to `library(knitrengines)` in an R code chunk at/near the top of your R
markdown file then use one of the available engines via the short name
below as the package will auto-register them on attach.

This package contains support for the following engines:

- `cawk`: Support for Awk builds that include CSV support (see
  `?knitr_cawk_engine`).
- `elixir` : Elixir language support
- `pygments` : Use [pygments](http://pygments.org/) to stylize
  non-executable code blocks. See `knitrengines::knitr_pygments_engine`
  for all the “gotchas”
- `gnuplot` : Use [gnuplot](http://www.gnuplot.info/) for plotting

You can contribe to the project and add support for other language code
chunks by:

- forking this repo
- adding a new `xyz_engine.r` under the `R` directory ensuring you add
  yourself as an `@author`
- adding that engine to the list in `zzz.r`
- update `DESCRIPTION` and add yourself as a contributor and update the
  third dottedn number in the version string (i.e. 0.2.0 -\> 0.2.1)
- update `inst/examples/knitr_engine_test.Rmd` and add a (small) example
  of your engine
- update the `README.Rmd` to include your new engine.
- submit a PR

The only real downside is that these language chunks do not have access
to the variables in/across chunks, so you have to export the data from
previous chunks to files (or databases, etc.) to access it (if needed).

Before you go creating other engines, these are the ones knitr already:

``` r
sort(names(knitr::knit_engines$get()))
##  [1] "asis"      "asy"       "awk"       "bash"      "block"     "block2"    "bslib"     "c"         "cat"      
## [10] "cc"        "coffee"    "comment"   "css"       "ditaa"     "dot"       "embed"     "exec"      "fortran"  
## [19] "fortran95" "gawk"      "glue"      "glue_sql"  "gluesql"   "go"        "groovy"    "haskell"   "highlight"
## [28] "js"        "julia"     "lein"      "mermaid"   "mysql"     "node"      "octave"    "ojs"       "perl"     
## [37] "psql"      "python"    "R"         "Rcpp"      "Rscript"   "ruby"      "sas"       "sass"      "scala"    
## [46] "scss"      "sed"       "sh"        "sql"       "stan"      "stata"     "targets"   "tikz"      "verbatim" 
## [55] "zsh"
```

## Installation

``` r
remotes::install_github("hrbrmstr/knitrengines")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.
