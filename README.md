
# Student Attendance & Academic Analytics System

## Overview
A beginner-friendly data analytics project built with Python and MySQL to analyse student attendance and academic performance.

## Features
- Connects Python to a MySQL database
- Calculates attendance percentages by student and subject
- Identifies attendance below 75%
- Analyses marks and subject-wise performance
- Exports reports to CSV
- Generates attendance and marks charts

## Technology Stack
- Python
- MySQL 8.0
- MySQL Connector/Python
- Pandas
- Matplotlib

## Project Structure
- `main.py` — Main analytics program
- `requirements.txt` — Python dependencies
- `.gitignore` — Excludes local and unnecessary files
- `reports/` — Generated reports and charts

## Setup
1. Install Python and MySQL.
2. Create the `student_analytics` database and its required tables.
3. Install dependencies using `python -m pip install -r requirements.txt`.
4. Set the `STUDENT_DB_PASSWORD` environment variable in Windows.
5. Run `main.py` using Python.

## Data Privacy
This project uses sample student data. Do not publish real student records, passwords, or other sensitive information.

## Learning Outcomes
- SQL queries and relational database design
- Python database connectivity
- Data cleaning and analysis with Pandas
- Data visualization with Matplotlib
- CSV report generation
