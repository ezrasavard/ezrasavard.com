---
layout: post
title: Simulating a D-Wave Quantum Computer
tags: [qmc]
---

# Simulating a D-Wave Quantum Computer

## Quantum Computers vs Quantum Computers
D-Wave sells their product as a quantum computer. This is a source of a lot of confusion for some people because of phrases like "Quantum computers will completely negate RSA," which a D-Wave machine would not.

D-Wave machines are quantum annealers, that is, a special purpose quantum computer that is capable of solving some important problems, but not quantum algorithms like Shore's or... I forgot the other. Those require quantum logic gates, which I won't get into here.

## What do Quantum Annealers do then?
Quantum annealers solve problems that can be modeled with an ising spin glass and embedded into the computer. This includes a lot of hard problems like traveling salesman, MAXCUT, number partitioning problem, and really any quadratic uncontrained binary optimization problem that only requires two-spin interactions.

aside --

The embedding problem is part of why D-Wave is focused on producing computers with more and more qubits -- you need a lot of qubits to solve useful problems. Further, D-Wave machines are (currently) working with a planar arrangement of qubits, which limits the amount of connectivity available, meaning that sometimes several qubits are needed to represent a single spin in the source problem.

--

So quantum annealers find the ground state configuration and energy of a frustrated ising spin glass. According to some pretty solid research, they do this really fast, but not the way that computer scientists generally talk about fast, so this is another of those points of confusion.

### Are they Fast? Pre-Factors and Asymptotic Scaling
In Google's 2015 paper characterizing a D-Wave 2X, it was found that the D-Wave machine solved *problems that were designed for it to be great at* really really well. It isn't like they tried to pass this off as a normal problem either, they wanted to show a limiting case, and it was great. What was *super* interesting though, was that the physical quantum annealer (The D-Wave computer) scaled the exact same way as a heuristic algorithm based on the same theories - the path-integral quantum monte carlo (PI-QMC, or PIMC). So as far as asymptotic notation is concerned, they both scaled the same.

But what about prefactors? Do they matter? They *can* matter.

Mergesort scales better than quicksort, yet quicksort is the default sorting algorithm used in many standard libraries. It *usually* runs faster because it has a much better prefactor than mergesort. The Google paper found that for their limiting case problem and a few others, the prefactor on the DWave machine was around 10^8, which is enormous.

Because of the aforementioned embedding problem, a D-Wave device of this style will always be limited in the size of the problems it can represent by the number of available qubits, currently around 2000 (fabrication isn't flawless, so sometimes not all of them work).

That paper has a lot of great information in it. I've written a summary of it as part of research, available here, or you can find the original on arxiv.

## Heuristic Algorithms
Copy in some background from my papers.

## My Research
My research centered on using a path integral quantum monte carlo solver to try and simulate the results we were getting back from D-Wave for some particular problems.

### My Solvers
I started writing my own solvers, rather than using existing ones, so I could pull information from the solver mid-process, which was useful for understanding what was going on under-the-hood and exploring relationships with the physical simulation data.

link to some background on QCA.

I ended up writing a PIQMC in Python and later re-writing in C for speed reasons, allowing me to produce a lot more test data. The originals are on GitHub, but are not exactly user friendly, which is why I re-wrote them (available here). The simulated annealing algorithm is super basic and the PIQMC is based on research by Martonak et al., but they didn't provide any code.

If you just want a fast monte carlo solver, download CASINO or some other major project and have at it. My solvers are not optimized and are written for readability as more of a learning tool, as I learned a great deal by writing them and wanted to share that with others.

If you would like to hack around with some solvers, have at it! =)

### My Results
The original goal was to try and simulate the results of the physical quantum annealer on a classical (normal) computer and that did not work out. It might be possible with more work, but my work did not achieve it.

I did replicate well known results comparing different heuristic solvers for speed on solving ising spin problems, and that was pretty exciting, especially considering that I had never written anything like this before.
