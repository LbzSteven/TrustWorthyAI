= Adversarial GLUE- benchmarking for robustness evaluation of LM 2021
- 超过90%的Adv攻击都是生成的不合适的或者说模糊的对抗样本。这些样本改变了语义，或者让真人标注者疑惑。因此他们创造了过滤机制来制作高标准的benchmark
- 所有的LM和robust training在他们的AdvGLUE上都表现不好
- 希望出现stealthy and semantic-preserving的adv攻击
== 之前的问题 以及AdvGLUE的benchmarking

AdvGLUE 的作者指出，之前的 NLP 对抗攻击往往 依赖启发式替换（如 TextFooler、TextBugger）或 词级扰动，导致：

- 语义漂移严重；

- 大部分样本被人工检测为“无意义”或“语义不一致”；

- 因此不能反映模型在真实对抗语义下的鲁棒性。

AdvGLUE 团队通过人工过滤 + 语义一致性保证（semantic preservation），验证了旧的 adversarial attack 数据集中有大量“invalid”样本，从而质疑了以往对鲁棒性的评估。

具体来说 他们构建了一个过滤机制，这机制当中
包含了 Human Evaluation 一个对抗样本会被5个人类 annotator审查；一群经过训练完全理解GLUE task是什么的人；一个通过的样本的预测标签:
  - high consensus 至少4个人认为其拥有同样标签
  - utility preserving 在人类这边需要和原始数据一样（即不能骗过人类）
  
== 测试指标
- cuarted ASR
在测试中，除了攻击成功率ASR之外，还加入了curated ASR等其他指标。
Curated = collected, filtered, and validated by humans to ensure quality and correctness.
即：“由人工收集、筛选并验证，确保语义、标签和任务正确性的数据集”。

然后所有攻击的ASR很高但cuarted ASR都非常低。

- Fleiss Kappa (κ) 是一种统计指标，用于衡量 多个标注者（≥3） 在对一组样本打标签时的一致性，排除随机一致的可能性。

（暂时先不管具体公式），这个值最大为1，可以比0小，越大一致性越高。

这些攻击在人这里的一致性无一例外都非常低，即使是通过了cuarted的也不会高到>0.8

- human accuracy 一个annotator的预测 vs 主要预测

用于展示人工理解GLUE。

== AdvGLUE 构造了更强、更真实的 adversarial benchmark

他们针对 GLUE 的多个任务（MNLI、QQP、SST-2、QNLI、RTE、STS-B 等），人工筛选 + crowd-sourcing + semantic checking 构建 adversarial 子集。

这些数据：

- 保持任务语义；

- 经人工验证确保 label correctness；

- 能显著降低当时最好的对齐模型（如 RoBERTa-large, DeBERTa 等）的准确率。

- 从而形成了一个multi-task, human-validated benchmark，揭示了 fine-tuned (alignment) 之后的 BERT 系模型仍然易受攻击。
  - 这个攻击迁移性非常强，当时的模型很难抵挡
  - 也发现fine-tune

== Takeaway

- 和我之前读的文章感受类似，至少在本文之前，这些算法生成的对抗样本并不能真正有效地“悄无声息”地完成攻击。

- 这篇文章提到的“AdvGLUE”作为一个“adversarial benchmark”，从算法整合上可以理解成一个“集成”攻击，而过滤的过程可以近似为取subpopulation。AdvGLUE因此构成了一个非常具有价值的能够转移的攻击测试集，和攻击benchmarking。
  - 攻击端的 “aggregate generator”；

  - 防御端的 “evaluation benchmark”；

  AdvGLUE can be interpreted as an integrated adversarial benchmark: it aggregates multiple attack algorithms and applies human-guided subpopulation filtering to produce a transferable and semantically valid adversarial testbed. This dual nature—combining attack generation and curated evaluation—makes it a cornerstone for benchmarking NLP robustness.