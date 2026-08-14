
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
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_upi_id INT NOT NULL,
    receiver_upi_id INT NOT NULL,
    merchant_id INT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    transaction_date DATETIME NOT NULL,
    transaction_note VARCHAR(255),

    CHECK (amount > 0),
    CHECK (transaction_type IN ('UPI Transfer', 'Merchant Payment')),
    CHECK (transaction_status IN ('Successful', 'Failed', 'Pending')),

    FOREIGN KEY (sender_upi_id) REFERENCES UPI_Accounts(upi_id),
    FOREIGN KEY (receiver_upi_id) REFERENCES UPI_Accounts(upi_id),
    FOREIGN KEY (merchant_id) REFERENCES Merchants(merchant_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL UNIQUE,
    payment_method VARCHAR(30) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CHECK (payment_method IN ('UPI', 'UPI Lite', 'Bank Account')),
    CHECK (payment_status IN ('Successful', 'Failed', 'Pending')),

    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);
CREATE TABLE Bill_Payments (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    transaction_id INT NOT NULL UNIQUE,
    bill_type VARCHAR(40) NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    consumer_number VARCHAR(30) NOT NULL,
    bill_amount DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE NOT NULL,
    bill_status VARCHAR(20) NOT NULL DEFAULT 'Successful',

    CHECK (bill_amount > 0),
    CHECK (bill_status IN ('Successful', 'Failed', 'Pending')),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);
CREATE TABLE Mobile_Recharges (
    recharge_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    transaction_id INT NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL,
    operator VARCHAR(50) NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    recharge_date DATE NOT NULL,
    recharge_status VARCHAR(20) NOT NULL DEFAULT 'Successful',

    CHECK (amount > 0),
    CHECK (recharge_status IN ('Successful', 'Failed', 'Pending')),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);
CREATE TABLE Rewards (
    reward_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    transaction_id INT NOT NULL UNIQUE,
    reward_type VARCHAR(30) NOT NULL,
    reward_points INT NOT NULL DEFAULT 0,
    reward_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    reward_date DATE NOT NULL,

    CHECK (reward_type IN ('Cashback', 'Scratch Card', 'Referral', 'Offer')),
    CHECK (reward_points >= 0),
    CHECK (reward_amount >= 0),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);

