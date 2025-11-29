# Database Project – University Library

This repository contains the project developed for the **Databases** university exam.  
The goal of the project is to design and implement a database for managing a **university library**.  
The work includes conceptual, logical, and physical design, SQL implementation, and a wide set of queries of increasing complexity.

---

## Repository Structure

main_repository/
│
├── description.pdf
├── implementation.sql
├── LICENSE
└── README.md

---

## Project Objective

The aim of the project is to design an information system for a **university library**, capable of managing:

- Books and their copies  
- Authors, genres, and publishing houses  
- Readers and their categories (student, researcher, PhD student, professor)  
- Borrowing operations (active and completed loans)  
- User evaluations of the library  
- Physical placement of books on shelves and floors  

---

## Conceptual Design

The conceptual phase was developed using an **inside-out** approach:  
starting from the main concept (*Book*), expanding to copies, authors, genres, readers, shelves, loans, and evaluations.

This phase includes:

- Natural language requirements  
- Glossary of domain terms  
- Requirements refinement  
- Entity–Relationship (E/R) diagram  
- Data dictionary (entities, attributes, identifiers)  
- Integrity and derivation rules  

The full E/R diagram is available in the PDF file.

---

## Logical Design

The logical design translates the E/R diagram into a **relational schema**, including:

- Removal of generalization (Reader → specialized categories)  
- Removal of composite attributes  
- Definitions of tables with primary keys, foreign keys, and integrity constraints  

Main tables include:

- **Author**
- **Genre**
- **PublishingHouse**
- **Book**
- **Copy**
- **Shelf**
- **Reader**
- **Loans** (Borrowing, Returning)
- **Evaluation**
- **Researcher / Professor / PhDStudent / Student**
- Associative tables (Writing, Ownership, Composition)

---

## Physical Design & SQL Implementation

The project includes both the PDF and SQL files, which contain:

- Creation of all tables  
- Definition of primary keys, foreign keys, and referential constraints  
- Normalization to eliminate redundancy  
- Creation of views  
- More than **30 SQL queries**, including:  
  - 10 simple queries  
  - 6 JOIN queries  
  - 4 aggregate queries  
  - 5 nested queries  
  - 2 queries using views  
  - 3 queries using set operators  

### How to run the SQL script

The SQL script can be executed on any compatible RDBMS (MySQL, MariaDB, or PostgreSQL). Follow these steps:

1. Create a new database:
CREATE DATABASE library_db;
USE library_db;

2. Execute the SQL script:
  - In MySQL / MariaDB:
  SOURCE implementation.sql;
  - In PostgreSQL:
  \i implementation.sql

3. After execution, all tables, views, and sample queries will be available.
