#! /usr/bin/env nextflow

process count_collabs {
    container 'empfff/abstractanalysis'

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