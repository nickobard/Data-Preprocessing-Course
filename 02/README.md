# Data Preprocessing — Homework 2 (Incomplete)

This directory contains an **unfinished attempt** at the second homework assignment from the Data Preprocessing course. The assignment concerns preprocessing an imbalanced binary-classification dataset through binning, class balancing, feature engineering, feature selection, and dimensionality reduction.

Only the initial exploration, dataset split, Linear SVM baseline, and part of the statistical investigation for binning were completed. The README distinguishes implemented work from planned but unimplemented sections so that the presence of an assignment heading in the notebook is not mistaken for a finished solution.

## Assignment

The objective was to improve prediction of whether a policyholder would file an automobile-insurance claim in the following year. The target is `y`; predictor meanings are hidden, while suffixes identify binary (`_bin`) and categorical (`_cat`) variables. A value of `-1` represents missing data.

The complete assignment requested:

1. Split the data correctly into training, validation, and test sets.
2. Choose at least one classification algorithm as a baseline.
3. Compare at least two binning methods.
4. Compare at least two class-balancing methods, applied only to the appropriate dataset partition.
5. Transform existing features and engineer new ones.
6. Compare at least two automatic feature-selection methods without PCA.
7. Apply PCA and discuss the effect of the number of components.
8. Compare the original pipeline with the best preprocessing combination on the held-out test set.

The full assignment was worth 30 points. This project does **not** complete all of these requirements.

## Completion status

| Requirement | Status | What is present |
| --- | --- | --- |
| Dataset inspection and splitting | **Completed** | Loaded 595,212 rows with 57 predictors and one target. Created reproducible 80/10/10 training, validation, and test partitions using `random_state=42`. |
| Classification algorithm | **Partially completed** | Linear and RBF SVM decision boundaries were visualized on synthetic data. A `LinearSVC` baseline was tuned over ten values of `C`; the RBF model was not trained or evaluated on the project dataset. |
| Two binning methods | **Not completed** | Equal-width and equal-frequency binning are described, but neither method is implemented and no classifier comparison is produced. Supervised binning is only a heading. |
| Two balancing methods | **Not completed** | The class distribution is inspected, but the section ends with `# TODO`; no resampling method or evaluation is implemented. |
| Transformations and feature engineering | **Not completed** | One-hot encoding and standardization are mentioned, but the section contains only `# TODO`. |
| Two feature-selection methods | **Not completed** | The section contains only `# TODO`. |
| PCA | **Not completed** | The section contains only `# TODO`. |
| Final model comparison | **Not completed** | No final pipeline is selected and the held-out test set is not used for a final comparison. |

## Work completed

### Data inspection and split

`data.csv` contains 595,212 observations and 58 columns. All columns are numeric at load time: 48 are integer-valued and 10 are floating-point. The notebook separates the data as follows:

| Partition | Rows | Predictors |
| --- | ---: | ---: |
| Training | 476,169 | 57 |
| Validation | 59,521 | 57 |
| Test | 59,522 | 57 |

The target is strongly imbalanced:

| Class | Rows | Approximate share |
| --- | ---: | ---: |
| `0` — no claim | 573,518 | 96.36% |
| `1` — claim | 21,694 | 3.64% |

### Linear SVM baseline

A `LinearSVC` model was trained for ten `C` values. The notebook reports a best training accuracy of 0.9637 and validation accuracy of 0.9628—that is, approximately 96.37% and 96.28%, despite the output labels incorrectly including a percent sign after the fractional values.

Accuracy alone is not informative enough here: predicting only the majority class would achieve approximately 96.36% accuracy on the full dataset. The notebook recognizes that an imbalance-aware metric such as F-score is needed, but precision, recall, F-score, PR-AUC, and confusion matrices were not calculated. Consequently, the baseline does not demonstrate useful detection of claim cases.

### Exploratory analysis for binning

The notebook identifies 26 features whose names do not end in `_cat` or `_bin` and treats them as numeric binning candidates. It then:

- counts unique values to distinguish low- and high-cardinality predictors;
- runs one-sample Kolmogorov–Smirnov tests against fitted uniform distributions;
- compares KS statistics and visualizes selected feature histograms;
- inspects box plots for features with high KS statistics;
- discusses using features above the median KS statistic as possible equal-width binning candidates.

All tested features produce p-values reported as zero on this large dataset, so the notebook uses KS statistics only as an exploratory ranking. This analysis does not progress to fitted binning transformations or downstream model evaluation.

## Supporting experiments

Two separate notebooks investigate statistical tests considered for choosing binning candidates. These are exploratory studies and are **not integrated into a completed preprocessing pipeline**.

### `kolmogorov_smirnov_test.ipynb`

This notebook verifies how SciPy's Kolmogorov–Smirnov goodness-of-fit test should be configured for a uniform distribution outside the default interval `[0, 1]`. It demonstrates three valid approaches:

1. rescaling observations to `[0, 1]`;
2. passing the distribution's `loc` and `scale` parameters;
3. comparing the observations with a separately sampled reference distribution.

For the generated uniform sample, the correctly configured one-sample test returns statistic `0.02996` and p-value `0.32438`, while the two-sample comparison returns statistic `0.047` and p-value `0.21940`. In both cases, the experiment does not reject the uniform-distribution hypothesis.

### `diptest.ipynb`

This notebook explores Hartigan's dip test, whose null hypothesis is unimodality. It confirms expected behavior for synthetic normal and bimodal samples and examines sensitivity to a small secondary mode.

The test rejects unimodality for balanced and 95/5 bimodal samples. With a secondary mode containing 0.2% of observations, the reported p-value rises to approximately `0.0702`; at 0.1%, it rises to approximately `0.9681`. The experiment therefore shows that detectability depends strongly on the relative size of the secondary mode. The dip-test results were not subsequently added to the main notebook's feature table.

## Repository structure

```text
.
├── 02_homework.ipynb
├── data.csv
├── diptest.ipynb
├── kolmogorov_smirnov_test.ipynb
├── README.md
└── utils.py
```

| File | Purpose |
| --- | --- |
| `02_homework.ipynb` | Main, unfinished homework notebook. |
| `data.csv` | Binary-classification dataset used by the homework. |
| `diptest.ipynb` | Synthetic experiments with Hartigan's dip test for unimodality. |
| `kolmogorov_smirnov_test.ipynb` | Synthetic experiments validating use of SciPy's KS test. |
| `utils.py` | Helper used to visualize classifier decision boundaries. |

## Known limitations

- The main assignment is incomplete and will remain incomplete; the TODO sections are retained as a record of intended work.
- The validation process uses accuracy despite severe target imbalance, and no minority-class metric is reported.
- The baseline tuning does not explicitly preserve target proportions with stratified splitting.
- The KS test is used as a heuristic ranking against uniformity, but non-uniformity alone does not establish that binning will improve classification.
- The test set was created correctly but never used for a final unbiased evaluation.
