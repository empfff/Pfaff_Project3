#! /usr/bin/env nextflow

process count_collabs {
    container 'epfaff/abstractanalysis'

    script:
    """
    Rscript $baseDir/bin/CollabCounter.R
    """
}

process count_words {
    container 'epfaff/abstractanalysis'

    script:
    """
    Rscript $baseDir/bin/WordCounter.R
    """
}