# University: ERD to Tables

`PK` = primary key, `FK` = foreign key.

```
Department   (Dept_No [PK], Dept_Name, Head_Ins_ID [FK -> Instructor], Head_Start_Dt)
Instructor   (Ins_ID [PK], Ins_Name, Dept_No [FK -> Department])
Student      (St_ID [PK], St_Name, DOB, Dept_No [FK -> Department])

Course       (Crs_Code [PK], Title, Hrs)
Prerequisite (Crs_Code [PK, FK -> Course], Prereq_Code [PK, FK -> Course])

Section      (Sect_No [PK], Crs_Code [PK, FK -> Course], Room, Time)
Enrollment   (St_ID [PK, FK -> Student], Sect_No [PK], Crs_Code [PK], Grade)
             (Sect_No, Crs_Code) is one composite FK -> Section
```

## Mapping decisions

- **Age** is derived from `DOB`, so it is not stored.
- **Belong_to (1:N)** and **Work_on (1:N):** the foreign key `Dept_No` goes on the N side (`Student`, `Instructor`).
- **Head (1:1, Department total, Instructor partial):** the foreign key is placed in `Department`, the total side, together with the relationship attribute `Head_Start_Dt`.
- **Section is a weak entity** owned by `Course`: its key is `Crs_Code` (owner key) + `Sect_No` (partial key).
- **Prerequisite (unary M:N):** a new table with two foreign keys, both referencing `Course`.
- **Enrollment (M:N):** a new table. It references `Section` with its full composite key, because a section number alone does not identify a section.

## Note

`Department` and `Instructor` reference each other. When creating them in SQL, create both tables first, then add one of the foreign keys with `ALTER TABLE`.
