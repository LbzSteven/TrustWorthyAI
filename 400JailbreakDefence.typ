= 401 Defending LLMs against Jailbreaking Attacks via Backtranslation

A simple and lightweight method.


Assumption/background: LLM has been trained with safety alignment and is normally able to refuse clean harmful prompts. 但是即便模型做了安全对齐，但其仍然易受“改写提示以隐藏有害意图”的 jail-break 提示攻击。


Method: in turn prompt a language model to infer the possible prompt, termed as the “backtranslated prompt". Given the backtranslated prompt, we prompt the target LLM again to generate a second response, and we check if the model refuses the backtranslated prompt in the second response.

系统地来说$O = M(S)$ O是输出，M是模型，S是adv输入prompt。如果S被拒绝了，直接结束输出拒绝$R$。如果S没有被拒绝，我们生成backtranslated prompt S' = B(O)，如果$P(O|S') lt.eq gamma$ 则输出$O$, 负责再一次使用模型$M$对S'进行推理，得到$O' = M(S')$，如果$O'$被拒绝，则输出拒绝$R$，否则输出$O$。

这套系统的逻辑是，如果遇到有害的对抗prompt S,模型可能无法直接拒绝，但是显示地让模型根据输出反推一下模型的输入prompt S'，如果S'是有害的，那么模型应该能够拒绝S'，从而间接地拒绝S。
因为这里的$S'$不再是精心设计的对抗prompt，而是反翻译模型B模型自己的prompt，模型更容易识别出S'的有害性。这里的$gamma$主要是防止模型在反翻译时出现信息丢失，导致S'和O对不上的情况。

这里的反翻译模型B就是通过prompt特化的“猜测用户的request”，如果存在多个可能的request，则输出最有害的那一个。当然也可以使用专门训练的反翻译模型B。





优势
- 在response上进行，而非在prompt上进行修改，对prompt更加鲁棒。
- 模型不需要额外训练
- 对善意方法无影响
- 不需要额外训练

有一个judge模块判断输出是否有害。

limitation

- 依赖反翻译模型B的能力，如果B无法正确反翻译出有害prompt S'，则防御失效。
- 反翻译依旧可能存在翻译错误。
- 更复杂的攻击，例如ciphers等可能绕过防御。

我的认知：
- 为什么不直接检测O是否有害？
- 不知道是不是会overkill的？
- 除了ciphers，还有没有更复杂的攻击会绕过防御？比如cosplay某种情况等。
