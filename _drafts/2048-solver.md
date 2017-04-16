---
title: 2048 Solver
date: 2017-04-16
tags: [misc]
---

Out of curiousity, I've been studying some extra computer science through edX.
Most recently, I have been working through the ColumbiaX AI course, which seems
to follow AI AMA pretty closely, at least for the first half. The course has
had a few projects, but I really enjoyed the challenge of writing a search agent
to play 2048.

<!--more-->

2048 is a tile based game that involves shifting around tiles on a board in order
to produce larger powers of two by combining tiles of the same value. The game
becomes increasingly difficult and succeeding in creating a 2048 tile is considered
a win. Some people manage to go quite a lot higher though.

An interesting requirement on this project was a 100ms real-time move limit. This
necessitated searching in a manner that would enable immediate termination, but
still return a reasonable move choice. I chose to address this with an iterative
deepening search (IDS) and a fairly shallow initial search depth.

Another interesting dimension of the project was the depth of the search tree.
It was totally infeasible to reach the bottom of the search tree for most of the
game duration with the real-time limit in place. Ultimately, game states had to be
evaluated through heuristic functions that aimed to define the "goodness" of a
node. Watching a really good 2048 player and playing it myself helped a lot with
defining useful heuristics, which essentially tell the game "how to play" rather
than just "how to win." My heuristics focused on keeping the board tidy and 
using either monotonic rows or columns. Additionally, it tried to cheat one more
layer of depth by rewarding potential block merges and empty space. Some
poor performance was worked out by coding in an additional death flag that made sure
any game-losing node would have a terrible score, no matter how "good" the rest of
the board looked.

The search used was a minimax algorithm, which allows the search agent to choose
moves based on an opponant playing against them as effectively as possible. In
this case, the opponant places a tile in a random location, with a value of 2 or 4,
with 90%/10% probabilities respectively. For simplicity, I treated the opponant as
playing the best possible moves against the player (that is, the ones that would
make the player lose). Alpha-Beta pruning was then used to limit the search space.
Alpha-Beta pruning is a branch and bound algorithm and allowed pruning of branches
that offer a better outcome to the opponant than others that you already can choose.
Since there would be no reason to offer the opponant that option, the entire branch
can be pruned and that time can be spent searching elsewhere.

I've seen some amazing 2048 solvers out there, but this one is not particularly well
optimized. Still, it tends to win fairly regularly (stats?). Here is a video of it in
action =).
