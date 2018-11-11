#! /usr/bin/env nextflow

params.folder = "$baseDir/data"
myDir = file(params.folder)
in_abstracts = Channel.fromPath( 'data/all/allAbstracts.txt' )

process count_collabs {
    container 'empfff/abstractanalysis'

    input:
    file i from in_abstracts

    output:
    file '*.csv' into csv_out

    script:
    """
    Rscript $baseDir/bin/CollabCounter.R $i
    """
}

csv_out.subscribe { it.copyTo(myDir) }