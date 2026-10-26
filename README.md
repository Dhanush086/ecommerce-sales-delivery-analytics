## E-Commerce Sales, Customer Behavior and Delivery Performance Analytics



An end-to-end analytics project on the public Olist Brazilian E-Commerce dataset,

using PostgreSQL, SQL and Power BI.



## Business questions

1\. How do orders and sales change month by month?

2\. How do customers pay?

3\. How long does delivery take, and how often is it late?

4\. Do customers buy again?

5\. Which states drive sales?



## Data

\- Source: Olist Brazilian E-Commerce dataset (Kaggle, public). 9 CSV files.

\- Raw files are not included in this repository. See `data/README.md`.

\- Period used for trends: Sep 2016 to Aug 2018. Sep and Oct 2018 contain only 20 orders.



## Workflow

1\. Loaded the raw CSVs unchanged into a `staging` schema (all columns as text).

2\. Checked data quality with SQL (keys, missing delivery dates, payment totals).

3\. Built typed `clean` tables: orders, order\_items, order\_payments, customers.

4\. Wrote metric definitions and SQL analysis (`sql/`).

5\. Built a 3-page Power BI dashboard and reconciled its totals with SQL.



## Metric definitions

- \*\*Item sales\*\*: sum of `price` for orders not `canceled` or `unavailable`. Freight and payment value are separate measures and are never added to sales.

- \*\*Delivered order (delivery metrics)\*\*: status `delivered` with a delivery date.

- \*\*Delivery duration\*\*: delivered date minus purchase date, in days.

- \*\*Late order\*\*: delivered date later than the estimated date.

- \*\*Customer\*\*: distinct `customer\_unique\_id`. \*\*Repeat customer\*\*: 2 or more eligible orders.


## Dashboard

![Executive Overview](docs/page1.png)

![Sales and Payments](docs/page2.png)

![Customers and Delivery](docs/page3.png)



## Key results

See `docs/executive_summary.md.docx` (Word file, download to read).



## Validation

SQL and Power BI totals were compared (item sales, payment value, late orders, repeat customers, 2017 sales, SP delivery metrics).



## Limitations

- Power BI totals differ from SQL by about 0.002% (267.40 of 13.59M). Cause not identified. SQL is the source of truth.

- Payments do not always equal item sales plus freight (775 orders have payments but no items).

- No cost data, so no profit analysis. Currency is not specified in the data.

- The analysis is based on a static historical dataset.



## How to reproduce

1\. Download the dataset from Kaggle and load the CSVs into `staging` tables in PostgreSQL.

2\. Run `sql/01\_clean\_tables.sql`, then the queries in `sql/02\_analysis.sql`.

3\. Open the Power BI file and point it at your PostgreSQL database.

