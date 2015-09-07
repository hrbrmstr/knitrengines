#' knitr engine for the Elixir language
#'
#' Elixir is a dynamic, functional language designed for building scalable and
#' maintainable applications.
#'
#' Elixir leverages the Erlang VM, known for running low-latency, distributed
#' and fault-tolerant systems, while also being successfully used in web
#' development and the embedded software domain.
#'
#' @param options knitr options (required parameter)
#' @references \url{http://elixir-lang.org/}
#' @author Wendy Smoak
knitr_elixir_engine <- function(options) {

  # create a temporary file

  f <- basename(tempfile("temp", '.', paste('.', "exs", sep = '')))
  on.exit(unlink(f)) # cleanup temp file on function exit
  writeLines(options$code, f)

  out <- ''

  # if eval != FALSE compile/run the code, preserving output

  if (options$eval) {
    out <- system(sprintf('elixir %s', paste(f, options$engine.opts)), intern=TRUE)
  }

  # spit back stuff to the user

  engine_output(options, options$code, out)
}

