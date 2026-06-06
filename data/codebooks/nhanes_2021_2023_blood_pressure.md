# NHANES 2021-2023 Blood Pressure

Source: CDC/NCHS NHANES August 2021-August 2023 `BPXO_L.xpt`.

Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BPXO_L.htm>

Unit of observation: one NHANES participant eligible for oscillometric blood pressure measurement, age 8+.

Teaching use: repeated measurements, averages, missing readings, distributions, and joins to demographics.

Important caution: readings were collected with a standardized oscillometric protocol. Use exam weights for formal NHANES estimates; unweighted classroom plots are exploratory.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `bp_arm`: arm selected for measurement, `right` or `left`.
- `cuff_size`: cuff size category based on mid-arm circumference.
- `systolic_1`, `systolic_2`, `systolic_3`: systolic readings in mmHg.
- `diastolic_1`, `diastolic_2`, `diastolic_3`: diastolic readings in mmHg.
- `pulse_1`, `pulse_2`, `pulse_3`: pulse readings.
- `systolic_mean`: mean of available systolic readings.
- `diastolic_mean`: mean of available diastolic readings.
- `pulse_mean`: mean of available pulse readings.
- `systolic_n_readings`: number of non-missing systolic readings.
- `diastolic_n_readings`: number of non-missing diastolic readings.
