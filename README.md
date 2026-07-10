# Vehicle Routing Problem (CVRP) in MATLAB

## Overview

This project implements a solution for the **Capacitated Vehicle Routing Problem (CVRP)** using MATLAB.

The project first generates an initial feasible solution with a **Greedy algorithm**, then improves it using the **Simulated Annealing (SA)** metaheuristic. In addition, an AI-generated solution can be validated and evaluated using a separate verification module.

---

## Problem Description

The objective of the Capacitated Vehicle Routing Problem is to determine the optimal routes for a fleet of vehicles such that:

- Every customer is visited exactly once.
- Every vehicle starts and ends at the depot.
- Vehicle capacity constraints are satisfied.
- The total travel distance is minimized.

---

## Algorithms Used

### Greedy Algorithm

- Generates a fast initial feasible solution.
- Selects the nearest feasible customer at each step.
- Provides a good starting point for optimization.

### Simulated Annealing (SA)

- Improves the initial Greedy solution.
- Explores neighboring solutions.
- Uses a temperature parameter to escape local optima.
- Applies three neighborhood operators:
  - Relocate
  - Swap
  - 2-opt

---

## AI Solution Verification

The project also includes a module that verifies AI-generated routes.

The verification process checks:

- Route structure
- Vehicle capacity constraints
- Missing customers
- Duplicate customers
- Invalid nodes

Finally, the true routing cost is computed and the routes are visualized.

---

## Project Structure

```
run_vrp_A32.m          Main program
read_vrp_tsplib.m      Reads TSPLIB dataset
distmat_euc2d.m        Computes Euclidean distance matrix
initial_greedy_cvrp.m  Generates initial Greedy solution
cvrp_cost.m            Computes routing cost
sa_cvrp.m              Simulated Annealing optimization
plot_routes.m          Route visualization
verify_ai_solution.m   AI solution verification
AI.m                   Runs AI verification
```

---

## Dataset

The project uses the **A-n32-k5** benchmark instance from the TSPLIB Vehicle Routing Problem library.

---

## Results

| Method | Cost |
|--------|------:|
| Greedy | 1146.40 |
| Simulated Annealing | 768.44 |
| AI Solution | 933.79 |

The Simulated Annealing algorithm significantly improves the initial Greedy solution while satisfying all CVRP constraints.

---

## How to Run

### Run the optimization

```matlab
run_vrp_A32
```

### Verify an AI-generated solution

```matlab
AI
```

---

## Requirements

- MATLAB R2025a (or compatible version)

---

## Author

## Initial Solution (Greedy)

![Initial Solution](images/initial_solution.png)

---

## Optimized Solution (Simulated Annealing)

![SA Solution](images/sa_solution.png)

---

## AI Generated Solution

![AI Solution](images/ai_solution.png)
**Pardis Eshghinejad**

Master's Student in Computer Engineering (Artificial Intelligence)
