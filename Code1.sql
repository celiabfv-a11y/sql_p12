-- DROP THE TABLES
DROP TABLE AppUser CASCADE CONSTRAINTS;
DROP TABLE AppGroup CASCADE CONSTRAINTS;
DROP TABLE Category1 CASCADE CONSTRAINTS;
DROP TABLE Currency CASCADE CONSTRAINTS;
DROP TABLE ExchangeRate CASCADE CONSTRAINTS;
DROP TABLE Expense CASCADE CONSTRAINTS;
DROP TABLE ParticipationExpense CASCADE CONSTRAINTS;
DROP TABLE Membership CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Notification1 CASCADE CONSTRAINTS;
DROP TABLE MessageGroup CASCADE CONSTRAINTS;
DROP TABLE MessagePrivate CASCADE CONSTRAINTS;


-- CREATE THE TABLES
CREATE TABLE AppUser (
	AppUserId NUMBER NOT NULL,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	"Alias" VARCHAR2(30),
	Phone VARCHAR2(30),
	constraint AppUser_PK PRIMARY KEY (AppUserId));

CREATE TABLE AppGroup (
	AppGroupId NUMBER NOT NULL,
	GroupName VARCHAR2(30) NOT NULL,
	CreationDate DATE NOT NULL,
	GroupDescription VARCHAR2(30),
	BaseCurrencyId NUMBER NOT NULL,
	constraint AppGroup_PK PRIMARY KEY (AppGroupId));

CREATE TABLE Membership (
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	JoiningDate DATE NOT NULL,
	MemberRole VARCHAR2(30) NOT NULL CHECK (MemberRole IN ('Owner', 'Admin', 'Member')),
	LeavingDate DATE,
	constraint Membership_PK PRIMARY KEY (AppUserId, AppGroupId));

CREATE TABLE Expense (
	ExpenseId NUMBER NOT NULL,
    AppGroupId NUMBER NOT NULL,
    AppUserId NUMBER NOT NULL,
    Amount NUMBER(10, 2) NOT NULL, 
    CurrencyId NUMBER NOT NULL,
    ExpenseDate DATE NOT NULL,
    RegistrationDate DATE NOT NULL,
    DivisionType VARCHAR2(30) DEFAULT 'Equal',
    CategoryId NUMBER NOT NULL,
	constraint Expense_PK PRIMARY KEY (ExpenseId),
    constraint CH_Division CHECK (DivisionType IN ('Equal', 'Shared', 'Exact')));

CREATE TABLE ParticipationExpense (
	ExpenseId NUMBER NOT NULL,
	AppUserId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10,2) NOT NULL,
	constraint ParticipationExpense_PK PRIMARY KEY (ExpenseId, AppUserId, AppGroupId));

CREATE TABLE Category1 (
	CategoryId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	CategoryName VARCHAR(30) NOT NULL,
	constraint Category1_PK PRIMARY KEY (CategoryId));

CREATE TABLE Currency (
	CurrencyId NUMBER NOT NULL,
	CurrencyName VARCHAR(30) NOT NULL,
	constraint Currency_PK PRIMARY KEY (CurrencyId));

CREATE TABLE ExchangeRate (
	RateId NUMBER NOT NULL,
	CurrencyFrom NUMBER NOT NULL,
	CurrencyTo NUMBER NOT NULL,
	ExchangeDate DATE NOT NULL,
	Rate NUMBER(10, 2),
	constraint ExchangeRate_PK PRIMARY KEY (RateId));

CREATE TABLE Payment (
	PaymentId NUMBER NOT NULL,
	PayerId NUMBER NOT NULL,
	PayeeId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	Amount NUMBER(10, 2) NOT NULL,
	CurrencyId NUMBER NOT NULL,
	PaymentDate DATE NOT NULL,
	Note VARCHAR2(30),
	constraint Payment_PK PRIMARY KEY (PaymentId));

CREATE TABLE Notification1 (
	NotificationId NUMBER NOT NULL,
	PaymentId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	NotificationText VARCHAR2(30) NOT NULL,
	NotificationTime TIMESTAMP NOT NULL,
	IsRead CHAR(1) NOT NULL CHECK (IsRead IN ('Y', 'N')),
	constraint Notification1_PK PRIMARY KEY (NotificationId));

CREATE TABLE MessageGroup (
	MessageGroupId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessageGroup_PK PRIMARY KEY (MessageGroupId));

CREATE TABLE MessagePrivate (
	MessagePrivateId NUMBER NOT NULL,
    AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessagePrivate_PK PRIMARY KEY (MessagePrivateId));


-- ADD FOREIGN KEYS
ALTER TABLE AppGroup ADD CONSTRAINT AppGroup_fk0 FOREIGN KEY (BaseCurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Membership ADD CONSTRAINT Membership_fk0 FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId);
ALTER TABLE Membership ADD CONSTRAINT Membership_fk1 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE Expense ADD CONSTRAINT Expense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk3 FOREIGN KEY (CategoryId) REFERENCES Category1(CategoryId);

ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk2 FOREIGN KEY (ExpenseId) REFERENCES Expense(ExpenseId);

ALTER TABLE Category1 ADD CONSTRAINT Category_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk0 FOREIGN KEY (CurrencyFrom) REFERENCES Currency(CurrencyId);
ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk1 FOREIGN KEY (CurrencyTo) REFERENCES Currency(CurrencyId);

ALTER TABLE Payment ADD CONSTRAINT Payment_fk0 FOREIGN KEY (AppGroupId, PayerId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk1 FOREIGN KEY (AppGroupId, PayeeId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Notification1 ADD CONSTRAINT Notification_fk0 FOREIGN KEY (PaymentId) REFERENCES Payment(PaymentId);
ALTER TABLE Notification1 ADD CONSTRAINT Notification_fk1 FOREIGN KEY (RecipientId) REFERENCES AppUser(AppUserId);

ALTER TABLE MessageGroup ADD CONSTRAINT MessageGroup_fk0 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);

ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk1 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk2 FOREIGN KEY (AppGroupId, RecipientId) REFERENCES Membership(AppGroupId, AppUserId);


-- INSERTIONS
--- Currency
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (401, 'JPY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (402, 'AUD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (403, 'INR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (404, 'CAD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (405, 'EUR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (406, 'LYD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (407, 'TND');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (408, 'CNY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (409, 'USD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (410, 'GBP');

--- ExchangeRate
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (501, 401, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.12);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (502, 402, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.89);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (503, 401, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.87);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (504, 403, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.15);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (505, 401, 404, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 5.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (506, 404, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.21);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (507, 401, 405, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 3.25);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (508, 405, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.31);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (509, 406, 405, TO_DATE('2025-06-10', 'YYYY-MM-DD'), 1.42);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (510, 406, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0071);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (511, 401, 407, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 7.60);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (512, 407, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.132);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (513, 401, 408, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 91.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (514, 408, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0109);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (515, 403, 401, TO_DATE('2025-08-18', 'YYYY-MM-DD'), 1.58);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (516, 409, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.63);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (517, 401, 410, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 146.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (518, 410, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.68);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (519, 402, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.78);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (520, 403, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.29);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (521, 402, 404, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 4.55);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (522, 404, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.21);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (523, 402, 405, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 3.05);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (524, 405, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.32);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (525, 402, 406, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 133.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (526, 406, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0075);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (527, 402, 407, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 6.85);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (528, 407, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.148);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (529, 402, 408, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 83.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (530, 408, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0118);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (531, 402, 409, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.48);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (532, 409, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.68);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (533, 402, 410, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.33);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (534, 410, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.76);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (535, 403, 404, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 5.85);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (536, 404, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.171);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (537, 403, 405, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 3.95);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (538, 405, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.255);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (539, 403, 406, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 156.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (540, 406, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0066);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (541, 403, 407, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 8.10);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (542, 407, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.131);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (543, 403, 408, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 96.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (544, 408, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0108);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (545, 403, 409, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.72);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (546, 409, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.60);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (547, 403, 410, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.52);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (548, 410, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.66);

--- AppUser
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (1, 'Lucas', 'Ramírez', 'Luki', '+34 600-1112233');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (2, 'María', 'Gil', NULL, '+34 611-2233445');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (3, 'Javier', 'López', NULL, '+34 622-3344556');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (4, 'Valentina', 'Santos', 'Vally', '+1 (333) 444-5566');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (5, 'Miguel', 'Torres', 'Miggy', '+1 (444) 555-6677');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (6, 'Elena', 'Morales', 'Eli', '+1 (555) 666-7788');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (7, 'Omar', 'Hernández', NULL, '+218 092-1234567');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (8, 'Sergio', 'Cruz', 'SC', '+44 017-2020304');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (9, 'Isabel', 'Martín', NULL, '+44 620-1011122');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (10, 'Diego', 'Vargas', 'D-V', '+34 632-2021223');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (11, 'Laura', 'Ríos', NULL, '+34 645-3031324');

--- AppGroup
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (101, 'Home Budget', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Monthly home costs', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (102, 'Travel Crew', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Trips with friends', 402);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (103, 'Office Team', TO_DATE('2025-03-05', 'YYYY-MM-DD'), 'Work expenses', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (104, 'Tokyo Trip', TO_DATE('2025-06-07', 'YYYY-MM-DD'), 'Japan travel', 405);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (105, 'London Tour', TO_DATE('2025-08-15', 'YYYY-MM-DD'), 'UK sightseeing', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (106, 'Weekend Fun', TO_DATE('2022-11-03', 'YYYY-MM-DD'), 'Friday night fun', 402);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (107, 'House Rent', TO_DATE('2025-04-20', 'YYYY-MM-DD'), 'Monthly rent', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (108, 'Ski Trip', TO_DATE('2025-05-25', 'YYYY-MM-DD'), 'Snow weekend', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (109, 'Fitness Club', TO_DATE('2025-06-28', 'YYYY-MM-DD'), 'Gym group', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (110, 'North Africa', TO_DATE('2025-07-12', 'YYYY-MM-DD'), 'Summer travel', 404);

--- Membership
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 101, TO_DATE('2025-01-10','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (2, 101, TO_DATE('2025-01-12','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (3, 101, TO_DATE('2025-01-15','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (4, 102, TO_DATE('2025-02-18','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (5, 103, TO_DATE('2025-03-05','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (6, 104, TO_DATE('2025-06-07','YYYY-MM-DD'), 'Member', TO_DATE('2025-06-20','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 104, TO_DATE('2025-06-05','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (7, 105, TO_DATE('2025-08-14','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (8, 105, TO_DATE('2025-08-15','YYYY-MM-DD'), 'Member', TO_DATE('2025-08-22','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (8, 106, TO_DATE('2022-11-05','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (9, 107, TO_DATE('2025-04-20','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (10,108, TO_DATE('2025-05-25','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (9, 108, TO_DATE('2025-05-26','YYYY-MM-DD'), 'Admin', TO_DATE('2025-05-30','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (11, 109, TO_DATE('2025-07-02','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (5, 110, TO_DATE('2025-07-16','YYYY-MM-DD'), 'Member', TO_DATE('2025-08-01','YYYY-MM-DD')); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (7, 110, TO_DATE('2025-07-18','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 102, TO_DATE('2025-03-02','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (2, 102, TO_DATE('2025-03-06','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (3, 102, TO_DATE('2025-03-11','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (4, 101, TO_DATE('2025-02-28','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (6, 102, TO_DATE('2025-03-16','YYYY-MM-DD'), 'Member', NULL);

--- Category
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (201, 101, 'Food');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (202, 101, 'Invoices');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (203, 101, 'Invoices');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (204, 102, 'Leisure');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (205, 102, 'Food');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (206, 102, 'Leisure');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (207, 103, 'Invoices');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (208, 103, 'Food');
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (209, 104, 'Leisure');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (210, 104, 'Leisure');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (211, 104, 'Food');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (212, 105, 'Invoices');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (213, 105, 'Leisure');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (214, 105, 'Food');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (215,106, 'Food');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (216,106, 'Leisure');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (217,107, 'Invoices');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (218,107, 'Invoices');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (219,108, 'Leisure');			
INSERT INTO Category1 (CategoryId, AppGroupId, CategoryName) VALUES (220,108, 'Leisure');

--- Expense
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (301, 1, 101, 165.50, 401, TO_DATE('2023-01-18','YYYY-MM-DD'), TO_DATE('2023-01-18','YYYY-MM-DD'), 'Equal', 201); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (302, 2, 101, 80.25, 401, TO_DATE('2023-01-23','YYYY-MM-DD'), TO_DATE('2023-01-23','YYYY-MM-DD'), 'Shared', 202); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (303, 3, 101, 1250.00, 401, TO_DATE('2023-02-05','YYYY-MM-DD'), TO_DATE('2023-02-05','YYYY-MM-DD'), 'Exact', 203); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (304, 4, 102, 320.00, 401, TO_DATE('2023-02-24','YYYY-MM-DD'), TO_DATE('2023-02-24','YYYY-MM-DD'), 'Equal', 204); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (305, 2, 102, 215.00, 401, TO_DATE('2023-03-16','YYYY-MM-DD'), TO_DATE('2023-03-16','YYYY-MM-DD'), 'Shared', 207); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (306, 1, 104, 820.00, 406, TO_DATE('2025-06-10','YYYY-MM-DD'), TO_DATE('2025-06-10','YYYY-MM-DD'), 'Equal', 209); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (307, 7, 105, 615.00, 403, TO_DATE('2025-08-18','YYYY-MM-DD'), TO_DATE('2025-08-18','YYYY-MM-DD'), 'Shared', 212); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (308, 4, 101, 130.00, 402, TO_DATE('2022-11-05','YYYY-MM-DD'), TO_DATE('2022-11-05','YYYY-MM-DD'), 'Equal', 215); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (309, 9, 107, 970.00, 401, TO_DATE('2023-04-22','YYYY-MM-DD'), TO_DATE('2023-04-22','YYYY-MM-DD'), 'Exact', 217); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (310, 10, 108, 430.00, 401, TO_DATE('2023-05-26','YYYY-MM-DD'), TO_DATE('2023-05-26','YYYY-MM-DD'), 'Shared', 219);

--- ParticipationExpense (ordered by ExpenseId)
---- Expense 301 (165.50 JPY / Group 101) - Corrected to 55.17 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 1, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 2, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 3, 101, 55.17);
---- Expense 302 (80.25 JPY / Group 101) - Corrected to 40.13 and 13.37 respectively
----- 50% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 1, 101, 40.13); 
----- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 2, 101, 13.37);
----- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 3, 101, 13.37);
----- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 4, 101, 13.37);
---- Expense 303 (1250.00 JPY / Group 101)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (303, 3, 101, 1250.00);
---- Expense 304 (320.00 JPY / Group 102)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 1, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 2, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 3, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 4, 102, 80.00);
---- Expense 305 (215.00 JPY / Group 102)
----- 45% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (305, 2, 102, 96.75);
----- 55% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (305, 3, 102, 118.25);
---- Expense 306 (820.00 LYD / Group 104)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 1, 104, 410.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 6, 104, 410.00);
---- Expense 307 (615.00 INR / Group 105)
----- 75% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 7, 105, 461.25);
----- 25% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 8, 105, 153.25);
---- Expense 308 (130.00 AUD / Group 106)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (308, 1, 101, 43.33);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (308, 2, 101, 43.33);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (308, 4, 101, 43.33);
---- Expense 309 (970.00 JPY / Group 107) 
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (309, 9, 107, 970.00);
---- Expense 310 (430.00 JPY / Group 108)
----- 60% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 9, 108, 258.00);
----- 40% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 10, 108, 172.00);

--- Payment
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (601, 2, 1, 101, 55.17, 401, TO_DATE('2023-01-25','YYYY-MM-DD'), 'Split groceries');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (602, 1, 2, 101, 40.13, 401, TO_DATE('2023-02-08','YYYY-MM-DD'), 'Monthly rent');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (603, 3, 2, 101, 13.37, 401, TO_DATE('2023-02-27','YYYY-MM-DD'), 'Shared trip costs');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (604, 3, 4, 102, 80.00, 401, TO_DATE('2023-03-18','YYYY-MM-DD'), 'Office supplies');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (605, 3, 2, 102, 118.25, 401, TO_DATE('2025-06-12','YYYY-MM-DD'), 'Flight refund');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (606, 6, 1, 104, 410.00, 406, TO_DATE('2025-08-20','YYYY-MM-DD'), 'Hotel cost share');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (607, 8, 7, 105, 153.25, 403, TO_DATE('2022-11-07','YYYY-MM-DD'), 'Dinner split');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (608, 1, 4, 101, 43.33, 402, TO_DATE('2023-04-25','YYYY-MM-DD'), 'Monthly rent');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (609, 2, 4, 101, 43.33, 402, TO_DATE('2023-05-28','YYYY-MM-DD'), 'Ski trip refund');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (610, 9, 10, 108, 258.00, 401, TO_DATE('2024-07-22','YYYY-MM-DD'), 'Travel refund');

--- Notification
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (701, 601, 1, '55.17 JPY from María Gil', SYSTIMESTAMP, 'N');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (702, 602, 2, '40.13 JPY from Lucas Ramírez', SYSTIMESTAMP, 'Y');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (703, 603, 2, '13.37 JPY from Javier López', SYSTIMESTAMP, 'N');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (704, 604, 4, '80.00 JPY from Javier López', SYSTIMESTAMP, 'N');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (705, 605, 2, '118.25 JPY from Javier López', SYSTIMESTAMP, 'Y');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (706, 606, 1, '410.00 LYD from Elena Morales', SYSTIMESTAMP, 'N');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (707, 607, 7, '153.25 INR from Sergio Cruz', SYSTIMESTAMP, 'N');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (708, 608, 4, '43.33 AUD from ILucas Ramírez', SYSTIMESTAMP, 'Y');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (709, 609, 4, '43.33 AUD from María Gil', SYSTIMESTAMP, 'Y');
INSERT INTO Notification1 (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (710, 610, 10, '258.00 JPY from Isabel Martín', SYSTIMESTAMP, 'N');

--- MessageGroup
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (801, 101, 1, 'New group created!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (802, 102, 4, 'The trip is near!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (803, 103, 5, 'Meeting at 10 AM', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (804, 104, 1, 'Japan trip ready!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (805, 105, 7, 'Ready for the adventure!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (806, 106, 8, 'Friday night plans?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (807, 107, 9, 'Rent is due', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (808, 108, 10, 'Ski weekend confirmed!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (809, 109, 11, 'Gym tomorrow morning?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (810, 110, 7, 'Trip planning starts!', SYSTIMESTAMP);

--- MessagePrivate
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (901, 101, 1, 2, 'Hey Maria, how are you?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (902, 101, 2, 1, 'Thanks a lot!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (903, 101, 3, 4, 'Are you ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (904, 101, 4, 3, 'Can’t wait to start!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (905, 104, 1, 6, 'Have you made the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (906, 104, 6, 1, 'Almost done with it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (907, 105, 7, 8, 'Will you join the Japan trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (908, 105, 8, 7, 'Looking forward to it!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (909, 108, 9, 10, 'Did you book everything?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (910, 108, 10, 9, 'Yes, all set.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (911, 110, 5, 7, 'Can you help me with this?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, AppGroupId, SenderId, RecipientId, MessageText, MessageTime) VALUES (912, 110, 7, 5, 'Sure, what do you need?', SYSTIMESTAMP);


-- QUERIES
--- 1. Average amount spent by each user in each group. 
SELECT AppUser.FirstName, AppUser.LastName, AppGroup.GroupName, AVG(Payment.amount)
FROM Payment
JOIN AppUser ON AppUser.AppUserId = Payment.PayerId
JOIN AppGroup ON Payment.AppGroupId = AppGroup.AppGroupId
GROUP BY AppUser.AppUserId, AppGroup.AppGroupId,AppUser.FirstName,AppUser.LastName,AppGroup.GroupName
ORDER BY AppUser.FirstName ASC, AppUser.LastName ASC, AppGroup.GroupName ASC;

--- 2. Average amount of the expenses for the months of June, July, and August of the year 2025 for each group and category.
Select AG.GroupName, C.CategoryName, 
	   AVG(E.Amount * ER.Rate) AS AverageExpenseInBaseCurrency
From Expense E
Join AppGroup AG ON E.AppGroupId = AG.AppGroupId
Join Category1 C ON E.CategoryId = C.CategoryId
Join ExchangeRate ER ON E.CurrencyId = ER.CurrencyFrom 
					 AND AG.BaseCurrencyId = ER.CurrencyTo
					 AND ER.ExchangeDate = E.ExpenseDate 
Where EXTRACT(MONTH FROM E.ExpenseDate) IN (6, 7, 8)
  AND EXTRACT(YEAR FROM E.ExpenseDate) = 2025
group by AG.GroupName, C.CategoryName;

--- 3. Total number of group messages, the total number of private messages, and total of all messages sent by each user.
SELECT *
FROM (
    SELECT 
        u.FirstName,
        u.LastName,
        (SELECT COUNT(*) 
         FROM MessageGroup mg
         WHERE mg.SenderId = u.AppUserId) AS TotalGroupMessages,
        (SELECT COUNT(*) 
         FROM MessagePrivate mp
         WHERE mp.SenderId = u.AppUserId) AS TotalPrivateMessages,
        (
            (SELECT COUNT(*) 
             FROM MessageGroup mg
             WHERE mg.SenderId = u.AppUserId)
          + (SELECT COUNT(*) 
             FROM MessagePrivate mp
             WHERE mp.SenderId = u.AppUserId)
        ) AS OverallTotalMessages
    FROM AppUser u
) Results
WHERE Results.OverallTotalMessages > 0
ORDER BY Results.OverallTotalMessages DESC;

--- 4. Details of all payment settlements whose amount is greater than the average payment amount within the same group. 
SELECT 
    g.GroupName,
    p.PaymentDate,
    p.Amount,
    payer.FirstName  AS PayerFirstName,
    payer.LastName   AS PayerLastName,
    payee.FirstName  AS PayeeFirstName,
    payee.LastName   AS PayeeLastName
FROM Payment p
JOIN AppGroup g 
    ON p.AppGroupId = g.AppGroupId
JOIN AppUser payer
    ON payer.AppUserId = p.PayerId
JOIN AppUser payee
    ON payee.AppUserId = p.PayeeId
WHERE p.Amount > (
        SELECT AVG(pay.Amount)
        FROM Payment pay
        WHERE pay.AppGroupId = p.AppGroupId
    )
ORDER BY 
    g.GroupName ASC,
    p.Amount DESC;

--- 5. Minimum expense and maximum expense made by each user in groups belonging to the 'Invoices' category.
SELECT AppUser.FirstName, AppUser.LastName, AppGroup.GroupName, MIN(Expense.amount), MAX(Expense.amount)
	FROM Expense
	JOIN AppUser ON AppUser.AppUserId = Expense.AppUserId
	JOIN AppGroup ON AppGroup.AppGroupId = Expense.AppGroupId
	JOIN Category1 ON Category1.CategoryId = Expense.CategoryId
	WHERE Category1.CategoryName = 'Invoices'
	GROUP BY AppUser.FirstName, AppUser.LastName, AppGroup.GroupName
	ORDER BY AppUser.FirstName, AppUser.LastName, AppGroup.GroupName;

--- 6. Full name, group name, and total number of unread notifications of each user who is an active member of a group.
SELECT AppUser.FirstName, AppUser.LastName, AppGroup.GroupName, COUNT(*)AS Notifications_unread
	FROM MEMBERSHIP
	JOIN AppUser ON AppUser.AppUserId = Membership.AppUserId
	JOIN AppGroup ON AppGroup.AppGroupId = Membership.AppGroupId
	JOIN Notification1 ON Notification1.RecipientId = AppUser.AppUserId
	WHERE Notification1.IsRead = 'N' 
	AND Membership.LeavingDate IS NULL 
	AND Membership.MemberRole IN ('Owner','Admin')
	GROUP BY AppUser.AppUserId, AppUser.FirstName, AppUser.LastName, AppGroup.AppGroupId, AppGroup.GroupName;


-- TRIGGERS
--- 1. When a member left the group, the balance must be 0.
CREATE OR REPLACE TRIGGER check_balance_before_leaving
BEFORE UPDATE OF LeavingDate ON Membership
FOR EACH ROW
DECLARE
    v_balance NUMBER;
    v_expenses_created NUMBER;
    v_payments_received NUMBER;
    v_participations_owed NUMBER;
    v_payments_paid NUMBER;
BEGIN
    -- Only run this check if the user is being marked as having left
    IF :NEW.LeavingDate IS NOT NULL AND :OLD.LeavingDate IS NULL THEN
        
        -- 1. Get all money the user is OWED
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_expenses_created 
        FROM Expense 
        WHERE AppUserId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;
        
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_payments_received 
        FROM Payment 
        WHERE PayeeId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        -- 2. Get all money the user OWES
        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_participations_owed 
        FROM ParticipationExpense 
        WHERE AppUserId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        SELECT COALESCE(SUM(Amount), 0) 
        INTO v_payments_paid 
        FROM Payment 
        WHERE PayerId = :OLD.AppUserId AND AppGroupId = :OLD.AppGroupId;

        -- 3. Calculate the final balance
        v_balance := (v_expenses_created + v_payments_received) - (v_participations_owed + v_payments_paid);

        -- 4. Check the balance
        IF v_balance != 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Member cannot leave group with a non-zero balance. Current balance is: ' || v_balance);
        END IF;
    END IF;
END;
/

--- 2. In a payment, payer and payee must be active members of the same group.
CREATE TRIGGER MembershipCheck1
BEFORE INSERT ON Payment
FOR EACH ROW
DECLARE
    payer_g    NUMBER;   
    payee_g    NUMBER;  
    payer_left DATE;     
    payee_left DATE;     
BEGIN
    
    SELECT m.AppGroupId, m.LeavingDate
    INTO   payer_g, payer_left
    FROM   Membership m
    WHERE  m.AppUserId  = :NEW.PayerId
    AND    m.AppGroupId = :NEW.AppGroupId;

    
    SELECT m.AppGroupId, m.LeavingDate
    INTO   payee_g, payee_left
    FROM   Membership m
    WHERE  m.AppUserId  = :NEW.PayeeId
    AND    m.AppGroupId = :NEW.AppGroupId;

    
    IF payer_g != :NEW.AppGroupId THEN
        raise_application_error(
            -20010,
            'Payer ' || :NEW.PayerId ||
            ' does not belong to group ' || :NEW.AppGroupId
        );
    END IF;

    
    IF payee_g != :NEW.AppGroupId THEN
        raise_application_error(
            -20011,
            'Payee ' || :NEW.PayeeId ||
            ' does not belong to group ' || :NEW.AppGroupId
        );
    END IF;

    
    IF payer_left IS NOT NULL THEN
        raise_application_error(
            -20012,
            'Payer ' || :NEW.PayerId ||
            ' is not active in group ' || :NEW.AppGroupId
        );
    END IF;

    
    IF payee_left IS NOT NULL THEN
        raise_application_error(
            -20013,
            'Payee ' || :NEW.PayeeId ||
            ' is not active in group ' || :NEW.AppGroupId
        );
    END IF;
END;
/
--- 3. When sending a private message set automatically the message Id (as asequence) and the message date (current date).
Create sequence MessagePrivateSeq
START WITH 800
INCREMENT BY 1;
--- trigger for setting MessagePrivateId and MessageTime
Create OR REPLACE TRIGGER set_messageprivate_fields
Before Insert ON MessagePrivate
FOR EACH ROW
Begin
	:NEW.MessagePrivateId := MessagePrivateSeq.NEXTVAL;
	:NEW.MessageTime := SYSTIMESTAMP;
End;
/
--- 4. When the currency of the payment is different than the default currency of the group, it must exist a ExchangeRate from the currency of the payment to the default currency of the group for the payment date.
CREATE OR REPLACE TRIGGER ExchangeRateExists
BEFORE INSERT ON Payment
FOR EACH ROW
DECLARE
    v_base_currency_id  VARCHAR2(3);
    v_exchange_count    NUMBER;
BEGIN
    -- Step 1: Get the group's base currency
    SELECT BaseCurrencyId
    INTO v_base_currency_id
    FROM AppGroup
    WHERE AppGroupId = :NEW.AppGroupId;

    -- Step 2: Only proceed with check if currency is not base. (otherwise we are fine)
    IF :NEW.CurrencyId <> v_base_currency_id THEN
        
        -- Step 3: Check if a valid exchange rate exists on PaymentDate
        SELECT COUNT(*)
        INTO v_exchange_count
        FROM ExchangeRate ER
        WHERE ER.CurrencyFrom = :NEW.CurrencyId
          AND ER.CurrencyTo = v_base_currency_id
          AND ER.ExchangeDate = :NEW.PaymentDate; 

        -- Step 4: If NO exchange rate exists, raise error
        IF v_exchange_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 
                'No exchange rate exists for the payment currency to the group base currency on the payment date.');
        END IF;
    END IF;
END;
/
