FROM rocker/tidyverse

RUN apt-get update

RUN Rscript -e 'install.packages("tm")' 
RUN Rscript -e 'install.packages("plyr")' 
RUN Rscript -e 'install.packages("stringr")' 
RUN Rscript -e 'install.packages("shiny")' 