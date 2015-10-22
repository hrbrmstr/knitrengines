#' knitr engine for the Go language
#'
#' Gnuplot is a portable command-line driven graphing utility for Linux, OS/2,
#' MS Windows, OSX, VMS, and many other platforms
#'
#' @param options knitr options (required parameter)
#' @references \url{http://www.gnuplot.info/}
#' @author Bob Rudis
knitr_gnuplot_engine <- function(options) {

  # create a temporary file

  f <- basename(tempfile("gnuplot", '.', paste('.', "plt", sep = '')))
  on.exit(unlink(f)) # cleanup temp file on function exit
  writeLines(options$code, f)

  out <- ''

  # if eval != FALSE compile/run the code, preserving output

  if (options$eval) {
    out <- system(sprintf('gnuplot %s', paste(f, options$engine.opts)), intern=TRUE)
  }

  # spit back stuff to the user

  engine_output(options, options$code, out)

}
