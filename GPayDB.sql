
USE GooglePayDB;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CHECK (account_status IN ('Active', 'Inactive', 'Blocked'))
);
CREATE TABLE Bank_Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type VARCHAR(20) NOT NULL,
    ifsc_code VARCHAR(15) NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0,
    account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    linked_date DATE NOT NULL,

    CHECK (account_type IN ('Savings', 'Current')),
    CHECK (balance >= 0),
    CHECK (account_status IN ('Active', 'Inactive', 'Blocked')),

    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE UPI_Accounts (
    upi_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    upi_address VARCHAR(100) NOT NULL UNIQUE,
    account_id INT NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0,
    created_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CHECK (balance >= 0),
    CHECK (status IN ('Active', 'Inactive', 'Blocked')),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (account_id) REFERENCES Bank_Accounts(account_id)
);
CREATE TABLE Merchants (
    merchant_id INT PRIMARY KEY AUTO_INCREMENT,
    merchant_name VARCHAR(100) NOT NULL,
    business_category VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    merchant_status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CHECK (merchant_status IN ('Active', 'Inactive', 'Blocked'))
);
