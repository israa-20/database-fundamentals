# Library: ERD to Tables

`PK` = primary key, `FK` = foreign key.

```
Member        (Mem_ID [PK], Name, Street, City, Card_No, Issue_Dt)
Member_Phone  (Mem_ID [PK, FK], Phone_No [PK])

Book          (ISBN [PK], Title)

Author        (Author_ID [PK], Name, DOB, Website)
Author_Phone  (Author_ID [PK, FK], Phone_No [PK])

Borrow        (Mem_ID [PK, FK], ISBN [PK, FK], Loan_Dt [PK], Return_Dt)
Book_Author   (ISBN [PK, FK], Author_ID [PK, FK])
```

## Mapping decisions

- **Address** is composite, so only its parts (`Street`, `City`) are stored.
- **Phone_No** is multi-valued, so each entity gets its own phone table. Each cell holds one value.
- **Has (1:1, total on both sides):** `Membership` is merged into `Member` (`Card_No`, `Issue_Dt`).
- **Borrow (M:N):** a new table. `Loan_Dt` and `Return_Dt` are attributes of the relationship, so they live there. `Loan_Dt` is part of the key so a member can borrow the same book more than once.
- **Writes (M:N):** a new table `Book_Author`, with both foreign keys as the primary key.

## Assumptions

- Every book has at least one author (total participation of Book in Writes).
- An author is recorded only if they wrote a book in the system (assumed, the scenario did not say).
