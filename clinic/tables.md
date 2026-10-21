# Clinic: ERD to Tables

`PK` = primary key, `FK` = foreign key.

```
Rooms          (Room_No [PK], Floor)
Beds           (Room_No [PK, FK -> Rooms], Bed_No [PK])

Patients       (Patient_ID [PK], Patient_Name, DOB, Street, City, Zone,
                Room_No, Bed_No)
               (Room_No, Bed_No) is one composite FK -> Beds
Patient_Phones (Patient_ID [PK, FK -> Patients], Phone_No [PK])

Doctors        (Doc_ID [PK], Doc_Name, Specialty)
Medicines      (Med_Code [PK], Med_Name, Price)

Prescriptions  (Doc_ID [PK, FK -> Doctors], Patient_ID [PK, FK -> Patients],
                Med_Code [PK, FK -> Medicines], Presc_Date [PK], Dose)
```

## Mapping decisions

- **Address** is composite, so only its parts (`Street`, `City`, `Zone`) are stored.
- **Phone_No** is multi-valued, so it gets its own table. Each cell holds one value.
- **Bed is a weak entity** owned by `Rooms`: its key is `Room_No` (owner key) + `Bed_No` (partial key).
- **Admission (1:1, partial on both sides):** the foreign key is placed in `Patients`. It has two columns, `(Room_No, Bed_No)`, because a bed number alone does not identify a bed. Both columns are `NULL` for patients who are not admitted.
- **Prescription (ternary):** a new table with a foreign key to each of the three entities. `Presc_Date` is part of the key so the same doctor can prescribe the same medicine to the same patient on different dates. `Dose` is an attribute of the relationship.

## Constraints that are not visible in the ERD

- A filtered unique index on `Patients (Room_No, Bed_No)` guarantees that a bed holds at most one patient. A plain `UNIQUE` is not used because SQL Server allows only one `NULL` in a unique column.
- A `CHECK` makes `Room_No` and `Bed_No` both `NULL` or both filled.
- `Price` must be positive.

## Assumptions

- Every room has at least one bed (total participation of Rooms in Has). This is not enforced in SQL.
- A patient occupies at most one bed at a time. Admission history is not stored.
