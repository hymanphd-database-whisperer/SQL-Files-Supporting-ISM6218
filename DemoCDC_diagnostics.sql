
--test parameters are valid and return values
declare @begin_lsn binary(10), @end_lsn binary(10)
SELECT @Begin_LSN, @End_LSN, N'all';

--check the object is being captured in the change table
select capture_instance from cdc.change_tables

--disable CDC at database level
declare @rc int
exec @rc = sys.sp_cdc_disable_db
select @rc

-- show databases and their CDC setting
select name, is_cdc_enabled from sys.databases

--enable CDC at database level
declare @rc int
exec @rc = sys.sp_cdc_enable_db
select @rc

--check capture_instance name
SELECT * FROM cdc.change_tables