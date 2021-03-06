% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lsd-class.R
\name{deb_is_lsd}
\alias{deb_is_lsd}
\title{Test if an object is of class lsd}
\usage{
deb_is_lsd(lsd)
}
\arguments{
\item{lsd}{An object.}
}
\value{
\code{TRUE} if object is of class lsd and \code{FALSE} if it is not.
}
\description{
Test if an object is of class lsd.
}
\examples{
x <- c(5, 3, 8)
y <- deb_as_lsd(x)

deb_is_lsd(x)
deb_is_lsd(y)

}
