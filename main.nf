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

process count_words {
    container 'empfff/abstractanalysis'

    output:
    file '*.csv' into csv_out2

    script:
    """
    Rscript $baseDir/bin/WordCounter.R $baseDir/data
    """
}

csv_out.subscribe { it.copyTo(myDir) }
csv_out2.subscribe { it.copyTo(myDir) }

