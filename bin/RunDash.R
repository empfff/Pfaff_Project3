library(shiny)

args = commandArgs(trailingOnly = TRUE)
runApp(paste(args[1],"dashboard",sep=""))