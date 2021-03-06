#' @title Grouping metadata
#'
#' @param .data,x A `data.frame`.
#'
#' @examples
#' df <- data.frame(x = c(1,1,2,2))
#' group_vars(df)
#' group_rows(df)
#' group_data(df)
#'
#' gf <- group_by(df, x)
#' group_vars(gf)
#' group_rows(gf)
#' group_data(gf)
#'
#' @seealso See [context] for equivalent functions that return values for the current group.
#'
#' @name group_metadata
NULL

#' @description
#' * `group_data()` returns a data frame that defines the grouping structure. The columns give the values of the
#'   grouping variables. The last column, always called `.rows`, is a list of integer vectors that gives the location of
#'   the rows in each group.
#' @rdname group_metadata
#' @export
group_data <- function(.data) {
  if (!has_groups(.data)) return(data.frame(.rows = I(list(seq_len(nrow(.data))))))
  groups <- get_groups(.data)
  group_data_worker(.data, groups)
}

group_data_worker <- function(.data, groups) {
  res <- unique(.data[, groups, drop = FALSE])
  class(res) <- "data.frame"
  nrow_res <- nrow(res)
  rows <- rep(list(NA), nrow_res)
  for (i in seq_len(nrow_res)) {
    rows[[i]] <- which(interaction(.data[, groups]) %in% interaction(res[i, groups]))
  }
  res$`.rows` <- rows
  res <- res[do.call(order, lapply(groups, function(x) res[, x])), , drop = FALSE]
  rownames(res) <- NULL
  res
}

#' @description
#' * `group_rows()` returns the rows which each group contains.
#' @rdname group_metadata
#' @export
group_rows <- function(.data) {
  group_data(.data)[[".rows"]]
}

#' @description
#' * `group_indices()` returns an integer vector the same length as `.data` that gives the group that each row belongs
#'   to.
#' @rdname group_metadata
#' @export
group_indices <- function(.data) {
  if (!has_groups(.data)) return(rep(1L, nrow(.data)))
  groups <- get_groups(.data)
  res <- unique(.data[, groups, drop = FALSE])
  res <- res[do.call(order, lapply(groups, function(x) res[, x])), , drop = FALSE]
  class(res) <- "data.frame"
  nrow_data <- nrow(.data)
  rows <- rep(NA, nrow_data)
  for (i in seq_len(nrow_data)) {
    rows[i] <- which(interaction(res[, groups]) %in% interaction(.data[i, groups]))
  }
  rows
}

#' @description
#' * `group_vars()` gives names of grouping variables as character vector.
#' @rdname group_metadata
#' @export
group_vars <- function(x) {
  get_groups(x)
}

#' @description
#' * `groups()` gives the names as a list of symbols.
#' @rdname group_metadata
#' @export
groups <- function(x) {
  lapply(get_groups(x), as.symbol)
}

#' @description
#' * `group_size()` gives the size of each group.
#' @rdname group_metadata
#' @export
group_size <- function(x) {
  lengths(group_rows(x))
}

#' @description
#' * `n_groups()` gives the total number of groups.
#' @rdname group_metadata
#' @export
n_groups <- function(x) {
  nrow(group_data(x))
}
