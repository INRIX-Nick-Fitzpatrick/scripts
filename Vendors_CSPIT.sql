/* Use CS PIT archive database DNFSQLARC04, select DB name, and change table name and date range as needed */

DECLARE @dbName VARCHAR(20)
SET @dbName = (SELECT DB_NAME());
PRINT @dbName
  
declare @starttime VARCHAR(25)
declare @endtime VARCHAR(25)     
set @starttime = '2017-3-7 00:00'
set @endtime = '2017-3-8 00:00' 

drop table ##pdata

DECLARE @execquery AS NVARCHAR(MAX)
DECLARE @tablename AS NVARCHAR(128)
DECLARE @temptable AS NVARCHAR(128)
SET @tablename = 'PIT03'
SET @temptable = '##pdata'
SET @execquery = N'SELECT * INTO ' + QUOTENAME(@temptable) + ' FROM ' + QUOTENAME(@tablename) + ' where ArrivalDtUtc between ''' + convert(nvarchar(25), @starttime, 121) + '''' + ' and ''' + convert(nvarchar(25), @endtime, 121) + ''''
PRINT @execquery
EXECUTE sp_executesql @execquery  

IF @dbName = 'CSPit_Mobile_Archive' 
	--select vendor ID from PIT, whitelist table, and production vendor name
	select p.VendorID as VendorIdPIT, ISNULL(vp.VendorID, -1) as VendorIdWhiteList, ISNULL(vp.[Description], -1) as VendorNmWhiteList, v1.VendorID as VendorIdDEN, v1.VendorName as VendorDEN
	, COUNT(*) as Volume
	from ##pdata p 
	left outer join DNWMSQL02.ConnectedServicesPIT.dbo.vendorprovider vp on p.VendorID = vp.VendorID
	left outer join DNWMSQL03.inrixtrafficservice.dbo.vendor v1 on p.VendorID = v1.VendorId
	where (p.VendorID not in (12587, 12627, 12669, 12670)) --internal testing VendorIds  12502, 12512,  12605, 12627, 12632
	group by p.VendorID, vp.VendorID, vp.[Description], v1.VendorID, v1.VendorName
	order by VendorIdWhiteList, Volume desc
ELSE
	--select vendor ID from PIT, whitelist table, and production vendor name
	select p.VendorID as VendorIdPIT, ISNULL(vp.VendorID, -1) as VendorIdWhiteList, ISNULL(vp.[Description], -1) as VendorNmWhiteList, v1.VendorID as VendorIdDEN, v1.VendorName as VendorDEN
	, COUNT(*) as Volume
	from ##pdata p 
	left outer join DNWSQL14.ConnectedServicesPIT.dbo.vendorprovider vp on p.VendorID = vp.VendorID
	left outer join DNWSQL05.[InrixTrafficService].dbo.vendor v1 on p.VendorID = v1.VendorId 
	where (p.VendorID not in (12587, 12627, 12669, 12670)) --internal testing VendorIds  12502, 12512,  12605, 12627, 12632
	group by p.VendorID, vp.VendorID, vp.[Description], v1.VendorID, v1.VendorName
	order by VendorIdWhiteList, Volume desc
