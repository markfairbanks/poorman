% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/joins_filtering.R
\name{filter_joins}
\alias{filter_joins}
\alias{anti_join}
\alias{semi_join}
\title{Filtering joins filter rows from \code{x} based on the presence or absence of
matches in \code{y}:}
\usage{
anti_join(x, y, by = NULL)

semi_join(x, y, by = NULL)
}
\arguments{
\item{x, y}{The \code{data.frame}s to join.}

\item{by}{A character vector of variables to join by. If \code{NULL}, the default,
\verb{*_join()} will do a natural join, using all variables with common names
across the two tables. A message lists the variables so that you can check
they're right (to suppress the message, simply explicitly list the variables
that you want to join).}
}
\description{
\itemize{
\item \code{semi_join()} return all rows from \code{x} with a match in \code{y}.
\item \code{anti_join()} return all rows from \code{x} with\emph{out} a match in \code{y}.
}
}
\examples{
table1 <- data.frame(
  pupil = rep(1:3, each = 2),
  test = rep(c("A", "B"), 3),
  score = c(60, 70, 65, 80, 85, 70),
  stringsAsFactors = FALSE
)
table2 <- table1[c(1, 3, 4), ]

table1 \%>\% anti_join(table2, by = c("pupil", "test"))
table1 \%>\% semi_join(table2, by = c("pupil", "test"))

}
