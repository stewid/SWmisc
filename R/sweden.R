##' Adminstrative boundary for Sweden
##'
##' Download and extract adminstrative boundary for Sweden from
##' Eurostat.
##' @param scale The scale of the map.
##' @param year The year of the dataset.
##' @references
##'     \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
##'
##' @seealso Copyright notice
##'     \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}
##' @export
##' @examples
##' plot(sweden())
sweden <- function(scale = c("1:20 Million", "1:1 Million",
                             "1:3 Million", "1:10 Million",
                             "1:60 Million"),
                   year = c("2013", "2010", "2006"))
{
    scale <- match.arg(scale)
    scale <- switch(scale,
                    "1:1 Million" = "01M",
                    "1:3 Million" = "03M",
                    "1:10 Million" = "10M",
                    "1:20 Million" = "20M",
                    "1:60 Million" = "60M")

    year <- match.arg(year)

    filename <- paste0("NUTS_", year, "_", scale, "_SH.zip")

    ## Download from Eurostat
    if (!file.exists(filename)) {
        url = "http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/"
        download.file(url = paste0(url, filename), destfile = filename, mode = "wb")
    }

    ## Extract NUTS shapefile
    if (!dir.exists(sub("[.]zip$", "", filename))) {
        unzip(filename)
    }

    ## Extract SE
    if(!requireNamespace("rgdal", quietly = TRUE)) {
        stop("The 'sweden' function requires the 'rgdal' packages.",
             call. = FALSE)
    }

    dir <- switch(year,
                  "2006" = "/shape/data",
                  "2010" = "/Data",
                  "2013" = "/data")
    dsn <- paste0("NUTS_", year, "_", scale, "_SH", dir)
    layer <- paste0("NUTS_RG_", scale, "_", year)
    sweden <- rgdal::readOGR(dsn = dsn, layer = layer)
    sweden <- sweden[grep("^SE$", sweden@data$NUTS_ID),]
    if(!requireNamespace("sp", quietly = TRUE)) {
        stop("The 'sweden' function requires the 'sp' packages.",
             call. = FALSE)
    }
    sweden <- sp::spTransform(sweden, sp::CRS("+init=epsg:3021"))

    sweden
}
