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
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (401, 'EUR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (402, 'USD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (403, 'GBP');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (404, 'LYD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (405, 'TND');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (406, 'JPY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (407, 'CNY');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (408, 'INR');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (409, 'AUD');
INSERT INTO Currency (CurrencyId, CurrencyName) VALUES (410, 'CAD');

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
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (1, 'Emma', 'Hernández', 'Em', '+34 611-223344');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (2, 'Lucas', 'Martínez', NULL, '+34 622-334455');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (3, 'Valeria', 'Santos', NULL, '+34 633-445566');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (4, 'Andrés', 'López', 'Dragon', '+1 (333) 555-1212');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (5, 'Mateo', 'Ruiz', 'Falcon', '+1 (444) 666-1313');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (6, 'Sofía', 'Morales', 'Phoenix', '+1 (555) 777-1414');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (7, 'Omar', 'Khaled', NULL, '+218 092-4589123');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (8, 'Javier', 'Torres', 'JT', '+44 017-2009');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (9, 'Luna', 'Fernández', NULL, '+44 620-1010110');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (10, 'Gabriel', 'Cruz', 'Ace', '+34 632-2020304');
INSERT INTO AppUser (AppUserId, FirstName, LastName, "Alias", Phone) VALUES (11, 'Isabella', 'Vega', NULL, '+34 645-3031415');

---APPGROUP Cambiar 201-101
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (101, 'Home Budget', TO_DATE('2023-05-10', 'YYYY-MM-DD'), 'Family costs', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (102, 'Travel Buddies', TO_DATE('2023-06-15', 'YYYY-MM-DD'), 'Trip planning', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (103, 'Office Team', TO_DATE('2023-07-01', 'YYYY-MM-DD'), 'Work expenses', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (104, 'Tokyo2025', TO_DATE('2025-09-10', 'YYYY-MM-DD'), 'Japan trip', 406);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (105, 'London Tour', TO_DATE('2025-10-05', 'YYYY-MM-DD'), 'Travel costs', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (106, 'Weekend Fun', TO_DATE('2022-12-01', 'YYYY-MM-DD'), 'Weekly outings', 402);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (107, 'Apartment', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 'House costs', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (108, 'Ski Trip', TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'Ski weekend', 401);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (109, 'Gym Team', TO_DATE('2023-08-05', 'YYYY-MM-DD'), 'Fitness costs', 403);
INSERT INTO AppGroup (AppGroupId, GroupName, CreationDate, GroupDescription, BaseCurrencyId) VALUES (110, 'North Africa Tour', TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Travel costs', 404);

---MEMBERSHIP
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 101, TO_DATE('2025-01-10','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (2, 101, TO_DATE('2025-01-15','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (3, 101, TO_DATE('2025-01-20','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (4, 102, TO_DATE('2025-02-10','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (5, 103, TO_DATE('2025-03-05','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (6, 104, TO_DATE('2025-06-08','YYYY-MM-DD'), 'Member', TO_DATE('2025-06-28','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 104, TO_DATE('2025-06-07','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (7, 105, TO_DATE('2025-08-15','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (8, 105, TO_DATE('2025-08-16','YYYY-MM-DD'), 'Member', TO_DATE('2025-08-22','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (8, 106, TO_DATE('2022-11-05','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (9, 107, TO_DATE('2025-04-01','YYYY-MM-DD'), 'Owner', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (10, 108, TO_DATE('2025-05-05','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (9, 108, TO_DATE('2025-05-06','YYYY-MM-DD'), 'Admin', TO_DATE('2025-05-10','YYYY-MM-DD')); -- Left
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (11, 109, TO_DATE('2025-07-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (5, 110, TO_DATE('2025-07-15','YYYY-MM-DD'), 'Member', TO_DATE('2025-10-01','YYYY-MM-DD')); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (7, 110, TO_DATE('2025-07-16','YYYY-MM-DD'), 'Owner', NULL); 
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (1, 102, TO_DATE('2025-03-01','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (2, 102, TO_DATE('2025-03-05','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (3, 102, TO_DATE('2025-03-10','YYYY-MM-DD'), 'Admin', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (4, 101, TO_DATE('2025-02-25','YYYY-MM-DD'), 'Member', NULL);
INSERT INTO Membership (AppUserId, AppGroupId, JoiningDate, MemberRole, LeavingDate) VALUES (6, 102, TO_DATE('2025-03-15','YYYY-MM-DD'), 'Member', NULL);

---CATEGORY
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (401, 101, 'Groceries');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (402, 101, 'Utilities');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (403, 101, 'Rent');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (404, 102, 'Travel');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (405, 102, 'Dining');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (406, 102, 'Entertainment');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (407, 103, 'Office Supplies');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (408, 103, 'Client Entertainment');
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (409, 104, 'Flights');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (410, 104, 'Accommodation');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (411, 104, 'Food');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (412, 105, 'Flights');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (413, 105, 'Accommodation');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (414, 105, 'Food');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (415, 106, 'Dining');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (416, 106, 'Entertainment');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (417, 107, 'Rent');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (418, 107, 'Utilities');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (419, 108, 'Ski Passes');			
INSERT INTO Category (CategoryId, AppGroupId, CategoryName) VALUES (420, 108, 'Accommodation');

---EXPENSE Cambiar 401-301
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (401, 1, 201, 150.00, 1, TO_DATE('2023-01-16','YYYY-MM-DD'), TO_DATE('2023-01-16','YYYY-MM-DD'), 'Equal', 301);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (402, 102, 201, 75.00, 1, TO_DATE('2023-01-21','YYYY-MM-DD'), TO_DATE('2023-01-21','YYYY-MM-DD'), 'Shared', 302);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (403, 103, 201, 1200.00, 1, TO_DATE('2023-02-02','YYYY-MM-DD'), TO_DATE('2023-02-02','YYYY-MM-DD'), 'Exact', 303);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (404, 104, 202, 300.00, 1, TO_DATE('2023-02-22','YYYY-MM-DD'), TO_DATE('2023-02-22','YYYY-MM-DD'), 'Equal', 304);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (405, 105, 203, 200.00, 1, TO_DATE('2023-03-12','YYYY-MM-DD'), TO_DATE('2023-03-12','YYYY-MM-DD'), 'Shared', 307);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (406, 101, 204, 800.00, 6, TO_DATE('2025-06-07','YYYY-MM-DD'), TO_DATE('2025-06-07','YYYY-MM-DD'), 'Equal', 309);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (407, 107, 205, 600.00, 3, TO_DATE('2025-08-15','YYYY-MM-DD'), TO_DATE('2025-08-15','YYYY-MM-DD'), 'Shared', 312);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (408, 108, 206, 120.00, 2, TO_DATE('2022-11-03','YYYY-MM-DD'), TO_DATE('2022-11-03','YYYY-MM-DD'), 'Equal', 315);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (409, 109, 207, 950.00, 1, TO_DATE('2023-04-20','YYYY-MM-DD'), TO_DATE('2023-04-20','YYYY-MM-DD'), 'Exact', 317);
INSERT INTO Expense (ExpenseId, AppUserId, AppGroupId, Amount, CurrencyId, ExpenseDate, RegistrationDate, DivisionType, CategoryId) VALUES (410, 110, 208, 400.00, 1, TO_DATE('2023-05-24','YYYY-MM-DD'), TO_DATE('2023-05-24','YYYY-MM-DD'), 'Shared', 319);

---PARTICIPATIONEXPENSE (ORDERED BY EXPENSEID)
-- Expense 401 (150.00 EUR / Group 201)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 101, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 102, 201, 50.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (401, 103, 201, 50.00);
-- Expense 402 (75.00 EUR / Group 201) - Corrected to 18.75 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 101, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 102, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 103, 201, 18.75);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (402, 104, 201, 18.75);
-- Expense 403 (1200.00 EUR / Group 201)
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (403, 103, 201, 1200.00);
-- Expense 404 (300.00 EUR / Group 202) - Corrected to 75.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 101, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 102, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 103, 202, 75.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (404, 104, 202, 75.00);
-- Expense 405 (200.00 EUR / Group 203) - Corrected to 200.00 for the only participant
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (405, 105, 203, 200.00);
-- Expense 406 (800.00 JPY / Group 204) - Missing, added as 400.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 101, 204, 400.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (406, 106, 204, 400.00);
-- Expense 407 (600.00 GBP / Group 205) - Missing, added as 300.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 107, 205, 300.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (407, 108, 205, 300.00);
-- Expense 408 (120.00 USD / Group 206) - Missing, added as 120.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (408, 108, 206, 120.00);
-- Expense 409 (950.00 EUR / Group 207) - Missing, added as 950.00 for the only active member
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (409, 109, 207, 950.00);
-- Expense 410 (400.00 EUR / Group 208) - Missing, added as 200.00 each
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 109, 208, 200.00);
INSERT INTO ParticipationExpense (ExpenseId, AppUserId, AppGroupId, Amount) VALUES (410, 110, 208, 200.00);

---PAYMENT ambiar 501-601
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (501, 1, 102, 201, 75.00, 1, TO_DATE('2023-01-22','YYYY-MM-DD'), 'Reimbursement for utilities');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (502, 103, 1, 201, 400.00, 1, TO_DATE('2023-02-05','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (503, 104, 102, 202, 150.00, 1, TO_DATE('2023-02-25','YYYY-MM-DD'), 'Trip expenses');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (504, 105, 1, 203, 200.00, 1, TO_DATE('2023-03-15','YYYY-MM-DD'), 'Office supplies reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (505, 107, 1, 204, 400.00, 6, TO_DATE('2025-06-10','YYYY-MM-DD'), 'Flight reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (506, 108, 107, 205, 300.00, 3, TO_DATE('2025-08-18','YYYY-MM-DD'), 'Accommodation reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (507, 108, 108, 206, 120.00, 2, TO_DATE('2022-11-05','YYYY-MM-DD'), 'Dinner reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (508, 109, 109, 207, 950.00, 1, TO_DATE('2023-04-22','YYYY-MM-DD'), 'Rent payment');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (509, 110, 109, 208, 200.00, 1, TO_DATE('2023-05-26','YYYY-MM-DD'), 'Ski pass reimbursement');
INSERT INTO Payment (PaymentId, PayerId, PayeeId, AppGroupId, Amount, CurrencyId, PaymentDate, Note) VALUES (510, 107, 105, 210, 300.00, 4, TO_DATE('2024-07-20','YYYY-MM-DD'), 'Travel expenses reimbursement');

---NOTIFICATION Cambiar 601-701
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (601, 501, 102, '75.00 EUR from Mohammed Smith', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (602, 502, 1, '400.00 EUR from Mel Gibson', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (603, 503, 102, '150.00 EUR from Diana Prince', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (604, 504, 1, '200.00 EUR from Clark Kent', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (605, 505, 1, '400.00 JPY from Majid Ben Ghet', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (606, 506, 107, '300.00 GBP from Derek Trotter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (607, 507, 108, '120.00 USD from Derek Trotter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (608, 508, 109, '950.00 EUR from Harry Potter', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (609, 509, 109, '200.00 EUR from Rodrigo Campos', SYSTIMESTAMP, 'N');
INSERT INTO Notification (NotificationId, PaymentId, RecipientId, NotificationText, NotificationTime, IsRead) VALUES (610, 510, 105, '300.00 LYD from Majid Ben Ghet', SYSTIMESTAMP, 'N');

---MESSAGEGROUP Cambiar 701-801
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (701, 201, 1, 'Welcome to the expenses group', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (702, 202, 104, 'The trip is coming up soon', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (703, 203, 105, 'Don''t forget the meeting', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (704, 204, 101, 'Japan trip is coming up', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (705, 205, 107, 'Can''t wait for London', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (706, 206, 108, 'Friday night plans?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (707, 207, 109, 'Rent is due next week.', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (708, 208, 110, 'Ski weekend!', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (709, 209, 111, 'Gym session tomorrow?', SYSTIMESTAMP);
INSERT INTO MessageGroup (MessageGroupId, AppGroupId, SenderId, MessageText, MessageTime) VALUES (710, 210, 107, 'Summer trip planning!', SYSTIMESTAMP);

--MESSAGEPRIVATE CAmbiar 801-901
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (801, 1, 102, 'Hey Jimmy', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (802, 102, 1, 'Thank You.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (803, 103, 104, 'Ready for the trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (804, 104, 103, 'Can''t wait!', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (805, 105, 106, 'Did you make the payment?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (806, 106, 105, 'Peter, almost done.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (807, 107, 108, 'Are you joining the Japan trip?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (808, 108, 107, 'Looking forward to it.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (809, 109, 110, 'Did you book it?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (810, 110, 109, 'Yes I did.', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (811, 111, 1, 'Can you help me?', SYSTIMESTAMP);
INSERT INTO MessagePrivate (MessagePrivateId, SenderId, RecipientId, MessageText, MessageTime) VALUES (812, 101, 111, 'Sure, what do you need?', SYSTIMESTAMP);
