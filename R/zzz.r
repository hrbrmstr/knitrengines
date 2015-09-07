# contributors should add their new engines here. follow the example.

.onAttach <- function(libname, pkgname) {

  packageStartupMessage(
    "Registering new knitr chunk processing engines [go, elixir]...")

  knitr::knit_engines$set(go     = knitr_go_engine,
                          elixir = knitr_elixir_engine)

}
