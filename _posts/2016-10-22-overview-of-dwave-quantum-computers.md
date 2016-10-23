---
title: Overview of D-Wave Quantum Computers and Optimization
date:   2016-10-22
cover:  /media/dwave-chip_cover.jpg
thumb:  /media/dwave-chip_thumb.jpg
tags: [qmc]
---

From January until late August of 2016, I pursued undergraduate research on simulating physical quantum annealing with a normal (classical) computer. The methods that I tried didn't work out, but it was a pretty interesting journey. By the end, I had learned how to learn from research papers, a great deal about quantum mechanics and optimization algorithms, and that I liked building research tools a lot more than using them for research.

In this post I'm going to give an overview about D-Wave, quantum annealing, heuristic optimization algorithms, and then touch on what I was researching exactly.

In a later post I'll share my full research, but for now, let's talk about quantum computers.

<!--More-->

# D-Wave Quantum Computers vs Quantum Computers
D-Wave sells their product as a "quantum computer." This is a source of a lot of confusion for some people because of phrases like "Quantum computers will completely negate RSA," which a D-Wave machine does not do.

D-Wave machines are *quantum annealers*, that is, a special purpose quantum computer that is capable of solving some important problems, but not capable of running quantum algorithms like Shor's algorithm, or Grover's. Those algorithms require quantum logic gates, which I won't get into here.

* [Quantum Annealing on Wikipedia](https://en.wikipedia.org/wiki/Quantum_annealing)
* [D-Wave Systems](www.dwavesys.com)

## What do Quantum Annealers do then?
Quantum annealers solve problems that can be modeled with an ising [spin glass](https://en.wikipedia.org/wiki/Spin_glass) and embedded into the computer. This includes a lot of hard problems like traveling salesman, number partitioning problem, and really any quadratic uncontrained binary optimization (QUBO) problems.

The current D-Wave computers are hardware versions of QUBO with K = 2, meaning that it runs with single and two-spin interactions, but not more yet.

*The embedding problem is part of why D-Wave is focused on producing computers with more and more qubits -- you need a lot of qubits to solve useful problems. Further, D-Wave machines are (currently) working with a planar arrangement of qubits, which limits the amount of connectivity available, meaning that sometimes several qubits are needed to represent a single spin in the source problem.*

So quantum annealers find the ground state configuration and energy of a frustrated ising spin glass. According to some pretty solid research, they do this really fast, but not the way that computer scientists generally talk about fast, so this is another of those points of confusion.

### Are they Fast? Pre-Factors and Asymptotic Scaling
In Google's 2015 paper characterizing a D-Wave 2X, it was found that the D-Wave machine solved *problems that were designed for it to be great at* really really well. It isn't like they tried to pass this off as a normal problem either, they wanted to show a limiting case, and it was great. What was *super* interesting though, was that the physical quantum annealer (The D-Wave computer) scaled the exact same way as a heuristic algorithm based on the same theories - the path-integral quantum Monte Carlo (PI-QMC, or PIMC). So as far as asymptotic notation is concerned, they both had the same scaling.

But what about prefactors? Do they matter? They *can* matter.

Mergesort scales better than quicksort, yet quicksort frequently runs faster because it has a much better prefactor. The Google paper found that the prefactor on the D-Wave machine was around $$10^8$$, which is enormous. It is also worth noting that a great time of the time spent is spent on getting the problem into the computer and getting the results back out -- areas that I imagine D-Wave engineers are going to seriously improve on in the next few years.

If you want to read more about it, I wrote a summary of Google's paper and have it posted [here](http://ezrasavard.com/posts/computational-value-quantum-tunneling/), or you can find it [on arxiv](https://arxiv.org/abs/1512.02206v3).

# Heuristic Algorithms
Heuristic algorithms solve hard problems without taking forever. They are focused on finding "good enough" solutions, and can often find exact solutions, especially on smaller problems.

Simulated Annealing (SA) and the path-integral quantum Monte Carlo are classical optimization algorithms that can be applied to general problems without exploiting any knowledge of the problem structure. Problems are often described by their energy landscapes, which involve many minima and maxima.

<img alt="Energy Landscapes" src="{{site.baseurl}}/media/energy-landscape.png">

These large energy-hills between local minima are sometimes called barriers. The global minimum, or something close to it, is the target of the search in the cases I'm talking about in this post.
 
## Simulated Annealing
By mimicking the thermal process of the same name, SA searches for a global minimum by using excitation to travel over barriers in the configuration space. The solver excites less and less as time goes on and eventually freezes in place.

## Path-Integral Quantum Monte Carlo
Essentially a simulation of quantum annealing, PI-QMC performs random spin-flips across the configuration space, but allows parallel duplicates of the configuration space to interact with each other. Instead of just temperature, PI-QMC uses a tranverse field to encourage tunneling across barriers. As time goes on, two effects occur:

1. The tranverse field weakens, slowing down the rate of tunneling
2. The duplicate configurations interact more strongly

<img alt="Quantum Annealing in a Landscape" src="{{site.baseurl}}/media/qa-plot.jpg">

By the end of the process, the system pulls together into a single configuration they mostly "agree" on.

The path integral QMC is often used to solve quantum mechanical many-body problems at non-zero temperatures.

The path-integral part of PI-QMC relates to the transformation of a *d* dimensional quantum Hamiltonian to a *d + 1* dimensional classical Hamiltonian, but I'll save those equations for another post.

# My Research
My research centered on using a path integral quantum Monte Carlo solver to try and simulate the results we were getting back from D-Wave for some particular problems.

## My Solvers
I started writing my own solvers, rather than using existing ones, so I could pull information from the solver mid-process, which was useful for understanding what was going on under-the-hood and exploring relationships with the physical simulation data.

I ended up writing a PI-QMC in Python and later re-writing in C for speed reasons, allowing me to produce a lot more test data. The originals are on GitHub, but are not exactly user friendly. The simulated annealing algorithm is super basic and the PI-QMC is based [on research by Martonak et al.](http://journals.aps.org/prb/abstract/10.1103/PhysRevB.66.094203), but they didn't provide any code.

If you just want a fast Monte Carlo solver, download [CASINO](https://vallico.net/casinoqmc/what-is-casino/) or some other major project and have at it. My solvers are not optimized and are more useful for being readable, as I learned a great deal by writing them and wanted to share that with others. So if you would like to hack around with some solvers, have at it!

[My PI-QMC Repo](www.github.com/ezrasavard/qmc)

On top of CASINO and my own code for solvers, the [spinglass server](http://www.informatik.uni-koeln.de/spinglass/) is a great source of problem data with solutions.


## Results
The original goal was to try and simulate the results of the physical quantum annealer on a classical computer and that did not work out. It might be possible with more work, but my work did not achieve it.

I *did* replicate results comparing different heuristic solvers for speed on solving ising spin problems, and that was pretty exciting, especially considering that I had never written anything like this before.

In the near future, I'll face down the challenge of re-formatting my research paper so that it can be easily read. In the meantime, [this](	http://hdl.handle.net/2429/58266) is what I wrote in the middle of my research, before it became my full-time job.