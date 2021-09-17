/* Query to Remove all user related data to enable testing of APIs - see chapter 13 */

USE [Demo Database BC (19-0)]
GO

SELECT *  FROM [dbo].[User]
DELETE FROM [dbo].[User]
SELECT *  FROM [dbo].[User]
GO

SELECT *  FROM [dbo].[User Property]
DELETE FROM [dbo].[User Property]
SELECT *  FROM [dbo].[User Property]
GO

SELECT *  FROM [dbo].[Page Data Personalization]
DELETE FROM [dbo].[Page Data Personalization]
SELECT *  FROM [dbo].[Page Data Personalization]
GO

SELECT *  FROM [dbo].[User Personalization]
DELETE FROM [dbo].[User Personalization]
SELECT *  FROM [dbo].[User Personalization]
GO

SELECT *  FROM [dbo].[Access Control]
DELETE FROM [dbo].[Access Control]
SELECT *  FROM [dbo].[Access Control]
GO
