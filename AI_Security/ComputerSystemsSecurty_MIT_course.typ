= Intruduction, Threat Models 
- reference
https://ocw.mit.edu/courses/6-858-computer-systems-security-fall-2014/resources/lecture-1-introduction-threat-models/?utm_source=chatgpt.com

The goal is to "vs adversery"
+ policy  (CIA): confidentiality, intergrity, availability.
+ thread model: assumptions about the adversery. The assumption is a iterative process. Good assumption is hard to judge.
+ mechenism: software hardware system. 

Examples of Security problems

policy出问题: 
- recovery questions: it weaken the policy to either knowing password or know the question. 
- 多系统之间的互动会使得简单问题变得复杂许多。amazon可以简单地添加信用卡，信用卡又可以被用于重置密码，又可以影响me.com进而可以作为备用邮箱攻击gmail邮箱。

threat models：
- 人为因素，不要假设人能设置强的密码
- 随着时间变化：MIT在1980年Kerberos使用了2^56的密码，现在就可以被枚举出来。
- SSL/TLS 这些连接安全认证，由CAs认证机构做出来.假设是这些CA不会出错，但是有很多CA存在，每个都可以给认证，这些CA有些很多可以被攻击。
- DARPA secure OS: 偷了另一个服务器上的源代码。

mechenism 出问题
- Apple cloud 不同界面的机制不一样。比如icloud之前对于手机登录次数的检测不存在。
- login pw被存在citi的URL上面
- android bitcoin的随机生成 密码。（因为没有服务器检查，只会检查密码）- 这里面使用java的secureRandom()但底层实现可能出现0.
- SSL 和C之前表示string的差异，C会用"\0"来表示string的结束，这就导致了问题。 
一环偏差（policy 过宽、threat 假设过乐观、mechanism 实现疏漏），系统就会“看似安全但不可用”。
