% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lsd-accounts.R
\name{deb_balance}
\alias{deb_balance}
\title{Calculate the balance of a transactions data frame}
\usage{
deb_balance(df, credit = credit, debit = debit, lsd = lsd,
  round = 5, na.rm = FALSE)
}
\arguments{
\item{df}{A data frame containing transactions between accounts and values
in the form of an lsd list column.}

\item{credit}{Credit column: Unquoted name of the credit variable. This
represents the accounts that discharge the transactional values or from
which the values derive. Default is credit. The \code{credit} column must be
of the same class as the \code{debit} column.}

\item{debit}{Debit column: Unquoted name of the debit variable. This
represents the accounts that receive the transactional values. Default is
debit. The \code{debit} column must be of the same class as the \code{credit}
column.}

\item{lsd}{lsd list column: Unquoted name of an lsd list column of pounds,
shillings, and pence values with a bases attribute.}

\item{round}{Round pence to specified number of decimal places. Default
is 5. Rounding to whole numbers may give results that do not add together
due to rounding rules.}

\item{na.rm}{Logical. Passed on to \code{na.rm} argument in \code{\link[=sum]{sum()}}. Whether
missing values (NA) should be removed. Default is \code{FALSE}.}
}
\value{
Returns a tibble with two rows showing the credit and debit
remaining in \code{df} in an lsd list column.
}
\description{
Calculate the balance remaining in \code{df}. This shows the total credit and
debit remaining in the transactions data frame or account book with values
in an lsd list column.
}
\details{
\code{deb_balance()} is based on \code{\link[=deb_open]{deb_open()}}. The function sums the credits
and debits of the accounts that remain open to calculate the capital
remaining in the transactions data frame. The values for credit and debit
should be the same, as each credit also has a corresponding debit. The
exceptions are if there are missing values in \code{df} and \code{na.rm = FALSE}, or
if the \code{round} argument is set to a low value, leading rounding rules to
alter the returned values.

\code{deb_balance()} is part of a family of functions meant to be used on
data frames that contain transactions between accounts in an account
book. The data frame should possess a similar structure to a
\href{https://www.jessesadler.com/post/network-analysis-with-r/#nodes-edges}{directed edge list}.
In this context, credit and debit variables contain the ids of the accounts
and act as the edges of the network. Following the
\href{https://en.wikipedia.org/wiki/Debits_and_credits}{nomenclature of accounting},
the credit variable represents the account that the transactional value is
from, while the debit variable represents the account that receives the
value. Thus, from the credit account to the debit account.
}
\examples{
library(tibble)

# Create a transactions data frame
lsd_list <- deb_as_lsd(list(c(10, 15, 6),
                            c(6, 3, 11),
                            c(4, 11, 7),
                            c(7, 11, 8),
                            c(9, 2, 11)),
                       bases = c(20, 12))
trans <- tibble(credit = c("a", "b", "b", "a", "c"),
                debit = c("b", "a", "a", "c", "a"),
                lsd = lsd_list)

# Credit and debit remaining on trans
deb_balance(df = trans,
             credit = credit,
             debit = debit,
             lsd = lsd)

}
\seealso{
Other lsd account functions: \code{\link{deb_account_summary}},
  \code{\link{deb_account}}, \code{\link{deb_credit}},
  \code{\link{deb_current}}, \code{\link{deb_debit}},
  \code{\link{deb_open}}
}
\concept{lsd account functions}
