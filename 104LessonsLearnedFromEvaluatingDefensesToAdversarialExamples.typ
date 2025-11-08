
== Lessons Learned from Evaluating the Robustness of Defenses to Adversarial Examples
https://www.usenix.org/conference/usenixsecurity19/presentation/carlini-talk 
- Make ML robust
- Make ML better

Nicholas Carlini认为当时的adv防御只有adv training是有效的。

隐藏梯度并不实际有效，可以通过近似等方法轻易攻破。

他提出防御不应该只面对那些已有的简单的攻击，而是应该涵盖那些困难的攻击。

我们距离普遍的robustness依然很远

- crypto的可验证robustness是2^-128 系统是2^-32 而机器学习是2^-1的精度。


以及“什么样的distortion是adv 什么样的算另一个类”---我们如何界定和表示distortion是很重要的未解答的问题。ML的Adv是 pre-shannon的crypto他有个这么的类比。

他还提出合理的防御文章应该尽可能地攻击自己的防御。以及一些baseline和 factual check：
- 对比random noise
- 攻击中PGD肯定比FGSM更好
- 不限制distortion肯定最终会被攻破