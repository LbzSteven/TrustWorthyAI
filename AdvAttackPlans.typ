#set heading(numbering: "1.A.1")

= 第 1 周：起源 → 全景认知 → 经典方法

== Day 1｜直觉与框架
- ✅ Goodfellow Talk (CS231n 2017) — 40min  
  https://www.youtube.com/watch?v=CIfsB_EYsVI
- ✅ Kolter & Madry NeurIPS 2018 Tutorial（前半部分，min–max 框架 + PGD baseline） — 1h20min  
  https://adversarial-ml-tutorial.org
- 🕒 总计：~2h

== Day 2｜全景与术语
- ✅ Survey: A Survey of Adversarial Defences and Robustness in NLP (2022)（精读引言+分类+结论，扫中间方法） — 2h  
  https://arxiv.org/abs/2203.06414
- ➖ NIST Adversarial ML 术语与分类（扫 taxonomy 表格） — 30min  
  https://csrc.nist.gov/publications/detail/nistir/8269/draft
- 🕒 总计：~2.5h

== Day 3｜NLP 早期方法
- ✅ TextFooler (AAAI 2020) — 1h20min  
  https://arxiv.org/abs/1907.11932
- ➖ HotFlip (ACL 2018) / TextBugger (NDSS 2019)（扫读思路） — 40min  
  https://aclanthology.org/P18-2006/  
  https://arxiv.org/abs/1812.05271
- 🕒 总计：~2h

== Day 4｜通用触发与行为测试
- ✅ Universal Adversarial Triggers (EMNLP 2019) — 1h  
  https://arxiv.org/abs/1908.07125
- ✅ CheckList (ACL 2020) — 1h  
  https://arxiv.org/abs/2005.04118
- 🕒 总计：~2h

== Day 5｜工具与评测框架
- ✅ TextAttack (EMNLP 2020 Demo) + 小实验 — 1h30min  
  https://arxiv.org/abs/2005.05909  
  https://github.com/QData/TextAttack
- ➖ Robustness Gym / TextFlint（扫一眼功能） — 30min  
  https://arxiv.org/abs/2101.04840  
  https://arxiv.org/abs/2103.11441
- 🕒 总计：~2h

== Day 6｜体系化评测
- ✅ AdvGLUE (2021) — 1h20min  
  https://arxiv.org/abs/2111.02840
- ➖ Survey: Red Teaming for Generative Models (2024)（扫引言+结论） — 40min  
  https://arxiv.org/abs/2402.00872
- 🕒 总计：~2h

== Day 7｜复盘
- ✅ 回顾 Week 1 → 画 timeline（FGSM → PGD → NLP 攻击与基准） — 1h  
- ✅ 写半页总结 — 1h  
- 🕒 总计：~2h

= 第 2 周：LLM 攻防 → 防御与对齐 → 展望

== Day 8｜LLM 攻击起点
- ✅ Universal & Transferable Attacks on Aligned LLMs (2023) — 1h  
  https://llm-attacks.org
- ➖ Simon Willison Prompt Injection 博客（扫案例） — 40min  
  https://simonwillison.net/tags/prompt-injection/
- 🕒 总计：~2h

== Day 9｜LLM 越狱与长上下文
- ✅ Anthropic “Many-shot Jailbreaking” (2024) — 1h20min  
  https://www.anthropic.com/news/many-shot-jailbreaking
- ➖ OWASP Top 10 for LLM Applications（扫风险清单） — 40min  
  https://owasp.org/www-project-top-10-for-large-language-model-applications/
- 🕒 总计：~2h

== Day 10｜系统化评测与红队
- ✅ JailbreakBench (NeurIPS 2024) — 1h20min  
  https://jailbreakbench.github.io
- ➖ OpenAI GPT-4 System Card（扫方法） — 40min  
  https://cdn.openai.com/papers/gpt-4-system-card.pdf
- 🕒 总计：~2h

== Day 11｜对抗训练在 NLP
- ✅ Miyato et al., Adversarial Training for Text (ICLR 2017) — 1h  
  https://arxiv.org/abs/1605.07725
- ✅ FreeLB (ICLR 2020) — 1h  
  https://arxiv.org/abs/1909.11764
- 🕒 总计：~2h

== Day 12｜对齐与防御
- ✅ Anthropic: Constitutional AI (2022) — 1h  
  https://arxiv.org/abs/2212.08073
- ✅ Survey: Towards Safer Generative LMs (2023) — 1h20min  
  https://arxiv.org/abs/2302.09270
- 🕒 总计：~2.5h

== Day 13｜LLM 特有风险
- ✅ How Johnny Can Persuade LLMs (ACL 2024) — 1h  
  https://arxiv.org/abs/2401.06373
- ➖ Indirect Prompt Injection (Simon Willison, 2023) + Wired 报道 — 40min  
  https://simonwillison.net/2023/Oct/26/indirect-prompt-injection/  
  https://www.wired.com/story/prompt-injection-attack-ai/
- 🕒 总计：~2h

== Day 14｜收尾与展望
- ✅ PromptBench (2023) — 1h  
  https://arxiv.org/abs/2306.04528
- ✅ 写 3–5 页综述 — 1.5h  
  结构：  
  1) 起源与早期方法  
  2) 评测体系与工具  
  3) LLM 新兴问题（jailbreak/prompt injection）  
  4) 防御与对齐方法  
  5) 开放问题与未来方向
- 🕒 总计：~2.5h
