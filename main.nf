#! /usr/bin/env nextflow

myDir = file($baseDir)
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

process count_words {
    container 'empfff/abstractanalysis'

    script:
    """
    Rscript $baseDir/bin/WordCounter.R $baseDir
    """
}

csv_out.subscribe { it.copyTo(myDir) }

