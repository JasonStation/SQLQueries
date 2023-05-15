USE CompShop;

--2440051574 - Jason Leonardo Sutioso

--Nomor 1
CREATE TABLE MsSoftware(
	SoftwareID CHAR(5) PRIMARY KEY CHECK(SoftwareID LIKE 'SW[0-9][0-9][0-9]'),
	SoftwareName VARCHAR(50) NOT NULL,
	SoftwareType VARCHAR(100) NOT NULL CHECK (SoftwareType LIKE 'Application' OR SoftwareType = 'System' OR SoftwareType = 'Programming' OR SoftwareType = 'Driver')
)

INSERT INTO SoftwareID VALUES('SW022', 'ssss', 'ss');

--Nomor 2
ALTER TABLE MsStaff
ADD StaffEmail VARCHAR(50);

ALTER TABLE MsStaff
ADD CONSTRAINT EmailConstraint CHECK(StaffEmail LIKE '%.com');

--Nomor 3
INSERT INTO MsProduct(ProductID, ProductTypeID, ProductName, ProductDescription)
VALUES('PD006', 'PT001', 'WD My Passport Ultra', 'Portable drive delivers quick and easy storage for your PC');

--Nomor 4
SELECT
[StaffName] = UPPER(StaffName),
StaffGender,
StaffPhoneNumber
FROM MsStaff
WHERE
StaffSalary > 500000;

--Nomor 5
UPDATE MsStaff
SET StaffSalary = 100000
FROM
MsStaff ms,
HeaderTransaction ht
WHERE
ms.StaffID = ht.StaffID AND
ht.CustomerID LIKE 'CU004';




