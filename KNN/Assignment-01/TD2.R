# Part I - Exploratory data analysis

# Q1
# https://rafalab.github.io/pages/649/prostate.html
prostate<-read.table('prostate.data',header = TRUE)

# Q2
summary(prostate)
plot(prostate)
plot(prostate[,-10])
plot(prostate[,c(1,2,3,4,9)])

plot(prostate$lcavol,prostate$lpsa)
plot(prostate$lweight,prostate$lpsa)
plot(prostate$age,prostate$lpsa)
plot(prostate$svi,prostate$lpsa)

boxplot(lpsa~svi,data=prostate,xlab="svi",ylab="lpsa") # label

# Q3

library('FNN')

data<-prostate[,c('lcavol','lweight','age','lbph','lpsa','train')]
# https://hpi.de/fileadmin/user_upload/fachgebiete/boettinger/documents/Kurse_WS_1920/Data_Management_for_Digital_Health/200116_Data_Preprocessing.pdf
# slides page 27, 35
# https://blog.csdn.net/u012768474/article/details/99871942
# https://www.cnblogs.com/xiashiwendao/p/12130992.html
# z score standarization

x_ = data[data$train==T,1:4]

x.train<-scale(x_)
y.train<-data[data$train==T,5]
x.test<-scale(data[data$train==F,1:4])
y.test<-data[data$train==F,5]

# https://www.cnblogs.com/listenfwind/p/10311496.html
# slides page 44
reg<-knn.reg(train=x.train, test = x.test, y=y.train, k = 5)

# ????????????: x.train -> y.train
#  x.test  -> reg$pred(?????????)  ????????? y.test(?????????)

mean((y.test-reg$pred)^2)
plot(y.test,reg$pred,xlab='y',ylab='prediction')
abline(0,1)

# Q4

# slides page 40, 55
MSE<-rep(0,15)
for(k in 1:15){
  reg<-knn.reg(train=x.train, test = x.test, 
               y=y.train, k = k)
  MSE[k]<-mean((y.test-reg$pred)^2)
}
plot(1:15,MSE,type='b',xlab='k',ylab='MSE')       



#-------------------------------------------------
# Part II

# Q1
library(mvtnorm)
mu1<-c(0,0)
mu2<-c(0,2)
mu3<-c(2,0)

Sigma1<-matrix(c(1,0.5,0.5,2),2,2)
Sigma2<-matrix(c(2,-0.5,-0.5,1),2,2)
Sigma3<-diag(c(1,1))


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

# Training set
train<-gen.data(N=100,mu1,mu2,mu3,Sigma1,Sigma2,Sigma3,p1=0.3,p2=0.2)
plot(train$X[,1],train$X[,2],col=train$y,pch=train$y)

# Test set
test<-gen.data(N=1000,mu1,mu2,mu3,Sigma1,Sigma2,Sigma3,p1=0.3,p2=0.2)

# Q2-3

ypred<-knn(train$X,test$X,factor(train$y),k=5)
table(test$y,ypred)
err<-mean(test$y != ypred)
print(err)

# Q4
M<-10
Kmax<-20
ERR100<-matrix(0,M,Kmax)
ERR500<-ERR100
for(m in 1:M){
  print(m)
  train100<-gen.data(N=100,mu1,mu2,mu3,Sigma1,Sigma2,Sigma3,p1=0.3,p2=0.2)
  train500<-gen.data(N=500,mu1,mu2,mu3,Sigma1,Sigma2,Sigma3,p1=0.3,p2=0.2)
  for(k in 1:Kmax){
    ypred<-knn(train100$X,test$X,factor(train100$y),k=k)
    ERR100[m,k]<-mean(test$y != ypred)
    ypred<-knn(train500$X,test$X,factor(train500$y),k=k)
    ERR500[m,k]<-mean(test$y != ypred)
  }
}
err100<-colMeans(ERR100)
err500<-colMeans(ERR500)
plot(1:Kmax,err100,type="b",ylim=range(err100,err500))
lines(1:Kmax,err500,col="red")







