#!/usr/bin/env nextflow

process catAbstracts {

    output:
    ???

    """
    cat abs.*.txt > allabstracts.txt
    """
}


process convertToUpper {

    input:
    file x from letters

    output:
    stdout result

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}

result.subscribe {
    println it.trim()
}