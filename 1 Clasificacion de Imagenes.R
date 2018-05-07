##install packages, solo se deben correr una vez

#source("https://bioconductor.org/biocLite.R")
#biocLite("EBImage")

#install.packages("keras")
##


#load packages
library(EBImage)
library(keras)

#correr solo una vez pero despues de library(keras), instala packages para interactuar con Python:
#install_keras()

#rm(list=ls())

setwd("C:/Users/anfun/Desktop/RRR/CIFAR_images")
dir()
pics <- c('bird1.png','bird2.png','bird3.png','bird4.png','bird5.png',
          'bird6.png','bird7.png','bird8.png','bird9.png','bird10.png',
          'ship1.png','ship2.png','ship3.png','ship4.png','ship5.png',
          'ship6.png','ship7.png','ship8.png','ship9.png','ship10.png'
          )
#pics

#leer imagenes y transformarlas a datos numéricos
mypic <- list()
for (i in 1:20)  {mypic[[i]] <- readImage(pics[i])}
#readImage("bird3.png")
#readImage es un comando de EBImage que lee imagen y la vuelve datos numéricos

#class(mypic[[1]])
#print(mypic[[1]])
#display(mypic[[18]])
#summary(mypic[[1]])
#str(mypic[[1]]) #todos tienen la misma dimensión, no hace falta redimensionar con resize
# for (i in 1:20) {mypic[[i]] <- resize(mypic[[i]], 32, 32)}



#transformamos matriz de 32x32x3 = 3,072 a un vector de 3,072
for (i in 1:20) {mypic[[i]] <- array_reshape(mypic[[i]], c(32,32,3))}
#print(mypic[[1]])
#str(mypic)

#armar matrices de datos para el aprendizaje, en cada grupo 8 a train y 2 a test
trainx <- NULL
for (i in 1:8) {trainx <- rbind(trainx,mypic[[i]])}
str(trainx)
class(trainx)
for (i in 11:18){trainx <- rbind(trainx,mypic[[i]])}
testx <- NULL
testx <- rbind(mypic[[9]],mypic[[10]],mypic[[19]],mypic[[20]])
#str(testx)
trainy <- c(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1) #0 bird, 1 ship, asignado en los usados para entrenar
testy <- c(0,0,1,1)  #respuesta esperada

trainLabels <- to_categorical(trainy)
testLabels <- to_categorical(testy)
#print(trainLabels)
#str(trainLabels)

#construcción del modelo
model <- keras_model_sequential()
model %>%
  layer_dense(units=256, activation = 'relu', input_shape=c(3072)) %>%   #3072 is length of vectors
  layer_dense(units=128, activation = 'relu') %>%
  layer_dense(units=2, activation = 'softmax')
summary(model)
#3072*256+256  #number of parmeters from specifications
#units=2 en layer 3 es por que incluimos 2 respuestas: 0, 1  (bird,ship)

#compilacion
model %>%
  compile(loss='binary_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics=c('accuracy'))

#fit model
history <- model %>%
          fit(trainx,
              trainLabels,
              epochs=30,
              batch_size=32,
              validation_split = 0.2) #20% de datos para validation y 80% para training

plot(history)

#Evaluation and prediction in train data
model %>% evaluate(trainx,trainLabels)
#50% de accuracy 
#str(trainx)
#str(trainLabels)

pred <- model %>% predict_classes(trainx)
pred  #sale que todos son 0=birds
trainy #lo que debería haber salido
table(Predicted = pred, Actual = trainy) #confussion matrix

##evaluation and prediction - test data
model %>% evaluate(testx,testLabels)
#str(testx)
#testLabels
pred <- model %>% predict_classes(testx)
pred
testy
table(Predicted = pred, Actual = testy) #confussion matrix
