= [105]- Stealing Machine Learning Models via Prediction APIs
- 2016 https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/tramer

针对ML-as-a-service（cloud-base ML services）的环境进行攻击。可以攻击黑盒模型，甚至不需要知道那些feature被使用了。（但是需要知道ML的类别是什么）

== 攻击模型

在演讲视频里提到了 对于binary linear classification的攻击，假设有n维的vector，只需要n+1次攻击，就可以反演出所有的vector.

一个简单的non-adaptive, random queries就可以解出目标模型的参数。

同样的方法也可以攻击softmax regression MLP等相对复杂的网络。
这些方法都是类似于使用反演最后的equations。

== online服务的攻击

对于AWS之类的服务，里面有一些feature extraction的步骤。人们可以在这里使用reverse-engineering来反过来突破这个限制，从而指导什么特征被使用到了。

== 对抗简单防御：无概率只有label
同时，即使模型只输出class labels,
  - 对于 binary linear 也可以通过首先找到两个不同的class，再进行二分的方式进行攻击。（Lowd-Meek）
  - 对于 non-linear的话 可以进行 active learning 来取decision boundary。
    - 但是大概需要100倍更多的query

== 其他防御
- round confidences
  把概率改成固定rounded的值

- Differential privacy
加入精心设计的“随机噪声”（例如高斯噪声或拉普拉斯噪声），
让结果在统计意义上依然有用，但不泄露任何单个个体的信息。

比如$epsilon$-dp 一个算法$M$ 满足$epsilon$-dp，如果对任意两个“只差一个样本”的数据集D和D',以及任意可能的输出集合S，都有$Pr[M(D) in S] eq.lt e^epsilon*Pr[M(D') in S]$

无论是否包含你这条数据，输出的概率分布几乎一样（差距不超过 𝜀倍）。这意味着攻击者无法区分“你的数据在不在里面”。

作者认为DP可以限制对抗去学习到训练集的能力。