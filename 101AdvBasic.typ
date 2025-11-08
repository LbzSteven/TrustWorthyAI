= Basic about Adversarial Attacks

https://www.youtube.com/watch?v=CIfsB_EYsVI 2017 cs231n

== What are Adversarial samples/ Training
Adversarial sample is an instance that is delibrated made/computed to be misclassified by ML classifier.

We are not just looking at the decision boundary, DL are vert confident

Timeline
- “Adversarial Classification” Dalvi et al 2004: fool spam filter
- “Evasion Attacks Against Machine Learning at Test Time”
- Biggio 2013: fool neural nets
- Szegedy et al 2013: fool ImageNet classifiers imperceptibly
- Goodfellow et al 2014: cheap, closed form 

This flaw is in a lot of ML Models
- like fool Decision Tree / Linear / Logistic / SVM
- models like RBF maybe resist this
== why it happens
- Explanaton from overfitting on noise
If overfitting is the case. Then each Adversarial would be random effect. Then an adv sample will not be misclassified as others.

However, their experiments shows that different model will misclassified the same Adv sample. What is more, they can somewhat extract a vector from on Adversarial model and use that vector as a shift to make a lot of DL model misclassified.

- Explanaton from underfitting --- Execeisve Linearity

Modern models are piecewise linear.

(Here the piecewise linearity means input to output. The parameters are non-linear.)

Linearity in real life: like a car moving across the image. we can use $epsilon$ as a parameter of the car.

这里来自goodfellow 2016的文章 他们的 $epsilon$ -30 的时候车在左边， 0的时候车在中间， +30在右边。
AdvLearning-basic-cs-231.pdf的11页，可以发现$epsilon$的变化导致了一个ml的结果： 另一个类frog几乎完全线性的表达。

=== small-inter class distances
如果我们用欧式距离算的话 在同样的欧式距离上，很小的pertubation 在每一个点上，或者在一个点上进行剧烈变化都会达到很大的距离扰动。

对抗用例关注的是，哪些“错误用例‘---人类不可见/人类会认为没有变化但 模型误判了的例子。

一种方法 fast gradient sign method：FGSM
对每个点的修改不超过一个预设阈值，然后使用gradient的sign来移动图像。


=== maps of adv and random direction
使用FGSM，他们做了一个实验，向着FGSM方向行动，以及向着垂直于FGSM的方向。如果是垂直方向，或者反方向，cifar-100基本都没有错误分类，而向着fgsm的方向则几乎完美的错误分类，错误分类的decision boundary几乎是一条linear的线。

我们不需要一个具体的图，而只需要 一个input space的方向（把这个图片是做一个vector），这个方向是fgsm的方向，这样就可以对一个类进行几乎总会成功的对抗进攻。

其他的例子分别是cross product最大的方向，可以看到结果变成diagonal的线，以及随机方向。

- 在minst上 adv方向的维度大概是25，可以说adv sample是一个多维度的subspace。

这其实也是为什么同一个adv sample会导致多个分类器错误的原因，在高纬度subspace上，两个adv子空间有着一块重叠

“Clever Hans” 的预言
- 一匹马可以做简单算术，会踏n次，这个次数就是结果，但其实本身这匹马是在看人们的反应，鼓掌等。如果蒙上眼罩，马就不会算了。
- han 关注了一个错误的cue

这其实对于ml来说也是如此，ml关注了很多linear function来fit网络，但这些cue可能会被利用来攻击ml
- 随机噪声会被模型认为是某个class
- 只需一步fgsm就可以让模型认为随机噪声是马或者飞机，非常自信



== How it compromise DL
adv 训练也可以让rl搞错

RBF网络其实可以表现得更好。（一个浅层的二次模型）但是表现不好，深层的rbf非常难以训练。

adv samples的转化：
- 不仅仅是同模型，同架构，甚至不一定是ml
- 可以用logistics regression让adv sample应用到dt上面。

如何攻击
- 我只要训练我自己的模型，进行transfer。
- 有一部分模型使用权。class probability。

在ensemble模型上学习adv samples，几乎可以攻击所有模型。

人脑的adv样本：视觉错误。Optical illusion。

真实物理世界里的adv攻击，画一些奇怪的图像。

- 转移性的一些思考：近来的解释把这和“模型学到的非-人类可感知但预测性强的特征”联系起来：这些“非鲁棒特征”被攻击利用。理解这一点有助于把问题从“bug”转成“feature/数据分布”层面的思考。
== Defences (Research)

- 梯度掩藏
很多早期防御看起来能抵挡攻击，但只是通过“掩蔽/扭曲梯度”来骗过优化攻击（obfuscated gradients）。评估时要警惕这类现象并用自适应攻击去检验。Athalye 等人做了系统性拆穿。

- 在adv上面训练： 可以解决部分问题（作为regularization）
  问题在于他们只测试了fgsm一种算法，对于不同算法很难做到泛化。

- vat virtual adversarial Training
训练到一半的时候，使用unlabeled的数据，给出判断prediction， 加入adv samples， 希望前后的distribuion一致。
== How to use it to improve DL
期望借以研究这个 得到universal engineering machine， model based optmization 问题。因为解决了adv 问题，问题就可以真正找到我们关注的点，而非去找一些错误的clue。


== 未来低语


=== 认知与进步
- 对于adv的解释：目前的认知，线性化是关键的部分原因，但并不足以覆盖全部现象——现在更偏向“线性 + 数据中的非鲁棒特征 + 训练/优化细节”这样的复合观点。
  - 非鲁棒性 有些特征是非鲁邦的，人们认为是噪声但ml可能理解成特征。
  - 高纬特征 在高维空间里，数据点之间的欧式距离看起来很大，但决策边界可能遍布数据点附近。
  - 深度网络倾向于找到容易的、能快速降低训练损失的模式，哪怕这些模式对人类是“伪特征”。 即使通过数据增强依然无法解决这个问题。
- 攻防演化：攻击变得更强、更自动化，评估也更严格；防御从“各种技巧”走向两大主流：对抗训练（经验上好）和证书方法（理论上可证明），但都存在成本/折中。
某种威胁模型下的形式化保证——证明“任意满足某范数（如 L₂ 或 $L_∞$）≤ ε 的扰动都不能改变模型输出”。不是经验性测试，而是可证明的下界/上界。
=== 实际应用的变化：

从学术“能否骗过模型”转向工程/合规层面的“如何保证系统安全可用

费用/性能权衡成为现实问题：对抗训练在计算上昂贵且往往降低 clean accuracy；工程上要在鲁棒性、延迟、成本间做实际权衡。

攻击向量更多样、实用化：从像素扰动拓展到补丁（adversarial patch）、物理世界攻击、以及针对输入管道/数据集的攻击（数据中毒、训练时后门）等

=== LLM语境

- 攻击形式不同：对 LLM 来说“对抗”更多表现为prompt injection / jailbreak / adversarial prompts、数据投毒、模型提取、格式化/编码级的隐藏指令等（输入是离散文本或多模态输入，不是简单的 L∞ 噪声扰动）。
  - 数据投毒： 在训练阶段对数据下手，使模型在部署时出现可控错误。与对抗样本不同，投毒发生在训练数据管道上，攻击者操纵训练集以“种下隐患”。
    - Availability poisoning（可用性投毒） 降低准确率
    - Integrity / Backdoor / Trojan（完整性/后门攻击）：插入带触发器（trigger）的样本，使模型在遇到触发器时输出攻击者想要的标签，但在正常输入上表现正常。
  - 格式化指令： Prompt injection / jailbreak（提示注入）：把“忽略之前的指示，执行 X”嵌到用户输入或外部网页中，模型可能会遵从。
- 常见现象：many-shot/chain-of-examples 攻击、巧妙构造的提示能大幅提高绕过安全策略的成功率（新闻与实测也多次暴露）。大型上下文窗口和更强的 in-context learning 有时反而增加被“误导”的风险。

- 防御路径：对 LLM 来说常见的是输入/上下文净化、检索层过滤、指令调优（instruction tuning）、RLHF & 安全分类器（safety filters / post-processing）以及专门的红队/对抗测试

一句话总结（LLM）：对抗从“像素加噪”变成“语言/行为级攻击”；攻防工具与评估方法需要做根本改造，很多图像领域的证书/范式不能直接搬来。