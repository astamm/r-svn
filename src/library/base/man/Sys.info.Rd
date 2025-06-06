% File src/library/base/man/Sys.info.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2024 R Core Team
% Copyright      2008 The R Foundation
% Distributed under GPL 2 or later

\name{Sys.info}
\alias{Sys.info}
\title{Extract System and User Information}
\description{
  Reports system and user information.
}
\usage{
Sys.info()
}
\value{
  A character vector with fields
  \item{sysname}{The operating system name.}
  \item{release}{The OS release.}
  \item{version}{The OS version.}
  \item{nodename}{A name by which the machine is known on the network (if
    any).}
  \item{machine}{A concise description of the hardware, often the CPU type.}
  \item{login}{The user's login name, or \code{"unknown"} if it cannot be
    ascertained.}
  \item{user}{The name of the real user ID, or \code{"unknown"} if it
    cannot be ascertained.}
  \item{effective_user}{The name of the effective user ID, or
    \code{"unknown"} if it
    cannot be ascertained.  This may differ from the real user in
    \sQuote{set-user-ID} processes.}
  \item{udomain}{The domain name for the user. Only available on Windows.}

  \describe{
    \item{On Unix-alike platforms: }{
      The first five fields come from the \code{uname(2)} system call.  The
      login name comes from \code{getlogin(2)}, and the user names from
      \code{getpwuid(getuid())} and \code{getpwuid(geteuid())}.}
    \item{On Windows: }{
      Fields \code{login}, \code{user} and \code{effective_user} give the same
      value. \code{udomain} is the corresponding domain.}
  }
}
\details{
  This uses POSIX or Windows system calls.  Note that OS names (\code{sysname}) might not
  be what you expect: for example macOS identifies itself as
  \samp{Darwin} and Solaris as \samp{SunOS}.

  \code{Sys.info()} returns details of the platform \R is running on,
  whereas \code{\link{R.version}} gives details of the platform \R was
  built on: the \code{release} and \code{version} may well be different.
}
\note{
  The meaning of \code{release} and \code{version} is system-dependent:
  on a Unix-alike they normally refer to the kernel.  There, usually
  \code{release} contains a numeric version and \code{version} gives
  additional information.  Examples for \code{release}:
  \preformatted{
    "4.17.11-200.fc28.x86_64" # Linux (Fedora)
    "3.16.0-5-amd64"          # Linux (Debian)
    "17.7.0"                  # macOS 10.13.6
    "5.11"                    # Solaris
  }

  There is no guarantee that the node or login or user names will be
  what you might reasonably expect.  (In particular on some Linux
  distributions the login name is unknown from sessions with re-directed
  inputs.)

  The use of alternatives such as \code{system("whoami")} is not
  portable: the POSIX command \code{system("id")} is much more portable
  on Unix-alikes, provided only the POSIX options \option{-[Ggu][nr]} are
  used (and not the many BSD and GNU extensions).  \command{whoami} is
  equivalent to \command{id -un} (on Solaris, \command{/usr/xpg4/bin/id -un}).

  Windows may report unexpected versions: see the help for
  \code{\link{win.version}}.
}

\seealso{
  \code{\link{.Platform}}, and \code{\link{R.version}}.
  \code{\link{sessionInfo}()} gives a synopsis of both your system and
  the \R session (and gives the OS version in a human-readable form).
}

\examples{
Sys.info()
## An alternative (and probably better) way to get the login name on Unix
Sys.getenv("LOGNAME")
}
\keyword{utilities}
