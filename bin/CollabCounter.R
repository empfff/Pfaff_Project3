library(tidyverse)
library(stringr)
library(plyr)
library(dplyr)

#read in the concat abstract file
args = commandArgs(trailingOnly = TRUE)
abstracts <- read_lines(args[1])

#subset the abstracts to just those that specifically mention UNC in Author information (not all do)
uncAbstracts <- str_subset(abstracts, "Author information.{0,10000}Chapel Hill")

#break out all collaborators as individual strings
collaborators <- str_subset(uncAbstracts, "\\d+\\)(.*?\\.*(\\(|\\z))")

#break out all collaborators' cities/states as lists of individual strings, remove duplicates from each list
citystates <- str_extract_all(collaborators, "(\\w*)?\\s?(\\w*)?\\s?\\w+,\\s*(((Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|Florida|Georgia|Hawaii|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New\\s*Hampshire|New\\s*Jersey|New\\s*Mexico|New\\s*York|North\\s*Carolina|North\\s*Dakota|Ohio|Oklahoma|Oregon|Pennsylvania|Rhode\\s*Island|South\\s*Carolina|South\\s*Dakota|Tennessee|Texas|Utah|Vermont|Virginia|Washington|West\\s*Virginia|Wisconsin|Wyoming)(,\\sNew\\sYork)?)|((A[KLRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|P[AR]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY])))")

uniquecitystates <- vector("list",length(citystates))
for(i in 1:length(citystates)) {
  uniquecitystates[i] <- map(citystates[i],unique)
}

#Convert list of lists into a vector to make it easier to work with
allCollabs <- unlist(uniquecitystates)

#Replace all whitespaces with nothing to normalize city/state names
nospaces <- str_trim(allCollabs)
stateabbrevs <- vector("character",length(allCollabs))
for(i in 1:length(nospaces)) {
  statenm <- str_extract(nospaces[i],"(Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|Florida|Georgia|Hawaii|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New\\sHampshire|New\\sJersey|New\\sMexico|New\\sYork|North\\sCarolina|North\\sDakota|Ohio|Oklahoma|Oregon|Pennsylvania|Rhode\\sIsland|South\\sCarolina|South\\sDakota|Tennessee|Texas|Utah|Vermont|Virginia|Washington|West\\sVirginia|Wisconsin|Wyoming)")
  stateabbrevs[i] <- str_replace(nospaces[i],statenm,state.abb[match(statenm,state.name)])
  if(is.na(stateabbrevs[i])) {
    stateabbrevs[i] <- nospaces[i]
  }
}
stateabbrevs2 <- vector("character",length(stateabbrevs))
for(i in 1:length(stateabbrevs)) {
  statenm <- str_extract(stateabbrevs[i],"(New\\sYork)")
  stateabbrevs2[i] <- str_replace(stateabbrevs[i],statenm,state.abb[match(statenm,state.name)])
  if(is.na(stateabbrevs2[i])) {
    stateabbrevs2[i] <- stateabbrevs[i]
  }
}

#do some final cleanup; remove all spaces, correct frequent problems
cleaned <- str_replace_all(stateabbrevs2," ","")
newYork <- c("(atMountSinai,NY|atMountSinai,NewYork|KetteringCancerCenter,NY|PhysiciansandSurgeons,NY|MedicineatMountSinai,NY|UniversityLangoneMedicalCenter,NY|WeillCornellMedicine,NY|DepartmentofOtolaryngology,NY|FlatironHealth,NY|CornellUniversity,NewYork,NY|BethelGospelAssembly,NY|Box331,NY|SloanKetteringCancerCenter,NY|UniversityMedicalCenter,NY|PerlmutterCancerCenter,NY|ColumbiaUniversity,NY,NY|ofCardiothoracicSurgery,NY|SchoolofMedicine,NY|CollegeofMedicine,NY|CornellUniversity,NY|Bronx,NY|andEarInfirmary,NY|DepartmentofPathology,NY|CornellMedicalCollege,NY)")
cleaned <- str_replace_all(cleaned,"atChapelHill","ChapelHill")
cleaned <- str_replace_all(cleaned,"NY,NY","NY")
cleaned <- str_replace_all(cleaned,newYork,"NewYork,NY")

#Convert to dataframe, count the number of times each city appears in the dataframe, and convert to tibble
df<-data.frame(cleaned)
collabCounts <- ddply(df,.(cleaned),nrow)
collabCountsTib <- as.tibble(collabCounts)

#Sort descending on number of collaborations
collabCountsTib <- collabCountsTib %>%
  filter(cleaned != "ChapelHill,NC") %>%
  arrange(desc(V1)) %>%
  top_n(10)

#write output to file
#ACTION: SWITCH TO GENERIC PATH AND DELETE THIS COMMENT
write.csv(collabCountsTib,"data/collabCounts.csv")

