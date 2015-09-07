#' knitr engine for the Go language
#'
#' Go is an open source programming language that makes it easy to build simple,
#' reliable, and efficient software
#'
#' @param options knitr options (required parameter)
#' @references \url{https://golang.org/}
#' @author Bob Rudis
knitr_go_engine <- function(options) {

  # create a temporary file

  f <- basename(tempfile("go", '.', paste('.', "go", sep = '')))
  on.exit(unlink(f)) # cleanup temp file on function exit
  writeLines(options$code, f)

  out <- ''

  # if eval != FALSE compile/run the code, preserving output

  if (options$eval) {
    out <- system(sprintf('go run %s', paste(f, options$engine.opts)), intern=TRUE)
  }

  # spit back stuff to the user

  engine_output(options, options$code, out)

}
