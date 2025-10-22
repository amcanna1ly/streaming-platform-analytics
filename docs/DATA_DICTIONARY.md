# Data Dictionary (Dashboard 1 inputs)

## avg_rt_by_platform.csv

- Rows: 4
- Columns: 3

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 4 | 0 | Hulu, Disney+, Netflix, Prime Video |
| AVG_RT_CRITIC | float64 | 4 | 0 | 60.4, 58.31, 54.45, 50.4 |
| N_TITLES | int64 | 4 | 0 | 1047, 922, 3688, 4113 |

## highest_rated_per_year_platform.csv

- Rows: 317
- Columns: 4

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 317 | 0 | Disney+, Hulu, Netflix, Prime Video |
| RELEASE_YEAR | int64 | 317 | 0 | 1922, 1923, 1928, 1932, 1933 |
| TITLE | object | 317 | 0 | Robin Hood, The Hunchback of Notre Dame, Steamboat Willie, Flowers and Trees, Three Little Pigs |
| RATING_VALUE | int64 | 317 | 0 | 58, 60, 64, 56, 62 |

## rating_distribution_bins.csv

- Rows: 35
- Columns: 3

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 35 | 0 | Disney+, Hulu, Netflix, Prime Video |
| BIN_START | int64 | 35 | 0 | 10, 30, 40, 50, 60 |
| TITLES | int64 | 35 | 0 | 13, 41, 207, 253, 208 |

## titles_per_platform.csv

- Rows: 4
- Columns: 2

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 4 | 0 | Prime Video, Netflix, Hulu, Disney+ |
| TITLES_ON_PLATFORM | int64 | 4 | 0 | 4113, 3695, 1047, 922 |

## top10_by_platform.csv

- Rows: 40
- Columns: 4

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 40 | 0 | Disney+, Hulu, Netflix, Prime Video |
| TITLE | object | 40 | 0 | Mary Poppins, Avengers: Endgame, Avengers: Infinity War, Guardians of the Galaxy, Soul |
| RELEASE_YEAR | int64 | 40 | 0 | 1964, 2019, 2018, 2014, 2020 |
| RATING_VALUE | int64 | 40 | 0 | 96, 90, 89, 88, 94 |


# Data Dictionary (Dashboard 2 inputs)

## highest_rated_per_year_platform_dashboard2.csv
- Rows: 317
- Columns: 4

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 317 | 0 | Disney+, Hulu, Netflix, Prime Video |
| RELEASE_YEAR | int64 | 317 | 0 | 1922, 1923, 1928, 1932, 1933 |
| TITLE | object | 317 | 0 | Robin Hood, The Hunchback of Notre Dame, Steamboat Willie, Flowers and Trees, Three Little Pigs |
| RATING_VALUE | int64 | 317 | 0 | 58, 60, 64, 56, 62 |

## rating_distribution_bins_dashboard2.csv
- Rows: 35
- Columns: 3

| Column | Dtype | Non-Null | Nulls | Sample values |
|---|---|---:|---:|---|
| PLATFORM | object | 35 | 0 | Disney+, Hulu, Netflix, Prime Video |
| BIN_START | int64 | 35 | 0 | 10, 30, 40, 50, 60 |
| TITLES | int64 | 35 | 0 | 13, 41, 207, 253, 208 |
