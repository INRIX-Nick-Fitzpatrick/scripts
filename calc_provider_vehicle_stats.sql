/* Use any standard PIT archive database and change date range as needed */
declare @starttime VARCHAR(25)
declare @endtime VARCHAR(25)     
set @starttime = '2017-4-1 00:00'
set @endtime = '2017-4-20 00:00' 
--declare @providerId smallint  
--set @providerId = 385

drop table #rawdata
drop table #sumdup

select * into #rawdata
from pit04 (nolock)
where ArrivalDtUtc between @starttime and @endtime

select
	datepart(year,ArrivalDtUtc) as [year]
	,datepart(month,ArrivalDtUtc) as [month]
	,datepart(day,ArrivalDtUtc) as [day]
	,count(*) as rows_total
	,cast(count(distinct(analyticsvehicleid)) as bigint) as unique_devices
from #rawdata
GROUP BY datepart(year,ArrivalDtUtc), 
    datepart(month,ArrivalDtUtc), 
    datepart(day,ArrivalDtUtc)
order by 3 desc