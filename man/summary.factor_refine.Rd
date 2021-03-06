% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct03_backtestingFuncs.R
\name{summary.factor_refine}
\alias{summary.factor_refine}
\title{summary of factor-refine-methods comparing}
\usage{
\method{summary}{factor_refine}(rawTSF, refinePar_lists, refinePar_names,
  result_type = c("chart", "table", "data"), group_N = 5)
}
\arguments{
\item{rawTSF}{The TSF which contains the raw factorscore.}

\item{refinePar_lists}{A list of (refinePar)s, each refinePar is a list built by refinePar_default.}

\item{refinePar_names}{The character vector of names, could be missing.}

\item{result_type}{Currently supports 3 possible results : chart, table, data}

\item{group_N}{The argument passed into Ngroup.overall, etc.}
}
\description{
summary of factor-refine-methods comparing
}
\examples{
RebDates <- getRebDates(as.Date('2011-03-17'),as.Date('2012-04-17'),'month')
TS <- getTS(RebDates,'EI000300')
refinePar_lists <- list(refinePar_default(type = "none"),
                        refinePar_default(type = "reg"),
                        refinePar_default(type = "scale"))
rawTSF <- gf.NP_YOY(TS, src = "fin")
summary.factor_refine(rawTSF, refinePar_lists)
}
\author{
Han.Qian
}
