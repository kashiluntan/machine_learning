# -*- coding: UTF-8 -*-
"""
此脚本用于展示过度拟合的问题
"""

import os

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn import linear_model
from sklearn.preprocessing import PolynomialFeatures

def test():
    a=[[1, 2]]    #c=[[a,b]],这里要注意a的shape，如果是list形式，则将a.shape=-1,1
    a2=[[1, 2], [3, 4]] 
    b=[[1, 2, 3]] 
    #默认阶数为2次
    pl=PolynomialFeatures() 
    pl=PolynomialFeatures(degree=4)
    fs=pl.fit_transform(a2)


def read_data(path):
    """
    使用pandas读取数据
    """
    data = pd.read_csv(path)
    return data


def evaluate_model(model, test_data, features, labels, featurizer):
    """
    计算线性模型的均方差和决定系数
    """
    # 均方差(The mean squared error)，均方差越小越好
    # 根据当前的多项式模型，输入测试数据，计算出对应的特征。
    X_features = featurizer.fit_transform(test_data[features])
    
    # eg. y_hat = model.predict(x)          #向构建的模型输入X，估算输出值Y
    # 模型model中有训练好的参数估计值
    Y_hat = model.predict(X_features)
    error = np.mean(( Y_hat - test_data[labels]) ** 2)
   
    # 决定系数(Coefficient of determination)，决定系数越接近1越好
    # eg. score = model.score(x, y)
    score = model.score(X_features, test_data[labels])
    return error, score


def train_model(train_data, features, labels, featurizer):
    """
    利用训练数据，估计模型参数
    """
    # 创建一个线性回归模型,fit_intercept=False表示不存在截距
    model = linear_model.LinearRegression(fit_intercept=False)
    
    # 构建更多特征
    X_features = featurizer.fit_transform(train_data[features])   
    # 训练模型，估计模型参数
    model.fit(X_features, train_data[labels])
    return model


def visualize_model(model, featurizer, data, features, labels, evaluation):
    """
    模型可视化
    """
    # 为在Matplotlib中显示中文，设置特殊字体
    plt.rcParams['font.sans-serif'] = ['SimHei']
    # 创建一个图形框
    fig = plt.figure(figsize=(10, 10), dpi=80)
    # 在图形框里只画一幅图
    for i in range(4):
        ax = fig.add_subplot(2, 2, i+1)
        _visualization(ax, data, model[i], featurizer[i], evaluation[i], features, labels)
    plt.show()


def _visualization(ax, data, model, featurizer, evaluation, features, labels):
    """
    实现可视化
    """
    # 画点图，用蓝色圆点表示原始数据
    ax.scatter(np.array(data[features]), np.array(data[labels]), color='b')
    
    # 画线图，用红色线条表示模型结果
    ax.plot(data[features], model.predict(featurizer.fit_transform(data[features])),
            color="r")
    # 显示均方差和决定系数
    ax.text(0.01, 0.99,
            u'%s%.3f\n%s%.3f' % ("mse: ", evaluation[0], "R2: ", evaluation[1]),
            style="italic", verticalalignment="top", horizontalalignment="left",
            transform=ax.transAxes, color="m", fontsize=13)


def run_model(data):
    """
    运行模型
    """
    features = ["x"]
    labels = ["y"]
    # 将原数据集划分为训练集和测试集
    train_data = data[:15]
    test_data = data[15:]
    
    #用于存放多项式模型对象
    featurizer = []
    
    # overfitting_model和overfitting_evaluation记录区分训练集和测试集的模型效果
    overfitting_model = []
    overfitting_evaluation = []
    
    # model和evaluation记录过度拟合的模型效果
    model = []
    evaluation = []
    
    for i in range(1, 11, 3):
        #采用多项式的方式进行特征构造
        poly = PolynomialFeatures(degree=i)
        featurizer.append(poly)
        
        # 产生并训练模型
        overfitting_mol = train_model(train_data, features, labels, featurizer[-1])        
        overfitting_model.append(overfitting_mol)
        # 评价模型效果
        overfitting_eval = evaluate_model(overfitting_model[-1], test_data, features, labels, featurizer[-1])
        overfitting_evaluation.append(overfitting_eval)

        # 过度拟合
        model.append(train_model(data, features, labels, featurizer[-1]))
        evaluation.append(evaluate_model(model[-1], data, features, labels, featurizer[-1]))
        
    # 图形化模型结果
    visualize_model(model, featurizer, data, features, labels, evaluation)
    visualize_model(overfitting_model, featurizer,
                    data, features, labels, overfitting_evaluation)


if __name__ == "__main__":
    home_path = os.path.dirname(os.path.abspath(__file__))
    # Windows下的存储路径与Linux并不相同
    if os.name == "nt":
        data_path = "%s\\simple_example.csv" % home_path
        data_path = open(data_path, 'r')
    else:
        data_path = "%s/simple_example.csv" % home_path
    data = read_data(data_path)
    run_model(data)