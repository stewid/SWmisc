##' Utility function for mparse in SimInf
##'
##' Create a model for an Erlang distribution in SimInf
##' @param src The name of the source compartment.
##' @param dst The name of the destination compartment.
##' @param shape The shape parameter (integer) of the Erlang
##'     distribtion.
##' @param rate The rate parameter of the Erlang distribution.
##' @export
erlang <- function(src, dst, shape, rate) {
    if (!is.numeric(shape))
        stop("'shape' is not an integer.")
    if (!identical(length(shape), 1L))
        stop("length of 'shape' is not one.")
    if (!(abs(shape[1] - round(shape[1])) < .Machine$double.eps^0.5))
        stop("'shape' is not an integer.")
    if (shape[1] < 1)
        stop("'shape' is less than one.")

    shape <- as.integer(shape)
    if (shape > 1) {
        transitions <- c(paste0(src, seq_len(shape - 1), " -> ",
                                rate, " * ",
                                src, seq_len(shape - 1), " -> ", src,
                                seq_len(shape - 1) + 1),
                         paste0(src, shape, " -> ", rate, " * ", src,
                                shape, " -> ", dst))
        compartments <- c(paste0(src, seq_len(shape)), dst)
    } else {
        transitions <- paste0(src, " -> ", rate, " * ", src, " -> ", dst)
        compartments <- c(src, dst)
    }

    list(transitions = transitions, compartments = compartments)
}
