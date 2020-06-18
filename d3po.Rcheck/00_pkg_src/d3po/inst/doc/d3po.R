## ---- echo = FALSE, message = FALSE-------------------------------------------
knitr::opts_chunk$set(collapse = T,
                      comment = "#>",
                      fig.align = "center",
                      fig.width = 5)
options(tibble.print_min = 4L, tibble.print_max = 4L)
library(d3po)
set.seed(123)

## -----------------------------------------------------------------------------
labels = letters[1:3]

adjacency.matrix = matrix(c(0, 1, 2,
                            1, 0, 3,
                            2, 3, 0),
                          nrow = 3, byrow = TRUE)

chord(adjacency.matrix = adjacency.matrix, labels = labels)

## -----------------------------------------------------------------------------
require(dplyr)

df.state = data.frame(state = c("District of Columbia", state.name),
                      value.state = rnorm(51, sd = 3))
df.county = us.counties %>%
  mutate(value.county = rnorm(n(), sd = 1)) %>%
  left_join(df.state, by = "state") %>%
  mutate(value = value.state + value.county)

choropleth.state(df.state, value.column = "value.state")
choropleth.county(df.county)

## -----------------------------------------------------------------------------
require(dplyr)
require(rcorpora)

words = corpora("words/oprah_quotes")$oprahQuotes
words = tolower(unlist(strsplit(words, " ")))
words = gsub("[.,-;]+", "", words)
words = gsub("’", "'", words)
words = words[nchar(words) > 0]

stopwords = corpora("words/stopwords/en")$stopWords

word.df = data.frame(text = words)
word.df = word.df %>%
  filter(!(text %in% stopwords)) %>%
  group_by(text) %>%
  summarize(value = n(), .groups = "drop") %>%
  arrange(desc(value)) %>%
  slice(1:25) %>%
  mutate(value = 3 * value) # To make words a little larger in final image

cloud(word.df, text.color = "word", color.scheme = "RdYlGn")

## -----------------------------------------------------------------------------
num.groups = 5
num.vars = 3
df = data.frame(group = rep(LETTERS[1:num.groups], each = num.vars),
                var = rep(letters[1:num.vars], times = num.groups),
                value = runif(num.groups * num.vars, 0, 10))
marimekko(df, x.column = "group", y.column = "var", color.scheme = "Plasma")

## -----------------------------------------------------------------------------
num.targets = 5
num.sources = 3
df = data.frame(source = rep(LETTERS[1:num.sources], each = num.targets),
                target = rep(letters[1:num.targets], times = num.sources),
                value = runif(num.groups * num.vars, 0, 10))
sankey(df)

