# Streaming Platform Analytics

Analyze movie availability and ratings across Netflix, Hulu, Prime Video, and Disney+ with a normalized relational schema, reproducible SQL, and demo analytics. Includes ready-to-publish Tableau dashboards.

## Highlights
- Clean, normalized schema for titles, platforms, availability, genres, and ratings.
- Idempotent ETL from a staging table into the relational model.
- Demo analytics: platform coverage, overlaps, top titles per platform/year, rating distributions.
- Tableau dashboards for quick storytelling and portfolio-ready visuals.

## Repository layout
```
streaming-platform-analytics/
├─ sql/
│  ├─ 01_schema.sql                  # DDL for Oracle
│  ├─ 02_seed.sql                    # Seeds platforms & rating sources
│  ├─ 03_full_load_from_values.sql   # Simple loader prototype (demo only)
│  └─ 04_transform_from_stage.sql    # Staging->model ETL (final approach)
├─ docs/
│  ├─ SQL_Documentation.md           # Script-by-script explanation
│  └─ REPORT_Short.md                # Condensed report + ERD overview
├─ tableau/
│  ├─ dashboards.twbx                # Packaged Tableau Workbook
│  └─ images/                        # Exported dashboard PNGs for README
├─ images/                           # ERD and diagram exports used in docs
├─ .gitignore
├─ LICENSE
└─ README.md
```

## Oracle SQL Developer - Quickstart
1) Run the DDL to create tables:
```sql
@sql/01_schema.sql
```
2) Seed lookups:
```sql
@sql/02_seed.sql
```
3) Load staging and/or run the staged ETL:
- Option A (prototype demo): `@sql/03_full_load_from_values.sql`  
- Option B (recommended): Create and populate STAGE_MOVIES, then:
```sql
@sql/04_transform_from_stage.sql
```
4) Validate with demo queries (add your own as desired):
```sql
@sql/05_demo_queries.sql
```

Note: Scripts were authored for Oracle. For Postgres/SQLite, replace identity/merge syntax and LISTAGG equivalents.

## Tableau

#### Packaged workbook
The packaged Tableau workbook is included at:
- `tableau/Streaming Platform Analytics.twbx`

You can open this directly in Tableau Desktop or publish to Tableau Public.

### Data files (for Dashboard 2)
Additional CSVs for the Ratings & Trends dashboard are included in `/data`:

- `highest_rated_per_year_platform_dashboard2.csv`
- `rating_distribution_bins_dashboard2.csv`

These support the line charts and distribution visuals in Dashboard 2.

### Data files (for Dashboard 1)
CSVs used for the Platform Overview dashboard are included in `/data`:

- `avg_rt_by_platform.csv`
- `highest_rated_per_year_platform.csv`
- `rating_distribution_bins.csv`
- `titles_per_platform.csv`
- `top10_by_platform.csv`

In Tableau, point your data sources to these files for reproducibility. See `docs/DATA_DICTIONARY.md` for schema notes.
- Add your packaged workbook (.twbx) to /tableau/dashboards.twbx
- Export PNGs of your dashboards to /tableau/images/ and reference them below.
- If you publish on Tableau Public, add the link in this section.

### Screenshots
<p align="center">
  <img src="tableau/images/dashboard1.png" alt="Platform Overview" width="720">
</p>
<p align="center">
  <img src="tableau/images/dashboard2.png" alt="Ratings and Trends" width="720">
</p>

### Database Design

The entity–relationship diagram (ERD) and relational schema define the core data model for the Streaming Platform Analytics project.  
These documents describe the relationships among `TITLE`, `GENRE`, `PLATFORM`, and associated bridge tables.

<p align="center">
  <img src="images/Streaming_Platform_ERD.png" alt="ER Diagram" width="720">
</p>
<p align="center">
  <img src="images/Streaming_Platform_RelationalSchema.png" alt="Relational Schema" width="720">
</p>

## Dataset credit
Kaggle: Movies on Netflix, Prime Video, Hulu, and Disney+ by Ruchi Bhatia. Check license before redistribution.

## License
MIT — see LICENSE.

## Author
Alex McAnnally
