# Ygeiopolis General Hospital
## Database Semester Project, for the "Databases" course (6th Semester) of the ECE School, NTUA

Welcome to the **Ygeiopolis General Hospital** Database! This project aims to emulate a realistic database for a general hospital, as well as storing and managing data related to the many entities involved in its operation. To name some of them: doctors, nurses, administrative staff, patients, hospitalizations, shifts, medical procedures, lab tests, prescriptions, triage cases, and patient reviews. Our database is optimized to query and analyze data in an efficient manner.
This repository contains all the necessary files for setting up and running the **Ygeiopolis Hospital Database** as well as the interactive web app designed for further visualization of our database.

## Directory Features

- **Database Management**: Utilizes MariaDB for robust and scalable data storage.
- **Data Generation**: Includes dummy data scripts to create and manage test data for development.
- **Triggers and Indexes**: Implements MariaDB triggers to enforce business rules and custom indexes to optimize query performance.
- **Web Interface**: Provides a web-based interface for hospital staff and patients to interact with the database, manage hospitalizations, triage cases, prescriptions and view results.

This project is ideal for hospital administrators, medical staff, and anyone interested in managing large-scale hospital information systems.

## Database Features

- **Staff Management**: Store detailed information about doctors (specialty, rank, supervision hierarchy), nurses (rank, department) and administrative personnel (role, office).
- **Patient Management**: Handle data related to patients, including demographics, insurance providers, allergies, emergency contacts and hospitalization history.
- **Shift Scheduling**: Manage daily shifts (morning, afternoon, night) per department with full participation tracking and automated constraint enforcement via triggers.
- **Hospitalization Management**: Track admissions and discharges with ICD-10 diagnoses, KEN cost codes, bed assignments and total cost calculation.
- **Medical Procedures & Lab Tests**: Record surgical, diagnostic and therapeutic procedures along with laboratory examinations per hospitalization.
- **Prescription System**: Manage drug prescriptions using the EMA Article 57 medication database, with automatic allergy checks enforced by triggers.
- **Triage System**: Record emergency department triage events, urgency levels, wait times and admission outcomes.
- **Patient Reviews**: Allow patients to rate their hospitalization experience and individual doctors on a 1-5 Likert scale.

## Assumptions

1. A Director-rank doctor cannot have a supervisor; a Resident-rank doctor must always have one.
2. Circular supervision chains between doctors are strictly forbidden and enforced by trigger.
3. Each shift must be covered by at least 3 doctors, 6 nurses and 2 administrative staff members.
4. A minimum rest period of 8 hours is required between two consecutive shifts for the same staff member.
5. No staff member may participate in more than 3 consecutive night shifts.
6. Maximum monthly shifts: Doctors 15, Nurses 20, Administrative staff 25.
7. Prescriptions are forbidden if the patient has a documented allergy to any active substance contained in the medication.
8. Hospitalization total cost is calculated as: KEN base cost + daily excess charge x max(actual_days - MDN, 0).
9. The image table uses a polymorphic relationship via entity_type and entity_id; no foreign key constraint is defined for this table by design.
10. ICD-10 diagnosis codes are enforced via foreign key to the icd10 table.
11. Triage records may exist without a linked hospitalization (outcome = DISCHARGED).
12. Doctor reviews are only permitted for doctors who prescribed medication during the patient's hospitalization.
13. Hospitalization reviews are only permitted after the hospitalization is complete (discharge_date is not null).

## Technical Details

### Technologies Used

- **MariaDB 10.4**: MariaDB was used for setting up, storing and managing the database, as well as executing SQL queries.

- **XAMPP**: XAMPP was used to create a local development environment for managing the MariaDB database and running the web application via phpMyAdmin.

- **Node.js**: Node.js was used for developing the web application server.

- **Express**: Express was used as the web framework for building the server-side application.

- **EJS**: EJS (Embedded JavaScript) was used to dynamically generate HTML pages on the server side.

- **HTML/CSS**: HTML and CSS were used to develop the user interface (UI).

### Tech Stack

- **Node.js v18+**
- **Express 4.x**
- **MariaDB 10.4.32**
- **EJS**
- **XAMPP 8.2**

## Installation

To get started with the Ygeiopolis Hospital Database, follow the steps below:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/stavmem7/Databases-Project-2026.git
   cd Databases-Project-2026
   ```

2. **Set up the MariaDB database:**

   - Start XAMPP and ensure Apache and MySQL are running.
   - Open phpMyAdmin and create a new database named `ygeiopolis`.
   - Import the `sql/install.sql` file to set up the necessary tables, indexes and triggers.
   - Import the `sql/load.sql` file to load the dummy data.

   Or via CLI:

   ```bash
   mysql -u root -p ygeiopolis < sql/install.sql
   mysql -u root -p ygeiopolis < sql/load.sql
   ```

3. **Install the required Node.js packages:**

   ```bash
   cd Code
   npm install
   ```

4. **Run the app:**

   - Start the Node.js server by running the following command:

   ```bash
   node app.js
   ```

   - Open your browser and visit `http://localhost:3000` to start interacting with the Ygeiopolis Hospital database.

