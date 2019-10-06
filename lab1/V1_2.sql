USE AdventureWorks2012;
GO

/*
	������� �� ����� �����������, ������� ������� ��������� � ������:
	  �Accounts Manager�,�Benefits Specialist�,�Engineering Manager�,�Finance Manager�,�Maintenance Supervisor�,�Master Scheduler�,�Network Manager�.
	��������� ������� �� ��������� �������� �=�.
*/
SELECT
	BusinessEntityID,
	JobTitle,
	Gender,
	HireDate
FROM HumanResources.Employee
WHERE JobTitle IN (
	'Accounts Manager', 'Benefits Specialist', 'Engineering Manager', 'Finance Manager',
	'Maintenance Supervisor', 'Master Scheduler', 'Network Manager'
);

/*
	������� �� ����� ���������� �����������, �������� �� ������ ����� 2004 ���� (������� 2004 ���).
*/
SELECT COUNT(*) as EmpCount FROM HumanResources.Employee
WHERE HireDate >= '2004-01-01';

/*
	������� �� ����� 5(����) ����� ������� �����������, ��������� � �����, ������� ���� ������� �� ������ � 2004 ����.
*/
SELECT TOP(5)
	BusinessEntityID,
	JobTitle,
	MaritalStatus,
	Gender,
	BirthDate,
	HireDate
FROM HumanResources.Employee
WHERE MaritalStatus = 'M'
	AND DATEPART(year, HireDate) = '2004'
ORDER BY BirthDate DESC;