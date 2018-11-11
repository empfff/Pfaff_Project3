#! /usr/bin/env nextflow

params.in_files = 'data/all/allAbstracts.txt'

in_abstracts = Channel.fromPath( params.in_files )

process count_collabs {
    container 'empfff/abstractanalysis'

    input:
    file i from in_abstracts

    script:
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