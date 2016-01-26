-- Shows which sessions are holding the X pin,
-- that are blocking sessions waiting on the S pin. 

select s.inst_id as blocked_inst,
       s.sid as blocked_sid, 
       s.username as blocked_user,
       sa.sql_id as blocked_sql_id,
       trunc(s.p2/4294967296) as blocking_sid,
       b.username as blocking_user,
       b.sql_id as blocking_sql_id
from   gv$session s
join   gv$sqlarea sa
  on   sa.hash_value = s.p1
join   gv$session b
  on   trunc(s.p2/4294967296)=b.sid
  and  s.inst_id=b.inst_id
join   gv$sqlarea sa2
  on   b.sql_id=sa2.sql_id
where  s.event='cursor: pin S wait on X';




