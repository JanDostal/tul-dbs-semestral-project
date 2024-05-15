# Project description

- This project represents the data layer of the web app called *IDOL Eshop* for handling administrative matters by users of Liberec region public transport system, **located in Czechia**
- The goal is to simplify administration activities instead of going to the branch (ordering a new opuscard, purchasing a time coupon on opuscard, showing an overview of purchased coupons and opuscards and their validity statuses, etc.)
- The data layer allows:
    - Sharing a registered account with other accounts and vice versa
    - Choosing one or more tarif categories within one account (adult 18+, student up to 26, pensioner 65+, etc.)
    - Uploading ISIC card to claim a discount when purchasing a time coupon
    - Creating a new account followed by account activation using the link sent to user email
    - Usage of verification code in account details for communication via email or phone with customer service
    - Ordering a new opuscard
    - Blocking an existing opuscard (replacement, loss, damage)
    - Purchasing a time coupon for the user's active opuscard
    - Moving an active time coupon from an existing opuscard to a new opuscard
- App users are expected to be ordinary people (pensioners, children, adults, students, disabled) who use the public transport system of the Liberec region, **located in Czechia**
- The idea behind data layer design was inspired by this existing web app https://eshop.iidol.cz/cs

# Development info

- The project was being developed between October 2023 and January 2024
- The project was uploaded from university google drive to this repository in March 2024, which was shortly after the end of winter semester of 2nd year at the Technical university

# Instructions for starting project

1. Download **MySQL8.x** and **MSSQL19** relational database systems
2. Download client GUI apps for **MySQL8.x** and **MSSQL19** to be able to communicate with respective database systems
3. Create respective databases for **MySQL8.x** and **MSSQL19**
4. Run respective **SQL create scripts** on each database
5. Run respective **SQL insert scripts** on each database
6. Run respective **SQL querries scripts** on each database
