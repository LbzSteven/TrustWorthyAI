NLP/LLM 对抗攻击与防御 学习计划（2 周 × 每天 2–3 小时）
#set heading(numbering: "1.A.1")
= 第 1 周：起源 → 经典方法 → 体系化评测

== Day 1｜奠基与脉络
- Talk: Ian Goodfellow 关于对抗样本/对抗训练，介绍了对抗样本提出的背景与基本思想。  
  https://www.youtube.com/watch?v=CIfsB_EYsVI
- Talk: Kolter & Madry NeurIPS 2018 教程，系统讲解了对抗鲁棒性的理论与实践。  
  https://sites.google.com/view/adv-robustness-neurips-2018
- Survey: A Survey of Adversarial Defences and Robustness in NLP (2022)，全面梳理了 NLP 领域的攻击与防御方法。  
  https://arxiv.org/abs/2203.06414
- NIST Adversarial ML 术语与分类，提供统一的攻防安全术语体系。  
  https://csrc.nist.gov/publications/detail/nistir/8269/draft

== Day 2｜NLP 早期/经典攻击
- HotFlip (ACL 2018)，利用梯度信息进行字符级最优替换的早期白盒攻击。  
  https://aclanthology.org/P18-2006/
- TextBugger (NDSS 2019)，设计实用黑盒攻击，能绕过在线 NLP 服务的检测。  
  https://arxiv.org/abs/1812.05271
- TextFooler (AAAI 2020)，提出语义保持的词替换攻击，是 NLP 攻击的强力基线。  
  https://arxiv.org/abs/1907.11932

== Day 3｜通用触发词与行为测试
- Universal Adversarial Triggers (EMNLP 2019)，发现“通用触发词”能全局欺骗模型。  
  https://arxiv.org/abs/1908.07125
- CheckList (ACL 2020)，提出基于能力单元的系统化鲁棒性测试框架。  
  https://arxiv.org/abs/2005.04118
- CheckList Talk (ACL 2020)，展示如何通过 CheckList 检查模型的脆弱性。  
  https://slideslive.com/38932304/checklist

== Day 4｜评测工具与基准
- TextAttack (EMNLP 2020 Demo)，一个集攻击、训练、增强于一体的工具箱。  
  https://arxiv.org/abs/2005.05909  
  https://github.com/QData/TextAttack
- Robustness Gym (NAACL 2021 Demo)，便于多角度测试模型鲁棒性的评测框架。  
  https://arxiv.org/abs/2101.04840
- TextFlint (ACL 2021 Demo)，自动生成丰富的文本扰动测试集。  
  https://arxiv.org/abs/2103.11441
- AdvGLUE (2021)，在 GLUE 基准上构建对抗任务，统一测试不同模型的鲁棒性。  
  https://arxiv.org/abs/2111.02840

== Day 5｜LLM 时代的对抗：Jailbreak 与 Prompt Injection
- Universal & Transferable Attacks on Aligned LLMs (2023)，提出可迁移的后缀攻击，能绕过对齐约束。  
  https://llm-attacks.org
- Anthropic “Many-shot Jailbreaking” (2024)，揭示通过长上下文诱导模型越狱的风险。  
  https://www.anthropic.com/news/many-shot-jailbreaking
- Blog: Simon Willison 系列文章，系统介绍 Prompt Injection 风险与真实案例。  
  https://simonwillison.net/tags/prompt-injection/
- OWASP Top 10 for LLM Applications，总结了 LLM 系统的十大安全风险。  
  https://owasp.org/www-project-top-10-for-large-language-model-applications/

== Day 6｜LLM 安全评测与红队
- JailbreakBench (NeurIPS 2024)，首个大规模越狱攻击基准，包含自动化评测流程。  
  https://jailbreakbench.github.io
- Survey: A Survey on Red Teaming for Generative Models (2024)，总结了红队测试在生成模型安全中的作用。  
  https://arxiv.org/abs/2402.00872
- OpenAI GPT-4 System Card，展示厂商如何在产品发布前评测安全性。  
  https://cdn.openai.com/papers/gpt-4-system-card.pdf

== Day 7｜复盘 + 小实验
- 使用 TextAttack 对一个文本分类任务运行小型攻击实验，直观感受模型脆弱性。  
  https://github.com/QData/TextAttack
- 写总结：梳理“2016–2021 NLP 攻击 → 2023–2025 LLM Jailbreak/Prompt Injection”的发展脉络。

= 第 2 周：防御 → 系统化安全 → 展望

== Day 8｜对抗训练在 NLP 的脉络
- Miyato et al., Adversarial Training for Text (ICLR 2017)，首次将对抗训练应用于词向量扰动，奠定 NLP 防御方向。  
  https://arxiv.org/abs/1605.07725
- FreeLB (ICLR 2020)，基于 PGD 的改进方法，对 Transformer 类模型效果显著。  
  https://arxiv.org/abs/1909.11764
- SMART (ACL 2020)，引入平滑正则与 Bregman 近端优化，提高对抗训练稳定性。  
  https://arxiv.org/abs/1911.03437
- Survey: Adversarial Training: A Survey (2024)，全面总结对抗训练的算法与挑战。  
  https://arxiv.org/abs/2401.11869

== Day 9｜系统安全与对齐方法
- Survey: Towards Safer Generative Language Models (2023)，系统梳理 LLM 安全风险、评估与改进方法。  
  https://arxiv.org/abs/2302.09270
- Anthropic: Constitutional AI (2022)，通过“宪法原则”引导模型对齐，减少有害输出。  
  https://arxiv.org/abs/2212.08073
- NIST AML 分类报告 (2024/2025)，提供系统层面对抗攻击与防御的分类与定义。  
  https://csrc.nist.gov/publications/detail/nistir/8269/draft

== Day 10｜LLM 特有攻防
- How Johnny Can Persuade LLMs to Jailbreak Them (ACL 2024)，提出“劝服式”越狱，揭示 LLM 在多轮对话中被操控的风险。  
  https://arxiv.org/abs/2401.06373
- Indirect Prompt Injection in Agent Systems，展示代理系统中的间接注入攻击案例。  
  https://simonwillison.net/2023/Oct/26/indirect-prompt-injection/
- Wired 报道: Indirect Prompt Injection，通俗介绍现实应用中 Prompt Injection 的危害。  
  https://www.wired.com/story/prompt-injection-attack-ai/

== Day 11｜基准与评测
- JailbreakBench 评测指标与原则 (NeurIPS 2024)，总结越狱攻击的标准化评测流程。  
  https://jailbreakbench.github.io
- Bag of Tricks: Benchmarking Jailbreak Attacks (2024)，指出评测细节和协议对实验结果影响巨大。  
  https://arxiv.org/abs/2406.12345

== Day 12｜评测与训练结合
- AdvGLUE 多任务基准 (2021)，覆盖常见 NLP 任务，适合测试对抗鲁棒性。  
  https://arxiv.org/abs/2111.02840
- PromptBench (2023)，针对 LLM 的 Prompt 鲁棒性评测框架。  
  https://arxiv.org/abs/2306.04528

== Day 13–14｜写短文综述
- 任务：撰写一份 3–5 页综述，结构包括：  
  1) 问题起源与早期方法  
  2) 评测体系与工具  
  3) LLM 新兴问题（jailbreak/prompt injection）  
  4) 防御与对齐方法  
  5) 开放问题与未来方向  
- 目标：形成自己对“对抗攻击与防御”的整体脉络认识，作为后续科研切入点。