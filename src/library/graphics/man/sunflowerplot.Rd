% File src/library/graphics/man/sunflowerplot.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2018 R Core Team
% Distributed under GPL 2 or later

\name{sunflowerplot}
\alias{sunflowerplot}
\alias{sunflowerplot.default}
\alias{sunflowerplot.formula}
\title{Produce a Sunflower Scatter Plot}
\description{
  Multiple points are plotted as \sQuote{sunflowers} with multiple leaves
  (\sQuote{petals}) such that overplotting is visualized instead of
  accidental and invisible.
}
\usage{
sunflowerplot(x, \dots)

\method{sunflowerplot}{default}(x, y = NULL, number, log = "", digits = 6,
              xlab = NULL, ylab = NULL, xlim = NULL, ylim = NULL,
              add = FALSE, rotate = FALSE,
              pch = 16, cex = 0.8, cex.fact = 1.5,
              col = par("col"), bg = NA, size = 1/8, seg.col = 2,
              seg.lwd = 1.5, \dots)

\method{sunflowerplot}{formula}(formula, data = NULL, xlab = NULL, ylab = NULL, \dots,
             subset, na.action = NULL)
}
\arguments{
  \item{x}{numeric vector of \code{x}-coordinates of length \code{n},
    say, or another valid plotting structure, as for
    \code{\link{plot.default}}, see also \code{\link{xy.coords}}.}
  \item{y}{numeric vector of \code{y}-coordinates of length \code{n}.}
  \item{number}{integer vector of length \code{n}. \code{number[i]} = number
    of replicates for \code{(x[i], y[i])}, may be 0.\cr
    Default (\code{missing(number)}): compute the exact multiplicity of
    the points \code{x[], y[]}, via
    \code{\link{xyTable}()}.}
  \item{log}{character indicating log coordinate scale, see
    \code{\link{plot.default}}.}
  \item{digits}{when \code{number} is computed (i.e., not specified),
    \code{x} and \code{y} are rounded to \code{digits} significant
    digits before multiplicities are computed.}
  \item{xlab, ylab}{character label for x-, or y-axis, respectively.}
  \item{xlim, ylim}{\code{numeric(2)} limiting the extents of the x-,
    or y-axis.}
  \item{add}{logical; should the plot be added on a previous one ?
    Default is \code{FALSE}.}
  \item{rotate}{logical; if \code{TRUE}, randomly rotate the
    sunflowers (preventing artefacts).}
  \item{pch}{plotting character to be used for points
    (\code{number[i]==1}) and center of sunflowers.}
  \item{cex}{numeric; character size expansion of center points
    (s. \code{pch}).}
  \item{cex.fact}{numeric \emph{shrinking} factor to be used for the
    center points \emph{when there are flower leaves},
    i.e., \code{cex / cex.fact} is used for these.}
  \item{col, bg}{colors for the plot symbols, passed to
    \code{\link{plot.default}}.}
  \item{size}{of sunflower leaves in inches, 1[in] := 2.54[cm].
    Default: 1/8\", approximately 3.2mm.}
  \item{seg.col}{color to be used for the \bold{seg}ments which make the
    sunflowers leaves, see \code{\link{par}(col=)};
    \code{col = "gold"} reminds of real sunflowers.}
  \item{seg.lwd}{numeric; the line width for the leaves' segments.}
  \item{\dots}{further arguments to \code{\link{plot}} [if
    \code{add = FALSE}], or to be passed to or from another method.}
  \item{formula}{a \code{\link{formula}}, such as \code{y ~ x}.}
  \item{data}{a data.frame (or list) from which the variables in
    \code{formula} should be taken.}
  \item{subset}{an optional vector specifying a subset of observations
    to be used in the fitting process.}
  \item{na.action}{a function which indicates what should happen
    when the data contain \code{NA}s.  The default is to ignore case
    with missing values.}
}
\details{
  This is a generic function with default and formula methods.

  For \code{number[i] == 1}, a (slightly enlarged) usual plotting symbol
  (\code{pch}) is drawn.  For \code{number[i] > 1}, a small plotting
  symbol is drawn and \code{number[i]} equi-angular \sQuote{rays}
  emanate from it.

  If \code{rotate = TRUE} and \code{number[i] >= 2}, a random direction
  is chosen (instead of the y-axis) for the first ray.  The goal is to
  \code{\link{jitter}} the orientations of the sunflowers in order to
  prevent artefactual visual impressions.
}
\section{Side Effects}{
  A scatter plot is drawn with \sQuote{sunflowers} as symbols.
}
\value{
  A list with three components of same length,
  \item{x}{x coordinates}
  \item{y}{y coordinates}
  \item{number}{number}

  Use \code{\link{xyTable}()} (from package
  \pkg{grDevices}) if you are only interested in this return value.
}
\references{
  Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983).
  \emph{Graphical Methods for Data Analysis}.
  Wadsworth.

  Schilling, M. F. and Watkins, A. E. (1994).
  A suggestion for sunflower plots.
  \emph{The American Statistician}, \bold{48}, 303--305.
  \doi{10.2307/2684839}.

  Murrell, P. (2005).
  \emph{R Graphics}.
  Chapman & Hall/CRC Press.
}
\author{
  Andreas Ruckstuhl, Werner Stahel, Martin Maechler, Tim Hesterberg,
  1989--1993.  Port to \R by Martin Maechler
  \email{maechler@stat.math.ethz.ch}.
}
\seealso{\code{\link{density}}, \code{\link{xyTable}};
  \code{\link{smoothScatter}()} is often preferable to
  \code{sunflowerplot()} nowadays.
}
\examples{
require(stats) # for rnorm
require(grDevices)

## 'number' is computed automatically:
sunflowerplot(iris[, 3:4])
## Imitating Chambers et al, p.109, closely:
sunflowerplot(iris[, 3:4], cex = .2, cex.fact = 1, size = .035, seg.lwd = .8)
## or
sunflowerplot(Petal.Width ~ Petal.Length, data = iris,
              cex = .2, cex.fact = 1, size = .035, seg.lwd = .8)


sunflowerplot(x = sort(2*round(rnorm(100))), y = round(rnorm(100), 0),
              main = "Sunflower Plot of Rounded N(0,1)")
## Similarly using a "xyTable" argument:
xyT <- xyTable(x = sort(2*round(rnorm(100))), y = round(rnorm(100), 0),
               digits = 3)
utils::str(xyT, vec.len = 20)
sunflowerplot(xyT, main = "2nd Sunflower Plot of Rounded N(0,1)")

## A 'marked point process' {explicit 'number' argument}:
sunflowerplot(rnorm(100), rnorm(100), number = rpois(n = 100, lambda = 2),
              main = "Sunflower plot (marked point process)",
              rotate = TRUE, col = "blue4")
}
\keyword{hplot}
\keyword{smooth}
\keyword{nonparametric}
