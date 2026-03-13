# End-to-End Retail Analytics Simulation (PostgreSQL)

## 📌 Overview
This project simulates a retail database environment to solve complex business problems using PostgreSQL. I moved beyond simple "Select" statements to build a robust system involving relational modeling and oins.

## 🛠️ Technical Deep-Dive
* **Relational Modeling:** Implemented a schema with 6 tables using Primary/Foreign Key constraints.
* **Advanced Window Functions:** Utilized `DENSE_RANK()` for customer segmentation and `SUM() OVER(PARTITION BY)` for rolling sales analysis.
* **Dynamic Logic:** Engineered `CASE` statements to categorize order sizes for better logistics insight.
* **Automation:** Developed PL/pgSQL Functions and Stored Procedures to handle regional discounts and dynamic data retrieval.

## 🧠 The Learning Journey (Debugging Notes)
* **Procedure vs Function:** Initially attempted to use Stored Procedures for data retrieval. Learned that in PostgreSQL, `PROCEDURES` are optimized for DML (Data Manipulation) like updates/deletes, while `FUNCTIONS` with `RETURNS SETOF` are the correct tool for dynamic data display.
* **String Manipulation:** Successfully used `SUBSTRING` and `POSITION` to extract usernames and domain providers from raw email strings—a common task in CRM data cleaning.

## 📊 Visual Results
*The output of these queries was later integrated into a Power BI Dashboard to track Regional Profitability and Customer Loyalty.*
