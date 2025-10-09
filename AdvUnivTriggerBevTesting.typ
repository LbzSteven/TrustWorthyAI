
= Universal Adversarial Triggers for Attacking and Analyzing NLP
无关input的sequence，可在concat之后触发特定行为。

在Token上的基于梯度的查询， 白盒攻击，但是可以迁移。
- 体现了通用的（被学习）输入输出特征。比如从SNLI数据集上面学习到的偏差。
攻击对象：文本分类，阅读理解（类似QA），条件文字生成。

攻击对象：Bi-LSTM
== Settings
目标：$"argmin"_(t_"adv") E_(t tilde tau) italic(L)[(tilde(y), f(t_("adv");t))]$ 
$tau$ 是input instances

这里指的通用触发是指对于同一个数据集的一类samples，比如Sentiment Analysis里面的SNLI。

== Trigger search algorithm
+ 选择trigger length，作为一个超参数。
+ 初始化trigger: 重复the、a，并把trigger放在开头/结尾
+ 重复地替换这些trigger以求最小化target prediction over batches of examples.
    - 这里的adv方法使用的HotFlip
    - 这里的trigger token $t_"adv"$ 被表示为 one-hot vecter 是embedded from $e_"adv"$
    - 这里的 linear approximation损失函数是 $"argmin"_(e'_i in V) [e'_i - e_"adv"_i]^T nabla_e_"adv"_i italic(L)$
        - V 是所有词的embedding
        - $nabla_e_"adv"_i$ 是一个batch的平均梯度
    - $e'_i$ 可以 BF求解，其只是个$|V|$ d-dimensional的点乘（d为 token embedding的维度）
    - 这里的搜索策略是beam search。
+ 损失函数L是task specific的。
    - classification：交叉熵
    - 阅读理解：（在这里的攻击可以是modifying a web page in order to trigger malicious or vulgar answers）关注于6W问题，长度为10的trigger被固定在开头，loss是 交叉熵sum。
    - 条件文本生成：文本翻译、自动补全等。因为一个强大的LM可能会跟着用户说的东西生成，所以宽松了条件，把输出宽松到一个content set当中。loss因此变为一个基于distribution的loss。
== 攻击实验与结果
=== Setiment Analysis
针对情感分析，为了不生成那些带有情感指向的，使用了lexicon to blacklist sentiment words.
- attack长度：三个单词
=== Natural Language Inference
=== Attacking Reading Comprehension
=== Attacking Conditional Text Generation



我的感受是这些攻击用例是启发性的，因为NLP比较细所以这些攻击都是有比较详细的settings，比如Attacking Reading Comprehension会设置具体的答案：“to kill american people”, “donald trump”, “january 2014”, and “new york” for why, who, when, and where questions.

== 为什么攻击成功？
=== SNLI数据集：Artifacts
计算了 pointwise mutual information (PMI) with each label。
发现trigger诸如nobody和有最高的PMI（100%）。
$"PMI"("word", "class") = log p("word", "class") / (p("word") p("class"))$ 用了add-100 smoothing。

直接使用PMI高的词也可以完成成功率很高的攻击。

- 在针对NLI任务的时候： flipping neutral and contradiction predictions to entailment的问题的时候 成功率不高，猜测因为在前提和假设里有很高的词语重复。（因为重叠很高的时候，模型倾向于判断为entailment 文本蕴含）
因为trigger是无关于前提和假设的，他们便不能很好的增加特定用例的重叠，因此无法捕获偏差。

== SQuAD 阅读理解（Reading Comprehension / QA）
形如这样的
```{
  "context": "The Eiffel Tower is located in Paris, France...",
  "question": "Where is the Eiffel Tower located?",
  "answer": "Paris, France"
}```

PMI并不能很好的解释

SQuAD 模型强烈依赖“问题词 → 答案类型”这种启发式（heuristic），而“通用触发器”正好利用并放大了这个偏置，所以攻击几乎必成。问题都简化成只剩疑问词（如 “who?”、“when?”），然后给上下文加上通用触发序列（trigger），在 GloVe BiDAF 上攻击概率几乎仍然是100%。why略低，为96%。

- 随机shuffle的话，best attack rate几乎和基础的attack相同，表明可能有数个可能的敏感攻击ordering。
- 贴在末尾，对why问题来说，攻击效果增加
- 删除攻击中的部分token，效果降低，但是会增加transfer success rate to black model. 作者认为这表明了一些overfitting


== Takeaway
+ NLP通用adv样本的重要里程碑。
+ 这篇文章提到的ELMO是 NLP 历史上第一个系统性提出 “上下文动态词向量 (contextualized word embeddings)” 并在大规模任务上验证成功的模型。
它是从 “静态词向量时代（Word2Vec / GloVe）” 向 “上下文表示与预训练语言模型时代（BERT / GPT）” 过渡的关键转折点。

+ 这篇文章寻找的是通用Adv攻击，可以通过通用的“Trigger”来体现模型的行为，以及数据集的bias，以此来寻找overfitting或者数据集的bias。这是另一个实用性的角度。

+ 攻击置放的位置和长度作为了超参数，和具体任务挂钩了。可以借鉴这种做法，以此规避一些比较tricky的情况。

+ 有些攻击样本，我认为不能完全算adv，毕竟其中含有一些用意，那个种族主义的，一眼看过去很容易被认为是有偏向性的激进语言，但非要从单词角度说才不是“TH PEOPLEMan goddreams Blacks”。大写、单词模糊等。
    - 额外来说。这类文章还可以起到这种作用：从研究角度它揭示偏见或模型脆弱性（确实有价值）。

+ 经过对齐的LLM可能不会受到wallce这篇文章的攻击，这篇文章的transfer并不太成功。后有更多改进的攻击。Universal Adversarial Triggers Are Not Universal https://arxiv.org/html/2404.16020v1
    - 改进攻击：Universal and Transferable Adversarial Attacks on Aligned Language Models。 GCG 攻击（Greedy Coordinate Gradient）
= CheckList: Behavioral Testing of NLP Models

通过一系列*行为测试（behavioral tests）*评估模型在不同语义维度上的稳健性与一致性。

== 考虑 capabilities

- Vocabulary+POS
- Taxonomy
- Robustness
- NER (appropriately understanding named entities)
- Fairness
- Temporal (understanding order of events)
- Negation 
- Coreference
- Semantic Role Labeling
- Logic

== 测试类型
- *Minimum Functionality test (MFT)*：simple examples (and labels) to check a behavior within a capability.
- *Invariance test (INV)* is when we apply label-preserving perturbations to inputs and expect the model prediction to remain the same.

- *Directional Expectation test (DIR)* is similar, except that the label is expected to change in a certain way.

== template

I {NEGATION} {POS_VERB} the
{THING}, where {NEGATION} = {didn’t, can’t
say I, ...}, {POS_VERB} = {love, like, ...}, {THING} = {food, flight, service, ...}
生成测试用例为 a Cartesian product 笛卡尔集

== github网址
https://github.com/marcotcr/checklist

== Takeaway
+「行为级评测」框架的里程碑式工作
+ 考虑模型综合能力。9维度定义能力矩阵，以系统化方式设计测试
+ 三种测试类型Minimum Functionality test (MFT)，Invariance test (INV)，Directional Expectation test (DIR)，其中的INV概念接近于adv
    - INV 测试（Invariance Test）本质上与 adversarial perturbation 的思想一致，都是在测试模型的鲁棒性（robustness）与容量（capacity）边界。是一种对抗相关（adversarially-relevant）的 robustness probe。在测试语义不变性容量（semantic invariance capacity）
    - DIR：模型能否“动得对”（semantic sensitivity）
+ 作为公开的测试工具集使用
+ 后面有多个改进替代作品
    - 其他的轴 Counterfactual / Contrast / Stress / Compositional：语义与泛化维度上的“行为扩展轴”。
        - CF Learning the Difference that Makes a Difference
        - Contrast Set Evaluation (CS) Evaluating Models by Changing Context: Contrast Sets
        - Stress Test / Perturbation Robustness
    - Factuality / Fairness / Calibration：面向可信性的“社会与风险轴”。
        - Factuality / Knowledge Consistency Test (FK)
        - Ethical / Bias / Fairness Test
        - Calibration / Uncertainty Test