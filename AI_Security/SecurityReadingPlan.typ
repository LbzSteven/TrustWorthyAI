= Security Reading Plan（2 Weeks, Intensive Track）
Ziwen Kan · UC Davis · 2025

本计划面向 IEEE S&P / USENIX / CCS / NDSS 四大安全会议。  
目标：在两周内完成 “Papernot → Modern SoK → Survey” 的连续线索；形成对 Evasion, Poisoning, Privacy/Extraction 三类威胁的系统理解。  
每天约 2–3 篇论文 + 笔记 + 思考 (3–4 h)。

---

= Week 1｜从 Papernot 到现代 Privacy & Extraction

== Day 1｜Privacy & Extraction 统一视角 (ACM CSUR 2023)
📖 A Survey of Privacy Attacks in Machine Learning (ACM Computing Surveys 2023)  
- Block A — Threat Model Framework：membership / inference / extraction 的三分。  
- Block B — Attack Taxonomy & Metrics：影子模型、置信度利用、泛化差距。  
- Block C — Defenses：差分隐私、置信度压缩、正则化。  
📄 产出：整理「攻击目标 × 可见信息 × 可测指标」表 + 简短反思 “隐私攻击与模型泛化的关系”。

== Day 2｜Model Stealing Attacks and Defenses – Where are we now? (2024)
📄 Asokan et al. (2024 survey)  
- Block A — Attack 类别：黑箱 / 灰箱 / 白箱；查询驱动、知识蒸馏式、参数拟合式。  
- Block B — 防御：输出扰动、限频、watermark、fingerprinting。  
- Block C — 交叉关系：为何防 privacy 未必能防 stealing。  
📄 产出：3×3 便签表 (Goal × Knowledge × Defense)；写 150 字准备明日交流摘要。  
👉 放置在最前，优先阅读（明日与 Extraction 教授交流前）。

== Day 3｜SoK: On-Device Model Extraction (USENIX Security 2024)
📄 SoK: All You Need to Know About On-Device ML Model Extraction  
- 阅读 Introduction + Threat Models + Taxonomy：区分 on-device vs cloud API。  
- 梳理防御面：输出量化、置信度抑制、查询节流、篡改检测。  
📄 产出：对比表「访问方式 × 可行攻击 × 适用防御」。

== Day 4｜SoK: Data Reconstruction Attacks (USENIX Security 2025)
📄 SoK: Data Reconstruction Attacks Against ML Models — Definition, Metrics, and Benchmark  
- 阅读 Definition / Metrics / Benchmark；理解 membership → reconstruction 的连续性。  
- 起草 Minimal Reproduction Checklist（数据、模型、指标）。  
📄 产出：1 页摘要 + 最小复现实验清单。

== Day 5｜Evasion / Adversarial Robustness 现代视角
📖 Carlini et al., Evaluating Adversarial Robustness (USENIX Security 2019)  
📖 SoK: Certified Robustness for Deep Neural Networks (IEEE S&P 2022)  
- Block A — Carlini Checklist：adaptive attack、strong baseline、可复现性。  
- Block B — Certified Robustness Taxonomy：interval bound propagation、Lipschitz bounds。  
📄 产出：鲁棒性评测 checklist + 可认证防御对照表。

---

= Week 2｜Cross-Impact and System Level Context

== Day 6｜SoK: Unintended Interactions Among ML Models (2024 preprint)
📄 探讨 Robustness vs Privacy vs Fairness 的耦合。  
重点阅读 Section 3–5 的 case studies。  
📄 产出：一页概念图：「一个防御如何触发另一类漏洞」。

== Day 7｜Backdoor & Supply Chain Attack 综述
📖 Backdoor Learning: A Survey (IEEE TPAMI 2022)  
📖 Model Supply-Chain Security Survey (ACM CSUR 2024)  
理解 poisoning → backdoor → supply chain 连续线。  
📄 产出：3×3 表：「阶段 × 攻击粒度 × 检测方式」。

== Day 8｜LLM Jailbreak 与 Prompt Injection 综述
📄 Zou et al., Universal and Transferable Jailbreaks on Aligned LLMs (USENIX 2023)  
📄 SoK: LLM Safety and Jailbreaking (2025 preprint)  
整理 prompt injection 类型、攻防机制。  
📄 产出：LLM Attack → Defense map。

== Day 9–10｜Synthesis + Mini Review Draft
📄 将前三大方向 (Evasion / Poisoning / Privacy + Extraction) 的 threat model 与 metrics 整合。  
📄 输出 2 页小结（可直接演化为 SOP 安全部分）。

---

#table(
  columns: 3,
  [输出], [形式], [用途],
  ["Attack Taxonomy Sheet"], [typst 表格], [课堂展示 / 套词交流],
  ["Extraction Notes (2024 Survey + USENIX SoK)"], [1 页 PDF], [与教授讨论准备],
  ["Week 2 Mini Review"], [2 页 draft], [可纳入 SOP 安全部分],
)
