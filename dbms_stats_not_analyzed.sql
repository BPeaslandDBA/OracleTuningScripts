-- Used to gather stats on application tables that have missing stats

declare
cursor c1 is
select owner,table_name from dba_tables where last_analyzed is null 
and owner in (select grantee from dba_role_privs where granted_role like 'ECROP%')
order by 1,2;
v_own varchar2(30);
v_tab varchar2(30);
begin
open c1;
loop
fetch c1 into v_own,v_tab;
exit when c1%notfound;
dbms_stats.gather_table_stats(ownname=>v_own,tabname=>v_tab);
end loop;
close c1;
end;
/