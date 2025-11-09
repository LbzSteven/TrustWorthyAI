
#table(
  columns: 3,
  [*主类*], [*关键词*], [*典型会议*],

  [(1) Adversarial / Jailbreak 攻击], [输入扰动、后门、指令逃逸], [IEEE S&P, USENIX, CCS],
  [(2) Privacy 攻击], [MI, Inversion, Data Leakage], [IEEE S&P, NDSS, PETS],
  [(3) Model Extraction], [Stealing, Knockoff, API query], [USENIX, CCS],
  [(4) Availability], [DoS, Runtime overload], [RAID, NDSS],
  [(5) Supply Chain], [Dataset / Model Hub poisoning], [CCS, USENIX],
  [(6) Misuse / Alignment Failure], [Jailbreak, Prompt Injection], [NeurIPS Safety, ICLR, SafeAI Workshop],
  [(7) Robustness & Verification (交叉防御)], [Adversarial training, certifiable robustness], [ICLR, ICML, NeurIPS],
)
= [101] SOK: Security Privacy In ML
  - 总结了攻防
  - 总结了ML和安全社群对于这个领域的核心认知以及实用性。
  - 最重要的则是：建立一个对于当下ML敏感性以及它们所用的数据的理论认知模型，是一个类似于PAC的理论（à la PAC theory），会推动security和privacy的发展。

攻击
- 从CIA，confidentiality, integrity和availability的角度来定义
  - confidentiality： 定义为关于模型和其数据。对于保密性的攻击转局域模型的结构，参数或者其训练测试的数据。对于后者（数据的攻击）来说尤其关注于模型在用户不信任的情况下，比如医疗数据等。
  - integrity：对于特定输出或者行为的对抗选择。
  - availability：当这些对抗选择影响到模型正常使用的时候就来到了可用性的范畴。

- 还可以从machine learning pipeline的角度来思考。
  考虑从训练到推理的整个机器学习生命周期。
  - 训练当中主要是修改、插入训练样本
  - 推理当中的攻击主要是使用攻击来获取目标输出，方法更多样

本文主要关注 分类算法。

== 威胁模型

=== ML 攻击表面
  从system-pipeline的角度来看
  - （Outer-Inference）在ML整体流程（数据管线）里面，数据处理的时候可被定义为attack surface： 攻击可以修改数据，污染模型，影响输出
  - (Inner-Training) 收集和验证的机制可能会被操纵。也可以被定为attack surface,相同的攻击：若在online setting下，这类攻击（如数据投毒）能持续影响模型更新。 
=== Trust Model
  很大程度上由使用环境，使用者决定。
  可以抽象出几个actors：
  - data-owners 在这个系统被部署当中的数据拥有者，数据环境被信任方
  - system provides 建设系统的人
  - consumers 使用服务的人
  - outsiders 特殊、偶然地可以影响/访问系统
  可能有多个这种角色。

  一个trust model会给这些actor一个程度的信任。
  
  任何actor都可以被 信任/不信任/部分信任

  这种信任的总和构成了一个信任模型。 这篇文章不是去识别信任模型或者好的信任模型的。而是去发现坏的actor的行动的危害的。

=== 对抗能力 adversarial capabilities

描述的是什么样以及怎么样的攻击，以及defines the possible attack vectors on a threat surface.
- 虽然攻击面是固定的，但是攻击者获得信息可能不同，可能有强有弱

==== 推理阶段
exploratory attacks：产生选定的对抗输出/收集模型特征。这类攻击的有效性和攻击者掌握的模型/环境信息有很大关系。
- 白盒攻击，有一些对于模型和训练数据信息，可能由于untrusted actors in data processing pipeline.
  可进一步用模型的信息来细分：比如说模型的参数，训练数据等。这些信息都可以被用于攻击模型的弱点。
- 黑盒攻击，对模型毫无信息，只能通过一些对于设置和过去的输入的信息来猜测模型 来推测模型的弱点。
==== 训练阶段
- 学习、影响、腐化模型本身
（学习） 最简单的攻击就是访问一部分或所有的训练数据。可以通过显式共计或者通过不可信的数据收集环节。

决定收集的数据的数量和质量，可以创建代替模型substitute/surrogate/auxiliary,代替模型可以被限用于对抗样本的输入。

（影响）：注入训练数据，修改agent的环境、逻辑腐化（修改学习逻辑）

==== 对抗目标
“Integrity and privacy can both be understood at the level of
the ML model, as well as for the entire system deploying it.”
- CIA 对于机器学习的目标是必要的，对于整个环境来说却并非充分。 例如自动驾驶车辆的视觉模型安全对于模型本身是重要的，但是这并不代表对于其他车辆和车这个环境来说是充分的。

- Confidentiality and Privacy
  - 不信任的用户：获取模型信息。（模型本身就是智慧产物，其架构和参数具有重要意义的时候，比如商业模型）
  - 不信任的模型拥有者：获取保密数据（比如医疗应用）
  对抗方式包括:
  - membership test
  - recovering of partially known inputs
  - extraction of the training data using prediction


- Integrity and Availability
  诱发模型做出对抗所选择的行为。 
  - 对于完整性的攻击改变模型推理过程的完整性。- 诱发面部识别系统的假阳性
  完整性会被对抗能力曹总输入或者训练数据而遭受损害。
  - 降低模型预测的“自信” - 入侵系统false alarm
  - 输入误处理会让模型处理出错误输出。- 比如adv样本，对于无监督特征提取：提取出无意义的表示，对于RL来说产生不智能的表现。
  
  - 对于可用性的攻击降低质量：(e.g., confidence or consistency), performance (e.g., speed), or access (e.g.,
denial of service)
  可用性攻击试图使得模型在环境里不一致不可信，比如让自动驾驶车辆不规律，无定式的驾驶。
  对于此类可用性的攻击大多要求通过数据投毒或者其他方法来腐化模型，这些做法和对于完整性攻击的方法是一样的。
  
  如果系统需要使用模型预测的结果的话，那么攻击就也可能是broad category of denial of service.
== Training in Adversarial Settings
投毒攻击 - 修改训练集 - 设定例子：入侵监测系统- inserting, editing, or removing points with the intent of modifying the decision boundaries of the targeted model

无限制的攻击总归会成功的，所以一般这些攻击都有个限制。

几乎所有的都是针对分类器的。

=== Targeting Integrity

基线：如果允许用概率$beta$修改训练样本时，学习器的精度，指出如果要推理阶段达到的错误率为$epsilon$ 那么需要满足$beta eq.lt epsilon / (1 + epsilon)$


==== Label Manipulation

仅能修改训练数据集 - 攻击面受限：他们必须在已知部分或全部学习算法的情况下，找到最具破坏性的标签扰动。

- 基线策略是：随机地扰动部分训练数据的标签（即随机分配新的标签）。

- 启发式方法可提高攻击者的成功率。对那些模型在后期以较高置信度分类的样本进行投毒，会进一步影响模型的推理性能。与随机翻转标签相比，他们所需投毒样本的比例降低了约 10 个百分点，以达到同样的准确率下降。

要点 4.1：
模型在训练与测试分布上的性能差异（即泛化误差）的上界通常较为宽松，因此难以量化投毒攻击对推理阶段性能的具体影响。

==== Input Manipulation
- 对学习输入的直接投毒（Direct Poisoning of Learning Inputs）

当学习以在线方式进行，即系统通过观察环境不断添加新的训练点时，模型的攻击面往往被放大。此时，攻击者可通过逐步插入特定样本来影响模型。多数研究集中于聚类模型（clustering models），其中直觉性的攻击策略是：逐渐移动聚类中心，使得在推理阶段部分样本被误分类。

向用于异常检测（anomaly detection）的训练集中插入投毒样本，展示了这如何逐步改变质心模型（centroid model）的决策边界

还有基于梯度上升的攻击，用于识别投毒样本。

==== 对学习输入的间接投毒（Indirect Poisoning of Learning Inputs）

多态蠕虫（polymorphic worms）包含噪声流，使得：（1）它们的分词表示包含并不代表蠕虫流量的标记；（2）它们改变了分类器的阈值，从而使其使用错误的特征去标记蠕虫。

=== Targeting Privacy and Confidentiality
数据与模型的机密性和隐私性是否受影响，并不取决于机器学习本身的使用，而取决于攻击者对托管系统的访问范围。这属于传统的访问控制问题。
== Inferring in Adversarial Settings


=== White-box Adversaries

==== 直接操纵模型输入（Direct Manipulation of Model Inputs）
对抗样本 L-BFGS FGSM等

对扰动 𝑟 的最小化可通过不同度量定义，这导致了多种攻击形式

要点 5.1：
模型通常在训练数据覆盖的有限子空间上进行线性外推。算法可以利用这种规律性，指导搜索以定位潜在的对抗区域。

==== 间接操纵模型输入（Indirect Manipulation of Model Inputs）
物理对抗样本

要点 5.2：
为了抵御流水线中的变形，对抗样本在物理域中需引入更大或经过适配的扰动。这表明，强制物理可实现性与域约束可减少模型的错误空间。

==== Beyond Classification

攻击者可诱导代理即时或延时地做出错误行为——即创建“潜伏代理（sleeper agents）”，它们在环境扰动后的若干时间步仍表现正常，随后才出现错误行为。

要点 5.3：
尽管研究主要集中于分类任务，对抗样本算法同样适用于其他设定，如强化学习：例如，攻击者可扰动游戏视频帧以迫使代理采取错误动作。


=== 白盒的隐私与机密性（Privacy and Confidentiality）

比如简单的攻击是成员测试（membership test），即判断某特定输入是否参与了模型的训练。更强的攻击者可能试图提取部分或完整的训练样本。

=== Black-box Adversaries
“预言机（oracle）” 在“（ML-as-a-Service）”的云平台环境中尤为相关。

==== 完整性攻击（Integrity）


以黑盒模型的查询次数来估计误分类代价（cost of misclassification）[72]。攻击者拥有对模型的预言机访问权。输入 𝑥 被修改为目标实例 𝑥∗，并定义代价函数为两者的加权 $𝐿_1$距离。作者提出 ACRE 可学习性（ACRE learnability） 概念，即使用多项式数量的查询找到使恶意输入被分类为良性输入的最小代价修改。

==== 直接操纵模型输入（Direct Manipulation of Model Inputs）

当攻击者能访问模型输出的类别概率时，可恢复底层黑盒模型的诸多细节，这构成了所谓模型提取攻击（model extraction attacks）

- 应用遗传算法（genetic algorithm），其变异样本的适应度由预言机输出的类别概率决定。 该方法可逃避基于随机森林和 SVM 的恶意软件检测。然而，当输入特征维度较大时，生成遗传变体的计算量显著增加。


- 当攻击者无法访问概率，仅能观察预测标签时，提取决策边界的信息更加困难，而这是产生误分类所必需的。 对抗样本的可迁移性。

- 假设获取可获得代理数据（surrogate data）： 替代模型（substitute model）以模仿目标模型的策略

要点 5.4：
对抗样本之所以能在不同模型间转移，是因为各模型的错误空间（error space）呈高维分布，使得这些空间往往相交。此外，解决相同任务且性能相近的模型往往具有相似的决策边界。

- 数据流水线操纵（Data Pipeline Manipulation）
类似于物理对抗样本

==== 隐私与机密性攻击（Privacy and Confidentiality）

- 成员攻击（Membership Attacks）

此类攻击者试图判断特定样本是否存在于训练数据集中。 

利用模型在训练样本与非训练样本上置信度差异。对目标模型的每个类别，他们训练多个“影子模型（shadow models）”，每个影子模型用于执行成员推断测试。生成影子模型的合成数据过程如下：从随机输入开始，通过查询原模型进行“爬山”搜索（hill climbing），寻找能以高置信度被归入目标类别的输入。假设这些合成输入在统计上与原模型的训练样本相似。


后续可以推广到包括生成模型（generative models）的无监督学习。

- 训练数据提取（Training Data Extraction）
模型反演攻击（model inversion attack）
若攻击者能访问模型及患者的稳定剂量等辅助信息，即可恢复部分基因组信息。

- 模型提取（Model Extraction）
他们通过求解方程组，从观察到的输入输出对 (𝑥,ℎ𝜃(𝑥))中恢复参数 
𝜃。尽管方法简单，但在仅能获得类别标签（无法获得类别概率）的情境下，难以扩展。
== Towards Robust, Private, and Accountable Machine Learning Models


=== 模型对分布漂移的鲁棒性（Robustness of Models to Distribution Drifts）
机器学习模型必须在分布漂移下保持鲁棒性——即在训练与测试分布不一致的情形下维持性能。事实上，对抗性扰动正是此类漂移的典型实例。

- 训练阶段的防御
训练阶段的大多数防御机制基于这样一个事实：投毒样本通常处于预期输入分布之外。
如：借鉴稳健统计（robust statistics）思想，构建了一种基于主成分分析（PCA）的抗投毒检测模型。

或者：在模型训练的优化问题中使用正则化，以消除可被攻击者利用的复杂性。

- 防御推理阶段的攻击（Defending Against Inference-time Attacks）

通过梯度屏蔽进行防御（Defending by Gradient Masking）- 已经被摒弃

- 防御大扰动（Defending Against Larger Perturbations）
在训练集中注入标注正确的对抗样本，以增强模型鲁棒性。他们发现，用合法样本与对抗样本混合训练可实现正则化效果，使模型更抗干扰。
对抗训练。

=== 隐私的学习与推理（Learning and Inferring with Privacy）

一种定义隐私保护模型的方式是：模型不应泄露关于训练数据中个体的额外信息。这一理念由差分隐私（Differential Privacy, DP）


非正式地说，差分隐私要求：当输入数据中仅有一个记录（record）不同，算法的输出分布不应发生显著统计差异。在此设定中，“记录”指一个训练样本，“算法”指机器学习模型。

- 训练阶段（Training）

在训练中，可向数据、损失函数或参数值注入随机噪声。

一种方案称为本地隐私（local privacy） [89]。当用户将数据发送至中央服务器以训练模型时，随机响应机制（randomized response） 保护隐私：用户以概率 q 返回真实答案，以概率 
1−q 返回随机值。

- 推理阶段（Inference）

在推理阶段，也可通过对预测输出引入噪声来提供差分隐私。然而，噪声量随查询次数增加而增大，会显著降低预测精度。

=== 公平与可问责性（Fairness and Accountability in ML）

- 公平性（Fairness）
公平性主要涉及模型预测在物理域触发的行动。模型不应造成对特定个体或群体的歧视。
- 可问责性（Accountability）

可问责性旨在通过模型内部结构 ℎ𝜃解释预测。少数模型天生具备可解释性（interpretable by design），能匹配人类推理过程
== 思考
=== 定义surface：ML和security的视角不同：
一句人话：从安全的角度来看，定义攻击面是在系统层面刻画“可被利用的边界”（即从哪里可能被攻击），以此对原本模糊的 ML 系统进行形式化建模，并据此确定防御策略的适用范围与边界。
- 对于ML角度
  攻击只是扰动数据，3.1仅仅是扰动的时机。
- 而对于security的角度  
  “攻击”是一种系统性威胁的建模。要求动机goal、能力capability、位置surface等，然后明确哪些部分是trust model可信的
  - 对于表面的定义也是如此，需要去描述可以被利用的接口，“不是“何时攻击”，而是“能从哪里切入”。”
  - 同时，对于安全的定义不能从经验判断，一个系统是否“secure”不能凭经验判断，必须相对于明确定义的 adversary
  - 而现在的ML的边界比已经封装好的传统软件模糊很多，因此更需要这种定义。

- broad category of denial of service
  - 在LLM里面，不知道有没有专门触发模型overkill的攻击类型？

有的 有叫做：
https://arxiv.org/html/2410.02916v3?utm_source=chatgpt.com
的文章 专门研究假阳性攻击，研究Denial-of-Service
=== papernot的A和I
对于papernot来说A似乎是I的一个后果
“Availability attacks attempt to reduce the quality, performance, or accessibility of the model to a level that renders it unusable within its operational context.”

A 似乎在安全方向上讨论稀少：
“availability attack” 在 ML 中难以单独定义——它往往只是“强 I 攻击 → 系统层 A 后果”。

缺乏纯 ML 层面指标：传统 A 可量化（uptime, throughput），但 ML 模型没有“服务 down / up” 概念——模型永远输出点什么。

边界问题：ML 只是系统组件；能否被访问、延迟高低；能否被访问、延迟高低、资源枯竭往往属于部署层问题（API、推理服务），而不是 ML 算法本身。

但在 LLM 时代，“Availability” 又重新出现

- Prompt-based DoS 诱导模型生成极长输出或死循环 → 资源耗尽
- Token exhaustion / prompt bomb 输出爆炸导致延迟与计费激增
- Agent loop / tool call loop 自动调用外部接口，形成 DoS 级调用链
- Output jail 模型拒绝回答、陷入无意义重复

ChatGPT说的这句话很有意思：可以从三个层级考虑
- 模型层（Model Availability）：模型仍能产生合理输出（不陷入循环、不崩溃）；

- 系统层（Service Availability）：推理服务/API 在攻击下不被阻塞或超时；

- 经济层（Operational Availability）：在成本与延迟可接受范围内持续服务。




不过我认为对于模型这一层的A的讨论依然是比较少的。

== 未来预兆 - by ChatGPT

=== 从 SoK 框架的延展视角

Papernot 等人（2018）提出的 SoK 框架，以「攻击面 (attack surface) × 信任模型 (trust model) × 对抗能力 (adversarial capability)」构建了安全分析的坐标系。  
它并未被时代淘汰，反而成为后续安全研究的参照基线。  
随着模型规模和应用场景的扩大，这一坐标系不断被填满：新的攻击面（如 prompt 组装、SFT 数据源、agent 工具链）被纳入，同样的信任模型被投射到更复杂的部署语境中。  
Papernot 的洞见在于——安全从来不是“单点防御”，而是**在系统边界上识别可被利用的接口**。这一直是 LLM 安全的根本逻辑。

=== 成员推测与模型提取的分化

2018 年时，成员推测 (Membership Inference) 与模型提取 (Model Extraction) 被共同视作隐私攻击的两个侧面：  
前者针对数据泄露，后者针对模型泄露。  
如今它们演化为两条独立的研究脉络：  
成员推测更倾向于统计与信息论，强调泛化差距与置信度校准；  
模型提取则走向知识产权与模型所有权的治理议题。  
二者的分化标志着安全研究的“成熟化”——从验证攻击存在，转向量化风险、建立审计标准与评估协议。

=== 威胁建模的再中心化

Papernot 的框架提醒研究者：**任何安全讨论都应以明确定义的威胁模型为前提**。  
MIA 与 ME 的现代研究重新回到了这一原点：  
它们分别明确了攻击者的访问权限、可观测输出及目标收益，  
并在此基础上构建了可比的防御与理论分析。  
这种“威胁建模的再中心化”是安全学科从实验走向系统的标志。

=== 新安全语境下的延续与挑战

在大型语言模型时代，传统隐私攻击的核心逻辑被保留但外延扩展：  
数据泄露转化为对话记忆泄露，模型提取演变为蒸馏与克隆，  
可用性攻击（availability）开始以 token 消耗、输出延迟与循环调用等形式出现。  
Papernot 所设的框架依旧适用，只是攻击面更动态、信任边界更模糊。  
未来的安全研究需要一种新的统一语言，用以描述模型、数据与人之间的动态信任关系。

=== 理论的回声

Papernot 在结语中提出「à la PAC theory」的愿景——  
即建立机器学习安全的理论基础，用可证的形式化工具刻画模型的敏感性与风险。  
这一愿景在今日重新回响：  
差分隐私、信息理论界限、模型可审计性与 LLM 解释性都在尝试以统一度量衡量“学习的可攻击性”。  
或许真正的安全，不在于构造无懈可击的模型，而在于让脆弱性成为可测量、可解释、可治理的量。

=== 小结

从 Papernot 的 SoK 到当下的 LLM 安全，我们见证了从「现象分类」到「风险量化」、从「单一模型」到「系统信任」的演化。  
如果说 2018 年的 SoK 是一张地图，那么今天的研究者正不断向其边界添加新的坐标。  
而那句 “à la PAC theory” 的预言，仍像一条尚未完全展开的曲线，延伸向安全与学习理论交汇的未来。



= [102]SoK: All You Need to Know About On-Device ML Model Extraction - The Gap Between Research and Practice
On-device的设定中，模型直接部署到了用户端的设备上，
提取从IoT 应用中提取ML 模型会导致 经济和安全上的问题。

Model extraction的攻防
- 攻击：decomposing and decompiling techniques, runtime memory extraction, side-channel attacks, and data mining techniques
- 防御：一些 standard Advanced Encryption Standard (AES) Homomorphic Encryption (HE) Trusted Execution Environment
(TEE)以及许多就算发的方法。

四种攻击：
- App-based attacks:  gain access to the application files either through the public application marketplace, or through a vulnerability within the IoT devices. (de-packaging or decompiling, and extract the model files)
  - defend: encryption, obfuscation, or customized protection to model files in an app package
- Device-based attacks: can access the IoT devices and gain access to the memory. (force a vulnerable application to launch and load ML models into memory or consistently scan the memory to
wait for models to be loaded)
  - defend: apply device-based protection, such as secure hardware, to prevent arbitrary memory access.
- Communication-based:  can intercept communication between various memory regions and hardware architectures on an IoT device. (data like application runtime data/hardware usage
records/memory usage/electromagnetic/power-related data)
  - defend: apply data transformation, encryption, and randomization techniques
- Model-based attacks: can send (selective) input queries to the models and observe the ML inference results. (leverage pre-trained models to improve the accuracy of training substitute models or employ large-scale datasets or distributed methods to send query requests to the target models.)
  - apply weight obfuscation, misinformation and differential
privacy

安全技术：
攻击方：
- Decomposing and Decompiling: these methods unpacks
application packages to extract useful files (e.g., ML models)
from the sources.
- Memory analysis: these methods access device memory
and obtain memory buffers containing model layers and
weights.
- Side-channel attacks: these methods exploit indirect (sidechannel) information that can be used to infer ML inference
data.
- Algorithm-based stealing: these methods monitor the
input and output pairs of ML models, and apply statistical
or ML-based algorithms to steal model parameters, or train
highly similar substitute models.

防御方：
- Encryption and obfuscation: these methods prevent unauthorized
access or modification to ML models
- Secure hardware: these methods allow the storing and
execution of ML models in a secure environment.
- Pattern randomization: these methods reduce the chance
for side-channel-based model extraction attacks by adding
noises to ML inference or randomizing patterns that may
coexist with ML inference.
- Data and algorithm diversification: these methods increase
the complexity of algorithm-based stealing, and prevent attackers from further model training.

== App-based attacks
攻击：leverage the weaknesses that (1) app packages
are easily accessible and prone to reverse engineering,
and (2) model files are not adequately protected through encryption or obfuscation measures.

防御：aim to obscure easily readable machine learning models into something highly complex and difficult to interpret.

发现：app-based model extraction defense solutions
mostly come from the industry communities。攻击者可能无法直接使用这种方法，因为1.必须对输入输出有了解；2.模型可能是黑箱，模型功能可能不为攻击者了解3.模型可能已经被obfuscated or encrypted，攻击者需要de-obfuscation or decrypt；防御者的key可能会被作为攻击对象

== Device-based Attacks
攻击：bypass app-based model encryption.

ModelXtractor - extracting encrypted models from device memory in plaintext.
Uses app instrumentation with four types of instrumentation strategies to dynamically find the memory buffers where a (decrypted) model is loaded and accessed by the ML frameworks.

总的来说device-based model extraction attacks cannot
be performed on a large scale. 能挖掘出的话，是some luck.

防御：defending against in-memory model extraction and related attacks. 防御基于defenses focused on TEE-based solutions.但是TEE有很大的开销。

发现：attacks in this category are semi-automatic,
and are hard to perform on large-scale

== Comm-based Attacks and Defenses
攻击：主要是cache and memory-based 和 side-channel attacks
side-channel attacks： leveraged reinforcement learning-based
optimization to reduce the search space and reconstruct a substitute architecture/ uses timing
and electromagnetic (EM) emanations to recover multilayer
perceptron and convolutional neural networks.

防御：obfuscating the dimension and number of the DNN layers/encrypted data 这些方法require low-level modification and are limited by the execution environment.

发现：这些方法需要和victim共同运作，增加了被发现的几率。

== Model-based Attacks
攻击：that attackers use pairs of inputs, outputs to train substitute models that are highly similar with the victim models

基于这一假设，已有研究主要围绕以下目标展开：
(1) 在尽量保持精度的前提下获得高相似度的模型；
(2) 消除对目标模型先验知识的依赖；
(3) 优化查询效率与效果；
(4) 生成“自然”的查询模式以规避提取检测。

一些结合VAE的尝试，既不需要了解目标模型，也无需原始训练数据的统计信息。
为降低查询次数与被检测的风险，使用“智能查询代理”（intelligent query agents）提升模型窃取效率。

还有基于主动学习（active learning）的模型窃取方法。该方法利用未标注的公开数据，使查询分布更接近自然分布，从而绕过基于查询分布检测的防御。


防御：研究主要集中于两大方向：

(1) 减少预测信息泄露：
 监测攻击者查询的分布特征（如查询相似度）来识别异常行为。
 与模型结构无关的防御机制：输出概率上引入定向扰动，使生成的梯度方向与真实梯度尽量偏离。

 (2) 增加攻击成本与计算开销。
 差分隐私（DP）
 在训练阶段，向数据与梯度中注入可控噪声，使攻击者难以重建模型。

 挑战在于：
 (1) 攻击者可能构造出与合法输入相似的查询
 (2) 对于属于合法类别但未见过的样本，防御系统可能误判为分布外输，从而降低正常用户的推理准确率。

 == 思考：
 这一篇写了很多其他的非算法类的攻击，从理解的角度上来说，的确可以帮我分别不同层次，但主要还是通过模拟模型的攻击我更感兴趣。


 = [103] A Survey on Model Extraction Attacks and Defenses for Large Language Models

== 2 Preliminaries
=== 2.1 Model Extraction Basics

这里定义的模型提取是通过在黑盒模型下，通过输入输出对，对抗学习到一个代替模型$M_S$来以此模拟$M_T$的行为。 （从之前安全的定义角度来说-这个定义比较机器学习化，可能是好量化吧）超参数、架构这些都可以被提取。



=== 2.2 Extraction Attack Process

LLM的攻击大概可分为三步：
query generation - 设计提示词 (𝑥′) 来探测模型的能力。

response collection - 获取模型输出$M(x')$来记录训练数据

surrogate model training. - 使用输入输出对来训练，可以是微调小型预训练模型，蒸馏知识到更紧凑的模型或者从头训练。这一部需要应对一些挑战比如处理变长以及复刻模型内容。


== 3 Taxonomy

分为 功能提取，训练数据提取 和 特征词导向的攻击

== 4 Model Extraction Attacks
=== 4.1 Model Functionality Extraction

$M' = "argmin"_(M' in italic(H)) sum_(x,y) in D_"ext" L(M'(x), y)$ 其中$D_"ext"$是收集到的数据集，总共通过了$N$次搜寻，有一个budget B。 L 表示的是输出差异。


- 通用功能提取 询问是广而丰富的数据集

系统性地转移模型学到的知识。不同于传统的知识蒸馏需要内部参数，这些方法只通过input-output对完成。
已有算法当中的一个insight是knowledge distillation attacks become practical as the architecture gap between commercial models narrows.

- 目标功能提取 关注于特殊的提示词，只提取模型一个方面
提示词是精心设计的，用于分析模型特定行为。

- 参数恢复 逆向工程找出内部元素，比如权重

这些方法是更关注与那些边缘部署模型比如IoT或者手机，有人发现注意力机制比传统NN更会泄露。

=== 4.2 Training Data Extraction

这些方法这么做原因是 恢复训练数据由直接的对模型敏感保密的信息提取组成。

$E(M) = {d in D_"train": exists p in P s.t. "sim"(M(p),d) > tau}$ $"sim"$ 衡量相似度，$tau$是阈值。 $D_"train" M$ 是未知的。

- Prompt-based Data Recovery 关注于取出被记住的训练样本，使用的是精心设计的prompt

发现更高级的模型可能更会由泄露的风险。

还有发现，普通的数据在集成当中可能记忆率较低；但是对于独特稀有的格式，则是不成比例地被记住了。



- Private Text Reconstruction 超越了逐字提取，来推断重建那些敏感信息。

“金丝雀提取”（canary extraction）技术，表明模型会以与训练暴露程度相关的概率记忆并泄露被特意插入的数据模式。

激活反演攻击（activation inversion attack）可以在去中心化训练环境中重建训练数据，这进一步说明模型的内部表示可被利用来恢复私有信息。

“privacy protections must advance beyond preventing obvious memorization to address subtle statistical patterns that enable reconstruction.”
=== 4.3 Prompt-targeted Attacks
提取的是提示词，如系统提示词（system prompts）、微调模板（fine-tuning templates）以及在 LLM 对齐过程中使用的指令集（instruction sets）。

- 提示窃取

提示窃取瞄准的是精心设计的提示词中所蕴含的知识产权。Sha 与 Zhang（2024）首先系统性地展示了提示窃取的可行性；PRSA 进一步表明，即使是复杂的系统提示也能在有限交互下被重建。PLeak 揭示：不少商用 LLM 应用由于输出过滤不一致而泄露底层提示

经济层面的威胁：随着商业价值从“模型权重”转向“提示工程”，窃取提示成为低成本攫取竞争优势的手段，冲击企业差异化与对齐安全

- 提示重构

提示重构侧重于恢复指令模式与少样本示例。通过反演 LLM 输出来提取提示，显示模型响应中保留了提示上下文的可识别痕迹；“指令指纹”（instructional fingerprinting）则表明指令微调会在模型行为中遗留可检测的模式
== 5 Model Extraction Defenses
=== 5.1 Model Protection
作者将其定义为创造一个保护模型$M'$的结果和原$M$差异最小且泄露出的对抗模型差异大。
- Architectural Defense

TransLink-Guard在transformer上增加watermarks

CoreGuard： structural modifications

这些方法是非常专于特殊结构的。同时需要修改特殊结构

- Output Control. 

在输出上加水印。 对于改不了模型的时候，这尤为重要。

难处在于balancing the degree of response alteration. Insufficient changes fail to prevent extraction, while excessive modification compromises legitimate user experience.

=== 5.2 Data Privacy Protection
- Training Data Security
基础的挑战在于模型本身就会去记忆训练模型。这里就会出现学习效率和隐私保护的紧张关系。

- Output Sanitization
自检测机制，防止敏感信息泄露。

但这会很麻烦。因为如果隐私信息本就是合理询问的核心内容的时候，这个方法面临挑战。

=== 5.3 Prompt Protection
- Direct Prompt Protection
watermarking system来保护API

prompt protection techniques to prevent unauthorized access to system instructions

- Query Monitoring
攻击可能会暴漏出明显的问题。检测这些行为
== 6 Evaluation Metrics
=== 6.1 Attack Effectiveness
- Functional Similarity
Agreement rate.

Behavioral consistency.

Perplexity similarity provides a continuous measure of functional extraction success by comparing cross-perplexity between models.

- Data Recovery Rate
Percentage of training examples that are successfully recovered

Precision and recall of extracted data
=== 6.2 Defense Performance
- Security Metrics

Query detection accuracy measures a defense system’s ability to identifymalicious query patterns.

- Utility Metrics
Performance preservation rate.

== 7 Limitations and Future Directions
- Extraction Attack Perspectives

Access restrictions and high computational requirements

- Defense Mechanism Advancements