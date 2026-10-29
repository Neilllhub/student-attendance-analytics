
import os
import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt

# Connect to MySQL
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("STUDENT_DB_PASSWORD")
    database="student_analytics"
)

# Create an output folder
os.makedirs("reports", exist_ok=True)

try:
    print("Connected to student_analytics!")

    # 1. Attendance percentage for each student
    attendance_query = """
        SELECT
            s.student_name,
            sub.subject_name,
            COUNT(a.attendance_id) AS total_classes,
            SUM(a.status = 'Present') AS classes_attended,
            ROUND(
                100.0 * SUM(a.status = 'Present')
                / NULLIF(COUNT(a.attendance_id), 0),
                2
            ) AS attendance_percentage
        FROM students s
        JOIN attendance a ON s.student_id = a.student_id
        JOIN subjects sub ON a.subject_id = sub.subject_id
        GROUP BY s.student_id, s.student_name,
                 sub.subject_id, sub.subject_name
        ORDER BY s.student_name, sub.subject_name
    """

    attendance_df = pd.read_sql(
        attendance_query, connection
    )

    print("\n--- ATTENDANCE REPORT ---")
    print(attendance_df.to_string(index=False))

    # 2. Students below 75% attendance
    low_attendance_df = attendance_df[
        attendance_df["attendance_percentage"] < 75
    ]

    print("\n--- STUDENTS BELOW 75% ATTENDANCE ---")

    if low_attendance_df.empty:
        print("No student-subject combinations below 75%.")
    else:
        print(low_attendance_df.to_string(index=False))

    # 3. Subject-wise marks analysis
    marks_query = """
        SELECT
            s.student_name,
            sub.subject_name,
            m.marks_obtained,
            m.max_marks,
            ROUND(
                100.0 * m.marks_obtained / m.max_marks, 2
            ) AS marks_percentage
        FROM marks m
        JOIN students s ON m.student_id = s.student_id
        JOIN subjects sub ON m.subject_id = sub.subject_id
        ORDER BY sub.subject_name, s.student_name
    """

    marks_df = pd.read_sql(marks_query, connection)

    print("\n--- MARKS REPORT ---")
    print(marks_df.to_string(index=False))

    # 4. Subject averages
    if not marks_df.empty:
        subject_summary = (
            marks_df.groupby("subject_name")["marks_percentage"]
            .agg(["mean", "max", "min"])
            .round(2)
            .reset_index()
        )

        subject_summary.columns = [
            "subject_name",
            "average_percentage",
            "highest_percentage",
            "lowest_percentage"
        ]

        print("\n--- SUBJECT-WISE SUMMARY ---")
        print(subject_summary.to_string(index=False))

        subject_summary.to_csv(
            "reports/subject_summary.csv", index=False
        )

    # 5. Student average marks
    if not marks_df.empty:
        student_summary = (
            marks_df.groupby("student_name")["marks_percentage"]
            .mean()
            .round(2)
            .reset_index(name="average_marks_percentage")
            .sort_values(
                "average_marks_percentage", ascending=False
            )
        )

        print("\n--- STUDENT PERFORMANCE ---")
        print(student_summary.to_string(index=False))

        student_summary.to_csv(
            "reports/student_performance.csv", index=False
        )

    # 6. Export detailed reports
    attendance_df.to_csv(
        "reports/attendance_report.csv", index=False
    )

    low_attendance_df.to_csv(
        "reports/low_attendance.csv", index=False
    )

    marks_df.to_csv(
        "reports/marks_report.csv", index=False
    )

    # 7. Attendance chart
    if not attendance_df.empty:
        chart_data = (
            attendance_df.groupby("student_name")
            ["attendance_percentage"]
            .mean()
            .sort_values(ascending=False)
        )

        chart_data.plot(kind="bar", figsize=(9, 5))
        plt.title("Average Attendance by Student")
        plt.xlabel("Student")
        plt.ylabel("Attendance (%)")
        plt.ylim(0, 100)
        plt.xticks(rotation=30, ha="right")
        plt.tight_layout()
        plt.savefig("reports/attendance_chart.png")
        plt.show()
        plt.close()

    # 8. Marks chart
    if not marks_df.empty:
        marks_chart = (
            marks_df.groupby("subject_name")
            ["marks_percentage"]
            .mean()
            .sort_values(ascending=False)
        )

        marks_chart.plot(kind="bar", figsize=(9, 5))
        plt.title("Average Marks by Subject")
        plt.xlabel("Subject")
        plt.ylabel("Average marks (%)")
        plt.ylim(0, 100)
        plt.xticks(rotation=20, ha="right")
        plt.tight_layout()
        plt.savefig("reports/marks_chart.png")
        plt.show()
        plt.close()

    print("\nAll reports saved in the reports folder!")

finally:
    connection.close()
    print("MySQL connection closed.")
