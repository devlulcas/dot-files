#!/usr/bin/env python3

import os
import datetime
import csv
import sys
from pathlib import Path

# Define the base directory for data
DATA_DIR = Path.home() / "Documents" / "MONEY"
BANKS_FILE = DATA_DIR / "banks.txt"

def ensure_data_directory_exists():
    """Ensures the data directory exists."""
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    # print(f"Ensured directory exists: {DATA_DIR}") # Optional: for debugging

def register_banks():
    """Registers bank names by saving them to banks.txt."""
    bank_names_input = input("Enter bank names separated by commas (e.g., Bank A,Bank B,Bank C): ")
    if bank_names_input:
        # Split by comma, trim whitespace, and filter out empty names
        bank_names = [name.strip() for name in bank_names_input.split(',') if name.strip()]
        with open(BANKS_FILE, "w") as f:
            for bank in bank_names:
                f.write(f"{bank}\n")
        print("Registered banks:")
        for bank in bank_names:
            print(bank)
    else:
        print("No bank names entered.")

def get_latest_data_file(month_specific=False):
    """
    Finds the most recent data file.
    If month_specific is True, finds the most recent file in the current month.
    """
    ensure_data_directory_exists()
    data_files = sorted(DATA_DIR.glob("data_*.csv"), reverse=True)

    if not data_files:
        return None

    if month_specific:
        current_month_year = datetime.datetime.now().strftime("%Y-%m")
        for data_file in data_files:
            # Extract YYYY-MM from the filename (e.g., data_2023-10-27_10-30-00.csv)
            try:
                file_month_year = data_file.stem.split('_')[1].rsplit('-', 2)[0]
                if file_month_year == current_month_year:
                    return data_file
            except IndexError:
                # Handle unexpected filename formats
                continue
        return None # No file found for the current month
    else:
        return data_files[0] # Return the absolute latest file

def get_latest_bank_data(data_file, bank_name):
    """
    Gets the latest debt and credit for a specific bank from a given data file.
    Returns a tuple (debt, credit) or (None, None) if not found.
    """
    if not data_file or not data_file.is_file():
        return None, None

    latest_debt = None
    latest_credit = None

    with open(data_file, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) >= 3:
                file_bank_name = row[0].strip()
                if file_bank_name == bank_name:
                    try:
                        # Attempt to convert to float, handle errors
                        latest_debt = float(row[1].strip())
                        latest_credit = float(row[2].strip())
                    except ValueError:
                        # Handle cases where data is not a valid number
                        latest_debt = row[1].strip()
                        latest_credit = row[2].strip()

    return latest_debt, latest_credit

def input_financial_data():
    """Prompts user to input financial data for each registered bank."""
    if not BANKS_FILE.is_file():
        print("No banks registered. Please run 'money register' first.")
        sys.exit(1)

    ensure_data_directory_exists()

    with open(BANKS_FILE, "r") as f:
        banks = [line.strip() for line in f if line.strip()] # Read banks, remove empty lines

    if not banks:
        print("No banks registered. Please run 'money register' first.")
        sys.exit(1)

    current_datetime = datetime.datetime.now()
    timestamp_str = current_datetime.strftime("%Y-%m-%d_%H-%M-%S")
    output_file = DATA_DIR / f"data_{timestamp_str}.csv"

    latest_month_data_file = get_latest_data_file(month_specific=True)
    latest_overall_data_file = get_latest_data_file(month_specific=False) # Used to get all banks from latest file

    # Get data from the latest file to ensure all banks are processed
    latest_data = {}
    if latest_overall_data_file and latest_overall_data_file.is_file():
        with open(latest_overall_data_file, "r") as f:
            reader = csv.reader(f)
            for row in reader:
                if len(row) >= 3:
                    latest_data[row[0].strip()] = (row[1].strip(), row[2].strip())

    # If banks.txt is empty but there's data, use banks from latest data file
    if not banks and latest_data:
         banks = list(latest_data.keys())
         print("Using banks from the latest data file.")
    elif not banks:
         print("No banks registered. Please run 'money register' first.")
         sys.exit(1)


    collected_data = []
    print(f"\nCollecting data for {current_datetime.strftime('%Y-%m-%d %H:%M:%S')}")

    for bank in banks:
        print(f"\n--- {bank} ---")

        default_debt = ""
        default_credit = ""

        # Get default values from the latest file in the current month if available
        if latest_month_data_file:
             debt, credit = get_latest_bank_data(latest_month_data_file, bank)
             if debt is not None:
                 default_debt = str(debt)
             if credit is not None:
                 default_credit = str(credit)

        debt_input = input(f"Enter current debt (default: {default_debt}): ") or default_debt
        credit_input = input(f"Enter account balance (default: {default_credit}): ") or default_credit

        collected_data.append([bank, debt_input, credit_input])

    # Save the collected data to the new file
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerows(collected_data)

    print(f"\nData saved to {output_file}")

def see_financial_data():
    """Displays the latest financial data in a table."""
    latest_data_file = get_latest_data_file()

    if not latest_data_file:
        print("No financial data recorded yet. Run 'money' to input data.")
        sys.exit(0)

    print(f"\nLatest financial data from: {latest_data_file.name}")

    data = []
    total_debt = 0.0
    total_credit = 0.0

    with open(latest_data_file, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) >= 3:
                bank_name = row[0].strip()
                debt_str = row[1].strip()
                credit_str = row[2].strip()

                data.append([bank_name, debt_str, credit_str])

                try:
                    total_debt += float(debt_str) if debt_str else 0.0
                    total_credit += float(credit_str) if credit_str else 0.0
                except ValueError:
                    # Handle non-numeric values gracefully in totals
                    pass

    # Print the table
    if data:
        # Find max width for each column for alignment
        max_bank_width = max(len(row[0]) for row in data) if data else 0
        max_debt_width = max(len(row[1]) for row in data) if data else 0
        max_credit_width = max(len(row[2]) for row in data) if data else 0

        # Add header
        header = ["Bank", "Debt", "Credit"]
        print(f"{header[0]:<{max_bank_width}} | {header[1]:<{max_debt_width}} | {header[2]:<{max_credit_width}}")
        print("-" * (max_bank_width + max_debt_width + max_credit_width + 6)) # Separator line

        # Print data rows
        for row in data:
            print(f"{row[0]:<{max_bank_width}} | {row[1]:<{max_debt_width}} | {row[2]:<{max_credit_width}}")

        print("-" * (max_bank_width + max_debt_width + max_credit_width + 6)) # Separator line
        print(f"{'TOTALS':<{max_bank_width}} | {total_debt:<{max_debt_width}.2f} | {total_credit:<{max_credit_width}.2f}")

    else:
        print("No data found in the latest file.")


# --- Main execution ---
if __name__ == "__main__":
    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command == "register":
            register_banks()
        elif command == "see":
            see_financial_data()
        else:
            print("Usage: money [register|see]")
            sys.exit(1)
    else:
        input_financial_data()
