#! /usr/bin/env nextflow

allAbsChannel = Channel.fromPath( 'data/all/allAbstracts.txt' )

process count_collabs {
    container 'empfff/abstractanalysis'

    input:
    file i from allAbsChannel

    script
    """
    Rscript $baseDir/bin/CollabCounter.R
    """
}

process count_words {
    container 'empfff/abstractanalysis'

    script:
    """
    Rscript $baseDir/bin/WordCounter.R
    """
}