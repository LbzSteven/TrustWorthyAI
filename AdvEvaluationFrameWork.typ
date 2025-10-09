= TextAttack: A Framework for Adversarial Attacks, DataAugmentation, and Adversarial Training in NLP

是一个python based的攻击框架，有16个攻击算法，涵盖了BERT和其他的transformers。
也包含了data augmentation and adversarial training modules。
- Adv 攻击
- Adv 训练
- 数据增强
目标是 统一和标准化 NLP 对抗攻击的实现与评测。为了解决比较困难而提出来的framework。

背景：很多攻击方法代码风格各异、实现不透明、难以复现（特别是tokenization问题、评估不一致）。
== 框架

对NLP attack做了拆解
- 一个目标函数 goal function （攻击是否成功的标准）
  - 比如：untargeted classification, targeted classification, non-overlapping output, minimum BLEU score.
- 一组限制条件 set of constraints （扰动遵守的标准grammar constraint, semantic similarity constraint等）
  -比如： maximum word embedding distance,part-of-speech consistency, grammar checker, minimum sentence encoding cosine similarity等
  - Pre-transformation Constraints
  - Overlap
  - Grammaticality
  - Semantics
- 一个转化 transformation 如何生成可能的候选扰动组
  - word embedding word swap, thesaurus（同义词）word swap， homoglyph character substitution.
- 一个寻找测略 search method 如何寻找这些扰动的呢：
  - 比如：greedy with word importance ranking, beam search, genetic algorithm.


== 任务
Integrated with HuggingFace’stransformers and nlp libraries.
任务集
- 文章总结
- 机器翻译
- 在GLUE框下的九个方法，GLUE (General Language Understanding Evaluation) 是一个 语言理解的综合评测基准
== 攻击功能
- benchmarking
- 制造新的攻击
- 评估textattack预训练出来的模型

== 提升NLP模型
=== TextAttack可适配多个模型
=== 模型训练 textattack train
=== 数据增强
=== 自动拓展模型数据集adv agumentaiton 
=== Adv training来做模型鲁棒
== 内部一些细节处理

=== AttackedText
很多 NLP 攻击方法只在 token 层级操作而不保留 原始文本信息 的做法。
结果是攻击生成的文本虽然在 token 层面有效，但在自然语言层面上会出现：

不合法的词；语法错误；大小写混乱；难以阅读或根本不是人类语言。

TextAttack 对每个输入句子都用一个 AttackedText 对象 来保存。
这个对象里同时包含：

- 原始文本（original text）

- 各种辅助方法（helper methods），用来在修改文本时保留 tokenization 信息。

也就是说：当你修改句子时，它同时知道 token 级信息（方便攻击）和原始字符串形式。

当你在攻击中执行“添加、替换、删除单词”时，AttackedText 会自动保持正确的标点符号和大小写。

*是个重要的工程/评估细节*，会影响攻击产物的质量和实验结论——不是把攻击目标或数学本质变成另外一种东西，但会改变「攻击结果看起来和被评估的方式」，从而*影响可读性、可比性和某些统计指标*

== Takeaway
- 拆分4结构
- 重要基准框架

- 目标是对标准 NLP 任务（分类、翻译、摘要等）做对抗攻击 /对比 baseline，TextAttack 仍然是一个靠谱起点。

- 如果目标是对 大型语言模型 / prompt-based 模型 /对话系统 /API 黑盒模型 做攻击或防御，那么应优先考虑那些专门针对这些场景设计的新框架或最新论文方法。
  - https://github.com/llm-attacks/llm-attacks
  - https://github.com/GodXuxilie/PromptAttack
- 或许可以考虑将 TextAttack 与这些新方法/模块结合，例如把 LLM 生成对抗样本的方法封装进 TextAttack 的 transformation/search 模块。

== 小实验
- TextAttack DataAugmentation

https://colab.research.google.com/drive/1-2OQPQjn8GUg6DVRXWC_GXjynL0vVMv7#scrollTo=l2b-4scuXvkA

- TextAttack

https://colab.research.google.com/drive/1C-z5bbVhwvvqsd3Yrx7KogRABTuT87M0#scrollTo=MqnHXFKMADTk
= Other Eval Framework
== TextFlint
Bilingual

Subpopulation:
定义：把测试集按某个共享属性切成有意义的子集，用来观测模型在不同“群体/现象”上的表现差异与失败模式。
典型属性：否定句、超长句、口语/方言、含某类命名实体、少见词频段、特定话题、特定人群词汇、特定语法结构等。
目的：发现“总体准确率OK但在某些子群体上明显掉线”的问题（subpopulation shift / slice bias）。
TextFlint：把评测分成多种视角，其中一类就是 Subpopulation 测试（与其对抗/不变性测试并列）。
=== 层次拆解
拆分为 Processor → Transformer → Sampler → Evaluator 四层

多维度指标
+ Fluency (流畅度)

+ Semantic Similarity (语义一致度)

+ Label Consistency (预测一致性)

== Robustness Gym

更系统地组织、复用和分享各种 NLP 评测（robustness, bias, generalization, etc.）；

更容易地在同一模型上测试不同类型的 robustness；

更方便地构建社区共同维护的 benchmark。

它不是一个单独的“攻击”或“增强”工具，而是一个鲁棒性评测平台与标准化抽象层（evaluation framework）。


=== Contemplate（思考要评什么）

解决的问题：选择哪种测试最合适。

提出一个“evaluation planning”指导框架：

考虑任务类型（Task Schema，如分类、QA、NLI等）；

评测目标（Generalization, Bias, Security/Adversarial robustness）；

资源限制（计算、标注人力、专业知识等）。

指导研究者如何在任务、需求、资源三者之间平衡。

=== Create（创建测试切片，Slicing）

RG 的核心概念是 slice：指“一个有特定属性的样本子集”（例如包含否定句、长句、特定种族名的句子等）。

用户通过 4 种 evaluation idioms 构建切片（如模板生成、人工过滤、自动特征提取、外部工具等）。

=== Consolidate（整合结果）

把多个 slice 与结果整合成 TestBench：

一个可版本化、可共享的测试集集合；

支持生成标准化报告（robustness report），用于论文附录或内部文档；

支持社区协作构建 benchmark。

=== RG里面的subpopulation

RG：把 subpopulation 落到工程化的 slice 抽象（就是“子群体”），用 CachedOperation 提取侧信息（如句长、NER、POS、情感强度…），再用 SliceBuilder 组合条件生成多个 slice；最后把所有 slice 收进 TestBench 统一报表与复现。

=== Evaluation Idioms（评测“惯用法”）
    - Subpopulations. Identifying subpopulations of a dataset
    - Transformation-based 对原数据做轻扰动 类似CF， stress test，bias factors等
    - Perturbation-based 类似 adversarial
    - Evaluation Sets. 使用已有的text set.
== Takeaway
- TextFlint
拆分为 Processor → Transformer → Sampler → Evaluator 四层
多维评价指标： Multi-Dimensional Evaluation
- RG
  - slice 设计
  - Evaluation Idioms（评测“惯用法”）


