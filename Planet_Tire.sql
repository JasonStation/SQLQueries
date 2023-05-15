
USE planet_tire

--Nomor 1
SELECT
CustomerId,
CustomerName,
CustomerPhone,
CustomerEmail
FROM MsCustomer
WHERE CustomerName LIKE '%Filip%'

--Nomor 2
SELECT
s.StaffId,
StaffName,
StaffPhone,
StaffEmail
FROM MsStaff s JOIN SalesHeader sh ON sh.StaffId = s.StaffId
WHERE DATENAME(WEEKDAY, SalesDate) = 'Monday'

--Nomor 3
SELECT
[TypeId] = RIGHT(mtt.TypeId, 3),
TypeName,
TypeDurability,
[Total Stock] = SUM(Stock)
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
WHERE TypeName = 'Off Road'
GROUP BY mtt.TypeId, TypeName, TypeDurability

--Nomor 4
SELECT
mtt.TypeId,
TypeName,
[Highest Tire Sold] = MAX(Quantity),
[Total Stock] = SUM(Stock)
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
JOIN SalesDetail sd ON sd.TireId = mt.TireId
WHERE mtt.TypeId IN
(
	SELECT
	TypeId
	FROM MsTireType
	WHERE TypeName = 'Off Road'
)
GROUP BY mtt.TypeId, TypeName
UNION
SELECT
mtt.TypeId,
TypeName,
[Highest Tire Sold] = MAX(Quantity),
[Total Stock] = SUM(Stock)
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
JOIN SalesDetail sd ON sd.TireId = mt.TireId
GROUP BY mtt.TypeId, TypeName
HAVING SUM(Stock) > 2000
ORDER BY SUM(Stock) DESC

--Nomor 5
SELECT
mtt.TypeId,
[TypeName] = UPPER(TypeName),
TireName,
[DateCreated] = CONVERT(VARCHAR(20), DateCreated, 107),
Stock,
Quantity
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
JOIN SalesDetail sd ON sd.TireId = mt.TireId
WHERE TireName IN ('ICESTONE', 'TIRELLI', 'DEVELOP TIRES') AND
Quantity > 4

--Nomor 6
SELECT
sd.SalesId,
[SalesDate] = CONVERT(VARCHAR(20), SalesDate, 106),
TireName,
TypeName,
[Quantity] = CAST(Quantity AS VARCHAR(5)) + ' Pc(s)'
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
JOIN SalesDetail sd ON sd.TireId = mt.TireId
JOIN SalesHeader sh ON sh.SalesId = sd.SalesId,
(
	SELECT
	[Type Durability] = AVG(TypeDurability)
	FROM MsTireType
)a
WHERE TypeDurability >= a.[Type Durability] AND
YEAR(sh.SalesDate) = 2020

--Nomor 7
CREATE VIEW [StaffSalesRecap] AS
SELECT
s.StaffId,
SalesId,
StaffName,
StaffEmail,
[SalesDate] = CONVERT(VARCHAR(20), SalesDate, 103)
FROM MsStaff s JOIN SalesHeader sh ON s.StaffId = sh.StaffId
WHERE YEAR(SalesDate) < 2019

--Nomor 8
CREATE VIEW [TireSoldSummary] AS
SELECT
[TypeId] = REPLACE(mt.TypeId, 'TY', 'Type '),
TypeName,
TypeDurability,
[Highest Sold Quantity] = MAX(Quantity),
SalesDate
FROM MsTireType mtt JOIN MsTire mt ON mt.TypeId = mtt.TypeId
JOIN SalesDetail sd ON sd.TireId = mt.TireId
JOIN SalesHeader sh ON sh.SalesId = sd.SalesId
WHERE
mt.TypeId IN
(
	SELECT
	TypeId
	FROM MsTireType
	WHERE TypeDurability > 70
)
AND MONTH(SalesDate) = 8
GROUP BY mt.TypeId, TypeName, SalesDate, TypeDurability

--Nomor 9
ALTER TABLE MsTireType
ADD TypeMaterial VARCHAR(50)

ALTER TABLE MsTireType
ADD CONSTRAINT MaterialCheck CHECK(TypeMaterial IN ('Natural Rubber', 'Synthetic Rubber'))

--Nomor 10
UPDATE MsStaff
SET StaffSalary = StaffSalary + 1000000
FROM MsStaff s JOIN SalesHeader sh ON sh.StaffId = s.StaffId
JOIN SalesDetail sd ON sh.SalesId = sd.SalesId
WHERE Quantity >= 8 AND StaffSalary < 5000000





