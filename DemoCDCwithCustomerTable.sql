declare @rc int
exec @rc = sys.sp_cdc_enable_db
select @rc
-- new column added to sys.databases: is_cdc_enabled
select name, is_cdc_enabled from sys.databases
--/
exec sys.sp_cdc_enable_table 
    @source_schema = 'dbo', 
    @source_name = 'customer' ,
    @role_name = 'CDCRole',
    @supports_net_changes = 1
--/
select name, type, type_desc, is_tracked_by_cdc from sys.tables
--/
insert customer values ('abc company', 'md')
insert customer values ('xyz company', 'de')
insert customer values ('xox company', 'va')
update customer set state = 'pa' where id = 1
delete from customer where id = 3
--/
declare @begin_lsn binary(10), @end_lsn binary(10)
-- get the first LSN for customer changes
select @begin_lsn = sys.fn_cdc_get_min_lsn('dbo_customer')
-- get the last LSN for customer changes
select @end_lsn = sys.fn_cdc_get_max_lsn()
-- get net changes; group changes in the range by the pk
select * from cdc.fn_cdc_get_net_changes_dbo_customer(@begin_lsn, @end_lsn,'all'); 
-- get individual changes in the range
select * from cdc.fn_cdc_get_all_changes_dbo_customer(@begin_lsn, @end_lsn,'all');
--/
create table dbo.customer_lsn (last_lsn binary(10))
--/
create function dbo.get_last_customer_lsn() 
returns binary(10)
as
begin
 declare @last_lsn binary(10)
 select @last_lsn = last_lsn from dbo.customer_lsn
 select @last_lsn = isnull(@last_lsn, sys.fn_cdc_get_min_lsn('dbo_customer'))
 return @last_lsn
end
--/

declare @begin_lsn binary(10), @end_lsn binary(10)
-- get the first LSN for customer changes
select @begin_lsn = sys.fn_cdc_get_min_lsn('dbo_customer')
-- get the last LSN for customer changes
select @end_lsn = sys.fn_cdc_get_max_lsn()
-- get net changes; group changes in the range by the pk
select * from cdc.fn_cdc_get_net_changes_dbo_customer(@begin_lsn, @end_lsn, 'all'); 
-- get individual changes in the range
select * from cdc.fn_cdc_get_all_changes_dbo_customer(@begin_lsn, @end_lsn, 'all');
-- save the end_lsn in the customer_lsn table
update dbo.customer_lsn
set last_lsn = @end_lsn
if @@ROWCOUNT = 0
insert into dbo.customer_lsn values(@end_lsn)