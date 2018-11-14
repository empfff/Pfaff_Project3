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

    script:
    """
    Rscript $baseDir/bin/WordCounter.R $baseDir/data/
    """
}

process run_dashboard {

    script:
    """
    docker run -d -p 3838:3838 -p 8787:8787 -e ADD=shiny -e PASSWORD=1234 -v $baseDir/data:/srv/shiny-server rocker/tidyverse
    """
}

csv_out.subscribe { it.copyTo(myDir) }

