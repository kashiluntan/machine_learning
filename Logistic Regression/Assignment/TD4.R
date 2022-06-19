library(MASS)
library(naivebayes)
library(pROC)
library(nnet)

#--------- Part I: Heart data -------------

# Q1
heart<-read.table(file = "SAheart.data",sep=",",
                  header=T,row.names=1)

plot(heart[,c(1, 2, 3, 4, 5, 10)],col=heart[,10]+1) # col means color
plot(heart[,c(6, 7, 8, 9, 10)],col=heart[,10]+3)
n<-nrow(heart)

# Q2
ntrain<-round(2*n/3)
ntest<-n-ntrain
train<-sample(n,ntrain)
heart.train<-heart[train,]
heart.test<-heart[-train,]

# Q3
# LDA
fit.lda<- lda(chd~.,data=heart.train[,-5])
pred.lda<-predict(fit.lda,newdata=heart.test[,-5])
perf <-table(heart.test$chd,pred.lda$class)
print(perf)
err.lda <- 1-sum(diag(perf))/ntest  # error rate

# QDA
fit.qda<- qda(chd~.,data=heart.train[,-5])
pred.qda<-predict(fit.qda,newdata=heart.test[,-5])
perf <-table(heart.test$chd,pred.qda$class)
print(perf)
err.qda <-1-sum(diag(perf))/ntest  # error rate


# Naive Bayes
fit.nb<- naive_bayes(as.factor(chd)~.,data=heart.train)
pred.nb<-predict(fit.nb,newdata=heart.test[1:9],type="class")
pred.nb.prob<-predict(fit.nb,newdata=heart.test[1:9],type="prob")
perf <-table(heart.test$chd,pred.nb)
print(perf)
err.nb <-1-sum(diag(perf))/ntest  # error rate

# Logistic regression

fit.logreg<- glm(as.factor(chd)~.,data=heart.train,family=binomial)
pred.logreg<-predict(fit.logreg,newdata=heart.test,type='response')
perf <-table(heart.test$chd,pred.logreg>0.5)
print(perf)
err.logreg <-1-sum(diag(perf))/ntest  # error rate

print(c(err.lda,err.qda,err.nb,err.logreg))


# 100 replications

M<-100
ERR<-matrix(0,M,4)
for(i in 1:M){
  print(i)
  train<-sample(n,ntrain)
  heart.train<-heart[train,]
  heart.test<-heart[-train,]
  fit.lda<- lda(chd~.,data=heart.train[,-5])
  pred.lda<-predict(fit.lda,newdata=heart.test[,-5])
  ERR[i,1]<-mean(heart.test$chd !=pred.lda$class)
  fit.qda<- qda(chd~.,data=heart.train[,-5])
  pred.qda<-predict(fit.qda,newdata=heart.test[,-5])
  ERR[i,2]<-mean(heart.test$chd !=pred.qda$class)
  fit.nb<- naive_bayes(as.factor(chd)~.,data=heart.train)
  pred.nb<-predict(fit.nb,newdata=heart.test,type="class")
  ERR[i,3]<-mean(heart.test$chd !=pred.nb)
  fit.logreg<- glm(as.factor(chd)~.,data=heart.train,family=binomial)
  pred.logreg<-predict(fit.logreg,newdata=heart.test,type='response')
  ERR[i,4]<-mean(heart.test$chd != (pred.logreg>0.5))
}

boxplot(ERR,ylab="Test error rate",names=c("LDA","QDA","NB","LR"))

# Q4
# Plot of ROC curves

roc_lda<-roc(heart.test$chd,as.vector(pred.lda$x))
plot(roc_lda)
roc_qda<-roc(heart.test$chd,as.vector(pred.qda$posterior[,1]))
plot(roc_qda,add=TRUE,col='red')
roc_nb<-roc(heart.test$chd,as.vector(pred.nb.prob[,1]))
plot(roc_nb,add=TRUE,col='blue')
roc_logreg<-roc(heart.test$chd,as.vector(pred.logreg))
plot(roc_logreg,add=TRUE,col='green')


#--------- Part II: Vowel data -------------

# Q1
vowel <- read.table('vowel.data',
                    header=FALSE)
names(vowel)[11]<-'class'
plot(vowel[,1:5],col=vowel[,11],pch=3)
plot(vowel[,6:10],col=vowel[,11],pch=3)
n<-nrow(vowel)

# Q2
ntrain<-round(2*n/3)
ntest<-n-ntrain
train<-sample(n,ntrain)
vowel.train<-vowel[train,]
vowel.test<-vowel[-train,]

# Q3
# LDA
fit.lda<- lda(class~.,data=vowel.train)
pred.lda<-predict(fit.lda,newdata=vowel.test)
perf <-table(vowel.test$class,pred.lda$class)
print(perf)
err.lda <- 1-sum(diag(perf))/ntest  # error rate

# QDA
fit.qda<- qda(class~.,data=vowel.train)
pred.qda<-predict(fit.qda,newdata=vowel.test)
perf <-table(vowel.test$class,pred.qda$class)
print(perf)
err.qda <-1-sum(diag(perf))/ntest  # error rate

# Naive Bayes
fit.nb<- naive_bayes(as.factor(class)~.,data=vowel.train)
pred.nb<-predict(fit.nb,newdata=vowel.test,type="class")
perf <-table(vowel.test$class,pred.nb)
print(perf)
err.nb <-1-sum(diag(perf))/ntest  # error rate

# Logistic regression

fit.logreg<- multinom(as.factor(class)~.,data=vowel.train)
pred.logreg<-predict(fit.logreg,newdata=vowel.test,type='class')
perf <-table(vowel.test$class,pred.logreg)
print(perf)
err.logreg <-1-sum(diag(perf))/ntest  # error rate

print(c(err.lda,err.qda,err.nb,err.logreg))

# Q4
# 10 replications

M<-10
ERR<-matrix(0,M,4)
for(i in 1:M){
  print(i)
  train<-sample(n,ntrain)
  vowel.train<-vowel[train,]
  vowel.test<-vowel[-train,]
  fit.lda<- lda(class~.,data=vowel.train)
  pred.lda<-predict(fit.lda,newdata=vowel.test)
  ERR[i,1]<-mean(vowel.test$class !=pred.lda$class)
  fit.qda<- qda(class~.,data=vowel.train)
  pred.qda<-predict(fit.qda,newdata=vowel.test)
  ERR[i,2]<-mean(vowel.test$class !=pred.qda$class)
  fit.nb<- naive_bayes(as.factor(class)~.,data=vowel.train)
  pred.nb<-predict(fit.nb,newdata=vowel.test,type="class")
  ERR[i,3]<-mean(vowel.test$class !=pred.nb)
  fit.logreg<- multinom(as.factor(class)~.,data=vowel.train)
  pred.logreg<-predict(fit.logreg,newdata=vowel.test,type='class',trace=FALSE)
  ERR[i,4]<-mean(vowel.test$class != pred.logreg)
}

boxplot(ERR,ylab="Test error rate",names=c("LDA","QDA","NB","LR"))

