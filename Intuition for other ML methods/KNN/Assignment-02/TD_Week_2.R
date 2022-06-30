# https://ocw.mit.edu/courses/mathematics/18-05-introduction-to-probability-and-statistics-spring-2014/readings/MIT18_05S14_Reading7b.pdf
# https://www.probabilitycourse.com/chapter5/5_3_2_bivariate_normal_dist.php
# https://datasciencegenie.com/3d-contour-plots-of-bivariate-normal-distribution/
# https://peterroelants.github.io/posts/multivariate-normal-primer/
# https://www.amherst.edu/system/files/media/1150/bivarnorm.PDF
# https://www2.stat.duke.edu/courses/Spring12/sta104.1/Lectures/Lec22.pdf



# Lab 2, Problem 2

library('FNN')
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


# RNG (Random Number Generator): option 1
mx = 0
my = 0
sx = 1
sy = sqrt(2)
rho = 1 / sqrt(8)
n = 20000
x = rnorm(n, mx, sx)
y = rnorm(n, my + rho * sy * (x - mx) / sx,
          sy * sqrt((1 - rho ^ 2)))
plot(x, y, pch = 20, cex=0.01, col="red", xlim=c(-5,5), ylim=c(-5,5))
summary(x)
summary(y)
var(x)
var(y)
sd(x)
sd(y)
cov(x, y)


# RNG (Random Number Generator): option 2

mu = matrix(c(0, 0), 2, 1)
sigma = matrix(c(1, 0.5, 0.5, 2), 2, 2, byrow=T)
lam = diag(eigen(sigma)$values)
gam = t(eigen(sigma)$vectors)
sig = t(gam) %*% sqrt(lam) %*% gam
z1 = rnorm(20000)
z2 = rnorm(20000)
x = mu[1] + sig[1, 1] * z1 + sig[1, 2] * z2
y = mu[2] + sig[2, 1] * z1 + sig[2, 2] * z2
plot(x, y, pch = 20, cex=0.01, col="green", xlim=c(-5,5), ylim=c(-5,5))
summary(x)
summary(y)
var(x)
var(y)
sd(x)
sd(y)
cov(x, y)

