get_wordcloud <- function (dsin = NULL, varin = NULL, min_freq = 1) {
  ## ------------------------------------------------------------------------ ##
  ## <!-- SOURCE: https://datascienceplus.com/building-wordclouds-in-r/   --> ##
  ## ------------------------------------------------------------------------ ##
  
  ## get corpus
  varin_sel <- dsin[, varin]
  
  ## doesn't work too...
  if (str_detect(varin, "country_code")) {
    print("I am in..")
    # varin_corpus <- tm_map(varin_corpus, content_transformer(toupper))     ## doesn't work (see below)...
    varin_sel <- toupper(varin_sel)     ## forcing it to be upper case
  }
  
  varin_corpus <- Corpus(VectorSource(varin_sel))
  
  ## convert Corpus to lowercase
  if (!str_detect(varin, "country_code")) {
    print("I am out..")
    varin_corpus <- tm_map(varin_corpus, content_transformer(tolower))
  }
#   else {
#     print("I am out..")
#     # varin_corpus <- tm_map(varin_corpus, content_transformer(toupper))     ## doesn't work...
#     varin_corpus <- toupper(varin_corpus)     ## forcing it to be upper case
#   }
  
  ## remove all punctuation and stopwords, and convert it to a plain text document.. 
  ## Stopwords are commonly used words in the English language such as I, me, my, etc.
  varin_corpus <- tm_map(varin_corpus, removePunctuation)
  varin_corpus <- tm_map(varin_corpus, removeWords, stopwords('english'))
  
  ## perform stemming. This means that all the words are converted to their stem 
  ## (Ex: learning -> learn, walked -> walk, etc.). 
  varin_corpus <- tm_map(varin_corpus, stemDocument)
  
  ## generate wordcloud
  file_name <- paste("./outputs/plots/", "wordcloud_", varin, ".png", sep = "")
  png(file_name)
  
  wordcloud(varin_corpus, min.freq = min_freq, random.order = FALSE, scale = c(4,.5))
  
  dev.off()
}




