#import math

= Tutorial 2018

== Introduction

=== Notation (分类模型的基本定义/PGD)

- model, hypothesis function, $h_theta: math.italic(Chi) -> R^k$ k is the number of classes
- loss function $L(h_theta (x), y)$ = $log(sum_k^(i=1) exp(h_theta (x)_j) - h_theta (x)_y)$

=== Creating an adversiarl example
With backpropagation we can compute the gradient of the loss function with respect to the input $nabla_x L(h_theta (x), y)$:
Then we can solve an optimization problem to find an adversarial example $hat(x)$:
$max_(delta in Delta) l(h_theta (x+delta), y)$
$Delta$ is an allowed perturbation set, for example, (and commonly) an $L_"infinity"$ ball.
where $Delta = {delta in R^m | ||delta|| <= epsilon}$

In theory, we would like $Delta$ to capture anything than human visually cannot distinguish (feel to be the 
"same" as the original input x), but this is hard to formalize.
The $L_"inf"$ ball provide a “necessarily-but-definitely-not-close-to-sufficient” condition for us to consider a classifier robust to perturbations.

we follow each step with a projection back onto the ℓ∞ ball (done by simply clipping the values that exceed ϵ magnitude to ±ϵ), this is actually a procedure known as projected gradient descent (PGD). 

=== Targeted attack, 构造对抗样本
maximize the loss of the correct class while also minimizing the loss of the target class

$max_(delta in Delta) (l(h_theta (x+delta), y) - l(h_theta (x+delta), y_"target") equiv max_(delta in Delta)(h_theta (x + delta)_(y_"target") - h_theta (x+delta)_y)$ since the log term can be canceled out.

=== Adversarial robustness and Training

- risk, training, and testing sets

The risk of a classifier is it's expectied loss under the true distribution of samples:
$R(h_theta) = E_(x,y) tilde D [l(h_theta (x), y)]$
$D$ denotes the true distribution over samples. $D = {(x_i, y_i) tilde math.italic(D)}, i = 1,...,m$

The empirical risk is the average loss over a finite training set:
$hat(R)(h_theta, D) = 1/(|D|) sum_(i=1)^m l(h_theta (x_i), y_i)$
We ust testset to estimate the true risk. $hat(R)(h_theta, D_"test")$

- adversarial risk
The adversarial risk of a classifier is the expected worst-case loss under allowed perturbations (some region around the sample point):

$R_"adv"(h_theta) = E_(x,y) tilde D [max_(delta in Delta) l(h_theta (x+delta), y)]$

Here explicitly allow that the perturbation region Δ(x) can depend on the sample point itself; using the examples from the previous sections, this would be necessary in order to ensure that perturbations respected the *ultimate image bounds* (e.g., pixel values in [0, 1]) after perturbation.

The empirical adversarial risk is the average worst-case loss over a finite training set:

$hat(R)_"adv"(h_theta, D) = 1/(|D|) sum_(i=1)^m max_(delta in Delta) l(h_theta (x_i + delta), y_i)$

When we prefer to use the adversarial risk as our measure of performance：
1. Several classification tasks (especially those relating to computer security) such as spam classification, malware detection, network intrusion detection, etc, are genuinely adversarial, where attackers have an direct incentive to fool a classifier. 

2.  It is very difficult to actually draw samples i.i.d. from the true underlying distribution. Instead, any procedure we use to collect data is an empirical attempt at accessing the true underlying distribution, and may ignore certain dimensions, especially if these appear “obvious” to humans. This is hopefully somewhat obvious even on the previous image classification example. 

=== Training adversarially robust classifiers

We can train adversarially robust classifiers by minimizing the empirical adversarial risk over a training set, which is a min-max optimization problem:

$min_(theta) hat(R)_"adv"(h_theta, D) = min_(theta) 1/(|D|) sum_(i=1)^m max_(delta in Delta) l(h_theta (x_i + delta), y_i)$

The inner maximization problem is generally hard to solve exactly, the gradient of the inner function involving the maximization term is simply given by the gradient of the function evaluated at this maximum. In other words, letting $δ^*$ denote the optimum of the inner optimization problem.

$delta^* = "argmax"_(delta in Delta(x)) l(h_theta (x+ delta), y)$

the gradient we require is simply given by:

$nabla_(theta) max_(delta in Delta(x)) l(h_theta (x+ delta), y) = nabla_(theta) l(h_theta (x + delta^*), y)$

Iteratively compute adversarial examples, and then update the classifier based not upon the original data points

在实践中常用 PGD 来近似内层最大化，因此 PGD adversarial training 被认为是当前最有效且最稳定的防御方法。

=== 最终comments

对抗鲁棒性其实可以统一地看作是一个鲁棒优化问题，即「内层最大化」（攻击）和「外层最小化」（防御）

所有对抗攻击方法，本质上都是在尝试解决 内层最大化（在允许扰动范围内寻找最坏的输入扰动，最大化模型损失）。

所有防御方法，本质上都是在尝试解决 外层最小化（在对抗扰动存在的情况下训练或改进模型，使损失最小）。

许多研究没有从“优化问题”的角度来阐述自己的方法，而是强调“用了什么手段”。

这导致出现了大量名字不同、方法看似五花八门的攻击/防御手段，但它们其实都只是对核心优化问题的细微变体：

- 在扰动的约束上使用不同的范数

- 用不同的优化算法来解内层最大化问题。

- 使用一些看似复杂甚至“花哨”的技巧，但未必与鲁棒优化框架有明确关系。

（Zico 和 Aleksander 的个人意见）

- 过度依赖这些“启发式方法”的历史表现不好，很多方法看似新颖，但效果和理论联系不强，最后往往没有持续影响力。

- 他们的观点是：真正重要的是回到优化问题的本质，而不是沉迷于各种五花八门的“技巧化命名”。

== Adversarial examples in Linear Models

优化：

线性二分类是唯一能“精确解出对抗鲁棒训练”的情况：内层最大化有解析解，外层凸优化可全局解。


等价：
等价于对抗训练等价于在原始数据上添加一个正则化项：

结果：
普通模型极易被对抗样本欺骗（高脆弱性）；鲁棒模型能有效降低攻击成功率，但 clean accuracy 会下降。

== Adversarial examples in Deep Learning
- 高维性带来的脆弱性

  - 在高维输入空间中，几乎任何点都存在一个方向能显著增加损失。

  - 这意味着即使很小的输入扰动，也会导致损失大幅上升，从而产生对抗样本。

  - 换句话说：深度网络的损失面天然容易产生“尖锐方向”，所以特别容易被对抗攻击。

- 非凸性带来的内层最大化困难

    - 与线性分类不同，深度网络输入空间的损失函数高度非凸。

    - 这使得内层最大化问题（寻找最坏扰动）难以精确求解，也难以上界。

    - 梯度方向可能只是局部最优，初始点不同会导致不同结果。

    - 对于攻击来说问题不大：因为“到处都有危险方向”，即使不是最优扰动也能成功。

    - 但对训练鲁棒模型来说是严重问题：

    - Danskin 定理失效（梯度不能简单地等于在最优扰动点的梯度）。

    - 无法把 min-max 问题化简为干净的外层最小化。


=== Solving the inner maximization
近似求解内层最大化（找最坏扰动）有三条主线，各自对应“下界—精确—上界”的思路与取舍。

- Lower bounding 下界（基于攻击的经验求解）---- 最常见

    - 做法：直接在约束集内找一个可行扰动 δ 使损失尽量大（如梯度法/PGD/多重重启/启发式搜索）。
    - 含义：任何找到的可行值都是目标的下界（≥0 的最坏值的一部分）。
    - 优点：最常用、易扩展到大模型；能产出真实对抗样本；也可用于对抗训练

    - 局限：不保证全局最优；攻击不够强会低估最坏损失 → 训练与评测可能“虚高”。

- 精确求解（组合优化/MIP/分枝定界）

    - 做法：把 ReLU 等非线性编码成整数约束，构造成混合整数规划等精确模型求解。

    - 含义：能给出真·最优值与对应最优扰动。

    - 优点：有“金标准”作用，可用于小网络/小数据严格评估或做研究对照。

    - 局限：不可扩展到大规模现代网络；计算代价极高。

- 上界（凸松弛/区间传播/对偶证据 → 认证鲁棒）

    - 做法：对网络作凸松弛/线性上、下界逼近，在松弛模型上“最大化损失”得到可计算的上界；或用对偶形式直接给出上界。

    - 含义：如果上界也很小，就能证明在给定 ϵ 下不存在成功攻击（=“认证鲁棒”）。

    - 优点：给出可证明保证；与训练结合（认证训练/松弛对抗训练）可获得可证明鲁棒的 SOTA 方法族。

    - 局限：上界可能松；构造真实样本并非目标；实现复杂，规模化仍有成本。


=== Lower bounding
我们可以使用损失函数的梯度信息来寻找一个局部最优的扰动 $delta$，从而得到内层最大化问题的一个下界。当然我们需要保证 $delta$ 在允许的扰动范围 $Delta$ 内。
- The Fast Gradient Sign Method (FGSM)
我们希望让$delta$朝着梯度的方向行动，那么这一步的大小应该是多大呢？我们希望这一步尽可能大，那么我们可以让$delta$等于在允许范围内的最大值：

$delta = epsilon * "sign"(nabla_x l(h_theta (x), y))$


```

def fgsm(model, X, y, epsilon):
    """ Construct FGSM adversarial examples on the examples X"""
    delta = torch.zeros_like(X, requires_grad=True)
    loss = nn.CrossEntropyLoss()(model(X + delta), y)
    loss.backward()
    return epsilon * delta.grad.detach().sign()
    
    ```

FGSM是一个在$L_"inf"$下的单步攻击方法，是对抗攻击的“入门基线”。也可以把其泛化为其他norm下的单步攻击。

FGSM对于一个线性二分类器来说就是最优的攻击方法。他通过模型的梯度假设了一个模型的线性估计。我们也知道模型并非线性的，因此我们可以通过多次迭代FGSM来获得更强的攻击方法，这就是PGD攻击。

- Projected gradient descent (PGD) attack
重复$delta := P(delta + alpha nabla_(delta)l(h_theta (x+ delta), y))$. P步骤是一个投影步骤，保证$delta$在允许的扰动范围内。

```
def pgd(model, X, y, epsilon, alpha, num_iter):
    """ Construct FGSM adversarial examples on the examples X"""
    delta = torch.zeros_like(X, requires_grad=True)
    for t in range(num_iter):
        loss = nn.CrossEntropyLoss()(model(X + delta), y)
        loss.backward()
        delta.data = (delta + X.shape[0]*alpha*delta.grad.data).clamp(-epsilon,epsilon)
        delta.grad.zero_()
    return delta.detach()

```
在这个例子里面，$alpha$设置得很大，是1e4,因为grad相对于$delta$来说是很小的。

除此之外，PSD的攻击选择最陡峭的梯度的时候，并不是传统意义上最大的梯度，而是一个经过归一化的梯度，一个normalized steepest descent。

还有一个方法是多次随机初始化PGD攻击，来获得更强的攻击。这个方法现实中比较昂贵。

- Targeted attack
稍微更困难的是有目标的攻击，我们希望让模型把$x+ delta$分类到一个特定的类别$y_"target"$。我们可以通过最大化$h_theta (x + delta)_(y_"target") - h_theta (x+delta)_y$来实现这个目标。


- Non $L_"inf"$ attacks

可以从 l_inf 范数攻击推广到其他范数攻击。比如转到l2范数，六
球事$sqrt(n)$大小的l_inf的球，因此需要缇娜加上一个$sqrt(2)/sqrt(pi e)$的scaling factor。

其他的攻击要么是针对不同的norm ball pertubation 要么是不同的优化norm ball的方法。

=== Exactly solving the inner maximization (combinatorial optimization)

=== Upper bounding the inner maximization

== Adversarial training, solving the outer minimization
我们假设，对于min-max问题的内部来说，对抗样本是有着这个模型的全部知识的，他们可以去被特化而攻击模型，无论这个模型拥有什么样的参数。（这些我们在外部min训练出来的参数）。
min-max问题的目标是建立一个鲁棒的优化问题。

当然实际上攻击方并不一定知道模型的全部信息，甚至可能不知道模型的架构和参数。对于攻击方的“能力”的大小并不好界定，但是对于能力的假设很重要。评估模型时要谨慎：如果只在弱攻击下评估，模型可能表面鲁棒但实际容易被更强的攻击破坏。

Danskin 要求“精确最大化”：定理的条件是内层的max 能被确切求解（且一些可微性/紧性条件成立），这时外层关于 𝜃的梯度等于在$δ^*$最优处对 𝑓 的梯度。

深网里通常不能精确求解内层：内层是非凸、可能有多极值、且最优解可能不是唯一。因而严格的 Danskin 条件通常不成立——理论上不能把外层梯度等同为在某个“全局最优扰动”处的梯度。但经验上，“近似最大化做得越好，Danskin 的结论越近似成立”。
因此在对抗训练里的实务含义：

- 若你用弱的攻击（例如单步 FGSM 或步数不足的 PGD）作为内层，得到的“鲁棒训练”会低估真实最坏情形——训练出的模型容易被更强攻击打穿。

- 所以要想得到“更真的”鲁棒性（即让 Danskin 近似更成立/让外层梯度更可信），需要把尽可能强的攻击嵌入内层（多步 PGD、重启、较小步长等）。社区实践也表明：多步 PGD（带重启）是目前最可靠的经验内层求解器之一。

不严格拥有数学保证。

显示实现:
```
def pgd_linf(model, X, y, epsilon=0.1, alpha=0.01, num_iter=20, randomize=False):
    """ Construct FGSM adversarial examples on the examples X"""
    if randomize:
        delta = torch.rand_like(X, requires_grad=True)
        delta.data = delta.data * 2 * epsilon - epsilon
    else:
        delta = torch.zeros_like(X, requires_grad=True)
        
    for t in range(num_iter):
        loss = nn.CrossEntropyLoss()(model(X + delta), y)
        loss.backward()
        delta.data = (delta + alpha*delta.grad.detach().sign()).clamp(-epsilon,epsilon)
        delta.grad.zero_()
    return delta.detach()
```

而对于一个epoch的训练来说，
```
    delta = attack(model, X, y, **kwargs)
    yp = model(X+delta)
```
我们使用一个attack替换掉了原本的训练。
```
    yp = model(X)
```

=== Evaluating robust Models
这里需要非常小心：我们可以非常简答地让模型修改来对抗一个特定的攻击方法，但我们可以轻易地被另一个不同的攻击方式所愚弄。

因此

1. 别用“错威胁模型”来评估
用 ℓ∞ 威胁模型训练出来的鲁棒模型，如果拿去用 ℓ2 攻击评估，结论基本没意义（最多满足好奇心）。因为模型只针对训练时的扰动集学会了防御，换了威胁模型自然不鲁棒。

2. 想要“跨攻击模型泛化”，就要在训练时明确并覆盖这些模型

3. 真正想要的是“人类感知不变”的攻击集，但难以刻画
理想的扰动集应是“人看起来还一样”的所有图像，这个集合极难精确定义，因此是很好的研究方向。

=== 可视化鲁棒loss的表面

普通图的loss surface非常不平滑，在梯度方向上变化剧烈，且在随机方向上也有较大变化。——（参数空间不一定更平滑：有研究做了 Hessian 分析，发现当对抗半径（预算）较大时，参数空间里的极小值反而可能更尖（sharper），并非处处“更平”，2020）

这里需要比较的重要一点是 z 轴的相对变化（鲁棒图的“起伏”只是因为使用了更小的刻度；如果放在相同刻度下，第二幅图几乎是完全平坦的）。
鲁棒模型在梯度方向（即最陡的方向）和随机方向上的损失曲面都相当平坦；而传统训练的模型在梯度方向上损失变化非常剧烈，并且在沿梯度方向移动一段后，随机方向上也会迅速产生较大的变化。
当然，这并不能保证不存在某个方向会带来急剧的损失增加，但至少提供了一种线索，说明可能发生了什么。

总之，通过基于 PGD 的对抗训练得到的模型确实表现出真正的鲁棒性：它们的损失曲面本身更加光滑，而不仅仅是通过某种“技巧”来掩盖真正的损失上升方向。
至于能否在形式上对这种鲁棒性说得更明确，还有待进一步研究，这是当前正在进行的研究主题。


=== 区间界的考量
区间界的考量作为evaluation是没什么意义的，因为区间界的考量是一个非常松的上界。

而在训练过程中显式考虑这些上界，界就能真正发挥作用。

=== 对于2018年的总结
这里做的测试都是在minst上面的，看起来比较容易，但是即使在cifar10上面，鲁棒错误率就达到了55%，而最好的可证明鲁棒模型错误率升职超过了70%。几乎还没有深入探索过训练流程、网络架构、正则化等方面的选择。
