# Database Fundamentals

Practice scenarios from the MaharaTech "Introduction to Database" course.
For each scenario: ERD drawn by hand, redrawn in draw.io, mapped to tables, and implemented in SQL Server.

## Scenarios

| Scenario | ERD | Tables and decisions | SQL |
|---|---|---|---|
| Library | [ERD](library/library-erd.png) | [tables.md](library/tables.md) | [schema.sql](library/schema.sql) |
| University | [ERD](university/university-erd.png) | [tables.md](university/tables.md) | [schema.sql](university/schema.sql) |

## Concepts practiced

- Entities, weak entities, composite / multi-valued / derived attributes
- Cardinality, participation, unary and M:N relationships
- ERD to tables mapping rules (merge for 1:1, junction tables for M:N)
- Constraints: PK, FK (including composite FK), UNIQUE, CHECK, NOT NULL
- SQL Server specifics: filtered unique index, GO batches, circular FK with ALTER TABLE
