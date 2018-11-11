#! /usr/bin/env nextflow

in_abstracts = Channel.fromPath( 'data/all/allAbstracts.txt' )

process count_collabs {
    container 'empfff/abstractanalysis'

    input:
    file i from in_abstracts

    script:
    """
    Rscript $baseDir/bin/CollabCounter.R $i
    """
}

