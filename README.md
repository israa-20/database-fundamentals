# Database Fundamentals

Practice scenarios from the MaharaTech "Introduction to Database" course. For each scenario: ERD drawn by hand, redrawn in draw.io, mapped to tables, and implemented in SQL Server with sample data and queries.

## Scenarios

| Scenario | ERD | Tables and decisions | SQL |
|---|---|---|---|
| Library | [ERD](library/library-erd.png) | [tables.md](library/tables.md) | [schema](library/schema.sql), [data](library/data.sql), [queries](library/queries.sql) |
| University | [ERD](university/university-erd.png) | [tables.md](university/tables.md) | [schema](university/schema.sql), [data](university/data.sql), [queries](university/queries.sql) |
| Clinic | [ERD](clinic/clinic-erd.png) | [tables.md](clinic/tables.md) | [schema](clinic/schema.sql), [data](clinic/data.sql), [queries](clinic/queries.sql) |

## What each scenario covers

- **Library:** composite and multi-valued attributes, M:N relationships with attributes, 1:1 merge.
- **University:** weak entity (section), unary M:N (prerequisites), circular foreign key resolved with ALTER TABLE.
- **Clinic:** weak entity (bed), ternary relationship (prescription), composite foreign key, filtered unique index.

## Concepts practiced

- Entities, weak entities, composite / multi-valued / derived attributes
- Cardinality, participation, unary, binary, and ternary relationships
- ERD to tables mapping rules (merge for 1:1, junction tables for M:N and ternary)
- Constraints: PK, FK (including composite FK), UNIQUE, CHECK, NOT NULL
- Queries: JOINs (including self join and LEFT JOIN), GROUP BY / HAVING, subqueries
- SQL Server specifics: filtered unique index, GO batches, circular FK with ALTER TABLE

## How to run

Each scenario is meant to run in this order, in SQL Server (SSMS or Azure Data Studio):

1. `schema.sql` creates the database and tables.
2. `data.sql` inserts sample data (the statements at the end, inside a comment, are meant to fail so the constraints can be tested).
3. `queries.sql` runs the practice queries.
