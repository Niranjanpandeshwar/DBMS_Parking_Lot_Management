
CREATE TABLE PARKINGLOT(
NAME VARCHAR2(20) PRIMARY KEY,
ADDRESS VARCHAR2(30));


CREATE TABLE SPACE(
SPACEID VARCHAR2(10) NOT NULL,
SPACETYPE VARCHAR2(12) DEFAULT 'regular',
LOTNAME VARCHAR2(20),
CONSTRAINT SPACE_LOT FOREIGN KEY(LOTNAME) REFERENCES PARKINGLOT(NAME) ON DELETE CASCADE,
PRIMARY KEY(SPACEID, LOTNAME));


CREATE TABLE ZONE(
ZONEID CHAR(5) PRIMARY KEY, 
CONSTRAINT ZONES_ID CHECK (ZONEID IN ('A','B','C','D','AS','BS','CS','DS','R','RS','V')) );

CREATE TABLE REL_ALLOCATED(
ZONEID CHAR(5) NOT NULL,
NAME VARCHAR2(20) NOT NULL,
CONSTRAINT REL_ALLOCATED_ZONE FOREIGN KEY(ZONEID) REFERENCES ZONE(ZONEID),
CONSTRAINT REL_ALLOCATED_LOT FOREIGN KEY(NAME) REFERENCES PARKINGLOT(NAME),
PRIMARY KEY(ZONEID, NAME));


CREATE TABLE NONVISITOR(
UNIVID VARCHAR2(20) PRIMARY KEY,
PHONENO NUMBER(10));

CREATE TABLE STUDENT(
UNIVID VARCHAR2(20) PRIMARY KEY,
CONSTRAINT STUDENT_NONVISITOR FOREIGN KEY(UNIVID) REFERENCES NONVISITOR(UNIVID) ON DELETE CASCADE);

CREATE TABLE EMPLOYEE(
UNIVID VARCHAR2(20) PRIMARY KEY,
ISADMIN NUMBER(1) DEFAULT 0,
CONSTRAINT EMPLOYEE_NONVISITOR FOREIGN KEY(UNIVID) REFERENCES NONVISITOR(UNIVID) ON DELETE CASCADE);

CREATE TABLE PERMIT(
PERMITNO VARCHAR2(8) PRIMARY KEY,
ZONEID CHAR(5) NOT NULL,
STARTDATE DATE NOT NULL,
PRIMARYVEHICLENO VARCHAR2(10) NOT NULL,
SPACETYPE VARCHAR2(12) DEFAULT 'regular' );

CREATE TABLE VISITORPERMIT(
LOTNAME VARCHAR(20) NOT NULL,
STARTTIME TIMESTAMP NOT NULL,
EXPIRETIME TIMESTAMP NOT NULL,
EXPIREDATE DATE NOT NULL,
SPACENO VARCHAR(10) NOT NULL,
PHONENO NUMBER(10) NOT NULL,
PERMITNO VARCHAR2(8) PRIMARY KEY,
CONSTRAINT PERMIT_VISITORPERMIT FOREIGN KEY(PERMITNO) REFERENCES PERMIT(PERMITNO) ON DELETE CASCADE);


CREATE TABLE REL_VISITORZONEACCESS(
PERMITNO VARCHAR2(8) NOT NULL,
ZONEID CHAR(5) NOT NULL,
PRIMARY KEY(PERMITNO, ZONEID),
CONSTRAINT REL_VISITORZONEACCESS_ZONE FOREIGN KEY(ZONEID) REFERENCES ZONE(ZONEID) ON DELETE CASCADE,
CONSTRAINT REL_VISITORZONEACCESS_PERMIT FOREIGN KEY(PERMITNO) REFERENCES VISITORPERMIT(PERMITNO) ON DELETE CASCADE,
CONSTRAINT VISITOR_ZONES CHECK (ZONEID = 'V') );


CREATE TABLE NONVISITORPERMIT( 
PERMITNO VARCHAR2(8) PRIMARY KEY, 
UNIVID VARCHAR2(20) NOT NULL, 
EXPIRETIME TIMESTAMP NOT NULL, 
EXPIREDATE DATE NOT NULL,
CONSTRAINT PERMIT_NONVISITORPERMIT FOREIGN KEY(PERMITNO) REFERENCES PERMIT(PERMITNO) ON DELETE CASCADE, 
CONSTRAINT NONVISITOR_NONVISITORPERMIT FOREIGN KEY(UNIVID) REFERENCES NONVISITOR(UNIVID) ON DELETE CASCADE);


CREATE TABLE REL_NONVISITORZONEACCESS(
PERMITNO VARCHAR2(8) NOT NULL,
ZONEID CHAR(5) NOT NULL,
PRIMARY KEY(PERMITNO, ZONEID),
CONSTRAINT REL_NONVISITORACCESS_ZONE FOREIGN KEY(ZONEID) REFERENCES ZONE(ZONEID) ON DELETE CASCADE,
CONSTRAINT REL_NONVISITORACCESS_PERMIT FOREIGN KEY(PERMITNO) REFERENCES NONVISITORPERMIT(PERMITNO) ON DELETE CASCADE,
CONSTRAINT NONVISITOR_ZONES CHECK (ZONEID IN ('A','B','C','D','AS','BS','CS','DS','R','RS')) );


CREATE TABLE VEHICLE(
LICENSEPLATE VARCHAR2(10) PRIMARY KEY,
MANUFACTURER VARCHAR2(20),
MODEL VARCHAR2(20),
YEAR NUMBER(4),
COLOR VARCHAR2(15),
PERMITNO VARCHAR2(8) NOT NULL,
CONSTRAINT FK_VEHICLE_PERMIT FOREIGN KEY(PERMITNO) REFERENCES PERMIT(PERMITNO) ON DELETE CASCADE);


CREATE TABLE ASSIGNMULTIPLE(
UNIVID VARCHAR2(20) NOT NULL,
PERMITNO VARCHAR(8) NOT NULL,
VEHICLENO VARCHAR2(20) PRIMARY KEY,
CONSTRAINT FK_VEHICLE_ASSIGNMULTIPLE FOREIGN KEY(VEHICLENO) REFERENCES VEHICLE(LICENSEPLATE) ON DELETE CASCADE,
CONSTRAINT FK_NONVISITOR_ASSIGNMULTIPLE FOREIGN KEY(PERMITNO) REFERENCES NONVISITORPERMIT(PERMITNO) ON DELETE CASCADE, 
CONSTRAINT FK_EMPLOYEE_ASSIGNMULTIPLE FOREIGN KEY(UNIVID) REFERENCES EMPLOYEE(UNIVID) ON DELETE CASCADE);


CREATE TABLE CITATION(
CITATIONNO NUMBER(10) PRIMARY KEY,
CARLICENSENO VARCHAR2(10) NOT NULL,
MODEL VARCHAR2(20),
COLOR VARCHAR2(15),
ISSUEDATE DATE,
STATUS VARCHAR2(10) DEFAULT 'unpaid',
TYPE VARCHAR(10) NOT NULL,
LOT VARCHAR(20) NOT NULL,
ISSUETIME TIMESTAMP NOT NULL,
VIOLATIONCATEGORY VARCHAR2(10) NOT NULL,
PAYMENTDUE DATE NOT NULL,
VIOLATIONFEE NUMBER(2) NOT NULL,
CONSTRAINT CITATION_CATEGORY CHECK ( VIOLATIONCATEGORY IN ('Invalid Permit','Expired Permit', 'No Permit')),
CONSTRAINT CITATION_VIOLATIONFEE CHECK ( VIOLATIONFEE IN (20,25,30)) );

CREATE TABLE NOTIFICATIONVISITOR(
PHONENO NUMBER(10) NOT NULL,
CITATIONNO NUMBER(10) NOT NULL,
PRIMARY KEY (PHONENO, CITATIONNO),
CONSTRAINT FK_CITATION_NOTIFVISITOR FOREIGN KEY(CITATIONNO) REFERENCES CITATION(CITATIONNO));

CREATE TABLE NOTIFICATIONNONVISITOR(
UNIVID VARCHAR2(20) NOT NULL,
CITATIONNO NUMBER(10) NOT NULL,
PRIMARY KEY (UNIVID, CITATIONNO),
CONSTRAINT FK_CITATION_NOTIFNONVISITOR FOREIGN KEY(CITATIONNO) REFERENCES CITATION(CITATIONNO));