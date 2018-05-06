#Sentiment Analysis de artículos periodísticos tomados de Kaggle competitions, 
# https://www.kaggle.com/snapcrack/all-the-news, datos tomados de: "articles1.csv"
#se tomó una muestra de los primeros 1,000 artículos, corresponden a New York Times 2016 -2017
#se perdieron algunos artículos al limpiar la base eliminando casos en que el contenido del artículo
  #contenía comandos que se interpretan como fin de linea


##install packages, solo se deben correr una vez
#install.packages("sentimentr")
#install.packages("xlsx")    
  ###instalar previamente java para 64 bits,
  ###   la instalación automática instala el de 32 bits generando conflicto 
##

#load packages
library(xlsx)
library(sentimentr)

setwd("C:/Users/anfun/Desktop/RRR/News")
#dir()

#carga de la información
titulos <- read.xlsx("articles1_muestra.xlsx", 1)
#head(titulos)

#str(titulos)
#titulos[1]
#titulos$id

#convertir los titulos de factor a character
titulos$title <- as.character(titulos$title)

#str(titulos$title)

#analisis de sentimientos:
sent <- sentiment(titulos$title)
#str(sent)
#summary(sent$sentiment)

#extract_sentiment_terms(titulos$title)

#análisis de resultados
x <- sent$sentiment
nff <- sum(x>.5)
nf <- sum((x>.2) & (x<=.5))
nt <- sum((x<(-.2)) & (x>=(-.5)))
ntt <- sum(x<(-.5))
nn <- sum((x>=(-.2)) & (x<=.2))
l <- length(x)
nff+nf+nn+nt+ntt

nall <- c(nff,nf,nn,nt,ntt)
nall/l
#0.06568712 0.42350908 0.43128781 0.06655143 0.01296456
#Hay un 42% de noticias felices, 48% de felices o muy felices contra 13% de tristes o muy tristes


