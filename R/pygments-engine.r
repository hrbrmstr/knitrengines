#' knitr engine for the pygments syntax highlighting (w/o execution)
#'
#' Pygments is a generic syntax highlighter suitable for use in code hosting,
#' forums, wikis or other applications that need to prettify source code. This
#' knitr engine only highlights code, it will not execute it.
#'
#' This requires setting of two options, \code{pyg.ext} which should be a file
#' extension recognized by the pygments lexer (i.e. \code{py} for Python) and
#' an optional styling (\code{pyg.sty}) for the code output. One of \code{autumn},
#' \code{borland}, \code{bw}, \code{colorful}, \code{default}, \code{emacs},
#' \code{friendly}, \code{fruity}, \code{github}, \code{manni}, \code{monokai},
#' \code{murphy}, \code{native}, \code{pastie}, \code{perldoc}, \code{tango},
#' \code{trac}, \code{vim}, \code{vs}, \code{zenburn}.
#'
#' It will use \code{default} if none are
#' specified. Styles nabbed from \url{https://github.com/richleland/pygments-css}.
#'
#' You can install \code{pygments} via \code{pip install pygments}.
#'
#' There is currently a limitation of one highlight style per knitr document.
#'
#' @note \code{echo} should be \code{FALSE} and \code{results} should be \code{asis}.
#'       However this function will automagically add them if they aren't there. Also,
#'       this function requrires the system program \code{pygmentize} to be on the
#'       executable \code{PATH}. It won't work without it.
#' @param options knitr options (required parameter)
#' @references \url{http://pygments.org/}
#' @author Bob Rudis
knitr_pygments_engine <- function(options) {

  out <- options$code

  # create temporary files

  if (length(options$pyg.ext) == 0) options$pyg.ext <- "txt"
  if (length(options$pyg.sty) == 0) options$pyg.sty <- "default"

  message(options$pyg.ext)
  message(options$pyg.sty)

  f <- basename(tempfile("pyg", '.', paste('.', options$pyg.ext, sep = '')))
  pygf <- tempfile(fileext=".html")
  on.exit({ unlink(f) ; unlink(pygf) }) # cleanup temp files on function exit
  writeLines(options$code, f)

  out <- sprintf("<style>\n%s\n</style>",
                 paste(readLines(system.file(sprintf("css/%s.css", options$pyg.sty),
                                             package="knitrengines")),
                       sep="\n", collapse="\n"))

  system(sprintf("pygmentize -o %s %s", pygf, f))
  out <- sprintf("%s\n%s", out, paste(readLines(pygf), sep="\n", collapse="\n"))

  options$echo <- FALSE
  options$results <- "asis"


  # spit back stuff to the user
  engine_output(options, options$code, out)

}
