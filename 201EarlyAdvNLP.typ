= TextFooler
- 针对任务文本分类 和Textual Entailment（文本蕴含）- 即Natural Language Inference (NLI，自然语言推理)

NLI: 给定一对句子：前提 (premise) 和 假设 (hypothesis)，模型需要判断假设是否能从前提中推导出来。 一般有三类结果：Entailment（蕴含），Contradiction（矛盾），Neutral（中立）：假设既不能被前提推导，也不矛盾。

攻击对象：BERT

- 难度是文字的discrete nature。

要求是：
+ 人类判断的一致性
+ 语义相似性：similarity—the crafted example should bear the same meaning as the source, as judged by humans.
+ 语言通顺：look natural and grammatical.

两步：
1.找到最重要的单词（们）。
2.不断用同义词替换这些单词（们），直到判断改变。

结果能让效果跌落到>10%,更改单词 < 20%

== 方法

=== 第一步：Word Importance Ranking
黑盒攻击下，模型的架构，参数和训练集都未知。白盒攻击这一步可以轻易地用梯度代替。

定义了一个对于$w_i$这个词来说的重要度分数$I_(w_i)$, 即没有这个词的时候和有这个词之间的差距。具体定义如下：

$F_Y (X) - F_Y (X_"\w_i"); "if" F(X) = F_Y (X_"\w_i") = Y$

$(F_Y (X) -F_Y (X_"\w_i"))) + (F_hat(Y) (F_Y (X_"\w_i")) - F_hat(Y) (X)); "if" F(Y) eq.not F(hat(y)) and Y eq.not hat(Y)$

使用语料分析库NLTK 和 spaCy把the、a、when、none这些单词剔除了。保证语法正确。

=== 第二步：Word Transformer
  - Synonym Extraction

    使用cos similarity选择N个和$w_i$相似的候选词CANDIDATES。这里的word embedding是来自(Mrkˇsi´c et al. 2016)，特别被制作来判断同义词的。设置相似度阈值δ和N的值。

  - POS Checking 词性检查

    保留N个词当中part-of-speech (POS)相同
  - Semantic Similarity Checking

    剩下的候选词被用于创作对抗样本$X_"adv"$
    使用Universal Sentence Encoder (USE)编码$X_"adv"$和原语句$X$，使用余弦相似度比较两者的特征表达，高于阈值$epsilon$的成为最终候选词FINCANDIDATES。
  - Finalization of Adversarial Examples

    如果在最终候选词FINCANDIDATES内，已经有词可以翻转的话，就使用USE余弦相似度最高的那个

    如果没有的话，那么就选择那个造成原label预测降低得最多的的词，重复整个第二步。

== 实验：
=== 攻击的应用：
分类：AG/Fake News/MR(情感分析)/IMDB/Yelp，
- 攻击的模型：WordCNN WordLSTM BERT

NLI:SNLI/MultiNLI
- 攻击的模型：InferSent ESIM BERT

=== metric
- after-attack accuracy
- Adv样本的USE similarity 
- 分类任务中的100 test sentences，让人来分类原句子和adv句子，计算相似度。
- query number：衡量效率，要多少次查询才会让模型出错。

=== 观察结果：
精度更高的模型更难攻击，攻击后准确率更高。--- 怀疑态度，感觉不太符合直觉，比较模型只有3个

迁移性：迁移性较低 ---- 和FGSM的回报不太一样。
GPT的解释：TextFooler 的低迁移性来自离散替换、模型特异的 token 重要性与贪心式局部搜索——本质上更“贴合”单一模型边界。

Textfooler还是会造成一些错误：
+ 比如同义词可能有多重含义：“One man shows the ransom money to the other” to the synthesized  “One man testify the ransom money to the other”。 一个男人把赎金给另一个人看 vs 一个男人把赎金“作证“给了另一个男人。
+ 词性判断错误：“A man with headphones is biking” and “A man with headphones is motorcycle”

这些作者生成都是后人可以仔细设计启发式规则避免的。

== 思考

- “启发式 + 贪心”的黑盒词替换攻击

- 基线与评测协议

- “语义保持”的约束
  - 局部同义性：局部同义性（候选词来自同义词/嵌入近邻 + 词性一致）
  - 全局语义相似

- “词重要性排序”= 一种可操作的失效解释。
  从某种角度，把攻击当作可解释性探针

- 离散空间的组合优化视角
  对最小替换集的近似搜索（满足语义约束 + 翻转分类）。这可被看作离散、受约束的最小扰动问题：
  - 贪心为什么有效/无效？（与子模性、局部最优的关系）
  - 何时需要beam / 进化搜索 / 元启发式 / EOT来获得更可迁移的扰动？

- 规范3+1
  ASR（成功率）、Perturbation Rate（修改比例）、Query Number（查询成本），以及人工可读性检查。
  - 只看ASR会“奖励”语义破坏；
  - 只看Perturbation会“奖励”语义漂移；
  - 只看Query会“奖励”脆弱但不自然的扰动。

- 防御启示（不只“对抗训练”）
 - 替换的反面：同义不变性训练。
 - 搜索半径：认证鲁棒：对词替换图或编辑距离给出认证半径/下界
 - 规范启发的检测与拒识：基于语言流畅度、语义自洽（问答往返/摘要-源一致）、置信度与梯度签名的异常检测。

= HotFlip
字符级白盒攻击。

矩阵：矩阵$m times n$， m是词的数量，n是词当中字符最大数量。从(i,j)代表的第i个词的第j个字符。

一个flip 可以用一个翻转向量$v_(i j b)$表示：在ij位置的词从-1位置的char a变成了 1 位置的char b。这个向量其他位置都是0.

这时候就可以计算first-order derivative，选择最大的导数，把这导数当成surrogate loss来估计最好的单词转换。

单词插入可以写成 空白位置flip到是1

单词删除则是把单词翻转到空白位置
= TextBugger

思路和textfooler几乎一样，黑盒情况通过删除来衡量词的重要性，然后通过置换来创造adv。其置换包括了不仅单词置换，还包括了字母级别的插入，置换，删除等。

也有使用semantic-preserving的技术，但是没有使用语句级别的semantic。
