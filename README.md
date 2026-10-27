# E-Commerce Sales, Customer Behavior and Delivery Performance Analytics

An analytics project on the public Olist Brazilian E-Commerce dataset, using PostgreSQL, SQL and Power BI.

## Business questions

1. How do orders and sales change month by month?
2. How do customers pay?
3. How long does delivery take, and how often is it late?
4. Do customers buy again?
5. Which states drive sales?

## Dashboard

![Executive Overview](docs/page1.png)

![Sales and Payments](docs/page2.png)

![Customers and Delivery](docs/page3.png)

## Key findings

| # | Finding | Evidence |
|---|---|---|
| 1 | November 2017 was the peak month (only one November exists, so not called seasonal) | 7,421 orders, 1,003,862.14 item sales |
| 2 | Credit card dominates payments | About 78.3% of payment value, 3.5 installments on average |
| 3 | About 1 in 12 delivered orders arrived late | 7,826 of 96,470 (8.11%), average 12.56 days |
| 4 | Late deliveries spiked in March 2018 | 21.04% of 7,003 delivered orders |
| 5 | Late % rose from June to August 2018 | About 1.4%, 4.5% and 10.4% |
| 6 | Few customers buy again | 2,888 of 94,990 customers (3.04%) |
| 7 | Sales are concentrated in a few states | SP 38.3% of item sales, top 5 states about 73.9% |

Full details, recommendations and limitations: [docs/executive_summary.md](docs/executive_summary.md)

## Data

- Source: [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle, public), 9 CSV files.
- Raw files are not included. See [data/README.md](data/README.md).
- Trends cover Sep 2016 to Aug 2018. Sep and Oct 2018 contain only 20 orders, and Sep to Dec 2016 are very thin (Nov 2016 has none).

## Workflow

1. Loaded the raw CSVs unchanged into a `staging` schema in PostgreSQL (all columns as text).
2. Checked data quality with SQL: key uniqueness, missing delivery dates, payment totals.
3. Built typed `clean` tables: orders, order_items, order_payments, customers (`sql/01_clean_tables.sql`).
4. Wrote the SQL analysis (`sql/02_analysis.sql`).
5. Built a 3-page Power BI dashboard with 12 DAX measures and compared key totals with SQL.

## Metric definitions

- **Item sales:** sum of `price` for orders not `canceled` or `unavailable`. Freight and payment value are separate measures and are never added to sales.
- **Delivered order (delivery metrics):** status `delivered` with a delivery date.
- **Delivery duration:** delivered date minus purchase date, in days.
- **Late order:** delivered date later than the estimated date.
- **Customer:** distinct `customer_unique_id`. **Repeat customer:** 2 or more eligible orders.

## Validation

SQL and Power BI were compared on item sales, payment value, late orders, repeat customers, average delivery days and 2017 sales. Most totals matched exactly.

## Limitations

**Data coverage**
- Static historical snapshot, not a live feed. Findings describe the past only.
- Trends cover Sep 2016 to Aug 2018. Sep and Oct 2018 contain only 20 orders, and none are delivered.
- Sep to Dec 2016 have very few orders (Nov 2016 has none), so early monthly values are not meaningful for trends.
- About two years of data, so later repeat purchases are not visible.

**Data quality**
- 8 delivered orders have no delivery date and are excluded from delivery metrics.
- Payments do not always equal item sales plus freight: 98,362 orders match, 264 paid more, 39 paid less, and 775 have payments but no item rows. The cause is not identified.
- 3 payment records have type `not_defined` with value 0.
- 1 order has items but no payment record.

**Metric scope**
- No cost data, so no profit analysis. Currency is not specified in the data.
- Repeat rate (3.04%) is not customer lifetime value.
- Item sales exclude cancelled and unavailable orders. This is my own rule, documented in the metric definitions.
- Late % uses delivered orders with a delivery date only. Orders still in transit are not counted.
- Late % by month hides months with fewer than 100 delivered orders (a chart filter, not a data change).

**Analysis scope**
- Findings show associations, not causes. For example, the data does not explain the March 2018 spike or the Nov 2017 peak.
- Only one November exists, so the peak cannot be called seasonal.
- Reviews, products and sellers were not analysed (only orders, items, payments and customers).
- The Power BI file is not included in the repository.

## Repository contents

- `sql/01_clean_tables.sql`: builds the clean layer from staging
- `sql/02_analysis.sql`: analysis queries
- `docs/`: dashboard screenshots and executive summary
- `data/README.md`: where to get the data

## How to reproduce

1. Download the dataset from Kaggle and load the 9 CSVs unchanged into `staging` tables in PostgreSQL (all columns as text).
2. Run `sql/01_clean_tables.sql`, then the queries in `sql/02_analysis.sql`.
3. The Power BI file is not included in this repository. The dashboard can be rebuilt from the `clean` tables using the metric definitions above.
