USE AdventureWorks2012;
GO

/*
	a) Создайте таблицу Production.ProductCategoryHst, которая будет хранить информацию об изменениях в таблице Production.ProductCategory.
*/
CREATE TABLE Production.ProductCategoryHst (
	ID bigint PRIMARY KEY IDENTITY(1, 1),
	Action nchar(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate datetime NOT NULL,
	SourceID int NOT NULL,
	UserName nvarchar(30) NOT NULL
);
GO

/*
	b) Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Production.ProductCategory.
	   Триггер должен заполнять таблицу Production.ProductCategoryHst с указанием типа операции в поле Action
	   в зависимости от оператора, вызвавшего триггер.
*/
CREATE TRIGGER Production.ProductCategoryActionTrigger ON Production.ProductCategory
AFTER INSERT, UPDATE, DELETE AS
	DECLARE @datetime DATETIME;
	SET @datetime = CURRENT_TIMESTAMP;

	INSERT INTO Production.ProductCategoryHst (
		Action,
		ModifiedDate,
		SourceID,
		UserName
	)
	SELECT
		'UPDATE',
		@datetime,
		INSERTED.ProductCategoryID,
		CURRENT_USER
	FROM INSERTED
	INNER JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
	UNION ALL
		SELECT
			'INSERT',
			@datetime,
			INSERTED.ProductCategoryID,
			CURRENT_USER
		FROM INSERTED
		LEFT JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE DELETED.ProductCategoryID IS NULL
	UNION ALL
		SELECT
			'DELETE',
			@datetime,
			DELETED.ProductCategoryID,
			CURRENT_USER
		FROM DELETED
		LEFT JOIN INSERTED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE INSERTED.ProductCategoryID IS NULL;
GO

/*
	c) Создайте представление VIEW, отображающее все поля таблицы Production.ProductCategory.
*/
CREATE VIEW Production.ProductCategoryView AS
	SELECT * FROM Production.ProductCategory;
GO

/*
	d) Вставьте новую строку в Production.ProductCategory через представление. Обновите вставленную строку.
	   Удалите вставленную строку. Убедитесь, что все три операции отображены в Production.ProductCategoryHst.
*/
INSERT INTO Production.ProductCategoryView (Name)
VALUES ('newCategory');

UPDATE Production.ProductCategoryView SET Name = 'newName' WHERE Name = 'newCategory';

DELETE Production.ProductCategoryView WHERE Name = 'newName';

SELECT * FROM Production.ProductCategoryHst;