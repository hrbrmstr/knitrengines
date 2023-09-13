#' knitr engine for the CSV-enhanced Awk language
#'
#' [The one, true Awk](https://github.com/onetrueawk/awk/tree/csv) now
#' has support for using CSV columns as fields.
#'
#' It will eventually be the default on most distros, until then, to
#' use this knitr engine, you will need to do the following:
#'
#' - `git clone git@github.com:onetrueawk/awk.git`
#' - `make`
#' - Move `a.out` to `cawk` somewhere on your `PATH`
#'
#' Previous instructions had one checkout the `csv` branch but
#' thanks [to a tip](https://fosstodon.org/@_TimTaylor/111058284203768015)
#' (thanks, Tim!) that is no longer necessary. This means that your
#' system's Awk may just get an update soon, rendering the `cawk`
#' bit unnecessary. I'll work on adding some checks to see if the
#' Awk you've got built-in has CSV support and use that if it finds it
#' otherwise have it prompt you to do this dance.
#'
#' You can find an example Quarto document that has a `cawk`
#' section via:
#'
#' `system.file("examples/cawk-test.qmd", package="knitrengines")`
#'
#' @section Chunk Options:
#'
#' Any chunk with the language of `cawk` will be processed
#' by this engine. Because there is quite a bit baked into
#' the way Awk works, we need to be able to set up various
#' command line options to get it to work. We do that
#' via knitr chunk options (either inline or in quarto
#' document structured comments).
#'
#' The following chunk options are supported:
#'
#' - `awk.csv`: when set to `TRUE`, this tells `cawk` to assume
#'   the input files are CSV files. This is not set by default
#'   though I'm open to feedback on that life choice.
#' - `awk.var.NAME`: CSV-enabled Awk knows nothing about
#'   column names. You reference each column by field number.
#'   That's not great for "data analysis" work (it isn't great
#'   for anything but one-liners, tbh), so one can use the `-v`
#'   CLI option to define variable name mappings to field numbers.
#'   So defining `awk.var.logdate=1` will let you use `$logdate` in
#'   the Awk script vs `$1`.
#' - `awk.file.#`: Awk processes stdin and files. You can't use data
#'   from the previous chunk without shoving it into a file. Awk can
#'   also work with multiple input files. You can specify the relative
#'   or full path(s) via something like `awk.file.1="this.csv"`. The
#'   entire `awk.file.#` gets ignored. It just needs to be unique.
#'   They are passed to the Awk CLI in the order they appear in the options.
#'
#' @param options knitr options (required parameter)
#' @author Bob Rudis
knitr_cawk_engine <- function(opts) {

  code <- paste(opts$code, collapse = '\n')

  tf <- tempfile(fileext = ".awk")
  writeLines(code, tf)
  on.exit(unlink(tf))

  args <- c("-f", tf)

  # enable awk CSV parsing if requested
  if (!is.null(opts[["awk.csv"]])) {
    args <- c(args, "--csv")
  }

  # enable awk variable assignment if requested
  awk_vars <- opts[grepl("^awk\\.var", names(opts))]

  if (length(awk_vars) > 0) {
    for (var_name in names(awk_vars)) {
      args <- c(
        args, "-v",
        sprintf(
          "%s=%s",
          sub("awk.var.", "", var_name, fixed=TRUE),
          shQuote(awk_vars[[var_name]])
        )
      )
    }
  }

  # get data file(s) to process
  awk_files <- opts[grepl("^awk\\.file", names(opts))]

  if (length(awk_files) > 0) {
    for (fil in awk_files) {
      args <- c(args, shQuote(fil))
    }
  }

  out <- ""

  # if not just showing off a script
  if (opts$eval) {
    out <- system2(
      command = Sys.which("cawk"),
      args = args,
      stdout = TRUE
    )
  }

  # so we get syntax highlighting
  opts$engine <- "awk"

  knitr::engine_output(
    options = opts,
    code = code,
    out = out,
    extra = NULL
  )

}
