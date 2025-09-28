# bd
Database

Hospital Management System – Database Project

📌 Overview

This project is a Database Management System (DBMS) designed for hospital management.
It handles information related to patients, doctors, appointments, treatments, medical equipment, bills, and departments.

The main goal is to digitize hospital processes such as scheduling, diagnosis, admission, treatment administration, and billing.
By using this system, hospitals can improve efficiency, resource management, and quality of patient care.

⸻

👨‍💻 Author
	•	Boldesco Roland
	•	University: Informatica, Year I, Semester II
	•	Group: 143

⸻

📂 Project Contents

The project includes the following steps:
	1.	Real-world model description – hospital departments, patient workflows, emergency & appointment flow.
	2.	Constraints and business rules – rules for doctors, patients, treatments, and equipment.
	3.	Entity description – with primary keys and relevant attributes.
	4.	Relationships description – including cardinalities.
	5.	Attributes with data types & constraints.
	6.	Entity-Relationship Diagram (ERD).
	7.	Conceptual schema.
	8.	Relational schemas (11+ tables).
	9.	Normalization up to 3NF.
	10.	SQL Sequences for generating primary keys.
	11.	Table creation & data insertion (with sample records).
	12.	Complex SQL queries (aggregations, subqueries, grouping, functions, top-N analysis).
	13.	Update & delete operations using subqueries.
	14.	Complex views with examples of allowed & forbidden LMD operations.
	15.	Outer-join, division, and top-N queries.
	16.	Optional optimization task (query optimization & execution plan).
	17.	Higher normal forms (BCNF, 4NF, 5NF) and denormalization.
	18.	Isolation levels demonstration.
	19.	Justification for migration to NoSQL.

⸻

🗄 Database Design

Entities
	•	Doctor (ID, Department, Qualification, Name, Contact)
	•	Patient (ID, CNP, Personal data, Medical history)
	•	Department (ID, Name, Floor)
	•	Appointment (Programare) (ID, Patient, Room, Dates)
	•	Treatment (ID, Doctor, Patient, Notes)
	•	Medicine (ID, Administration details)
	•	Bill (Factura) (ID, Patient, History)
	•	Room (Salon) (ID, Department, Type: private/shared)
	•	Medical Equipment (ID, Department)

Associative Tables
	•	TRATAMENT_MEDICAMENT
	•	TRATAMENT_ECHIPAMENT
	•	ECHIPAMENT_DEPARTAMENT

⸻

⚙️ Features
	•	Store patients, doctors, and departments data.
	•	Manage appointments, hospitalizations, and treatments.
	•	Assign equipment and medication to treatments.
	•	Generate and track invoices.
	•	Enforce business constraints (one doctor per department, unique patient appointments, etc.).
	•	Provide complex SQL reports:
	•	Patients hospitalized in shared/private rooms.
	•	Average hospitalization time per department.
	•	Doctors ranked by medical equipment usage.
	•	Patients with specific diagnoses and treatments.

⸻

🛠 Technologies Used
	•	Oracle SQL / PL-SQL (DDL, DML, Sequences, Views).
	•	Entity-Relationship Modeling.
	•	Normalization (1NF → 5NF, BCNF).
	•	Relational Algebra.
	•	NoSQL concepts (for scalability justification).

⸻

▶️ How to Run
	1.	Open your Oracle SQL Developer (or compatible SQL environment).
	2.	Create the sequences from sequences.sql.
	3.	Create tables using create_tables.sql.
	4.	Insert sample data using insert_data.sql.
	5.	Run queries from queries.sql for analysis and reports.
	6.	Explore advanced queries in complex_queries.sql.

⸻

📊 Example Queries
	•	Top 3 doctors by equipment usage
	•	Patients hospitalized at least 2 days in shared rooms
	•	Departments with hospitalization time above average
	•	Patients by age category (minor, adult, senior)

⸻

🚀 Future Improvements
	•	Add a web interface for real-time hospital management.
	•	Integrate with NoSQL (MongoDB) for scalability of unstructured data (medical records, imaging).
	•	Add role-based access control (admins, doctors, assistants, patients).
	•	Implement stored procedures for automated billing & notifications.
