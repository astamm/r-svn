% File src/library/base/man/regmatches.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2014 R Core Team
% Distributed under GPL 2 or later

\name{regmatches}
\alias{regmatches}
\alias{regmatches<-}
\title{Extract or Replace Matched Substrings}
\description{
  Extract or replace matched substrings from match data obtained by
  \code{\link{regexpr}}, \code{\link{gregexpr}},
  \code{\link{regexec}} or \code{\link{gregexec}}.
}
\usage{
regmatches(x, m, invert = FALSE)
regmatches(x, m, invert = FALSE) <- value
}
\arguments{
  \item{x}{a character vector.}
  \item{m}{an object with match data.}
  \item{invert}{a logical: if \code{TRUE}, extract or replace the
    non-matched substrings.}
  \item{value}{an object with suitable replacement values for the
    matched or non-matched substrings (see \code{Details}).}
}
\details{
  If \code{invert} is \code{FALSE} (default), \code{regmatches} extracts
  the matched substrings as specified by the match data.  For vector
  match data (as obtained from \code{\link{regexpr}}), empty matches are
  dropped; for list match data, empty matches give empty components
  (zero-length character vectors).

  If \code{invert} is \code{TRUE}, \code{regmatches} extracts the
  non-matched substrings, i.e., the strings are split according to the
  matches similar to \code{\link{strsplit}} (for vector match data, at
  most a single split is performed).

  If \code{invert} is \code{NA}, \code{regmatches} extracts both
  non-matched and matched substrings, always starting and ending with a
  non-match (empty if the match occurred at the beginning or the end,
  respectively).

  Note that the match data can be obtained from regular expression
  matching on a modified version of \code{x} with the same numbers of
  characters.

  The replacement function can be used for replacing the matched or
  non-matched substrings.  For vector match data, if \code{invert} is
  \code{FALSE}, \code{value} should be a character vector with length the
  number of matched elements in \code{m}.  Otherwise, it should be a
  list of character vectors with the same length as \code{m}, each as
  long as the number of replacements needed.  Replacement coerces values
  to character or list and generously recycles values as needed.
  Missing replacement values are not allowed.
}
\value{
  For \code{regmatches}, a character vector with the matched substrings
  if \code{m} is a vector and \code{invert} is \code{FALSE}.  Otherwise,
  a list with the matched or/and non-matched substrings.

  For \code{regmatches<-}, the updated character vector.
}
\examples{
x <- c("A and B", "A, B and C", "A, B, C and D", "foobar")
pattern <- "[[:space:]]*(,|and)[[:space:]]"
## Match data from regexpr()
m <- regexpr(pattern, x)
regmatches(x, m)
regmatches(x, m, invert = TRUE)
## Match data from gregexpr()
m <- gregexpr(pattern, x)
regmatches(x, m)
regmatches(x, m, invert = TRUE)

## Consider
x <- "John (fishing, hunting), Paul (hiking, biking)"
## Suppose we want to split at the comma (plus spaces) between the
## persons, but not at the commas in the parenthesized hobby lists.
## One idea is to "blank out" the parenthesized parts to match the
## parts to be used for splitting, and extract the persons as the
## non-matched parts.
## First, match the parenthesized hobby lists.
m <- gregexpr("\\\\([^)]*\\\\)", x)
## Create blank strings with given numbers of characters.
blanks <- function(n) strrep(" ", n)
## Create a copy of x with the parenthesized parts blanked out.
s <- x
regmatches(s, m) <- Map(blanks, lapply(regmatches(s, m), nchar))
s
## Compute the positions of the split matches (note that we cannot call
## strsplit() on x with match data from s).
m <- gregexpr(", *", s)
## And finally extract the non-matched parts.
regmatches(x, m, invert = TRUE)

## regexec() and gregexec() return overlapping ranges because the
## first match is the full match.  This conflicts with regmatches()<-
## and regmatches(..., invert=TRUE).  We can work-around by dropping
## the first match.
drop_first <- function(x) {
    if(!anyNA(x) && all(x > 0)) {
        ml <- attr(x, 'match.length')
        if(is.matrix(x)) x <- x[-1,] else x <- x[-1]
        attr(x, 'match.length') <- if(is.matrix(ml)) ml[-1,] else ml[-1]
    }
    x
}
m <- gregexec("(\\\\w+) \\\\(((?:\\\\w+(?:, )?)+)\\\\)", x)
regmatches(x, m)
try(regmatches(x, m, invert=TRUE))
regmatches(x, lapply(m, drop_first))
## invert=TRUE loses matrix structure because we are retrieving what
## is in between every sub-match
regmatches(x, lapply(m, drop_first), invert=TRUE)
y <- z <- x
## Notice **list**(...) on the RHS
regmatches(y, lapply(m, drop_first)) <- list(c("<NAME>", "<HOBBY-LIST>"))
y
regmatches(z, lapply(m, drop_first), invert=TRUE) <-
    list(sprintf("<\%d>", 1:5))
z

## With `perl = TRUE` and `invert = FALSE` capture group names
## are preserved.  Collect functions and arguments in calls:
NEWS <- head(readLines(file.path(R.home("doc"), "NEWS.2")), 100)
m <- gregexec("(?<fun>\\\\w+)\\\\((?<args>[^)]*)\\\\)", NEWS, perl = TRUE)
y <- regmatches(NEWS, m)
y[[16]]
## Make tabular, adding original line numbers
mdat <- as.data.frame(t(do.call(cbind, y)))
mdat <- cbind(mdat, line=rep(seq_along(y), lengths(y) / ncol(mdat)))
head(mdat)
NEWS[head(mdat[['line']])]
}
\keyword{character}
\keyword{utilities}
