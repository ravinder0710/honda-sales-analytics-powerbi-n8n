"""
Honda Two-Wheelers Sales Analytics ETL & Telemetry Validation Script
Orchestrates multi-branch CSV ingestion, validates records, and pushes clean data into Neon PostgreSQL.
"""

import os
import sys
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def validate_sales_record(row: dict) -> bool:
    """Validate transactional integrity for incoming showroom telemetry."""
    required_keys = ["invoice_no", "sale_date", "vehicle_id", "net_amount"]
    for key in required_keys:
        if key not in row or row[key] is None:
            return False
    try:
        amount = float(row["net_amount"])
        if amount <= 0:
            return False
    except ValueError:
        return False
    return True

def calculate_kpis(records: list) -> dict:
    """Compute headline KPI snapshot for monitoring."""
    total_revenue = sum(float(r["net_amount"]) for r in records if validate_sales_record(r))
    total_units = len([r for r in records if validate_sales_record(r)])
    aur = total_revenue / total_units if total_units > 0 else 0
    return {
        "total_revenue_inr": total_revenue,
        "total_units_delivered": total_units,
        "average_unit_realization": aur
    }

if __name__ == "__main__":
    logging.info("Honda Sales Pipeline Initialized. Ready for n8n cron webhook triggering.")
