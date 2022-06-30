# Part I - 

# Q1
library(MASS)
spam <- read.table("spambase.dat",
                   header=FALSE)
n<- nrow(spam)
p<-ncol(spam)-1
names(spam)[58]<-"class"

ntrain<-round(2*n/3)
ntest<-n-ntrain
train<-sample(n,ntrain)
spam.train<-spam[train,]
spam.test<-spam[-train,]

# Q2
library(lattice)
i<-4
# Boxplot
boxplot(spam[,i]~spam[,58],main=paste("V",i),xlab="class")
# Dotplot
dotplot(spam[,58]~spam[,i],xlab=paste("V",i),ylab="class")
# Histograms
par(mfrow=c(1,2))
i<-i+1
xx<-range(spam[,i])
hist(spam[spam$class==0,i],xlim=xx,xlab=paste("V",i),main="Non spam")
hist(spam[spam$class==1,i],xlim=xx,xlab=paste("V",i),main="Spam")
par(mfrow=c(1,1))


# Q3

lda.spam<- lda(class~.,data=spam.train)
pred.spam.lda<-predict(lda.spam,newdata=spam.test)

perf <-table(spam.test$class,pred.spam.lda$class)
print(perf)

1-sum(diag(perf))/ntest  # error rate


# Q4
library(pROC)
citation("pROC")
roc_curve<-roc(spam.test$class,as.vector(pred.spam.lda$x))
plot(roc_curve)

# Q5
library('FNN')
Kmax<-20
err<-rep(0,Kmax)
for(k in 1:Kmax){
  ypred<-knn(spam.train[,1:57],spam.test[,1:57],
             factor(spam.train$class),k=k)
  err[k]<-mean(spam.test$class != ypred)
}
plot(1:Kmax,err,type="b",xlab="k",ylab="test error rate")



#----- Part II

library(mvtnorm)
mu1<-c(0,0)
mu2<-c(0,2)
mu3<-c(2,0)
Sigma<-matrix(c(1,0.5,0.5,2),2,2)
p1<-0.3
p2<-0.3
p3<-1-p1-p2

# Q1

# Function to generate a data set
gen.data<- function(N,mu1,mu2,mu3,Sigma1,Sigma2,Sigma3,p1,p2){
  y<-sample(3,N,prob=c(p1,p2,1-p1-p2),replace=TRUE)
  X<-matrix(0,N,2)
  N1<-length(which(y==1)) # number of objects from class 1
  N2<-length(which(y==2))
  N3<-length(which(y==3))
  X[y==1,]<-rmvnorm(N1,mu1,Sigma1)
  X[y==2,]<-rmvnorm(N2,mu2,Sigma2)
  X[y==3,]<-rmvnorm(N3,mu3,Sigma3)
  return(list(X=X,y=y))
}


# Test set generation
test<-gen.data(N=10000,mu1,mu2,mu3,Sigma,Sigma,Sigma,
               p1=p1,p2=p2)
plot(test$X,col=test$y,pch=".")

# Test set classification using Bayes rule

g1 = p1*dmvnorm(test$X,mu1,Sigma)
g2 = p2*dmvnorm(test$X,mu2,Sigma)
g3 = p3*dmvnorm(test$X,mu3,Sigma)

g<-cbind(g1, g2, g3)

ypred<-max.col(g)
table(test$y,ypred)
errb<-mean(test$y != ypred)
print(errb)

# Q2 (LDA)

train<-gen.data(N=50,mu1,mu2,mu3,Sigma,Sigma,Sigma,
                p1=p1,p2=p2)
train.frame<-data.frame(train)
test.frame<-data.frame(test)

fit<- lda(y~.,data=train.frame)
pred<-predict(fit,newdata=test.frame)
err_lda<-mean(test$y != pred$class)
print(c(errb,err_lda))
