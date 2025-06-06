% File src/library/grid/man/grid.add.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2007 R Core Team
% Distributed under GPL 2 or later

\name{grid.add}
\alias{grid.add}
\alias{addGrob}
\alias{setChildren}
\title{Add a Grid Graphical Object}
\description{
  Add a grob to a \I{gTree} or a descendant of a \I{gTree}.
}
\usage{
grid.add(gPath, child, strict = FALSE, grep = FALSE,
         global = FALSE, allDevices = FALSE, redraw = TRUE)

addGrob(gTree, child, gPath = NULL, strict = FALSE, grep = FALSE,
        global = FALSE, warn = TRUE)

setChildren(x, children)
}
\arguments{
  \item{gTree, x}{A \I{gTree} object.}
  \item{gPath}{ A \I{gPath} object. For \code{grid.add} this
    specifies a \I{gTree} on the display list.  For \code{addGrob} this
    specifies a descendant of the specified \I{gTree}. }
  \item{child}{ A grob object. }
  \item{children}{ A \I{gList} object. }
  \item{strict}{ A boolean indicating whether the \I{gPath} must be
    matched exactly. }
  \item{grep}{A boolean indicating whether the \code{gPath} should
    be treated as a regular expression.  Values are recycled across
    elements of the \code{gPath} (e.g., \code{c(TRUE, FALSE)} means
    that every odd element of the \code{gPath} will be treated as
    a regular expression).
  }
  \item{global}{ A boolean indicating whether the function should affect
    just the first match of the \code{gPath}, or whether all matches
    should be affected.
  }
  \item{warn}{A logical to indicate whether failing to find the
    specified \I{gPath} should trigger an error.  }
  \item{allDevices}{ A boolean indicating whether all open devices
    should
    be searched for matches, or just the current device.
    NOT YET IMPLEMENTED.
  }
  \item{redraw}{A logical value to indicate whether to redraw the grob. }
}
\details{
  \code{addGrob} copies the specified grob and returns a modified
  grob.

  \code{grid.add} destructively modifies a grob on the display list.
  If \code{redraw}
  is \code{TRUE} it then redraws everything to reflect the change.

  \code{setChildren} is a basic function for setting all children
  of a \I{gTree} at once (instead of repeated calls to \code{addGrob}).
}
\value{
  \code{addGrob} returns a grob object;  \code{grid.add} returns \code{NULL}.
}
\author{Paul Murrell}
\seealso{
  \code{\link{grob}}, \code{\link{getGrob}},
  \code{\link{removeGrob}}.
}
\keyword{dplot}
