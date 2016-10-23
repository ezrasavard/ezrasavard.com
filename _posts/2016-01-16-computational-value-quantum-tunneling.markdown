---
title:  An Undergrad Summarizes Google's 2015 Paper About Quantum Annealing
date:   2016-01-16
cover:  /media/dwave-graph_cover.png
thumb:  /media/dwave-graph_thumb.png
tags: [qmc]
---

In December 2015, Google published the paper [“What is the Computational Value of Finite Range Tunneling?”](https://arxiv.org/abs/1512.02206v3)[^fn0] which summarizes a series of experiments comparing quantum annealing (QA) with both simulated annealing and the path integral quantum monte carlo (QMC) algorithm on two types of problems. The problems tested were a weak-strong cluster problem, which is binary optimization, and the number partitioning problem, which is a standard NP-Hard problem. The paper goes on to model QA mathematically and simulate the performance of future [D-Wave](http://www.dwavesys.com) computers.

At the start of my undergraduate research, I was tasked with summarizing it so I could learn the terminology and get a bit of background in the field. I've decided to post that summary here with some minor changes as an introduction to the subject of quantum annealing computers, for the curious. There is a lot of confusing wording around quantum computer terminology, but I'll save that for another post and keep this one to my summary-dump.

<!--more-->

# Optimization Problems and Energy Landscapes
Optimization problems are problems where a cost function needs to be minimized. The cost function can take many forms and is specific to the problem.

The energy landscape of the problem refers to the plot of the cost function across N variables. This landscape is frequently drawn in two or three dimensions for explanatory purposes, but is usually many more. Solving the optimization problem refers to reaching the global (or near global) minimum of the cost function.

“Ruggedness” refers to how tall the peaks and valleys are in the cost function; these peaks are also referred to as barriers with descriptors like height and width. Landscapes are generally more rugged in the upper range of cost, but some problems have rugged lower energy landscapes as well. Due to the exponential decay of a probability amplitude while tunneling through a barrier, it is less likely to observe tunneling across wide barriers. QA excels in rugged landscapes, which are very challenging for classical solvers. Quantum annealing essentially removes the effect of tall and narrow barriers from a problem, whereas when barriers are wide, finding a solution depends almost entirely on the thermal aspect of the annealing process.

## Quadratic Unconstrained Binary Optimization (QUBO)
The weak-strong cluster problem is an example of QUBO and the general problem takes the form [^fn1]:

$$ E(  X_1, X_2, ... X_N ) = \sum_{<ij>} Q_{ij} X_i X_j $$

The order of the problem is referred to by K, which is the number of couplings per cluster as represented in D-Wave’s hardware. The current generation hardware is limited to pairwise coupling, so the weak-strong cluster problem is 2nd order QUBO (K = 2). Current work in progress from Google is working with K in {3, 4, 5}. While a higher K has a more rugged energy landscape, it is more difficult to represent in hardware.

QUBO has very little structure to exploit, which makes SA is a good choice of classical algorithm for these problems.

## Number Partitioning Problem
Known as NPP, or a “partition problem”, the general problem is: given a set of numbers, divide the set into two partitions with a minimally different sum [^fn4].

The energy landscape for NPP is very rugged, even low in the energy landscape, which makes it a good candidate for QA. Additionally, there are no good heuristics that achieve particularly good solutions; the best classical heuristics, Karmarker & Karp (KK) and greedy heuristics, are O(NlogN) and can find solutions that are well below the median, but still far above the global minimum.

# Solvers
Simulated Annealing (SA) and the path-integral Quantum Monte Carlo (QMC) are classical optimization algorithms that can be applied to general problems without exploiting any knowledge of the problem structure. Because of their generality, they are good competitors against which to measure QA performance.

Both SA and QMC benefit immensely from parallelism, but were run on a single-core processor in these experiments because that is the most common case when using data-centres. Quantum annealing is performed physically by the D-Wave 2X in some experiments and simulated, with currently infeasible parameters, in others.

All three algorithms’ times to solution scale exponentially with problem size.

$$
T_{SA} = B_{SA}e^{\frac{E}{k_bT}}
$$

$$
T_{QMC} = B_{QMC}e^{\alpha_D}
$$

$$
T_{QA} = B_{QA}e^{\alpha_D}
$$

B is known as the prefactor and D is the tunneling domain size (number of qubits cotunneling), which is 8 for a single cluster in this problem in the current D-Wave architecture; D generally scales linearly with N, the problem size.

## Simulated Annealing
By mimicking a thermal process, SA searches for a global minimum by using excitation to travel over barriers. Temperatures must be raised very high to allow a tall barrier to be passed over, so rugged landscapes are very difficult for SA and a solution involves a large number of restarts. For the weak-strong cluster problem, by design, SA begins to resemble an exhaustive search done by random sampling. The median number of restarts was $$10^9$$ to achieve a 99% success probability.

## Quantum Monte Carlo
Essentially a simulation of quantum annealing, QMC performs random sampling and spin-flips across the problem domain. The path integral QMC is used to solve quantum mechanical many-body problems with finite temperature ranges.

## Quantum Annealing
Physical QA is performed by clusters of superconducting rf-SQUID qubits in the D-Wave 2X. The system contains around 1000 operational qubits and operates at 15 milli-Kelvin with a 20 microsecond annealing time.

In order to examine the performance of near-future devices, simulated QA was carried out with more optimal parameters of 5 milli-Kelvin with a 71 nanosecond annealing time.

QA offers the greatest speedups in more rugged regions, which are typically in the beginning of a solution. Lower in the energy spectrum the topology is less rugged and barriers are wider, so QA will operate much more slowly in that range.

The D-Wave processor physically implements binary optimization with K = 2.

# Experiments and Results
## Weak-Strong Cluster Problem
Weak-strong clusters is a QUBO problem with K = 2. The strong clusters (h = 1) are close to being single-well potentials while the weak clusters (h = 0.44) are more like skewed double-well potentials. Test problems were built by coupling strong clusters to other strong clusters with either +1 or -1; weak clusters are only coupled to a single strong cluster with +1.

It appears that this paper has reversed D-Wave’s sign convention for J and h.

This problem was crafted to both showcase QA at its best using current hardware and to show SA fail.

### D-Wave vs SA vs QMC
This figure from the original paper summarizes the results graphically. The measurements are for time-to-99% success probability.

<img alt="Algorithm Scaling" src="{{site.baseurl}}/media/dwave-google-algorithm-scaling.png">

Recall:

$$
T_{SA} = B_{SA}e^{\frac{E}{k_bT}}
$$

$$
T_{QMC} = B_{QMC}e^{\alpha_D}
$$

$$
T_{QA} = B_{QA}e^{\alpha_D}
$$

As expected, single-core SA performs poorly on weak-strong cluster problems due to the tall barriers where $$ \frac{E}{k_b T} > \alpha_D $$. QA was much faster than SA with better scaling and a large linear speedup. Though both scaled exponentially, QA’s better scaling becomes apparent as problems become larger -- on the largest test (945 qubits), $$ T_{SA} = (1.8 * 10^8) T_{QA} $$.

Quantum annealing had a similar linear speedup over QMC, on the order of $$10^7$$ to $$10^8$$, due to QMC’s computational overhead characterized by a much larger prefactor B. As QMC imitates QA, the scaling was very similar for both.

Some classical heuristics are faster than both SA and QMC for these types of problems (chimera graphs). “Cluster finding” works very well on chimera graph problems, but it is predicted that cluster finding will be ineffective for the chimera graphs in next-generation QA hardware because of the increased density of inter-cluster connections that is expected.

### Simulated Future QA vs QMC
Previous attempts to predict the performance of future QA underestimated the performance gains brought in by better engineering by four orders of magnitude. In particular, the prefactor B relates to noise in QA, which is reduced by operating at lower temperatures and faster annealing schedules.

In order to simulate QA outside of the D-Wave 2X’s capabilities and draw comparisons to QMC, a mathematical model of physical QA is applied to the weak-strong cluster problem. Swapping the polarization on a weak cluster means reversing the total spin, so 8 spins must co-tunnel to achieve a complete spin-flip. Tunneling is only modeled between the ground state and first excited state at the avoided crossing since other states are too energetic to consider.

Their QA model suggests that optimal annealing occurs at 5 mK for $$ T_{QA} = 71$$ ns and gives a success probability $$ p_0 = 0.95 $$.

Using a model for QMC and fixing $$ p_0 $$ to 0.95, minimizing TQMC results in an annealing time per qubit of $$ \frac{T_{QMC}}{N} = 0.75$$ seconds. This value is $$10^7$$ times greater than $$ T_{QA} $$, and $$10^{10}$$ greater for a 1000 qubit system.

|Current D-Wave operation | $$ T = 15 mK, T_{QA} = 20 \mu s $$.
|Desired D-Wave operation | $$ T = 5 mK, T_{QA} = 71 ns $$.

## Number Partitioning Problem
For these tests, physical QA was not used, but rather QA was simulated using the quantum trajectories method. This method uses a classical Monte Carlo method to sample the wavefunction and then perform the time evolution of the system on the sample. It then re-synthesizes the wavefunction and repeats the sampling process [^fn2].

### D-Wave vs SA vs QMC
All three of the algorithms tested scaled exponentially on NPP with form $$ T = 2^{\alpha N} $$, but QMC and simulated QA scaled somewhat better than SA. Due to the rugged landscape, SA behaves almost as an exhaustive search.

|---
| Algorithm | $$ \alpha $$
|:-|:-:
| SA | 0.98
| QMC | 0.81
| QA (simulated) | 0.82
|---

The best scaling reported in the paper comes from “quantum walk + moduli + representations” with $$ \alpha = 0.241 $$, but I wasn’t able to search effectively for information on that method at my current knowledge level.

Because QA scales so similarly to QMC in both the weak-strong clusters and in simulation for NPP, it is believed that physical QA will scale similarly for NPP while retaining the large linear speedup from removing computational overhead.

In addition to providing a potential runtime benefit, quantum annealing could also find much better solutions than current heuristics. Using a greedy search that flips $$ \kappa $$ bits at a time, coined “algorithmic tunneling (AT),” the paper demonstrates that the solutions found by tunneling based methods can be much better than those found by KK heuristics for a large range of realistic problem sizes. In one example, the expected minimum energy $$ E_{min} $$ of the cost function that the algorithm could achieve had $$ \frac{E_{min,AT}}{E_{min,KK}} = 10^{-9} $$.

# Conclusions
This paper and future works seek to identify problems that have these three criteria:
- Solution is valuable/interesting
- Representable with near-future hardware
- QA offers a run-time advantage

QUBO with K = 2 met these requirements and simulation implies that higher order QUBO will do very well. NPP was also successful in meeting these requirements because the simulated QA process matched QMC for runtime, and it is assumed that physical QA will provide the a similar large ($$10^8$$) speedup over QMC.

# Future Development
The results of this paper, particularly the modeling of a more optimal physical quantum annealer, suggest that lower temperatures and faster annealing schedules would be very favourable. The authors do mention thermally assisted QA, but are more interested in the improvements in coherence and reduction in low frequency noise that would come from the optimized parameters. The noise reduction would come from both temperature differences and substantially shorter time spent near an avoided crossing.

|Current D-Wave operation | $$T = 15 mK, T_{QA} = 20 \mu s$$.
|Desired D-Wave operation | $$T = 5 mK, T_{QA} = 71  ns$$.

In terms of applicability, it is worth noting that rugged landscapes are typical of higher order optimization problems (QUBO with K > 2). The current hardware supports only pairwise qubit coupling (K = 2) and higher K-body couplers (coupling K qubits) would be geometrically difficult to layout in hardware.
Another option for QA is to embed higher order K-body problems as multiple K = 2 problems, but the extra variables would likely thicken energy barriers and reduce the benefits gleaned from tunneling.

## Single-Core and Parallelism
All of the SA tests in this paper were done with a single core processor despite benefiting immensely from parallelism due to its many restarts; on the weak-strong clusters problem, SA averaged $$10^9$$ restarts. The given reason for this choice was that a single-core process is more common in a data-centre when using SA.

To add some perspective to the speed-up, I estimated that approximating with perfect parallelism, the $$10^8$$ speedup from physical QA could be compensated for with ~$$10^8$$ cores. The Tianhe 2 has $$3.12 * 10^8$$ cores and is the fastest supercomputer in the world [^fn5]. Thus, for a very rugged landscape problem, current QA hardware would approximately match the world’s fastest supercomputer running a generic optimization algorithm on a second order binary optimization problem small enough to represent on 1000 qubits.

## Over-tuning of QMC
Appendix 2 of the paper discusses that QMC may have been overly optimized in this study. The path integral Quantum Monte Carlo has several parameters that can be tuned for a specific problem. This effect would result in achieving more of an upper-bound of QMC performance, which suits the goal of the study to compare physical quantum annealing against a “best case” QMC. This may not have be representative of QMC used in practice, where tuning to such an extent is infeasible.

## References
[^fn0]: Denchev et al., “What is the Computational Value of Finite Range Tunneling?,” [Online]. Available: <https://arxiv.org/abs/1512.02206v3>
[^fn1]: "Quadratic Unconstrained Binary Optimization," [Online]. Available: <https://en.wikipedia.org/wiki/Quadratic_unconstrained_binary_optimization> [Accessed: 13-Jan-2016]
[^fn2]: J. Rising, "Theoretical Computer Science: What is QUBO?," [Online]. Available: <https://www.quora.com/Theoretical-Computer-Science/What-is-QUBO-quadratic-unconstrained-binary-optimization> [Accessed: 13-Jan-2016]
[^fn3]: "De Broglie–Bohm theory," [Online]. Available: <https://en.wikipedia.org/wiki/De_Broglie%E2%80%93Bohm_theory#Quantum_trajectory_method> [Accessed: 17-Jan-2016]
[^fn4]: "Partition problem", [Online]. Available: <https://en.wikipedia.org/wiki/Partition_problem> [Accessed: 18-Jan-2016]
[^fn5]: "Tianhe-2," [Online]. Available: <https://en.wikipedia.org/wiki/Tianhe-2> [Accessed: 18-Jan-2016]