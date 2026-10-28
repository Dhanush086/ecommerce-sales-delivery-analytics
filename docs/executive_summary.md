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
| 8 | Late deliveries are associated with lower review scores | Average 2.57 (late) vs 4.29 (on time); 54.1% vs 9.2% low (1 to 2 star) reviews | Treat delivery performance as a customer-experience issue to investigate | Association only. One review per order (latest kept); 768 orders have no review |

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
- - Products and sellers were not analysed. Reviews were analysed with one review per order (latest kept).
- The Power BI file is not included in the repository.
  
