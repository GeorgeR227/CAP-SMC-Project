# CAP-SMC-Project
This is our class project for Strategic Minds Collective.

## The Idea

This project is meant as an investigation into the idea of coalition games and the fairness of the core. Namely, we focus on the situation that the core may contain "unfair" outcomes. An extreme example of this is where one player is able to donate more than other players and due to this leverage is able to completely exclude the other players from the utility gained even though they too contributed to receiving that utility. 

Since the idea of fairness here is quite vague, we seek to employ various different notations of a fair outcome and denote any benefits/challenges to achieving this fairness. Namely we are currently investigating:

* Equal distribution (All players receive an equal amount)
* Shapley value informed (Proportional to the expected marginal contribution)
* More may be added in the future...

In order to achieve better fairness, we implement a mechanism where an external entity may advantage certain players in the hopes of producing a better core. Of course, we limit the amount of advantage that can be offered so as to keep the problem interesting.

With this limitation in mind, we do not expect to always be able to reduce the core to only contain the fairest outcome (indeed this may not even be possible with unlimited resources depending on the underlying payoff calculations). Instead we seek to restrain the core to contain outcomes that are within some distance away from this fairest outcome.

## How to Run

To run this code, please first install Julia at: https://julialang.org/downloads/.

To open this project and download all of the required dependencies, run the following:

```julia
] activate `path to local repo`
instantiate
```

You may then run any of the included `demos` files included by running:

```julia
include("demos/`path to demo`")
```




