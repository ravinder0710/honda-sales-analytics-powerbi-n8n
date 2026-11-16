
### HONDA TWO-WHEELER
SALES ANALYTICS


### END-TO-END ENTERPRISE DATA PIPELINE
& LIVE POWER BI DASHBOARD

Master Technical Architecture • Implementation Reference • Production Case Study


| PROJECT FIELD | DETAIL |
| --- | --- |
| Project | Enterprise Automated Honda Sales Analytics |
| Author / Role stated in source | Ravinder Gupta — Data Analyst / BI & Data Engineering Specialist |
| Business domain | Honda two-wheeler retail sales, dealership operations and financial performance |
| Pipeline | CSV ingestion → Python ETL → Neon PostgreSQL → Power BI Composite Model |
| Automation | n8n workflow on local Windows environment |
| Cloud database | Neon Serverless PostgreSQL — AWS Singapore region |
| BI platform | Microsoft Power BI Desktop using DirectQuery + Import dimensions |
| Source data volume | 1,500 distinct order records (as documented in source report) |
| Dashboard suite | Home, Overview, Sales Details, Segment Analysis |
| Infrastructure claim | ₹0 ongoing infrastructure cost / free-tier architecture (as stated in source report) |



### PORTFOLIO PURPOSE

Demonstrate a complete analytics workflow that transforms raw Honda dealership order records into a cleaned relational dataset, a cloud-hosted analytical model and a four-page interactive Power BI reporting suite.

Prepared from the supplied 23-page technical report and four dashboard screenshots • November 2026


# Contents

1. Executive Summary & Business Value

2. Business Context & Problem Statement

3. End-to-End System Architecture & Data Flow

4. Infrastructure & Environment Provisioning

5. Relational Database Design & Data Dictionary

6. Data Ingestion, Transformation & Migration Engineering

7. Network Security, Authentication & Debugging

8. Power BI Dimensional Modelling & Composite Architecture

9. Business Logic & DAX Metric Engineering

10. Four-Dashboard Suite — Screenshots & Deep Dive

11. UI/UX Design System & Theme Specifications

12. Maintenance, Automation & Production Runbook

13. Data Quality, Reconciliation & Acceptance Tests

14. Business Insights & Recommended Actions

15. Limitations, Evidence Boundaries & Risks

16. Resume & Interview Presentation Guide

Appendices — SQL, DAX and Implementation Checklist


# 1. Executive Summary & Business Value

The Honda Sales Analytics project documents an automated data pipeline and a four-page Power BI suite for analysing two-wheeler dealership transactions across multiple Indian cities, motorcycle models, sales channels, customer demographics, payment modes and financial measures.

The architecture described in the source report uses n8n to monitor incoming CSV files, a Python 3.14 worker to validate and clean records, Neon Serverless PostgreSQL as the cloud warehouse, and Power BI Composite Model with DirectQuery for the transactional fact table and Import mode for supporting dimensions.


| Headline measure | Value shown in supplied report | Evidence / note |
| --- | --- | --- |
| Order Count | 245 | Overview dashboard KPI. |
| Average Customer Rating | 4.31 | Overview dashboard KPI; source column documented on 1–5 scale. |
| Total Sales | ₹53.04M / ₹53.04 crore | Source report reconciliation; dashboard screenshot total appears ₹5.304 crore — see reconciliation warning. |
| Total Cost Price | ₹41.20M / ₹41.20 crore | Overview KPI; source report states cost total ₹41,19,87,380. |
| Total Profit | ₹11.84M / ₹11.84 crore | Overview KPI; source report states profit total ₹11,84,40,520. |
| Insurance Amount | ₹1.35M | Overview KPI. |
| Finance Amount | ₹31.98M | Overview KPI. |



### Key implementation themes

Automated CSV ingestion and batch loading rather than manual spreadsheet consolidation.

A 28-column relational table designed for transaction, product, geography, customer and financial analysis.

A 5-part SQL batch ingestion strategy to avoid browser/editor payload limits.

A DirectQuery fact table with Import-mode Calendar and motorcycle image dimensions.

A four-page report: showroom landing page, executive overview, granular sales ledger and hierarchical segment analysis.

Critical reconciliation note: the supplied report’s final database reconciliation states total revenue ₹53,04,27,900, while the Sales Details screenshot footer visually reads ₹5,30,42,790.00. This is a 10× difference. This report preserves both source observations and flags the mismatch for PBIX/database validation rather than silently choosing one.


# 2. Business Context & Problem Statement

The report describes a multi-region Honda two-wheeler dealership network across northern, western and southern India. Before the pipeline, store managers, counter accountants and inventory leads exported transaction data from separate CSV sources. Manual consolidation introduced delays, inconsistent date formats, missing currency values, duplicated rows and spreadsheet calculation risk.


| Region | Cities listed in source |
| --- | --- |
| Northern | Delhi NCR (New Delhi, Noida), Uttar Pradesh (Lucknow, Kanpur) |
| Western | Maharashtra (Mumbai, Pune, Nagpur), Gujarat (Ahmedabad, Surat) |
| Southern | Karnataka (Bangalore, Mysore, Hubli) |



## 2.1 Reported operational pain points

Decentralized data delivery: daily CSV exports from different stores and systems, with inconsistent schema conventions.

Manual ingestion bottlenecks: 2–3 hours daily spent downloading, merging and correcting localized date anomalies and currency formatting.

Stale visibility: executive reporting delays of 24–48 hours, limiting timely monitoring of stockouts, margins and discounting.

Infrastructure cost concerns: traditional VPS or managed database proposals were considered too expensive for the stated portfolio/business constraints.


## 2.2 Architectural objectives

Automate ingestion from file arrival through database upsert.

Normalize transaction records into a central cloud PostgreSQL table.

Provide a four-page Power BI suite using DirectQuery / Composite Model.

Support drill-down from company-level KPIs to model, segment, city and transaction-level detail.

Use free-tier infrastructure as described in the source report; actual ongoing cost remains dependent on provider limits and usage.


# 3. End-to-End System Architecture & Data Flow


| PIPELINE STAGE |
| --- |
| 01  FILE ARRIVAL New Honda sales CSV is detected by n8n folder watcher / file trigger. |



### ↓


| PIPELINE STAGE |
| --- |
| 02  ORCHESTRATION n8n starts the ingestion workflow and invokes the Python processing stage. |



### ↓


| PIPELINE STAGE |
| --- |
| 03  PYTHON ETL Python validates, normalizes column names, parses dates, coerces numeric values and prepares records. |



### ↓


| PIPELINE STAGE |
| --- |
| 04  BATCH GENERATION 1,500 records are split into five SQL batches of 300 rows each. |



### ↓


| PIPELINE STAGE |
| --- |
| 05  NEON POSTGRESQL Rows are inserted into public.honda_sales using ON CONFLICT (order_id) DO UPDATE. |



### ↓


| PIPELINE STAGE |
| --- |
| 06  POWER BI COMPOSITE MODEL Fact table connects through DirectQuery; Calendar and image dimension are imported. |



### ↓


| PIPELINE STAGE |
| --- |
| 07  REPORT & INSIGHTS Four Power BI pages expose overview KPIs, transaction detail and segment hierarchy. |



### Architecture components


| Layer | Technology / configuration stated in source | Role |
| --- | --- | --- |
| Automation | n8n 1.124.0; local service on localhost:5678 | Watches for CSV arrivals, orchestrates ingestion and triggers processing. |
| ETL | Python 3.14; pandas 3.0.5; NumPy; psycopg 3.3.6; SQLAlchemy 2.1.6 | Validation, cleaning, standardization, chunking and database delivery. |
| Warehouse | Neon Serverless PostgreSQL 16+; AWS Singapore (ap-southeast-1) | Central relational storage and SQL aggregation. |
| BI | Power BI Desktop Composite Model | DirectQuery fact table plus imported dimensions and visuals. |
| Assets | img dimension with image URLs | Motorcycle thumbnail gallery and dynamic central showcase. |



## 3.1 Data flow design considerations

The report describes DirectQuery so slicers and aggregations can be pushed to PostgreSQL rather than requiring a static imported fact snapshot.

Import-mode Calendar and image metadata are used to avoid repeated network trips for small static dimensions.

The n8n workflow is described as the automation entry point; a production deployment should include failure handling, retries, alerting and idempotent processing.


# 4. Infrastructure & Environment Provisioning


## 4.1 Local Node.js and n8n setup

The source report documents a Windows 11 local automation environment with Node.js 24.22.1 and npm 11.19.1, installed under C:\Program Files\nodejs. n8n was run as a background process listening on TCP port 5678.


| Component | Documented configuration |
| --- | --- |
| Operating environment | Windows 11 |
| Node.js | v24.22.1 |
| npm | 11.19.1 |
| n8n | v1.124.0 |
| Local endpoint | http://localhost:5678 |
| Execution | Background daemon / local process |



## 4.2 Neon serverless PostgreSQL

The report identifies Neon as the cloud PostgreSQL provider and AWS Asia Pacific (Singapore) as the deployment region, selected to reduce latency for the intended India-based use case.


| Setting | Value stated in source |
| --- | --- |
| Provider / region | Neon; AWS Asia Pacific (Singapore), ap-southeast-1 |
| Database | neondb |
| Default role | neondb_owner |
| PostgreSQL port | 5432 |
| Connection mode | Pooled and direct endpoints are documented |
| SSL | sslmode=require |
| Compute | 0.25 to 2 Compute Units (CU), with scale-to-zero described |


Security handling: connection strings, database passwords, private endpoints and credentials must remain in environment variables or a secrets manager. The source report includes sensitive connection and credential examples; this recreated portfolio report intentionally does not reproduce secret values.


## 4.3 Python engineering toolchain


| Package | Version stated | Purpose |
| --- | --- | --- |
| Python | 3.14 | ETL runtime. |
| pandas | 3.0.5 | CSV parsing, DataFrame transformations and type validation. |
| NumPy | Version not clearly specified | Numeric and array support. |
| psycopg | 3.3.6 | PostgreSQL adapter and data transfer. |
| SQLAlchemy | 2.1.6 | Database connection and SQL toolkit. |



# 5. Relational Database Design & Data Dictionary

The source report defines public.honda_sales as the production transaction table with 28 columns. order_id is the primary key and is used as the conflict target for idempotent upserts.


| Column group | Fields / examples | Analytical purpose |
| --- | --- | --- |
| Transaction key | order_id | Unique transaction / invoice key; primary key. |
| Date attributes | order_date, year, monthindex, month, quarter | Calendar analysis and chronological sorting. |
| Geography & dealer | state, city, dealer_name, sales_channel | Regional, city, dealership and channel performance. |
| Motorcycle attributes | bike_model, bike_segment, engine_cc, color | Model, segment, engine and colour analysis. |
| Customer attributes | customer_age, customer_gender, payment_mode | Demographic and payment segmentation. |
| Financial ledger | on_road_price, discount, insurance_amount, accessories_amount, finance_amount, exchange_bonus, net_sales_amount, cost_price, gross_profit | Revenue, cost, profit, discount and ancillary finance analysis. |
| Operational / experience | delivery_days, customer_rating | Delivery latency and satisfaction analysis. |



## 5.1 Data dictionary — full field register


| Field | Type / constraint | Business meaning |
| --- | --- | --- |
| order_id | VARCHAR(50), PRIMARY KEY | Unique invoice / transaction identifier. |
| order_date | DATE, NOT NULL | Standardized transaction date. |
| year | INTEGER, NOT NULL | Calendar year. |
| monthindex | INTEGER, NOT NULL | Numeric month 1–12 for chronological sorting. |
| month | VARCHAR(20), NOT NULL | Full calendar month name. |
| quarter | VARCHAR(10), NOT NULL | Fiscal/calendar quarter label. |
| state | VARCHAR(50), NOT NULL | Operating state. |
| city | VARCHAR(50), NOT NULL | Branch city. |
| dealer_name | VARCHAR(150), NOT NULL | Authorized dealership showroom. |
| sales_channel | VARCHAR(50), NOT NULL | Showroom Walk-in, Online Booking or Corporate Sale. |
| bike_model | VARCHAR(100), NOT NULL | Model name such as Activa 6G, CB350, Hornet 2.0, Shine 125, SP 125, Unicorn. |
| bike_segment | VARCHAR(50), NOT NULL | Scooter, Commuter, Premium Commuter, Sports or Premium. |
| engine_cc | INTEGER, NOT NULL | Engine displacement. |
| color | VARCHAR(30), NOT NULL | Exterior colour. |
| customer_age | INTEGER, NOT NULL | Customer age in years. |
| customer_gender | VARCHAR(20), NOT NULL | Registered customer gender. |
| payment_mode | VARCHAR(30), NOT NULL | Cash, Credit Card, Debit Card, Finance or UPI. |
| on_road_price | NUMERIC(12,2), NOT NULL | Invoice amount including road taxes and registration. |
| discount | NUMERIC(12,2), DEFAULT 0 | Dealer discount / incentive. |
| insurance_amount | NUMERIC(12,2), DEFAULT 0 | Insurance premium amount. |
| accessories_amount | NUMERIC(12,2), DEFAULT 0 | Accessories revenue. |
| finance_amount | NUMERIC(12,2), DEFAULT 0 | Loan principal disbursed. |
| exchange_bonus | NUMERIC(12,2), DEFAULT 0 | Trade-in subsidy / exchange value. |
| net_sales_amount | NUMERIC(12,2), NOT NULL | Final recognized revenue. |
| cost_price | NUMERIC(12,2), NOT NULL | Wholesale acquisition cost. |
| gross_profit | NUMERIC(12,2), NOT NULL | Net Sales Amount less Cost Price. |
| delivery_days | INTEGER, NOT NULL | Booking-to-delivery duration. |
| customer_rating | NUMERIC(3,2), NOT NULL | Post-delivery customer rating; 1.00–5.00. |



## 5.2 Supporting dimensions


| Dimension | Mode / purpose |
| --- | --- |
| Calendar | Import mode; continuous date dimension for time intelligence. |
| img | Import mode; motorcycle model to image URL mapping for visual assets. |
| _Key Measures | Dedicated measure table used to organize DAX calculations. |



# 6. Data Ingestion, Transformation & Migration Engineering


## 6.1 Raw input profile and validation

The source report states that Honda All Dataset.csv contained 1,500 distinct order records and was approximately 288 KB. Initial profiling identified mixed-case headers, multiple date formats and numeric fields containing occasional empty spaces or currency symbols.

Normalize headers to lowercase and standardized names.

Parse order_date using day-first handling where required, then convert to ISO date representation.

Coerce numeric columns to numeric types and fill missing numeric values with zero where the documented script applies that rule.

Validate required columns and ensure order_id is available as the unique key.


## 6.2 Python ETL sequence


| Step | Documented transformation | Reason |
| --- | --- | --- |
| 1 | Read CSV with pandas. | Load raw source. |
| 2 | Normalize column names using strip/lowercase. | Avoid header-case and whitespace mismatches. |
| 3 | Parse dates and standardize to YYYY-MM-DD. | Consistent PostgreSQL DATE handling. |
| 4 | Coerce listed numeric columns and fill null numeric values with 0. | Meet target numeric schema and avoid currency-text errors. |
| 5 | Split dataset into five 300-row chunks. | Avoid web SQL editor payload truncation. |
| 6 | Generate INSERT statements with ON CONFLICT (order_id) DO UPDATE. | Support repeatable upserts without duplicate order IDs. |



## 6.3 Batch ingestion and execution evidence


| Batch | Rows | Execution status in source report |
| --- | --- | --- |
| honda_part_1.sql | 1–300 | Executed successfully |
| honda_part_2.sql | 301–600 | Executed successfully |
| honda_part_3.sql | 601–900 | Executed successfully |
| honda_part_4.sql | 901–1,200 | Executed successfully |
| honda_part_5.sql | 1,201–1,500 | Executed successfully |


The report states that a single large SQL payload was truncated by the web SQL editor, so the process was redesigned into five discrete batches. It records all five batches as successfully executed.


## 6.4 Data cleaning risks

Filling every missing numeric value with zero can change business meaning; distinguish true zero from unknown/missing values for discount, insurance, finance and ratings.

Date parsing with day-first assumptions should be tested against ambiguous values such as 03/04/2026.

Upsert logic should update only intended mutable columns and should be tested for duplicate order_id values in the raw file.

Keep an audit trail of source filename, ingestion timestamp, row counts, rejected rows and batch status.


# 7. Network Security, Authentication & Debugging


## 7.1 Endpoint / SSL mismatch

The source report documents a connection failure caused by a manually transcribed Neon pooled endpoint hostname that did not match the provisioned endpoint. The report describes resolving the issue by copying the exact endpoint from the Neon console.


## 7.2 SCRAM-SHA-256 and channel binding

The report states that Neon uses SCRAM-SHA-256 password authentication and that Python connectivity was verified with psycopg3 and SSL channel binding requirements. It also describes compatibility issues with some older .NET PostgreSQL drivers.


## 7.3 Power BI credential cache

A further reported issue involved Power BI reusing a cached credential after the database password had changed. The source report’s resolution sequence was to open Data source settings, select Global permissions, locate the Neon server URI, clear permissions and restart authentication.

Security recommendation: never include real passwords, private endpoints or credential strings in portfolio screenshots or public GitHub repositories. Use rotated credentials and secret storage. The source document contains credential examples; those are deliberately omitted here.


# 8. Power BI Dimensional Modelling & Composite Architecture


## 8.1 Composite storage mode


| Model object | Storage mode | Role |
| --- | --- | --- |
| public.honda_sales | DirectQuery | Transactional fact table; filters and aggregations query PostgreSQL. |
| Calendar | Import | Continuous date dimension and time-intelligence attributes. |
| img | Import | Motorcycle image metadata / image URL lookup. |
| _Key Measures | Measure container | Centralized DAX measure organization. |



## 8.2 Continuous date dimension

The source report describes a 730-day calendar spanning 1 January 2025 to 31 December 2026. It includes Year, Month Number, Month, Month Short, Quarter, Year Month, Day and Day Name. Month is sorted by Month Number; Month Short is also sorted by Month Number; Calendar is marked as the date table.


## 8.3 Motorcycle image dimension

The image lookup table maps Bike Name to Image URL. In Power BI, the Image URL field is assigned the Image URL data category. A DAX measure uses SELECTEDVALUE with a fallback image URL so the central showcase can change when a motorcycle model is selected.


## 8.4 Active relationships


| From | To | Cardinality / direction |
| --- | --- | --- |
| Calendar[Date] | public.honda_sales[order_date] | 1:* active; single direction. |
| img[Bike Name] | public.honda_sales[bike_model] | 1:* active; single direction. |


The source report states that these are the two primary active relationships. Validate exact names, uniqueness on the one-side and filter propagation in the delivered PBIX.


# 9. Business Logic & DAX Metric Engineering


## 9.1 Financial revenue and margin measures


| Measure | Documented DAX logic |
| --- | --- |
| Total Sales | SUM('public honda_sales'[net_sales_amount]) |
| Total Cost Price | SUM('public honda_sales'[cost_price]) |
| Total Profit | SUM('public honda_sales'[gross_profit]) |
| Profit Margin % | DIVIDE([Total Profit], [Total Sales], 0) |



## 9.2 Operational and volume measures


| Measure | Documented DAX logic |
| --- | --- |
| Total Units Sold | COUNTROWS('public honda_sales') |
| Order Count | DISTINCTCOUNT('public honda_sales'[order_id]) |
| Average Order Value | DIVIDE([Total Sales], [Total Units Sold], 0) |
| Average Delivery Days | AVERAGE('public honda_sales'[delivery_days]) |



## 9.3 Ancillary revenue and customer experience


| Measure | Documented DAX logic |
| --- | --- |
| Total Finance Amount | SUM('public honda_sales'[finance_amount]) |
| Total Insurance Amount | SUM('public honda_sales'[insurance_amount]) |
| Total Accessories Amount | SUM('public honda_sales'[accessories_amount]) |
| Avg Customer Rating | AVERAGE('public honda_sales'[customer_rating]) |



## 9.4 Dynamic motorcycle showcase

The source report describes a DAX measure that reads the selected bike image URL from the imported img dimension and falls back to a default Hornet 2.0 image when no image is selected. This allows the central showcase to update with the model selection.


# 10. Four-Dashboard Suite — Screenshots & Deep Dive

The supplied report documents four Power BI pages. The four screenshots below are the actual dashboard images uploaded with this request and are included as implementation evidence.


## 10.1 Dashboard 1 — Home / Showroom Landing

Figure 1. Honda Home page — branded showroom landing page with Hornet 2.0 hero image and Dashboard navigation.

Honda Red Wing logo and Hornet 2.0 motorcycle hero visual.

Large muted watermark typography behind the hero image.

Dashboard navigation action directs the user into the Overview page.

Purpose: branded entry point for dealership executives and business users.


## 10.2 Dashboard 2 — Overview / Executive Operational Intelligence

Figure 2. Overview page — KPI cards, motorcycle selector gallery, payment mode and state mix, financial trend charts.


| Visual | Screenshot value / content | Business use |
| --- | --- | --- |
| Order Count | 245 | Selected-context transaction volume. |
| Avg Customer Rating | 4.31 | Customer experience indicator. |
| Insurance Amount | 1.35M | Insurance-related amount. |
| Finance Amount | 31.98M | Finance amount. |
| Total Profit | 11.84M | Profit performance. |
| Total Sales | 53.04M | Sales performance KPI shown on Overview. |
| Total Cost Price | 41.20M | Acquisition cost baseline. |
| Motorcycle selector | Six model thumbnails shown. | Changes central motorcycle showcase. |
| Payment mode donut | UPI, Credit Card, Finance, Cash. | Payment mix. |
| State donut | Uttar Pradesh, Gujarat, Karnataka, Maharashtra, Delhi. | Regional distribution. |
| Three bottom line charts | Profit, Sales and Cost Price by month. | Monthly financial movement. |



## 10.3 Dashboard 3 — Sales Details / Granular Transaction Ledger

Figure 3. Sales Details page — detailed transaction table with city, segment, model, engine, colour and financial fields.

The report describes this page as an operational audit view for regional inventory managers, financial auditors and branch accountants.

Visible columns include City, Bike Segment, Bike Model, Engine CC, Color, Total Sales, Total Cost Price, Total Profit, Insurance Amount, On Road Price and Customer Rating.

Alternating wine-red and dark-crimson rows improve readability in a dense table.

A bottom total row summarizes the selected table context.

Reconciliation issue: the visible Sales Details screenshot footer shows Total Sales ₹5,30,42,790.00, Total Cost Price ₹4,11,98,738.00 and Total Profit ₹1,18,44,052.00. The PDF’s database reconciliation instead reports sales ₹53,04,27,900.00, while its cost/profit figures appear to be ₹41,19,87,380 and ₹11,84,40,520. The sales and cost figures differ by 10× between screenshot and written reconciliation; profit differs by 10× too. Validate source data, visual display units and database aggregation before publishing.


## 10.4 Dashboard 4 — Segment Analysis / Hierarchical Matrix & Sparklines

Figure 4. Segment Analysis page — expandable segment/model/city hierarchy with financial measures and monthly sparklines.

Three-level drill hierarchy: Bike Segment → Bike Model → City.

Example hierarchy documented: Premium Commuter → Unicorn → city branches.

Financial columns include Total Sales, Cost Price, Total Profit, Discount, Accessories Amount, Finance Amount and Insurance Amount.

Monthly Bike Model Distribution sparklines show the monthly distribution pattern for each row.

Purpose: compare segment, model and city performance without leaving the matrix view.


# 11. UI/UX Design System & Theme Specifications


| Design token | Specification stated in source |
| --- | --- |
| Primary background | Deep Burgundy / Crimson gradient. |
| Card container | Translucent dark wine fill. |
| Primary accent | Honda Racing Red. |
| Primary text | Pure white. |
| Secondary text | Muted warm grey. |
| Sparkline | Bright neon red / pinkish-red line. |
| Canvas | 16:9 widescreen; 1280 × 720 display resolution stated. |
| Background assets | Frame 18 (3).png for Home, Overview and Segment Analysis; Frame 18 (7).png for secondary light-theme variations. |


Maintain strong contrast between bright red metrics and dark burgundy backgrounds.

Use consistent Honda branding and model imagery across report pages.

Ensure transaction tables remain readable at common desktop resolutions.

Keep slicer and gallery interactions discoverable and consistent across pages.


# 12. Maintenance, Automation & Production Runbook


## 12.1 Daily automated ingestion

n8n watches the designated sales-report folder or incoming file location.

The workflow extracts the incoming CSV file.

The Python processing stage validates schema, cleans fields and prepares SQL batches.

The database write stage inserts or updates records using order_id as the conflict key.

Power BI DirectQuery visuals query the latest committed database records when users interact with the report.


## 12.2 Database performance tuning

The source report includes indexes on order_date and the composite pair city, bike_segment to support frequent time and segment filters. It also recommends keeping fact calculations in PostgreSQL where practical so DirectQuery can push aggregations to the database.


| Index | Indexed fields | Intended query pattern |
| --- | --- | --- |
| idx_honda_sales_date_model | order_date, bike_model | Date and motorcycle model filtering. |
| idx_honda_sales_city_segment | city, bike_segment | Geographic and segment analysis. |



## 12.3 Operational safeguards to add

Record ingestion start/end time, source filename, row counts, rejected records and batch status.

Alert on failed n8n runs, PostgreSQL connection failures and schema drift.

Make ingestion idempotent and test replay of the same source file.

Monitor Neon compute usage, storage, connection limits and free-tier policy changes.

Set a documented Power BI refresh/DirectQuery validation process and owner.


# 13. Data Quality, Reconciliation & Acceptance Tests


| Test | Expected outcome / action |
| --- | --- |
| Primary key | order_id must be unique and non-null. |
| Row count | Source report states 1,500 distinct records; database count should reconcile to 1,500. |
| Date range | Database reconciliation states earliest 2025-01-02 and latest 2026-12-31; calendar covers 2025-01-01 to 2026-12-31. |
| Numeric validity | Financial values parse as numeric; distinguish missing from true zero. |
| Profit calculation | gross_profit should reconcile to net_sales_amount − cost_price if that is the business rule. |
| Sales reconciliation | Investigate 10× mismatch between Overview/PDF database total and Sales Details screenshot footer. |
| Order count KPI | 245 shown in Overview; verify whether this is filtered by selected model/state/payment context. |
| Customer rating | Validate 1–5 range and average calculation. |
| Date relationships | Calendar filters order_date correctly. |
| Image relationship | Each bike_model should map to one image record; verify image URL data category. |
| DirectQuery | Confirm filters and visuals query the expected database and return current results. |
| Hierarchy | Segment → model → city expands/collapses correctly. |
| Sparklines | Monthly distribution follows chronological month order. |



## 13.1 Key reconciliation warning

The source report contains materially inconsistent total values. The written final database reconciliation on page 13 states 1,500 records and total revenue ₹53,04,27,900. The Overview screenshot displays Total Sales 53.04M. However, the Sales Details screenshot’s total row appears to display ₹5,30,42,790.00. The source report’s listed Total Cost Price and Total Profit values also show a factor-of-ten discrepancy between page 13 and the screenshot footer. This must be resolved from the live database query and Power BI measure formatting before the dashboard is used for business decisions.


# 14. Business Insights & Recommended Actions


| Analysis area | Questions the dashboard enables | Suggested action |
| --- | --- | --- |
| Regional performance | Which states and cities contribute to sales, profit and order volume? | Compare state/city performance with consistent time and model filters. |
| Model / segment mix | Which motorcycle segments and models contribute to revenue and margin? | Review high-contribution models and investigate low-margin combinations. |
| Payment mix | How are transactions distributed across UPI, cards, finance and cash? | Use payment distribution to understand customer payment preferences. |
| Finance and insurance | How much finance and insurance amount is associated with transactions? | Review attachment rates and amounts by region/model; validate business definitions. |
| Customer experience | How do customer ratings vary by model, city or channel? | Investigate low-rating clusters with sufficient sample size. |
| Delivery operations | Where are delivery days higher? | Review branch/process bottlenecks after validating delivery-day calculation. |
| Discount and profit | How do discounts relate to gross profit by segment/model? | Monitor margin impact before promotional decisions. |


The dashboard provides descriptive analysis. The supplied evidence does not establish causal effects, stock-on-hand inventory tracking, forecasting or a verified pricing optimization model.


# 15. Limitations, Evidence Boundaries & Risks

The report is based on the uploaded 23-page technical handover PDF and four supplied dashboard screenshots.

The PDF documents a 1,500-row source dataset and database reconciliation; the raw CSV and live Neon database were not supplied for independent verification.

The exact n8n workflow export, Python ETL source file, SQL scripts and PBIX were not supplied as separate executable artefacts in this request.

The source report includes endpoint and credential details; sensitive values are intentionally excluded from this recreated report.

The report’s sales/cost/profit totals contain a material factor-of-ten discrepancy between written database reconciliation and Sales Details screenshot footer.

The claimed ₹0 ongoing infrastructure cost depends on free-tier quotas, compute/storage usage and provider policy; it should not be represented as guaranteed indefinitely.

The report describes an enterprise architecture and automation workflow; operational production status cannot be independently verified from screenshots and the PDF alone.


## 15.1 Recommendations before public portfolio release

Reconcile Total Sales, Total Cost Price and Total Profit across the SQL database, DAX measures and every report page.

Remove credentials, connection strings, organization/project identifiers and private endpoints from screenshots and source code.

Publish a sanitized data dictionary and architecture diagram without secrets.

Add a data-quality summary: duplicate keys, null counts, invalid dates, numeric coercion and rejected records.

Include the n8n workflow export, Python ETL script and SQL DDL/upsert scripts if they are safe to share.

Document the exact refresh/near-real-time behaviour and Neon free-tier limitations.


# 16. Portfolio

Built an end-to-end Honda two-wheeler sales analytics pipeline using n8n, Python, Neon Serverless PostgreSQL and Power BI Composite Model. Automated CSV ingestion and cleaning, standardized transaction data, loaded 1,500 order records through batched SQL upserts, and modelled a DirectQuery fact table with imported Calendar and motorcycle image dimensions. Developed a four-page Power BI suite covering executive KPIs, regional and payment mix, transaction-level sales detail, segment/model/city drill-down, financial performance and customer ratings.


# Appendix A. Implementation Inventory


| Asset / component | Documented status |
| --- | --- |
| Honda All Dataset.csv | Source report states 1,500 records, approx. 288 KB. |
| public.honda_sales | 28-column PostgreSQL transaction table. |
| Calendar | Import-mode date dimension, 730-day range. |
| img | Import-mode bike image lookup. |
| n8n | Local automation service, version 1.124.0. |
| Python ETL | Cleaning, normalization, batch generation and database dispatch described. |
| Five SQL batches | 300 rows per batch; all marked successful in source report. |
| Power BI Composite Model | DirectQuery fact table + imported dimensions. |
| Four report pages | Home, Overview, Sales Details, Segment Analysis. |



# Appendix B. Dashboard Acceptance Checklist


| Page | Acceptance criteria | Status |
| --- | --- | --- |
| Home | Honda brand, hero model image and Dashboard navigation action work. | To validate in PBIX |
| Overview | KPI totals reconcile; model gallery changes showcase; payment/state visuals filter correctly; monthly trends sort chronologically. | To validate in PBIX |
| Sales Details | Table fields and total row reconcile to database; numeric formats and currency units are consistent. | To validate in PBIX |
| Segment Analysis | Segment/model/city hierarchy expands correctly; financial values reconcile; sparklines show correct monthly order. | To validate in PBIX |
| Pipeline | n8n trigger, Python cleaning, five-batch execution, upsert and failure notifications tested. | To validate in runtime |



# Appendix C. Source Page Guide


| Source PDF pages | Content used |
| --- | --- |
| 1–2 | Executive summary, business context, architecture objectives and ingestion tier. |
| 3–5 | n8n / Node.js setup, Neon provisioning and Python toolchain. |
| 6–10 | PostgreSQL DDL and data dictionary. |
| 10–13 | Raw CSV profile, Python ETL, 5-batch ingestion and database reconciliation. |
| 13–14 | Network endpoint, SCRAM-SHA-256 and Power BI credential-cache debugging. |
| 14–16 | Composite model, Calendar, image dimension and relationships. |
| 16–18 | DAX measure catalogue and dynamic image selection. |
| 18–21 | Four dashboard page descriptions and UI/UX design system. |
| 21–23 | Automation runbook, indexing, resume and interview guide. |

