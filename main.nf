#! /usr/bin/env nextflow

process count_collabs {
    container 'mbiggs/r_ebimage'

    output:
    file '*.csv' into csv_out

    script:
    """
    Rscript $baseDir/bin/CollabCounter.R
    """
}