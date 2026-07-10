<img src="https://fit.cvut.cz/static/images/fit-cvut-logo-en.svg" alt="FIT CTU logo" height="200">

This software was developed with the support of the **Faculty of Information Technology, Czech Technical University in Prague**.
For more information, visit [fit.cvut.cz](https://fit.cvut.cz).


# Data Preprocessing

This repository contains coursework from the **Data Preprocessing** course. The course focuses on turning raw, inconsistent, or unstructured data into reliable representations suitable for analysis and machine learning.

The projects cover practical preprocessing problems such as data validation, cleaning, missing values, outlier detection, class imbalance, feature transformation, text processing, and dimensionality reduction. Practical course materials are available in the [Data Preprocessing Course repository](https://github.com/nickobard/Data-Preprocessing-Course).

## Projects

| Project | Topic | Status |
| --- | --- | --- |
| [Homework 1 — Data validation and cleaning](01/README.md) | Cleaning The Metropolitan Museum of Art Open Access dataset, Wikidata-assisted imputation, text preprocessing, and extraction of physical dimensions. | **Completed** |
| [Homework 2 — Balancing, transformations, and dimensionality reduction](02/README.md) | Initial exploration of an imbalanced insurance-claim dataset, an SVM baseline, and statistical experiments intended to support binning. | **Incomplete** |

## Homework 1 — Data validation and cleaning

The first project processes [The Metropolitan Museum of Art Open Access dataset](https://github.com/metmuseum/openaccess), containing 484,956 museum objects and 54 original columns.

The completed work includes:

- splitting object and artist information into related tables;
- consistency analysis of object names, accession years, and gallery numbers;
- integrity checks between artist birth and death dates;
- conversion of numeric, categorical, and datetime features;
- contextual analysis of date outliers, including valid BCE values;
- detection and normalization of alternative missing-value representations;
- imputation of artist gender and entity information using Wikidata;
- cleaning and sparse multi-hot encoding of the `Medium` feature;
- extraction of height, width, and depth from free-text dimension descriptions.

The `Medium` preprocessing reduced 65,907 raw values to 6,424 cleaned tokens and selected 300 frequent sparse features. The regular-expression dimension pipeline extracted at least one physical dimension from 84.13% of non-missing split records.

See the [Homework 1 README](01/README.md) for the assignment, methods, results, setup instructions, and limitations.

## Homework 2 — Balancing, transformations, and dimensionality reduction

The second project was intended to improve binary classification of automobile-insurance claims through binning, class balancing, feature engineering, feature selection, and PCA. This work is **unfinished and will remain unfinished**.

The implemented portion includes:

- inspection of a dataset with 595,212 observations and 57 predictors;
- a reproducible 80/10/10 training, validation, and test split;
- visualization of Linear and RBF SVM decision boundaries on synthetic data;
- tuning of a Linear SVM baseline;
- inspection of the severe target imbalance;
- exploratory ranking of numeric features using Kolmogorov–Smirnov statistics;
- separate synthetic experiments with the Kolmogorov–Smirnov and Hartigan dip tests.

The required binning comparison, balancing methods, feature engineering, feature selection, PCA, and final held-out test comparison were **not implemented**. The reported validation accuracy is also insufficient for evaluating the minority class because a majority-only classifier achieves approximately the same accuracy.

See the [Homework 2 README](02/README.md) for an explicit requirement-by-requirement completion table and details of the supporting experiments.

## Course scope

The course introduces the role of preprocessing in knowledge discovery and covers methods for extracting useful information from structured and unstructured sources.

Main topics include:

1. KDD and CRISP-DM standards, data-mining software, exploration, and visualization.
2. Feature significance, data representation, validation, and cleaning.
3. Missing values, date handling, and conversion of non-numeric data.
4. Discretization, outliers, transformations, sampling, and class balancing.
5. Data reduction using nearest-neighbour methods, Tomek links, and SMOTE.
6. Dimensionality reduction and representation methods, including PCA, ICA, and LDA.
7. Preprocessing and feature extraction for time series and text.
8. Image preprocessing, filtering, segmentation, and feature extraction.

## Repository structure

```text
.
├── 01
│   ├── 01_homework.ipynb
│   ├── README.md
│   ├── artists.csv
│   ├── img
│   │   └── art_gen_imp_example_1.png
│   ├── MetObjects.txt
│   ├── objects.csv
│   ├── spellcheck_lemmatized.pickle
│   └── wiki_api_data.csv
├── 02
│   ├── 02_homework.ipynb
│   ├── README.md
│   ├── data.csv
│   ├── diptest.ipynb
│   ├── kolmogorov_smirnov_test.ipynb
│   └── utils.py
└── scripts
    └── update_requirement.sh
```

Each project directory contains its own README with environment setup and execution instructions. The notebooks use paths relative to their respective directories, so launch Jupyter from inside the selected project directory.
