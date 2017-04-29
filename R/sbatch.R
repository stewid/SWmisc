##' Submit a job to slurm
##'
##' @param job What partition to choose.
##' @param cores The number of cores to use.
##' @param account Which project should be accounted for the running
##'     time. If \code{account} is \code{NULL} the environment
##'     variable \code{SLURM_ACCOUNT} is used.
##' @param jobname Name of job.
##' @param output Name of file for stdout.
##' @param time How long you want to reserve those nodes/cores
##'     (Format: -t d-hh:mm:ss).
##' @param script Commands to run
##' @param filename Where to write the batch job script.
##' @export
sbatch <- function(job = c("core", "node"),
                   cores = 1,
                   account = NULL,
                   jobname = NULL,
                   output = NULL,
                   time = "10:00:00",
                   script = NULL,
                   filename = NULL)
{
    if (is.null(account))
        account <- Sys.getenv("SLURM_ACCOUNT")
    if (!nchar(account))
        stop("'account' is unset")

    lines <- c("#!/bin/bash -l", "",
               sprintf("#SBATCH -A %s", account),
               sprintf("#SBATCH -p %s -n %i", match.arg(job), cores),
               sprintf("#SBATCH -t %s", time))

    if (!is.null(jobname))
        lines <- c(lines, sprintf("#SBATCH -J %s", jobname))
    if (!is.null(output))
        lines <- c(lines, sprintf("#SBATCH -o %s", output))

    if (is.null(script))
        stop("'script' is NULL")
    lines <- c(lines, "", script)

    if (is.null(filename))
        stop("'filename' is NULL")
    writeLines(lines, filename)

    system(paste("sbatch", filename))
}
