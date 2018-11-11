FROM rocker/tidyverse

RUN apt-get update && \ 
    apt-get install -y libfftw3-dev libtiff5-dev

RUN Rscript -e 'install.packages("BiocManager")' 
RUN Rscript -e 'BiocManager::install("EBImage")'
