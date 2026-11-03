-- ============================================================================
-- HONDA TWO-WHEELERS ENTERPRISE SALES ANALYTICS SCHEMA
-- Cloud Data Warehouse: Neon Serverless PostgreSQL (AWS Singapore)
-- DirectQuery Layer for Power BI Semantic Model
-- ============================================================================

-- 1. VEHICLE DIMENSION (Product Master)
CREATE TABLE IF NOT EXISTS dim_vehicle (
    vehicle_id INT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- 'Scooter', 'Commuter', 'Premium'
    engine_cc INT NOT NULL,
    fuel_capacity_liters NUMERIC(4, 1),
    ex_showroom_price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. BRANCH DIMENSION (Geographic Master)
CREATE TABLE IF NOT EXISTS dim_branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    region VARCHAR(20) NOT NULL, -- 'North', 'West', 'South', 'East'
    dealer_tier VARCHAR(10) DEFAULT 'Tier-1'
);

-- 3. PAYMENT & FINANCING DIMENSION
CREATE TABLE IF NOT EXISTS dim_payment (
    payment_id INT PRIMARY KEY,
    payment_type VARCHAR(50) NOT NULL, -- 'Cash', 'Finance', 'UPI'
    finance_partner VARCHAR(100),       -- 'HDFC Bank', 'ICICI', 'Bajaj Finance', 'None'
    downpayment_pct NUMERIC(5, 2)
);

-- 4. SALES FACT TABLE (Transactional Ledger - 5,617 Records, ₹59.63 Cr Volume)
CREATE TABLE IF NOT EXISTS fact_honda_sales (
    sale_id BIGINT PRIMARY KEY,
    invoice_no VARCHAR(50) UNIQUE NOT NULL,
    sale_date DATE NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT REFERENCES dim_vehicle(vehicle_id),
    branch_id INT REFERENCES dim_branch(branch_id),
    payment_id INT REFERENCES dim_payment(payment_id),
    sale_price NUMERIC(12, 2) NOT NULL,
    discount_amt NUMERIC(10, 2) DEFAULT 0.00,
    accessories_amt NUMERIC(10, 2) DEFAULT 0.00,
    net_amount NUMERIC(12, 2) NOT NULL,
    rto_charges NUMERIC(10, 2),
    insurance_amt NUMERIC(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for DirectQuery Acceleration
CREATE INDEX IF NOT EXISTS idx_honda_sales_date ON fact_honda_sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_honda_sales_vehicle ON fact_honda_sales(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_honda_sales_branch ON fact_honda_sales(branch_id);

-- ============================================================================
-- HIGH-PERFORMANCE DIRECTQUERY ANALYTICAL VIEWS
-- ============================================================================

-- View 1: Executive Sales Summary for Cockpit Dashboard
CREATE OR REPLACE VIEW v_executive_sales_summary AS
SELECT 
    b.region,
    b.city,
    v.category,
    v.model_name,
    DATE_TRUNC('month', s.sale_date) AS sales_month,
    COUNT(s.sale_id) AS total_units_sold,
    SUM(s.net_amount) AS total_net_revenue,
    AVG(s.net_amount) AS avg_ticket_price,
    SUM(s.discount_amt) AS total_discounts_granted
FROM fact_honda_sales s
JOIN dim_vehicle v ON s.vehicle_id = v.vehicle_id
JOIN dim_branch b ON s.branch_id = b.branch_id
GROUP BY b.region, b.city, v.category, v.model_name, DATE_TRUNC('month', s.sale_date);

-- View 2: Financing Penetration by Branch
CREATE OR REPLACE VIEW v_financing_penetration AS
SELECT 
    b.region,
    p.payment_type,
    p.finance_partner,
    COUNT(s.sale_id) AS financing_txns,
    SUM(s.net_amount) AS financed_volume,
    ROUND(COUNT(s.sale_id)::NUMERIC / SUM(COUNT(s.sale_id)) OVER(PARTITION BY b.region) * 100, 2) AS regional_penetration_pct
FROM fact_honda_sales s
JOIN dim_branch b ON s.branch_id = b.branch_id
JOIN dim_payment p ON s.payment_id = p.payment_id
GROUP BY b.region, p.payment_type, p.finance_partner;
