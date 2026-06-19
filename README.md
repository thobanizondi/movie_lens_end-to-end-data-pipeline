# movie_lens_end-to-end-data-pipeline
AWS S3 - Snowflake - dbt pipeline | MovieLens dataset | Medallion Architecture | SCD Type 2 | dbt tests
# 🎬 MovieLens End-to-End Data Pipeline

> A production-grade data engineering pipeline ingesting MovieLens data from **AWS S3** into **Snowflake**, transformed with **dbt** using Medallion Architecture featuring incremental models, SCD Type 2 snapshots, and automated data quality testing.

![dbt](https://img.shields.io/badge/dbt-1.11.11-orange?logo=dbt)
![Snowflake](https://img.shields.io/badge/Snowflake-Cloud-29B5E8?logo=snowflake)
![AWS S3](https://img.shields.io/badge/AWS-S3-FF9900?logo=amazonaws)
![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Data Sources](#data-sources)
- [Data Models](#data-models)
- [Pipeline Layers](#pipeline-layers)
- [dbt Features Used](#dbt-features-used)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Running the Pipeline](#running-the-pipeline)
- [Data Quality Tests](#data-quality-tests)
- [Snapshots](#snapshots)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This project implements a full end-to-end data pipeline using the **MovieLens dataset** — a widely used benchmark dataset containing movie ratings, tags, and genome scores. The pipeline follows modern data engineering best practices:

- Raw data is stored in **AWS S3**
- Data is loaded into **Snowflake** as the cloud data warehouse
- **dbt** handles all transformations across a structured Medallion Architecture
- Data quality is enforced through **23 automated dbt tests**
- Historical tracking is handled via **SCD Type 2 snapshots**

---

## Architecture

```
AWS S3 (Raw CSV Files)
        │
        ▼
Snowflake RAW Schema
        │
        ▼
dbt Transformations
        │
   ┌────┴────┐
   │         │
STAGING     STAGING
   │
   ├──► DIM (Dimension Tables)
   │
   ├──► FACT (Fact Tables)
   │
   └──► MART (Data Mart)
```

**Medallion Architecture Layers:**

| Layer | Schema | Purpose |
|-------|--------|---------|
| Bronze | `RAW` | Raw data loaded from AWS S3 |
| Silver | `STAGING` | Cleaned and typed staging models |
| Gold | `DIM / FACT / MART` | Business-ready dimension, fact, and mart tables |

---

## Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.12 | Data ingestion scripts |
| AWS S3 | — | Raw data storage |
| Snowflake | — | Cloud data warehouse |
| dbt | 1.11.11 | Data transformation framework |
| dbt-snowflake | 1.11.5 | Snowflake adapter for dbt |
| dbt_utils | 1.3.0 | dbt utility macros |

---

## Project Structure

```
movie-lens-end-to-end-data-pipeline/
│
├── movielens_dbt/                  # dbt project root
│   ├── models/
│   │   ├── staging/                # Silver layer — cleaned source models
│   │   │   ├── stg_movies.sql
│   │   │   ├── stg_ratings.sql
│   │   │   ├── stg_tags.sql
│   │   │   ├── stg_links.sql
│   │   │   ├── stg_genome_tags.sql
│   │   │   └── stg_genome_scores.sql
│   │   ├── dim/                    # Dimension tables
│   │   │   ├── dim_movies.sql
│   │   │   ├── dim_users.sql
│   │   │   └── dim_genome_tags.sql
│   │   ├── fact/                   # Fact tables
│   │   │   ├── fact_ratings.sql
│   │   │   └── fact_genome_scores.sql
│   │   └── mart/                   # Data mart layer
│   │       └── mart_movie_releases.sql
│   ├── snapshots/                  # SCD Type 2 snapshots
│   ├── seeds/                      # Static reference data
│   ├── macros/                     # Custom dbt macros
│   ├── tests/                      # Custom data tests
│   ├── analyses/                   # Ad-hoc analyses
│   ├── dbt_project.yml             # dbt project configuration
│   ├── packages.yml                # dbt package dependencies
│   └── schema.yml                  # Model documentation and tests
│
└── README.md
```

---

## Data Sources

The pipeline ingests **6 CSV files** from the [MovieLens dataset](https://grouplens.org/datasets/movielens/):

| Source File | Rows | Description |
|-------------|------|-------------|
| `movies.csv` | 27,278 | Movie titles and genres |
| `ratings.csv` | 100,000 | User movie ratings (0.5–5.0) |
| `tags.csv` | 465,564 | User-generated movie tags |
| `links.csv` | 27,278 | IMDb and TMDb movie links |
| `genome_tags.csv` | 1,128 | Genome tag labels |
| `genome_scores.csv` | 50,000 | Tag relevance scores per movie |

---

## Data Models

### Staging Layer (Silver)

| Model | Rows | Description |
|-------|------|-------------|
| `stg_movies` | 27,278 | Cleaned movie records with parsed genres |
| `stg_ratings` | 100,000 | Typed user ratings with timestamp conversion |
| `stg_tags` | 465,564 | User tag records |
| `stg_links` | 27,278 | IMDb/TMDb external identifiers |
| `stg_genome_tags` | 1,128 | Genome tag labels |
| `stg_genome_scores` | 50,000 | Tag relevance scores |

### Dimension Layer (Gold)

| Model | Rows | Description |
|-------|------|-------------|
| `dim_movies` | 27,278 | Movie dimension with title and genre |
| `dim_users` | 8,464 | Unique user dimension |
| `dim_genome_tags` | 1,128 | Genome tag dimension |

### Fact Layer (Gold)

| Model | Rows | Materialization | Description |
|-------|------|----------------|-------------|
| `fact_ratings` | 100,000 | Incremental | User movie ratings fact table |
| `fact_genome_scores` | 50,000 | Table | Tag relevance scores per movie |

### Mart Layer (Gold)

| Model | Description |
|-------|-------------|
| `mart_movie_releases` | Business-ready movie release analytics mart |

---

## Pipeline Layers

### RAW → STAGING
- Cast raw string columns to correct data types
- Rename columns to snake_case conventions
- Filter out null or invalid records
- Parse timestamps from Unix epoch

### STAGING → DIM / FACT
- Build surrogate keys where needed
- Enforce referential integrity via `relationships` tests
- Apply incremental loading strategy on `fact_ratings`

### FACT → MART
- Aggregate and join across dimensions and facts
- Produce business-ready analytical datasets

---

## dbt Features Used

| Feature | Usage |
|---------|-------|
| **Medallion Architecture** | RAW → STAGING → DIM/FACT → MART |
| **Incremental Models** | `fact_ratings` uses incremental materialization |
| **SCD Type 2 Snapshots** | Historical tracking of slowly changing records |
| **Generic Tests** | `not_null`, `unique`, `relationships`, `accepted_values` |
| **dbt_utils Package** | Utility macros across models |
| **Seeds** | Static reference data loaded into RAW schema |
| **Sources** | Defined and tested source freshness |
| **Documentation** | Full model and column descriptions in `schema.yml` |

---

## Getting Started

### Prerequisites

- Python 3.12+
- Snowflake account with a `TRANSFORM` role and `COMPUTE_WH` warehouse
- AWS S3 bucket with MovieLens CSV files
- Git

### Installation

1. Clone the repository:

```bash
git clone https://github.com/thobanizondi/movie-lens-end-to-end-data-pipeline.git
cd movie-lens-end-to-end-data-pipeline
```

2. Create and activate a virtual environment:

```bash
python -m venv venv
source venv/Scripts/activate  # Windows
# or
source venv/bin/activate       # Mac/Linux
```

3. Install dependencies:

```bash
pip install dbt-snowflake
```

4. Install dbt packages:

```bash
cd movielens_dbt
dbt deps
```

### Configuration

Create your `profiles.yml` at `~/.dbt/profiles.yml`:

```yaml
movielens_dbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      password: <your_password>
      role: TRANSFORM
      database: MOVIELENS
      warehouse: COMPUTE_WH
      schema: RAW
      threads: 1
```

Verify your connection:

```bash
dbt debug
```

### Running the Pipeline

```bash
# Run all models
dbt run

# Run tests
dbt test

# Run seeds
dbt seed

# Run snapshots
dbt snapshot

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

---

## Data Quality Tests

The pipeline enforces **23 automated data quality tests** across all models:

| Test Type | Count | Models Covered |
|-----------|-------|----------------|
| `not_null` | 12 | All dimension and fact models |
| `unique` | 5 | Primary keys across all dims and facts |
| `relationships` | 4 | FK integrity between facts and dims |
| `accepted_values` | 1 | Rating values (0.5–5.0) |
| Custom tests | 1 | Additional business logic |

Run all tests:

```bash
dbt test
```

---

## Snapshots

SCD Type 2 snapshots are implemented to track historical changes in slowly changing dimensions. Snapshots are stored in the `SNAPSHOTS` schema in Snowflake with `dbt_valid_from` and `dbt_valid_to` columns for full historical lineage.

Run snapshots:

```bash
dbt snapshot
```

---

## Results

Latest pipeline run results:

```
PASS=12  WARN=0  ERROR=0  SKIP=0  TOTAL=12
Finished in 22 seconds
```

| Layer | Models | Status |
|-------|--------|--------|
| Staging | 6 | ✅ All passing |
| Dimension | 3 | ✅ All passing |
| Fact | 2 | ✅ All passing |
| Mart | 1 | ✅ All passing |

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the MIT License.

---

<p align="center">Built by <a href="https://linkedin.com/in/thobani-zondi">Thobani Zondi</a> · <a href="https://datascienceportfol.io/thobanizondi">Portfolio</a> · <a href="https://github.com/thobanizondi">GitHub</a></p>
