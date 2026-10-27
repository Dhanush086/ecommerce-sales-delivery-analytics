# Executive Summary

**Project:** E-Commerce Sales, Customer Behavior and Delivery Performance Analytics (PostgreSQL, SQL, Power BI)

**Data:** Olist Brazilian E-Commerce public dataset, 99,441 orders. Trends cover Sep 2016 to Aug 2018. Sep and Oct 2018 contain only 20 orders, and Sep to Dec 2016 are also very thin (Nov 2016 has none), so those months are excluded from trend conclusions.

**Rules used:**
- Item sales = sum of `price` for orders not `canceled` or `unavailable`. Freight and payment value are separate measures and are never added to sales.
- Orders in sales discussions follow the same rule (7,421 in Nov 2017). Counting every order of any status, Nov 2017 has 7,544.
- Customer = `customer_unique_id`. Repeat customer = 2 or more eligible orders.
- Delivery metrics use delivered orders with a delivery date (96,470 orders).

## Key findings

| # | Finding | Evidence | Recommendation | Limitation |
|---|---|---|---|---|
| 1 | November 2017 was the peak month | 7,421 orders and 1,003,862.14 item sales, the highest in the data | Before planning capacity around it, check daily orders in late Nov 2017 | Only one November exists, so this cannot be called seasonal. Cause unknown |
| 2 | Credit card dominates payments | 76,505 orders, about 78.3% of payment value, 3.5 installments on average. Boleto is about 17.9% | Keep credit card and installment checkout reliable | Payment value is a separate measure from item sales |
| 3 | About 1 in 12 delivered orders arrived late | 7,826 of 96,470 (8.11%). Average delivery 12.56 days | Track late % monthly as a standing KPI | Only delivered orders with a delivery date are counted |
| 4 | Late deliveries spiked in March 2018 | 21.04% of 7,003 delivered orders, against 8.11% overall | Review that month with the logistics team | Shows that it happened, not why |
| 5 | Late % rose from June to August 2018 | About 1.4%, 4.5% and 10.4% (83, 276 and 660 late orders) | Review recent carrier and seller performance | Cause unknown. Orders delivered later are not visible |
| 6 | Few customers buy again | 2,888 of 94,990 customers (3.04%) placed 2 or more eligible orders | Test retention offers | About two years of data. This is a repeat rate, not customer lifetime value |
| 7 | Sales are concentrated in a few states | SP 38.3% of item sales (5,163,867.22), top 5 states about 73.9%. SP delivery is faster (8.76 days) with fewer late orders (5.89%) | Protect service quality in SP and look at growth in smaller states | Association only. Cause unknown |

## Data limitations

- Payments do not always equal item sales plus freight: 98,362 orders match, 264 paid more, 39 paid less, and 775 have payments but no item rows. Cause not identified.
- 8 delivered orders have no delivery date and are excluded from delivery metrics.
- Power BI totals differed from SQL by about 0.002% (267.40 of 13.59M). Cause not identified. SQL is the source of truth.
- There is no cost data, so there is no profit analysis. Currency is not specified in the data.
- The dataset is a static historical snapshot.
