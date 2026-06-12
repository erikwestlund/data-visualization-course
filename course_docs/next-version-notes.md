# Next Version Notes

## Replace Sensitive Exercise/Eating-Disorder Dataset

Consider moving away from the Blackmore and Davis exercise/eating-disorder dataset in the next course version.

Current file:

- `data/real/blackmore_davis_exercise_eating_disorders.csv`

Reason:

- The eating-disorder context is sensitive and may not be worth the instructional tradeoff when less sensitive repeated-measures or grouped-distribution datasets could teach the same visualization concepts.

Current uses to replace:

- grouped distributions
- repeated observations over age
- grouped trajectories
- distribution comparisons with outliers

Possible replacement characteristics:

- repeated observations by person, place, or group
- a numeric outcome with visible differences across groups
- enough skew or unusual values to support diagnostic discussion
- a low-stakes context such as exercise minutes, sleep, transportation, environmental exposure, appointments, or simulated clinical operations

## Add Plot Combinations

Add a short example showing how to combine multiple plots with `patchwork`.

Possible places:

- communication/polish module
- grab-bag preview
- reusable styling module
