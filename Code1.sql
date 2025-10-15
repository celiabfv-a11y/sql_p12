--Drop the tables;
DROP TABLE AppUser CASCADE CONSTRAINTS;
DROP TABLE AppGroup CASCADE CONSTRAINTS;
DROP TABLE Category CASCADE CONSTRAINTS;
DROP TABLE Currency CASCADE CONSTRAINTS;
DROP TABLE ExchangeRate CASCADE CONSTRAINTS;
DROP TABLE Expense CASCADE CONSTRAINTS;
DROP TABLE ParticipationExpense CASCADE CONSTRAINTS;
DROP TABLE Membership CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Notification CASCADE CONSTRAINTS;
DROP TABLE MessageGroup CASCADE CONSTRAINTS;
DROP TABLE MessagePrivate CASCADE CONSTRAINTS;

--Create the tables
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

CREATE TABLE Category (
	CategoryId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	CategoryName VARCHAR(30) NOT NULL,
	constraint Category_PK PRIMARY KEY (CategoryId));

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

CREATE TABLE Notification (
	NotificationId NUMBER NOT NULL,
	PaymentId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	NotificationText VARCHAR2(30) NOT NULL,
	NotificationTime TIMESTAMP NOT NULL,
	IsRead CHAR(1) NOT NULL CHECK (IsRead IN ('Y', 'N')),
	constraint Notification_PK PRIMARY KEY (NotificationId));

CREATE TABLE MessageGroup (
	MessageGroupId NUMBER NOT NULL,
	AppGroupId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessageGroup_PK PRIMARY KEY (MessageGroupId));

CREATE TABLE MessagePrivate (
	MessagePrivateId NUMBER NOT NULL,
	SenderId NUMBER NOT NULL,
	RecipientId NUMBER NOT NULL,
	MessageText VARCHAR2(30) NOT NULL,
	MessageTime TIMESTAMP NOT NULL,
	constraint MessagePrivate_PK PRIMARY KEY (MessagePrivateId));


--Add foreign keys
ALTER TABLE AppGroup ADD CONSTRAINT AppGroup_fk0 FOREIGN KEY (BaseCurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Membership ADD CONSTRAINT Membership_fk0 FOREIGN KEY (AppUserId) REFERENCES AppUser(AppUserId);
ALTER TABLE Membership ADD CONSTRAINT Membership_fk1 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE Expense ADD CONSTRAINT Expense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
--ALTER TABLE Expense ADD CONSTRAINT Expense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);
ALTER TABLE Expense ADD CONSTRAINT Expense_fk3 FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId);

ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk0 FOREIGN KEY (AppUserId, AppGroupId) REFERENCES Membership(AppUserId, AppGroupId);
--ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk1 FOREIGN KEY (AppGroupId) REFERENCES Membership(AppGroupId);
ALTER TABLE ParticipationExpense ADD CONSTRAINT ParticipationExpense_fk2 FOREIGN KEY (ExpenseId) REFERENCES Expense(ExpenseId);

ALTER TABLE Category ADD CONSTRAINT Category_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);

ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk0 FOREIGN KEY (CurrencyFrom) REFERENCES Currency(CurrencyId);
ALTER TABLE ExchangeRate ADD CONSTRAINT ExchangeRate_fk1 FOREIGN KEY (CurrencyTo) REFERENCES Currency(CurrencyId);

ALTER TABLE Payment ADD CONSTRAINT Payment_fk0 FOREIGN KEY (AppGroupId, PayerId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk1 FOREIGN KEY (AppGroupId, PayeeId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE Payment ADD CONSTRAINT Payment_fk2 FOREIGN KEY (CurrencyId) REFERENCES Currency(CurrencyId);

ALTER TABLE Notification ADD CONSTRAINT Notification_fk0 FOREIGN KEY (PaymentId) REFERENCES Payment(PaymentId);
ALTER TABLE Notification ADD CONSTRAINT Notification_fk1 FOREIGN KEY (RecipientId) REFERENCES AppUser(AppUserId);

ALTER TABLE MessageGroup ADD CONSTRAINT MessageGroup_fk0 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);

ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk0 FOREIGN KEY (AppGroupId) REFERENCES AppGroup(AppGroupId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk1 FOREIGN KEY (AppGroupId, SenderId) REFERENCES Membership(AppGroupId, AppUserId);
ALTER TABLE MessagePrivate ADD CONSTRAINT MessagePrivate_fk2 FOREIGN KEY (AppGroupId, RecipientId) REFERENCES Membership(AppGroupId, AppUserId);

--INSERTIONS
--CURRENCY
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

--EXCHANGERATE
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (501, 401, 402, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.12);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (502, 402, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.89);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (503, 401, 403, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.87);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (504, 403, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.15);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (505, 401, 404, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 5.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (506, 404, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.21);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (507, 401, 405, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 3.25);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (508, 405, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.31);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (509, 401, 406, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.42);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (510, 406, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0071);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (511, 401, 407, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 7.60);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (512, 407, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.132);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (513, 401, 408, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 91.00);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (514, 408, 401, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 0.0109);
INSERT INTO ExchangeRate (RateId, CurrencyFrom, CurrencyTo, ExchangeDate, Rate) VALUES (515, 401, 409, TO_DATE('2025-10-15', 'YYYY-MM-DD'), 1.58);
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

--APPUSER
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (1, 'Lucas', 'Ramírez', 'Luki', '+34 600-1112233');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (2, 'María', 'Fernández', NULL, '+34 611-2233445');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (3, 'Javier', 'López', NULL, '+34 622-3344556');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (4, 'Valentina', 'Santos', 'Vally', '+1 (333) 444-5566');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (5, 'Miguel', 'Torres', 'Miggy', '+1 (444) 555-6677');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (6, 'Elena', 'Morales', 'Eli', '+1 (555) 666-7788');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (7, 'Omar', 'Hernández', NULL, '+218 092-1234567');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (8, 'Sergio', 'Cruz', 'SC', '+44 017-2020304');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (9, 'Isabella', 'Martínez', NULL, '+44 620-1011122');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (10, 'Diego', 'Vargas', 'D-V', '+34 632-2021223');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (11, 'Laura', 'Ríos', NULL, '+34 645-3031324');

---APPGROUP
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (101, 'Home Budget', TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Monthly home costs', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (102, 'Travel Crew', TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Trips with friends', 402);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (103, 'Office Team', TO_DATE('2025-03-05', 'YYYY-MM-DD'), 'Work expenses', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (104, 'Tokyo Trip', TO_DATE('2025-06-07', 'YYYY-MM-DD'), 'Japan travel', 406);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (105, 'London Tour', TO_DATE('2025-08-15', 'YYYY-MM-DD'), 'UK sightseeing', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (106, 'Weekend Fun', TO_DATE('2022-11-03', 'YYYY-MM-DD'), 'Friday night fun', 402);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (107, 'House Rent', TO_DATE('2025-04-20', 'YYYY-MM-DD'), 'Monthly rent', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (108, 'Ski Trip', TO_DATE('2025-05-25', 'YYYY-MM-DD'), 'Snow weekend', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (109, 'Fitness Club', TO_DATE('2025-06-28', 'YYYY-MM-DD'), 'Gym group', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (110, 'North Africa', TO_DATE('2025-07-12', 'YYYY-MM-DD'), 'Summer travel', 404);

--MEMBERSHIP
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

--CATEGORY
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (201, 101, 'Supermarket');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (202, 101, 'Bills');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (203, 101, 'Housing');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (204, 102, 'Trips');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (205, 102, 'Restaurants');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (206, 102, 'Leisure');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (207, 103, 'Office Items');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (208, 103, 'Client Meals');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (209, 104, 'Air Tickets');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (210, 104, 'Hotel');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (211, 104, 'Meals');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (212, 105, 'Flights');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (213, 105, 'Lodging');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (214, 105, 'Food & Drinks');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (215,106, 'Dining Out');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (216,106, 'Fun');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (217,107, 'Rent Payment');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (218,107, 'Utilities Bills');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (219,108, 'Ski Tickets');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (220,108, 'Hotel Stay');

--EXPENSE
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (301, 1, 101, 165.50, 1, TO_DATE('2023-01-18','YYYY-MM-DD'), TO_DATE('2023-01-18','YYYY-MM-DD'), 'Equal', 401); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (302, 2, 101, 80.25, 1, TO_DATE('2023-01-23','YYYY-MM-DD'), TO_DATE('2023-01-23','YYYY-MM-DD'), 'Shared', 402); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (303, 3, 101, 1250.00, 1, TO_DATE('2023-02-05','YYYY-MM-DD'), TO_DATE('2023-02-05','YYYY-MM-DD'), 'Exact', 403); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (304, 4, 102, 320.00, 1, TO_DATE('2023-02-24','YYYY-MM-DD'), TO_DATE('2023-02-24','YYYY-MM-DD'), 'Equal', 404); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (305, 5, 103, 215.00, 1, TO_DATE('2023-03-16','YYYY-MM-DD'), TO_DATE('2023-03-16','YYYY-MM-DD'), 'Shared', 407); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (306, 1, 104, 820.00, 6, TO_DATE('2025-06-10','YYYY-MM-DD'), TO_DATE('2025-06-10','YYYY-MM-DD'), 'Equal', 409); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (307, 7, 105, 615.00, 3, TO_DATE('2025-08-18','YYYY-MM-DD'), TO_DATE('2025-08-18','YYYY-MM-DD'), 'Shared', 412); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (308, 8, 106, 130.00, 2, TO_DATE('2022-11-05','YYYY-MM-DD'), TO_DATE('2022-11-05','YYYY-MM-DD'), 'Equal', 415); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (309, 9, 107, 970.00, 1, TO_DATE('2023-04-22','YYYY-MM-DD'), TO_DATE('2023-04-22','YYYY-MM-DD'), 'Exact', 417); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (310, 10, 108, 430.00, 1, TO_DATE('2023-05-26','YYYY-MM-DD'), TO_DATE('2023-05-26','YYYY-MM-DD'), 'Shared', 419);

--PARTICIPATIONEXPENSE (ORDERED BY EXPENSEID)
--- Expense 301 (165.50 EUR / Group 101) - Corrected de 55.17 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 1, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 2, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 3, 101, 55.17);
--- Expense 302 (80.25 EUR / Group 101) - Corrected to 18.75 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 1, 101, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 2, 101, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 3, 101, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 4, 101, 18.75);
--- Expense 303 (1250.00 EUR / Group 101)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (303, 3, 101, 1200.00);
--- Expense 304 (320.00 EUR / Group 102) - Corrected to 75.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 1, 102, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 2, 102, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 3, 102, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 4, 102, 75.00);
--- Expense 305 (215.00 EUR / Group 103) - Corrected to 200.00 for the only participant
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (305, 5, 103, 200.00);
--- Expense 306 (820.00 JPY / Group 104) - Missing, added as 400.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 1, 104, 400.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 6, 104, 400.00);
--- Expense 307 (615.00 GBP / Group 105) - Missing, added as 300.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 7, 105, 300.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 8, 105, 300.00);
--- Expense 308 (130.00 USD / Group 106) - Missing, added as 120.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (308, 8, 106, 120.00);
--- Expense 309 (970.00 EUR / Group 107) - Missing, added as 950.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (309, 9, 107, 950.00);
--- Expense 310 (430.00 EUR / Group 108) - Missing, added as 200.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 9, 108, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 10, 108, 200.00);

--PAYMENT
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (401, 1, 102, 101, 75.00, 1, TO_DATE('2023-01-22','YYYY-MM-DD'), 'Reimbursement for utilities');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (402, 3, 1, 101, 400.00, 1, TO_DATE('2023-02-05','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (403, 4, 102, 102, 150.00, 1, TO_DATE('2023-02-25','YYYY-MM-DD'), 'Trip expenses');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (404, 5, 1, 103, 200.00, 1, TO_DATE('2023-03-15','YYYY-MM-DD'), 'Office supplies reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (405, 7, 1, 104, 400.00, 6, TO_DATE('2025-06-10','YYYY-MM-DD'), 'Flight reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (406, 8, 107, 105, 300.00, 3, TO_DATE('2025-08-18','YYYY-MM-DD'), 'Accommodation reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (407, 8, 108, 106, 120.00, 2, TO_DATE('2022-11-05','YYYY-MM-DD'), 'Dinner reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (408, 9, 109, 107, 950.00, 1, TO_DATE('2023-04-22','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (409, 10, 109, 108, 200.00, 1, TO_DATE('2023-05-26','YYYY-MM-DD'), 'Ski pass reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (410, 7, 105, 110, 300.00, 4, TO_DATE('2024-07-20','YYYY-MM-DD'), 'Travel expenses reimbursement');
---NOTIFICATION
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (501, 401, 2, '75.00 EUR from Mohammed Smith', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (502, 402, 1, '400.00 EUR from Mel Gibson', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (503, 403, 2, '150.00 EUR from Diana Prince', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (504, 404, 1, '200.00 EUR from Clark Kent', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (505, 405, 1, '400.00 JPY from Majid Ben Ghet', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (506, 406, 7, '300.00 GBP from Derek Trotter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (507, 407, 8, '120.00 USD from Derek Trotter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (508, 408, 9, '950.00 EUR from Harry Potter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (509, 409, 9, '200.00 EUR from Rodrigo Campos', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (510, 410, 5, '300.00 LYD from Majid Ben Ghet', SYSTIMESTAMP, 'N');
---MESSAGEGROUP
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (601, 101, 1, 'Welcome to the expenses group', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (602, 102, 4, 'The trip is coming up soon', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (603, 103, 5, 'Don''t forget the meeting', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (604, 104, 1, 'Japan trip is coming up', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (605, 105, 7, 'Can''t wait for London', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (606, 106, 8, 'Friday night plans?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (607, 107, 9, 'Rent is due next week.', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (608, 108, 10, 'Ski weekend!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (609, 109, 11, 'Gym session tomorrow?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (610, 110, 7, 'Summer trip planning!', SYSTIMESTAMP);
--MESSAGEPRIVATE
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (701, 1, 2, 'Hey Jimmy', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (702, 2, 1, 'Thank You.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (703, 3, 4, 'Ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (704, 4, 3, 'Can''t wait!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (705, 5, 6, 'Did you make the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (706, 6, 5, 'Peter, almost done.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (707, 7, 8, 'Are you joining the Japan trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (708, 8, 7, 'Looking forward to it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (709, 9, 10, 'Did you book it?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (710, 10, 9, 'Yes I did.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (711, 11, 1, 'Can you help me?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (712, 1, 11, 'Sure, what do you need?', SYSTIMESTAMP);
