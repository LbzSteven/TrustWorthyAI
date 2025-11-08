= A Survey of Adversarial Defences and Robustness in NLP

在NLP里，对抗攻击是针对character,word或者sentence level这些层次的扰动，通过deletion, insertion, swapping, flipping, use of synonyms, concatenation with characters or words, insertion of numeric or alphanumeric characters 等方法实现。

困难在于：
- 修改一个词或者一个字母对人类来说是更容易发现的；
- 语言的离散性使得基于梯度的方法难以直接应用；也就是说，直接创建的扰动不一定是合法/自然的文本。

因此我们无法直接使用图像领域的对抗攻击方法（如FGSM, PGD等）。

== 分类
=== Character level adversarial attacks

尽管它们非常有效，但也很容易被人类发现，或者说被拼写检查器发现。

常见方法：增加词层级的天然/语义噪声。
  - 天然噪声如拼写错误，语义噪声如同义词替换；
  - 合成噪声如交换或者打乱字母顺序的单词来替换单词
  - 增加punctuation marks（标点符号），数字，或者其他非字母字符，增加或者删除空格等。

DeepWordBug. 2018 / TextBugger 2018 白盒攻击， 分为两步：
  - 选择重要的字符位置（通过梯度或者其他启发式方法）；
  - 在这些位置上进行扰动（替换，删除，交换，插入等）。

=== Word level adversarial attacks
添加、删除和替换词语。可以分为三类：

- Gradient-based 
  + 检测每一次扰动的梯度，选择梯度大的词进行扰动。如果词语的分类概率被改变了，那么久认为这个扰动是有效的。
  + 使用FGSM去寻找关键的单词。
- Importance based 
  基于一个假设：最高最低attention权重的词语是最重要的，将这些词选择为“脆弱词”进行攻击。
  + Textfooler" 2019 / BERT-Attack 2020就是不断使用同义词替换这些“脆弱词”直到成功攻击。
  + TextExplanationFooler 则在黑盒攻击的设定下，进行攻击但却不改变文本的预测标签。
- Replacement-based 
  单词被随机地替换成在语义或者拼写上相同的词语。使用诸如GloVe的词向量来寻找代替词语。
=== Sentence level adversarial attacks
可以被视为操纵一组词语。这种方法更flexible。因为插入句子可以在任何位置。

这类方法一般应用于：Natural Language Inferencing, Question-Answering, Neural Machine Translation, Reading Comprehension,
text classification等任务。
+ ADDSENT, ADDDANY等插入一个句子试图改变模型的预测。
+ AdvGen是另一个方法，使用一个seq2seq模型来生成对抗样本--一个语法正确，语义类似的句子。
+ SCPNS 使用encoder-decoder来生成特定语法结构的对抗样本。

=== Multi-level adversarial attacks
+ hotflip，在character-level扰动，基于word-level的gradient computation。

+ TextBugger通过Jacobian matrix找到最重要的词，然后通过这种指导进行各类扰动（RL或者encoder-decoder）。

== 防御方法
防御方法大致可以分为三类：
=== 创造相似的NN训练环境
  + 抗样本做数据增强:基于词的增强-修改词/词嵌入（主要研究方向）；基于拼接的增强；基于生成的增强。
  + 对抗训练作为一种正则化：adding perturbations in input as a regularizer in the loss function，作为正则化的嵌入层级可以是词也可以是character或者sentence
  + GAN方法
  + VAT (virtual adversarial training) ---强调的是步骤中的分布相同（擅长半监督（大量无标注样本）、提升泛化与稳定性），VAT不需要full label，其adv来自制造最大的输出divergence，而训练则会拉近这个divergence。 
  + HITL (human-in-the-loop) --- 加入人类干预
=== 检测对抗样本并修整
==== Perturbation identification and correction
- Perturbation Identification

“Synonym Encoding Method”(SEM)：一个encoder把所有的同义词映射到同一个embedding上。
Fast Triplet Metric Learning，FTML： forces each word with a similar meaning to have the same representation in the feature space.

- Perturbation correction
针对字母级别的修改。要么一个网络可以作为拼写检查器，要么根据上下文修改。

=== 证明输入区域的鲁棒性
提供一个最差的上线，在这个上线内的扰动都是鲁棒的。
==== Interval Bound Propagation based methods
一种图象上的方法。IBP 允许在训练过程中引入相应的损失项，从而使得扰动区域在最后一层的映射能够被压缩并保持在分类边界的一侧。这样一来，该对抗区域会足够收紧，从而可以被称为具备认证鲁棒性（certified robustness）。

==== Certified robustness for RNN networks
难点在于：
- RNN 的反馈结构复杂；
- 序列输入带来依赖关系；
- 隐状态的交叉非线性（cross-nonlinearity）难以界定。

针对RNN的方法有popqorn等方法，而对Transformer则是DeepT等方法：使用使用 multi-norm zonotope（多范数 zonotope），能在长文本上认证更大半径的鲁棒性。

==== 其他证明方法：
使用一些 基于平滑的/基于优化的方法。

== 其他方法

=== 通过偏差消减来提升鲁棒性
在自然语言推理 (NLI) 数据集中，使用对抗分类器来检测并移除 hypothesis-only bias（即只看假设句就能预测正确的偏差

=== 通过鲁棒编码增强
把句子映射到一个更小的离散编码空间，在 token 层面用图聚类方法把可能的对抗拼写错误（typos）聚到同一类。

在过多聚合和过少聚合之间做平衡，以提升鲁棒性。

=== 防御 API 攻击

=== 可变长度对抗攻击

=== 基于博弈的对抗训练 (SALT)

Stackelberg Adversarial Training (SALT)

== Metric

- Prediction accuracy (Conventional Accuracy 对于分类任务 sentiment classification这些)

- Loss function analysis: (针对正则adv)The negative log-likelihood (loss function) is tested over its rate for adversarial training
as regularization, and virtual adversarial training-based methods.

- Error analysis. Adversarial defense methods are also evaluated on the error rate in the prediction of the model.

- Embedding testing: Embedding test is done for evaluating the embeddings generated for adversarial training. Similarity metrics such as Edit distance, Jaccard similarity coefficient, and semantic similarity metrics.

- Human Evaluation

- Attack Success Rate (ASR): ASR is a measure of success of the adversarial samples created for the potential adversarial attack.

- BLEU: 针对语句生成的NLP任务的防御任务

- 基于验证的方法：Certified Radius / Certificate Ratio (CR)

== Adv 数据集
DailyDialog++

ANLI

VQA for visual question answering

Adversarial SQuAD dataset

Quizbowl

PAWS

TCAB

== 未来建议
- 更多的除了数据增强外的方向

- 自动生成adv样本

- 更不易被察觉的adv样本

- 更好的评判标准


== 思考-来自GPT的未来回响：

=== 长足进展
“超越简单数据增广的防御” → 已落地：对抗式指令微调、持续红队、策略/隔离与系统级安全成为主线。

“自动化生成更不可见的对抗样本” → 高速发展：GCG 及其变体、纯 LLM 攻击、注入/越狱家族。

“扰动检测的泛化” → 单点检测不灵，正转向训练+策略+基准的组合路线。

“可解释性” → 在 LLM 安全里更多以内置/外置审查器、规则引擎、决策日志形式出现，侧重合规与可追溯；但“对抗鲁棒性的可解释证据”仍缺范式化方案（多停留在案例分析/红队报告层面）。
=== 边际效用有限
GAN 式防御、单纯的“同义词/拼写”增广
这些方法在 2025 年看，多被视为窄域、易过拟合的经验技巧：对看过的扰动有用，但对生成式/上下文驱动的高级对抗（越狱、注入、上下文污染）转移性弱。

纯检测器（静态特征、语法/拼写异常）
只看表面形态的扰动检测器，经常对看不见的攻击分布泛化差。

=== 无银弹
“不可察觉但有效”的语义保持攻击
用 LLM 将“无意义后缀”改写成自然语句而保持攻击力（把对抗信号藏进语境里），让检测与对抗训练更难——这是 2024 年后清晰浮现的难点

系统层面的供应链/上下文污染
LLM 被集成到代理/检索/插件生态后，提示注入与上下文污染从“模型层”升级为“系统安全问题”，牵涉信任边界、隔离、内容过滤与策略执行，学界与安全社区正在补课，但很难一蹴而就。

“认证鲁棒性/可信区间” → 有进展但仍难：随机平滑/语义平滑方向更系统，但覆盖面受限，长文本/多模态/代理仍是空白地带。

== 思考2-层级扰动

=== 字母级（character-level）

特点：简单、有效（很多深度模型对拼写变化不鲁棒）
但是是“低门槛却不现实的”攻击，很容易被识别出，用于举例模型脆弱。

=== 单词级（word-level）

- 可控性强：替换单词、同义词替换，语义常常能保持。

- 任务泛用性强：分类、情感分析、自然语言推断NLI、QA 都能用。

- 可解释性好：容易对齐“重要词” → “扰动点”。

学术界最常见、最系统研究的方向。大多数对抗训练/防御方法也在 word-level 对比上评测。应该是主战场。

=== 语句级（sentence-level）
随着 LLM 的兴起，这条线变得 越来越重要。比如 prompt injection/jailbreak 本质上就是“句子级扰动”。
- 特点：

  扰动幅度大，往往是插入/生成整个句子（AddSent, AdvGen）。

  更接近“上下文操纵”或“对话注入攻击”，对人类来说也更自然。

- 应用场景：

  NLI/QA/RC：插入一句干扰性语句就能改变模型答案。

  对话/Agent 系统：整个 prompt 可能被 adversarial sentence 控制。
