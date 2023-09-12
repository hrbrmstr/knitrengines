# contributors should add their new engines here. follow the example.

.onAttach <- function(libname, pkgname) {

  packageStartupMessage(
    "Registering new knitr chunk processing engines [awk, elixir, pygments, gnuplot]...")

  knitr::knit_engines$set(cawk     = knitr_cawk_engine,
                          elixir   = knitr_elixir_engine,
                          pygments = knitr_pygments_engine,
                          gnuplot  = knitr_gnuplot_engine)

}
