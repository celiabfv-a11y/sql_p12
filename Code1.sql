--Drop the tables
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
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (301, 1, 101, 165.50, 401, TO_DATE('2023-01-18','YYYY-MM-DD'), TO_DATE('2023-01-18','YYYY-MM-DD'), 'Equal', 201); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (302, 2, 101, 80.25, 401, TO_DATE('2023-01-23','YYYY-MM-DD'), TO_DATE('2023-01-23','YYYY-MM-DD'), 'Shared', 202); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (303, 3, 101, 1250.00, 401, TO_DATE('2023-02-05','YYYY-MM-DD'), TO_DATE('2023-02-05','YYYY-MM-DD'), 'Exact', 203); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (304, 4, 102, 320.00, 401, TO_DATE('2023-02-24','YYYY-MM-DD'), TO_DATE('2023-02-24','YYYY-MM-DD'), 'Equal', 204); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (305, 5, 103, 215.00, 401, TO_DATE('2023-03-16','YYYY-MM-DD'), TO_DATE('2023-03-16','YYYY-MM-DD'), 'Shared', 207); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (306, 1, 104, 820.00, 406, TO_DATE('2025-06-10','YYYY-MM-DD'), TO_DATE('2025-06-10','YYYY-MM-DD'), 'Equal', 209); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (307, 7, 105, 615.00, 403, TO_DATE('2025-08-18','YYYY-MM-DD'), TO_DATE('2025-08-18','YYYY-MM-DD'), 'Shared', 212); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (308, 8, 106, 130.00, 402, TO_DATE('2022-11-05','YYYY-MM-DD'), TO_DATE('2022-11-05','YYYY-MM-DD'), 'Equal', 215); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (309, 9, 107, 970.00, 401, TO_DATE('2023-04-22','YYYY-MM-DD'), TO_DATE('2023-04-22','YYYY-MM-DD'), 'Exact', 217); 
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (310, 10, 108, 430.00, 401, TO_DATE('2023-05-26','YYYY-MM-DD'), TO_DATE('2023-05-26','YYYY-MM-DD'), 'Shared', 219);

--PARTICIPATIONEXPENSE (ORDERED BY EXPENSEID)
--- Expense 301 (165.50 JPY / Group 101) - Corrected de 55.17 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 1, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 2, 101, 55.17);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (301, 3, 101, 55.17);
--- Expense 302 (80.25 JPY / Group 101) - Corrected to 40.13 and 13.37 respectively
---- 50% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 1, 101, 40.13); 
---- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 2, 101, 13.37);
---- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 3, 101, 13.37);
---- 16.67% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (302, 4, 101, 13.37);
--- Expense 303 (1250.00 JPY / Group 101)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (303, 3, 101, 1250.00);
--- Expense 304 (320.00 JPY / Group 102)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 1, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 2, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 3, 102, 80.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (304, 4, 102, 80.00);
--- Expense 305 (215.00 JPY / Group 103) - Corrected to 200.00 for the only participant
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (305, 5, 103, 215.00);
--- Expense 306 (820.00 LYD / Group 104)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 1, 104, 410.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (306, 6, 104, 410.00);
--- Expense 307 (615.00 INR / Group 105)
---- 75% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 7, 105, 461.25);
---- 25% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (307, 8, 105, 153.25);
--- Expense 308 (130.00 AUD / Group 106) -
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (308, 8, 106, 130.00);
--- Expense 309 (970.00 JPY / Group 107) 
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (309, 9, 107, 970.00);
--- Expense 310 (430.00 JPY / Group 108)
---- 60% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 9, 108, 258.00);
---- 40% of the total expense
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (310, 10, 108, 172.00);

--PAYMENT
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (601, 1, 2, 101, 82.25, 401, TO_DATE('2023-01-25','YYYY-MM-DD'), 'Split groceries');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (602, 3, 1, 101, 430.00, 401, TO_DATE('2023-02-08','YYYY-MM-DD'), 'Monthly rent');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (603, 4, 2, 102, 165.50, 401, TO_DATE('2023-02-27','YYYY-MM-DD'), 'Shared trip costs');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (604, 5, 1, 103, 215.00, 401, TO_DATE('2023-03-18','YYYY-MM-DD'), 'Office supplies payback');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (605, 7, 1, 104, 430.00, 406, TO_DATE('2025-06-12','YYYY-MM-DD'), 'Flight refund');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (606, 8, 7, 105, 320.00, 403, TO_DATE('2025-08-20','YYYY-MM-DD'), 'Hotel cost share');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (607, 8, 8, 106, 130.00, 402, TO_DATE('2022-11-07','YYYY-MM-DD'), 'Dinner split');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (608, 9, 9, 107, 970.00, 401, TO_DATE('2023-04-25','YYYY-MM-DD'), 'Monthly rent');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (609, 10, 9, 108, 215.00, 401, TO_DATE('2023-05-28','YYYY-MM-DD'), 'Ski trip refund');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (610, 7, 5, 110, 320.00, 404, TO_DATE('2024-07-22','YYYY-MM-DD'), 'Travel refund');

--NOTIFICATION
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (701, 601, 2, '80.25 JPY from Lucas Ramírez', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (702, 602, 1, '430.00 JPY from Javier López', SYSTIMESTAMP, 'Y');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (703, 603, 2, '165.50 JPY from Valentina Santos', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (704, 604, 1, '215.00 JPY from Miguel Torres', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (705, 605, 1, '430.00 LYD from Omar Hernández', SYSTIMESTAMP, 'Y');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (706, 606, 7, '320.00 INR from Sergio Cruz', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (707, 607, 8, '130.00 AUD from Sergio Cruz', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (708, 608, 9, '970.00 JPY from Isabella Martínez', SYSTIMESTAMP, 'Y');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (709, 609, 9, '215.00 JPY from Diego Vargas', SYSTIMESTAMP, 'Y');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (710, 610, 5, '320.00 CAD from Omar Hernández', SYSTIMESTAMP, 'N');

--MESSAGEGROUP
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (801, 101, 1, 'Hello everyone, new group created!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (802, 102, 4, 'Pack your bags, the trip is near!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (803, 103, 5, 'Reminder: meeting at 10 AM', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (804, 104, 1, 'Japan trip is ready, get excited!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (805, 105, 7, 'Can’t wait for London adventure!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (806, 106, 8, 'Friday night plans, anyone?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (807, 107, 9, 'Rent is due, don’t forget!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (808, 108, 10, 'Ski weekend confirmed! ⛷️', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (809, 109, 11, 'Gym session tomorrow morning?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime)VALUES (810, 110, 7, 'Summer trip planning starts!', SYSTIMESTAMP);

--MESSAGEPRIVATE
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (901, 1, 2, 'Hey Maria, how are you?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (902, 2, 1, 'Thanks a lot!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (903, 3, 4, 'Are you ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (904, 4, 3, 'Can’t wait to start!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (905, 5, 6, 'Have you made the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (906, 6, 5, 'Almost done with it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (907, 7, 8, 'Will you join the Japan trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (908, 8, 7, 'Looking forward to it!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (909, 9, 10, 'Did you book everything?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (910, 10, 9, 'Yes, all set.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (911, 11, 1, 'Can you help me with this?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (912, 1, 11, 'Sure, what do you need?', SYSTIMESTAMP);

--Queries
--2. Obtain the average amount of the expenses for the months of June, July, and August of the year 2025. 
SELECT AVG(Expense.Amount), Expense.ExpenseDate,Expense.AppGroupId,Expense.CategoryId
FROM Expense
WHERE ExpenseDate >= TODATE(2025-06-01) AND ExpenseDate <= TODATE(2025-08-30)
GROUP BY AppGroup.AppGroupId, Category.CategoryId

--4. In progress
SELECT AppGroup.GroupName, AppUser.FirstName, AppUser.LastName
FROM AppGroup, AppUser
WHERE AppGroup.AppGroupId, AppUser.AppUserId IN
	(SELECT Payment.AppGroupId, Payment.PayerId, Payment.PayeeId
	FROM Payment
	WHERE Payment.Amount > (SELECT AVG(Payment.Amount) FROM Payment))
