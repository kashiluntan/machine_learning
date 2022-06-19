# Part I: prostate data

prostate<-read.table('prostate.data',
                     header = TRUE)  
summary(prostate)
plot(prostate[,-10])

# Q1 Q2 Q3
reg<- lm(lpsa ~. - train ,data=prostate)
summary(reg)

plot(prostate$lpsa,fitted(reg))
abline(0,1)

plot(prostate$lpsa, resid(reg))
abline(h=0)



reg<- lm(lpsa ~. -lcavol -train,data=prostate)
summary(reg)

plot(prostate$lpsa,fitted(reg))
abline(0,1)

plot(prostate$lpsa, resid(reg))
abline(h=0)



reg<- lm(lpsa ~. -lcavol -lweight -train,data=prostate)
summary(reg)

plot(prostate$lpsa,fitted(reg))
abline(0,1)

plot(prostate$lpsa, resid(reg))
abline(h=0)

# Q4

reg<- lm(lpsa ~. - train ,
         data=prostate[prostate$train==TRUE,])

pred<-predict(reg,newdata=prostate[prostate$train==FALSE,])
ytest<-prostate$lpsa[prostate$train==FALSE]
plot(ytest,pred)
abline(0,1)

mse<-mean((ytest-pred)^2)


# Part II: Calcium data

calcium<-read.table("calcium.RData")

# Q1
fit<-lm(cal~time, data=calcium)

# Q2
plot(calcium)
abline(fit$coefficients,lwd=2,col="red")

# Q3
plot(calcium$time,fit$residuals)
abline(h=0)
plot(calcium$cal,fit$residuals)
abline(h=0)

# Q4
plot(calcium)
abline(fit$coefficients,lwd=2,col="red")

fit1<-lm(cal~time+I(time^2), data=calcium)
yhat<-predict(fit1,newdata=data.frame(time=seq(0,15,0.1)))
lines(seq(0,15,0.1),yhat,col="blue",lwd=2,lty=2)

fit2<-lm(cal~time+I(time^2)+I(time^3), data=calcium)
yhat<-predict(fit2,newdata=data.frame(time=seq(0,15,0.1)))
lines(seq(0,15,0.1),yhat,col="green",lwd=2,lty=2)

fit3<-lm(cal~time+I(sqrt(time)), data=calcium)
yhat<-predict(fit3,newdata=data.frame(time=seq(0,15,0.1)))
lines(seq(0,15,0.1),yhat,col="black",lwd=2,lty=2)

fit4<-lm(cal~time+I(time^2)+I(sqrt(time)), data=calcium)
yhat<-predict(fit4,newdata=data.frame(time=seq(0,15,0.1)))
lines(seq(0,15,0.1),yhat,col="black",lwd=2,lty=1)

print(c(summary(fit)$r.squared,summary(fit1)$r.squared,summary(fit2)$r.squared,
        summary(fit3)$r.squared,summary(fit4)$r.squared))



# Part III

n<-500
x1<-runif(n,0,1)
x2<-runif(n,0,1)
X<-cbind(rep(1,n),x1,x2)
beta<-c(0,0.1,1)
Ey<- X %*% beta
sig<-0.5
N<-1000 # number of datasets
pval<-matrix(0,N,3)
for(i in 1:N){
  y<-Ey+rnorm(n,0,sig) 
  fit<-lm(y ~ x1+x2)
  pval[i,] <- summary(fit)$coefficients[,4]
}

colMeans(pval<=0.05)
