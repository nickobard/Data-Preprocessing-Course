# Data Preprocessing — Homework 1

This project is the first homework assignment from the **Data Preprocessing** course. It explores validation and cleaning of [The Metropolitan Museum of Art Open Access dataset](https://github.com/metmuseum/openaccess), with emphasis on data consistency, integrity, missing values, feature preparation, and information extraction from text.

The complete analysis, implementation, visualizations, and outputs are available in [`01_homework.ipynb`](01_homework.ipynb).

## Assignment

The objective was to clean and prepare the Met Objects dataset by completing the following tasks:

1. Download the `MetObjects.csv` dataset from The Met Open Access repository.
2. Check the consistency of at least three features, including `Object Name`, and propose suitable cleaning methods.
3. Check an integrity constraint between at least two related features.
4. Convert at least five features to suitable data types, including numeric, categorical, and datetime representations.
5. Detect and interpret outliers using an appropriate method.
6. Detect missing data in at least three features and impute at least one feature using a non-trivial method.
7. Clean and encode the `Medium` feature for possible use with a k-nearest neighbours classifier.
8. Extract object height, width, and depth in centimetres from the free-text `Dimensions` feature.

All decisions, methods, and findings were required to be explained in Markdown cells and supported by visualizations where appropriate. The assignment was worth 20 points.

## Work summary

### Dataset preparation

The source dataset contains 484,956 museum objects and 54 columns. Artist attributes are stored as pipe-separated lists, so the data was transformed into two related tables:

- `objects.csv` — one row per museum object;
- `artists.csv` — artist and constituent records in long format, linked through `Object ID`.

Because concatenated constituent IDs have no delimiter, an `Artist ID` is assigned only when an object has a single constituent. Helper columns preserve the constituent count and original list order.

### Main results

| Area | What was done | Main finding |
| --- | --- | --- |
| Consistency | Examined `Object Name`, `AccessionYear`, and `Gallery Number` using case, whitespace, punctuation, format, and frequency checks. | About 5% of unique object names changed under the proposed normalization. Accession years mix years and complete dates, while 37 gallery entries use names instead of numbers. |
| Integrity | Compared artist begin and end years and checked historically plausible ranges. | Future years, reversed lifespans, zero-length lifespans, and implausibly long lifespans were identified. Negative years were retained as valid BCE dates. |
| Data types | Converted gallery number and artist role to nominal categories, accession year and artist years to nullable integers, and complete artist dates to Python `datetime` values. | The selected columns gained representations appropriate for analysis while retaining missing values and pre-1970 dates. |
| Outliers | Analyzed `Object Begin Date` and `Object End Date` with box plots, violin plots, histograms, and contextual inspection. | Ancient negative dates can be valid, whereas future dates are errors. Some future values appear repairable as typing mistakes, such as `2870` instead of `1870`. |
| Missing values | Investigated `Artist Prefix`, `Classification`, and `Tags`; normalized alternative missing-value markers. | Empty prefixes, symbols such as `?`, and `(not assigned)` classifications were converted to proper missing values. |
| Imputation | Enriched artist records through the Wikidata API using entity type and sex-or-gender properties. | Wikidata exposed people, companies, groups, and non-binary identities and reduced unresolved gender values among identified humans to 728. |
| `Medium` cleaning | Applied normalization, tokenization, stop-word removal, spellchecking, lemmatization, frequency filtering, and sparse multi-hot encoding. | 65,907 raw values were reduced to 6,424 cleaned tokens. The 300 most frequent features cover almost 90% of token occurrences and occupy about 16.5 MB in sparse form. |
| Dimensions | Built a staged regular-expression pipeline for diameters and one-, two-, or three-dimensional measurements in millimetres, centimetres, metres, and inches. | Height, width, or depth was extracted for 499,741 split dimension records—84.13% of non-missing entries. |

### Wikidata-assisted imputation

The notebook uses Wikidata rather than assuming every artist without a `Female` label is male. This matters because constituent records also include factories, businesses, collectives, and other organizations.

![Example of gender information retrieved from Wikidata](img/art_gen_imp_example_1.png)

Retrieved API data is cached in `wiki_api_data.csv`, so the expensive collection step does not need to be repeated for ordinary notebook use.

## Repository structure

```text
.
├── 01_homework.ipynb
├── artists.csv
├── img
│   └── art_gen_imp_example_1.png
├── MetObjects.txt
├── objects.csv
├── spellcheck_lemmatized.pickle
└── wiki_api_data.csv
```

| File | Purpose |
| --- | --- |
| `01_homework.ipynb` | Executed notebook containing the assignment and solution. |
| `MetObjects.txt` | Local copy of the original Met Objects CSV dataset. |
| `objects.csv` | Object-level table produced during preprocessing. |
| `artists.csv` | Exploded artist/constituent table produced during preprocessing. |
| `wiki_api_data.csv` | Cached Wikidata responses used for imputation. |
| `spellcheck_lemmatized.pickle` | Cached spellchecking and lemmatization mapping for `Medium`. |
| `img/art_gen_imp_example_1.png` | Example of Wikidata information used in the notebook. |


## Notes and limitations

- The analysis intentionally distinguishes unusual but plausible historical data from actual errors; for example, BCE object dates are not automatically treated as outliers to remove.
- Spellchecking can incorrectly change valid names, foreign words, or specialist material terms, so its output should be reviewed before production use.
- The 300-feature `Medium` representation is a practical compromise. A smaller feature set may still be necessary for kNN because prediction retains and compares many training samples.
- Dimension strings are highly irregular. The staged parser covers most records, but malformed values and descriptions with more than three measurements remain unresolved.
