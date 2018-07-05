修改表类型：
alter table table_name modify [column] column_definition [FIRST | AFTER col_name]
alter table emp modify ename varchar(20)

增加表字段：
ALTER TABLE table_name ADD [COLUMN] column_definition [FIRST | AFTER col_name]
alter table emp add column age int(3)

alter table emp drop column age 

alter table emp change age age1 int(4)
alter table emp add birth date after age1

alter table emp modify age int(3) first -- 修改字段age,将其
放到最前面。
alter table emp rename emp1    -- 修改表的名称

insert into table_name (field1,field2,...fieldn) values (value1, value2,...)

insert(str, x, y ,instr)函数：将字符串str从第x位置开始，y个字符串长度的字符串替换为字符串instr

-- 既要统计各部门的人数，又要统计总人数
select deptno, count(1) from emp group by deptno with rollup  -- roollup 还能检测出本组类得整体聚合信息


大批量插入数据
alter table film_test2 disable keys
load data infile '/home/mysql/film_test.txt' into table film_test2
alter table film_test2 enable keys


coalesce 函数： 返回列表中的第一个非空表达式  coalesce(expression, expression[,...])
如果所有的参数均为NULL， 则返回NULL

char 列的场电影固定为创建表时声明的长度，长度可以为0-255的任何值
varchar 列中的值为可变长字符串，长度可以指定为0-65535之间的值
检索时，char 列删除尾部的空格，varchar 列保留空格

编程中要尽量避免浮点数的比较，非要使用则使用范围比较而非“==”
1. 浮点数存在误差问题；
2. 对货币等精确度敏感的数据，应该用定点数表示或存储；
3. 要注意浮点数中一些特殊值的处理

having 是对聚合后的结果进行条件的过滤
where 是在聚合前就对记录进行过滤。
如果逻辑允许，尽可能用where先过滤记录，结果集减小，对聚合的效率提高，最后再根据逻辑看是否用having进行再过滤

UNION将返回两个查询的结果并去除其中的重复部分，
UNION ALL与UNION一样对表进行了合并，但是它不去掉重复的记录。

用聚合函数的时候，一般都要用到GROUP BY 先进行分组，然后再进行聚合函数的运算。运算完后就要用到HAVING 的用法了，就是进行判断

order by 从英文里理解就是行的排序方式，默认的为升序。 order by 后面必须列出排序的字段名，可以是多个字段名。

group by 从英文里理解就是分组。必须有“聚合函数”来配合才能使用，使用时至少需要一个分组标志字段。    sum()、count()、avg()等都是“聚合函数”
group by 有一个原则,就是 select 后面的所有列中,没有使用聚合函数的列,必须出现在 group by 后面


where 子句的作用是在对查询结果进行分组前，将不符合where条件的行去掉，即在分组之前过滤数据，条件中不能包含聚组函数，使用where条件显示特定的行。

having 子句的作用是筛选满足条件的组，即在分组之后过滤数据，条件中经常包含聚组函数，使用having 条件显示特定的组，也可以使用多个分组标准进行分组。



Self Join  某个表和其自身连接，连接方式可以是内连接，外连接，交叉连接
Natural Join   要求两个关系中进行比较的分量必须是相同的属性组，并且在结果中把重复的属性列去掉；而等值连接不会去掉重复的属性列。
Cross Join  不使用连接条件来限制结果集合，而是将分别来自两个数据源中的行以所有可能的方式进行组合。
INNER JOIN 两边表同时有对应的数据，即任何一边缺失数据就不显示。  //全部都是对应指定列
LEFT JOIN 会读取左边数据表的全部数据，即便右边表无对应数据。//左边的全保留，右边有对应的加上，没有的NULL/default
RIGHT JOIN 会读取右边数据表的全部数据，即便左边表无对应数据。//右边指定的的全保留，左边指定的没有就NULL/default


left join 和 left outer join 的区别及详细讲解见 stackoverflow 贴
https://stackoverflow.com/questions/406294/left-join-vs-left-outer-join-in-sql-server

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
join过程可以这样理解：首先两个表做一个笛卡尔积，on后面的条件是对这个笛卡尔积做一个过滤形成一张临时表，如果没有where就直接返回结果，如果有where就对上一步的临时表再进行过滤。

-- 如果查询的字段来自于两个table, 就需要使用join的方式, 作用是将几张表连接起来
-- 例如 from salaries s inner join dept_manager d

-- 例如查找所有已经分配部门的员工的last_name, first_name
select e.last_name, e.first_name, d.dept_no
from dept_emp d natural join employees e

-- 上例中 包括展示没有分配具体部门的员工
select e.last_name, e.first_name, d.dept_no
from employees e
left join dept_emp d
on e.emp_no = d.emp_no

如果是要统计当前的状况，则一般要在table的时间列中要满足
s.to_date = '9999-01-01'
and t.to_date = '9999-01-01'
--------------------------------------------------------------------------------------------------------------------------------

在使用left jion时，on和where条件的区别如下：

1、 on条件是在生成临时表时使用的条件，它不管on中的条件是否为真，都会返回左边表中的记录。
2、where条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉。

两者在inner join 里没有区别

hash索引：
1. 只用于使用= 或 <=> 操作符的等式比较
2. 优化器不能使用hash索引来加速 order by 操作
3. MySQL不能确定在两个值之间大约有多少行。如果将一个MyISAM表改成hash 索引的memory表，会影响一些查询的执行效率
4. 只能使用整个关键字来搜索一行



MINUS相减
返回的记录是存在于第一个表中但不存在于第二个表中的记录。
如果解释器不支持一般用table_name1 t2 LEFT OUTER JOIN table_name2 t2 WHERE t2.col_name IS NULL;

select * from table_name limit 3,1; # 跳过前3条数据，从数据库中第4条开始查询，取一条数据，即第4条数据
select * from table_name limit 3 offset 1;  # 从数据库中的第2条数据开始查询3条数据，即第2条到第4条

-- 查询表中入职员工实践排名倒数第三的员工信息
select * from employees 
order by hire_date desc limit 2, 1

-- 选取薪水第二多的员工
select emp_no, salary
from salaries
where salary = (select salary from salaries 
               order by salary desc 
               limit 1,1 )

-- 上例不使用order by 
select e.emp_no, max(s.salary), e.last_name, e.first_name
from employees e inner join salaries s
on e.emp_no = s.emp_no
where s.to_date = '9999-01-01' 
and s.salary not in (select max(salary) from salaries
                     where to_date = '9999-01-01'
               )

IFNULL是当SQL查询某个字段为空的时候，查询结果中设置其值为默认值。ISNULL使用指定的替换值替换 NULL：

//RANK()返回的是不持续的编号，例如100, 101, 101, 102返回的编号将是1,2,2,4；
//DENSE_RANK()返回的是持续的编号，例如100, 101, 101, 102返回的编号是1,2,2,3；
//ROW_NUMBER()返回的是持续不重复的编号，例如100, 101, 101, 102返回的编号将是1,2,3,4；

-- 例子： 对salaries表中的所有员工当前薪水按照salary进行按照1-N排名， 相同的salary并列且按照emp_no 升序排列

复用salaries表进行比较排名，具体思路如下：
1、从两张相同的salaries表（分别为s1与s2）进行对比分析，先将两表限定条件设为to_date = '9999-01-01'，挑选出当前所有员工的薪水情况。  /*决定连接的顺序-决定连接的要求*/
2、本题的精髓在于 s1.salary <= s2.salary，意思是在输出s1.salary的情况下，有多少个s2.salary大于等于s1.salary，比如当s1.salary=94409时，有3个s2.salary（分别为94692,94409,94409）大于等于它，但由于94409重复，利用COUNT(DISTINCT s2.salary)去重可得工资为94409的rank等于2。其余排名以此类推。
3、千万不要忘了GROUP BY s1.emp_no，否则输出的记录只有一条（可能是第一条或者最后一条，根据不同的数据库而定），因为用了合计函数COUNT()
4、最后先以 s1.salary 逆序排列，再以 s1.emp_no 顺序排列输出结果

SELECT s1.emp_no, s1.salary, COUNT(DISTINCT s2.salary) AS rank
FROM salaries AS s1, salaries AS s2
WHERE s1.to_date = '9999-01-01'  AND s2.to_date = '9999-01-01' AND s1.salary <= s2.salary
GROUP BY s1.emp_no
ORDER BY s1.salary DESC, s1.emp_no ASC

-- another example
获取所有非manager员工当前的薪水情况，给出dept_no、emp_no以及salary ，当前表示to_date='9999-01-01'

/*
1、先用INNER JOIN连接employees和salaries，找出当前所有员工的工资情况
2、再用INNER JOIN连接dept_emp表，找到所有员工所在的部门
3、最后用限制条件de.emp_no NOT IN (SELECT emp_no FROM dept_manager WHERE to_date = '9999-01-01')选出当前所有非manager员工，再依次输出dept_no、emp_no、salary
*/

SELECT de.dept_no, s.emp_no, s.salary 
FROM (employees AS e INNER JOIN salaries AS s ON s.emp_no = e.emp_no AND s.to_date = '9999-01-01')
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
WHERE de.emp_no NOT IN (SELECT emp_no FROM dept_manager WHERE to_date = '9999-01-01')


/*
找出员工当前薪水比其manager要高的相关信息。当前表示to_date='9999-01-01',
结果第一列给出员工的emp_no，
第二列给出其manager的manager_no，
第三列给出该员工当前的薪水emp_salary,
第四列给该员工对应的manager当前的薪水manager_salary  */



/*
具体思路如下：
1、先用INNER JOIN连接salaries和demp_emp，建立当前所有员工的工资记录sem
2、再用INNER JOIN连接salaries和demp_manager，建立当前所有员工的工资记录sdm
3、最后用限制条件sem.dept_no = sdm.dept_no AND sem.salary > sdm.salary
找出同一部门中工资比经理高的员工，并根据题意依次输出emp_no、manager_no、emp_salary、manager_salary
*/
SELECT sem.emp_no AS emp_no, sdm.emp_no AS manager_no, sem.salary AS emp_salary, sdm.salary AS manager_salary
FROM (SELECT s.salary, s.emp_no, de.dept_no FROM salaries s INNER JOIN dept_emp de
ON s.emp_no = de.emp_no AND s.to_date = '9999-01-01' ) AS sem, 
(SELECT s.salary, s.emp_no, dm.dept_no FROM salaries s INNER JOIN dept_manager dm
ON s.emp_no = dm.emp_no AND s.to_date = '9999-01-01' ) AS sdm
WHERE sem.dept_no = sdm.dept_no AND sem.salary > sdm.salary

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 随机抽样
SELECT * FROM table WHERE RAND() <= .3，这样可以抽出约30%的数据，然后再用TOP或者LIMIT子句。

<> 代表不等于

delete和truncate只删除表的数据不删除表的结构
速度,一般来说: drop> truncate >delete 
delete语句是dml,这个操作会放到rollback segement中,事务提交之后才生效;
如果有相应的trigger,执行的时候将被触发. truncate,drop是ddl, 操作立即生效,
原数据不放到rollback segment中,不能回滚. 操作不触发trigger. 


不再需要一张表的时候，用drop
想删除部分数据行时候，用delete，并且带上where子句
保留表而删除所有数据的时候用truncate

-- a example
给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date以及薪水涨幅值salary_growth，并按照salary_growth逆序排列。
提示：在sqlite中获取datetime时间对应的年份函数为strftime('%Y', to_date)

具体思路如下：
1、假设s1是涨薪水前的表，s2是涨薪水后的表，因为每个员工涨薪水的时间不全固定，有可能一年涨两次，有可能两年涨一次，所以每年薪水的涨幅，应该理解为两条薪水记录的from_date相同或to_date相同。
/** 如果只限定to_date相同，则将第三条原始测试数据的52668改成62668时，就会少一条【62668-48584=14084】的记录
INSERT INTO salaries VALUES(10008,46671,'1998-03-11','1999-03-11');
INSERT INTO salaries VALUES(10008,48584,'1999-03-11','2000-03-10');
INSERT INTO salaries VALUES(10008, 62668 ,'2000-03-10','2000-07-31');  **/
2、找到s1与s2符合要求的记录后，用s2的薪水减去s1的薪水，用salary_growth表示，加上限定条件 s1.emp_no = s2.emp_no AND salary_growth > 5000，即同一员工每年涨幅超过5000的记录
3、最后依次输出emp_no、from_date、salary_growth，并以salary_growth逆序排列


SELECT s2.emp_no, s2.from_date, (s2.salary - s1.salary) AS salary_growth
FROM salaries AS s1, salaries AS s2
WHERE s1.emp_no = s2.emp_no 
AND salary_growth > 5000
AND (strftime("%Y",s2.to_date) - strftime("%Y",s1.to_date) = 1 
     OR strftime("%Y",s2.from_date) - strftime("%Y",s1.from_date) = 1 )
ORDER BY salary_growth DESC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 增
INSERT INTO tab1(name, email) values('zhangyanlin', 'zhangyanlin8851@163.com')

-- 删
DELETE FROM 表 WHERE id = 1 AND name = 'zhangyanlin'

-- 改
UPDATE 表 SET name = 'zhangyanlin' WHERE id>1

-- 查
SELECT nid, name, gender AS gg FROM 表 WHERE id>1

-- 查找最高薪水相关信息
select d.dept_no, s.emp_no, max(salary) salary
from salaries s inner join dept_emp d
on d.emp_no = s.emp_no
where d.to_date = '9999-01-01' and s.to_date = '9999-01-01'
group by d.dept_no

-- 使用where时， 如果存在两个table 中有相同的字段比较内容的差异，则后者要使用select，将该字段提取出来
-- 例如 where e.emp_no not in (select emp_no from dept_manager)


-- 条件判断 where
SELECT * FROM 表 WHERE id > 1 AND name != 'aylin' AND  num =12
SELECT * FROM 表 WHERE id BETWEEN 5 AND 16   -- BETWEEN 将包含边界值
SELECT * FROM 表 WHERE id IN (11,22,33)
SELECT * FROM 表 WHERE id IN (SELECT nid FROM 表)

-- 通配符like
select * from 表 where name like 'zhang%'  # zhang开头的所有（多个字符串）
select * from 表 where name like 'zhang_'  # zhang开头的所有（一个字符）

-- 限制limit
select * from 表 limit 5;            - 前5行
select * from 表 limit 4,5;          - 跳过前四行，一直向后数5行
select * from 表 limit 5 offset 4    - 从1行到第九行

-- 排序asc, desc
select * from 表 order by 列 asc              - 根据 “列” 从小到大排列
select * from 表 order by 列 desc             - 根据 “列” 从大到小排列
select * from 表 order by 列1 desc,列2 asc    - 根据 “列1” 从大到小排列，如果相同则按列2从小到大排序

-- 分组group by
select num from 表 group by num
select num,nid from 表 group by num,nid
select num,nid from 表  where nid > 10 group by num,nid order by nid desc
select num,nid,count(*),sum(score),max(score),min(score) from 表 group by num,nid
select num from 表 group by num having max(id) > 10

特别的：group by 必须在where之后，order by之前



-- 查找薪水涨幅次数超过15次的员工号及其对应的涨幅次数
select emp_no, count(emp_no) t   -- 或者是像 (max(salary) - min(salary))这种到这里面（求涨幅）
from salaries
group by emp_no having t > 15


当前薪水不一定是最高的， 最先开始的薪水也不一定是最低的
-- 上例中查找所有员工入职以来的薪水涨幅情况
SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM (SELECT s.emp_no, s.salary FROM employees e LEFT JOIN salaries s ON e.emp_no = s.emp_no WHERE s.to_date = '9999-01-01') AS sCurrent
INNER JOIN (SELECT s.emp_no, s.salary FROM employees e LEFT JOIN salaries s ON e.emp_no = s.emp_no WHERE s.from_date = e.hire_date) AS sStart
ON sCurrent.emp_no = sStart.emp_no
ORDER BY growth



-- 创建视图
--格式：CREATE VIEW 视图名称 AS  SQL语句
CREATE VIEW v1 AS SELECT nid, name FROM tab1 WHERE nid > 4

-- 删除试图
--格式：DROP VIEW 视图名称
DROP VIEW v1

-- 修改视图
-- 格式：ALTER VIEW 视图名称 AS SQL语句
ALTER VIEW v1 AS
SELECT A.nid,B.NAME FROM tab1
LEFT JOIN B ON A.id = B.nid
LEFT JOIN C ON A.id = C.nid
WHERE tab1.id > 2

--使用视图
select * from v1

-- 创建存储过程 
-- 不带参数案例
-- 创建存储过程
delimiter //        --自定义语句结尾符号，因为这里要执行好多句sql语句，所以就得自定义，以防止出错
create procedure p1()
BEGIN
    select * from tab1;
END//
delimiter ;         --自定义局域结尾符号结束

-- 执行存储过程
call p1()

-- 带参数案例
-- 创建存储过程
delimiter //
create procedure p1(
    in i1 int,                        -- 传入参数i1
    in i2 int,                        -- 传入参数i2
    inout i3 int,                     -- 即传入又能得到返回值
    out r1 int                        -- 得到返回值
)
BEGIN
    DECLARE temp1 int;
    DECLARE temp2 int default 0;  
    set temp1 = 1;
    set r1 = i1 + i2 + temp1 + temp2; 
    set i3 = i3 + 100;
end//
delimiter ;

-- 执行存储过程
DECLARE @t1 INT default 3;           --  设置变量默认值为3
DECLARE @t2 INT;                     --  设置变量
CALL p1 (1, 2 ,@t1, @t2);            --  执行存储过程，并传入参数，t2自动取消
SELECT @t1,@t2;                      --  查看存储过程输出结果

-- 删除存储过程
drop procedure p1;


#!/usr/bin/env python
# -*- coding:utf-8 -*-
import pymysql

conn = pymysql.connect(host='127.0.0.1', port=3306, user='root', passwd='', db='day39b_')
cursor = conn.cursor(cursor=pymysql.cursors.DictCursor)
# 执行存储过程
row = cursor.callproc('p1',(1,2,3))
# 存储过程的查询结果
selc = cursor.fetchall()
print(selc)
# 获取存储过程返回
effect_row = cursor.execute('select @_p1_0,@_p1_1,@_p1_2')
# 曲存储过程的返回值
ret = cursor.fetchone()
print(ret)
# 提交，不然无法保存新建或者修改的数据
conn.commit()
# 关闭游标
cursor.close()
# 关闭连接
conn.close()


-- 函数function
CHAR_LENGTH(str)
        返回值为字符串str 的长度，长度的单位为字符。一个多字节字符算作一个单字符。
        对于一个包含五个二字节字符集, LENGTH()返回值为 10, 而CHAR_LENGTH()的返回值为5。

CONCAT(str1,str2,...)
        字符串拼接
        如有任何一个参数为NULL ，则返回值为 NULL。
CONCAT_WS(separator,str1,str2,...)
        字符串拼接（自定义连接符）
        CONCAT_WS()不会忽略任何空字符串。 (然而会忽略所有的 NULL）。

CONV(N,from_base,to_base)
        进制转换
        例如：
            SELECT CONV('a',16,2); 表示将 a 由16进制转换为2进制字符串表示

FORMAT(X,D)
        将数字X 的格式写为'#,###,###.##',以四舍五入的方式保留小数点后 D 位，
         并将结果以字符串的形式返回。若  D 为 0, 则返回结果不带有小数点，或不含小数部分。
        例如：
            SELECT FORMAT(12332.1,4); 结果为： '12,332.1000'
INSERT(str,pos,len,newstr)
        在str的指定位置插入字符串
            pos：要替换位置其实位置
            len：替换的长度
            newstr：新字符串
        特别的：
            如果pos超过原字符串长度，则返回原字符串
            如果len超过原字符串长度，则由新字符串完全替换
INSTR(str,substr)
        返回字符串 str 中子字符串的第一个出现位置。

LEFT(str,len)
        返回字符串str 从开始的len位置的子序列字符。

LOWER(str)
        变小写

UPPER(str)
        变大写

LTRIM(str)
        返回字符串 str ，其引导空格字符被删除。
RTRIM(str)
        返回字符串 str ，结尾空格字符被删去。
SUBSTRING(str,pos,len)
        获取字符串子序列

LOCATE(substr,str,pos)
        获取子序列索引位置

REPEAT(str,count)
        返回一个由重复的字符串str 组成的字符串，字符串str的数目等于count 。
        若 count <= 0,则返回一个空字符串。
        若str 或 count 为 NULL，则返回 NULL 。
REPLACE(str,from_str,to_str)
        返回字符串str 以及所有被字符串to_str替代的字符串from_str 。
REVERSE(str)
        返回字符串 str ，顺序和字符顺序相反。
RIGHT(str,len)
        从字符串str 开始，返回从后边开始len个字符组成的子序列

SPACE(N)
        返回一个由N空格组成的字符串。

SUBSTRING(str,pos) , SUBSTRING(str FROM pos) SUBSTRING(str,pos,len) , SUBSTRING(str FROM pos FOR len)
        不带有len 参数的格式从字符串str返回一个子字符串，起始于位置 pos。带有len参数的格式从字符串str返回一个长度同len字符相同的子字符串，起始于位置 pos。 使用 FROM的格式为标准 SQL 语法。也可能对pos使用一个负值。假若这样，则子字符串的位置起始于字符串结尾的pos 字符，而不是字符串的开头位置。在以下格式的函数中可以对pos 使用一个负值。

        mysql> SELECT SUBSTRING('Quadratically',5);
            -> 'ratically'

        mysql> SELECT SUBSTRING('foobarbar' FROM 4);
            -> 'barbar'

        mysql> SELECT SUBSTRING('Quadratically',5,6);
            -> 'ratica'

        mysql> SELECT SUBSTRING('Sakila', -3);
            -> 'ila'

        mysql> SELECT SUBSTRING('Sakila', -5, 3);
            -> 'aki'

        mysql> SELECT SUBSTRING('Sakila' FROM -4 FOR 2);
            -> 'ki'

TRIM([{BOTH | LEADING | TRAILING} [remstr] FROM] str) TRIM(remstr FROM] str)
        返回字符串 str ， 其中所有remstr 前缀和/或后缀都已被删除。若分类符BOTH、LEADIN或TRAILING中没有一个是给定的,则假设为BOTH 。 remstr 为可选项，在未指定情况下，可删除空格。

        mysql> SELECT TRIM('  bar   ');
                -> 'bar'

        mysql> SELECT TRIM(LEADING 'x' FROM 'xxxbarxxx');
                -> 'barxxx'

        mysql> SELECT TRIM(BOTH 'x' FROM 'xxxbarxxx');
                -> 'bar'

        mysql> SELECT TRIM(TRAILING 'xyz' FROM 'barxxyz');
                -> 'barx'


-- 自定义创建函数
delimiter \\
create function f1(
    i1 int,
    i2 int)
returns int
BEGIN
    declare num int;
    set num = i1 + i2;
    return(num);
END \\
delimiter ;

-- 删除函数
drop function f1;

-- 执行函数
# 获取返回值
declare @i VARCHAR(32);
select UPPER('alex') into @i;
SELECT @i;

# 在查询中使用
select f1(11,nid) ,name from tb2;


--事物  案例
delimiter \\
create PROCEDURE p1(
    OUT p_return_code tinyint
)
BEGIN 
  DECLARE exit handler for sqlexception 
  BEGIN 
    -- ERROR 
    set p_return_code = 1; 
    rollback; 
  END; 

  DECLARE exit handler for sqlwarning 
  BEGIN 
    -- WARNING 
    set p_return_code = 2; 
    rollback; 
  END; 

  START TRANSACTION; 
    DELETE from tb1;                   -- sql语句都放在这个里面
    insert into tb2(name)values('seven');
  COMMIT; 

  -- SUCCESS 
  set p_return_code = 0; 

  END\\
delimiter ;

--执行存储过程

DECLARE @i TINYINT;
call p1(@i);
select @i;

-- 触发器
# 插入前
CREATE TRIGGER tri_before_insert_tb1 BEFORE INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 插入后
CREATE TRIGGER tri_after_insert_tb1 AFTER INSERT ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 删除前
CREATE TRIGGER tri_before_delete_tb1 BEFORE DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 删除后
CREATE TRIGGER tri_after_delete_tb1 AFTER DELETE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 更新前
CREATE TRIGGER tri_before_update_tb1 BEFORE UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END

# 更新后
CREATE TRIGGER tri_after_update_tb1 AFTER UPDATE ON tb1 FOR EACH ROW
BEGIN
    ...
END


--示例：插入前
-- 在往tab1插入数据之前往tab2中插入一条name = 张岩林，当然是在判断往tab1中插入的名字是不是等于aylin
delimiter //
CREATE TRIGGER tri_before_insert_tb1 BEFORE INSERT ON tb1 FOR EACH ROW
BEGIN

IF NEW. NAME == 'aylin' THEN
    INSERT INTO tb2 (NAME)
VALUES
    ('张岩林')
END
END//
delimiter ;

--插入后

delimiter //
CREATE TRIGGER tri_after_insert_tb1 AFTER INSERT ON tb1 FOR EACH ROW
BEGIN
    IF NEW. num = 666 THEN
        INSERT INTO tb2 (NAME)
        VALUES
            ('张岩林'),
            ('很帅') ;
    ELSEIF NEW. num = 555 THEN
        INSERT INTO tb2 (NAME)
        VALUES
            ('aylin'),
            ('非常帅') ;
    END IF;
END//
delimiter ;

--删除触发器
DROP TRIGGER tri_after_insert_tb1;

--使用触发器
insert into tb1(name) values(‘张岩林’)

--------------------------------------------------------------------------
-- 聚集索引： 决定数据在磁盘上的物理排序，一个表只能有一个聚集索引
-- 非聚集索引：索引上只包含被建立索引的数据，以及一个行定位符row-locator
-- 			（可以理解为一个聚集索引物理排序的指针，通过该指针，可以找到行数据


-- 逻辑角度
-- 普通索引：没有任何限制
-- 唯一索引：索引列的值必须唯一，但允许有空值
-- 主键索引：不允许有空值
-- 联合索引：多个字段上建立的索引，能够加速复合查询条件的索引
--				建立时，区分度最高的字段放在最左边
-- 全文索引

--			建立非等号和等号混合判断条件时，在建索引时，要把等号条件的列前置

-- 1. 前导模糊查询不能使用索引， 页面搜索严禁左模糊或者全模糊，需要可以使用搜索引擎解决
select * from doc where title like '%XX'   -- 不能使用索引
select * from doc where title like 'XX%'   -- 非前导模糊查询可以使用索引

-- 在字段上进行计算不能命中索引
-- 如：
select * from doc where YEAR(create_time) <= '2016' --  可以优化为
select * from doc where create_time <= '2016-01-01'

-- 把计算放到业务层而不是数据库层
-- 如：
select * from order where date <= CURDATE()			-- 可以优化为
select * from order where date <= '2018-01-24 12:00:00'

-- 强制类型转换会全表扫描
-- 例如 phone字段是varchar类型，则下面的SQL 不能命中索引
select * from usr where phone = 123435454           -- 可以优化为
select * from usr where phone = '123435454'

-- 建立索引的列，不允许存在null

-- 如果明确知道只有一条结果返回，limite 1 可以提高效率
-- 如
select * from user where login_name = ? limit 1



1. 请问如下三条 SQL 该如何建立索引？

where a=1and b=1

where b=1

where b=1order by time desc

MySQL 的查询优化器会自动调整 where 子句的条件顺序以使用适合的索引吗？

回答：             

 

第一问：建议建立两个索引，即 idxab(a,b) 和 idxbtime(b,time)。

第二问：MySQL 的查询优化器会自动调整 where 子句的条件顺序以使用适合的索引，
对于上面的第一条 SQL，如果建立索引为 idxba(b,a) 也是可以用到索引的，
不过建议 where 后的字段顺序和联合索引保持一致，养成好习惯。




2.假如有联合索引(empno、title、fromdate)，下面的 SQL 是否可以用到索引，
如果可以的话，会使用几个列？

select * fromemployees.titles 
where emp_no between '10001' and'10010' and title='Senior Engineer' and 
from_date between '1986-01-01'and '1986-12-31'

回答：可以使用索引，可以用到索引全部三个列，这个 SQL 看起来是用了两个范围查询，
但作用于 empno 上的“between”实际上相当于“in”，也就是说 empno 实际是多值精确匹配，
在 MySQL 中要谨慎地区分多值匹配和范围匹配，否则会对 MySQL 的行为产生困惑。




3.既然索引可以加快查询速度，那么是不是只要是查询语句需要，就建上索引？

回答：不是，因为索引虽然加快了查询速度，但索引也是有代价的。
索引文件本身要消耗存储空间，同时索引会加重插入、删除和修改记录时的负担。
另外，MySQL 在运行时也要消耗资源维护索引，因此索引并不是越多越好。
一般两种情况下不建议建索引。
第一种情况是表记录比较少，例如一两千条甚至只有几百条记录的表，没必要建索引，
另一种是数据的区分度比较低，可以使用 count(distinct(列名))/count(*) 来计算区分度。




4.主键和聚集索引的关系？

回答：在 MySQL 中，InnoDB 引擎表是（聚集）索引组织表（Clustered IndexOrganize Table)，
它会先按照主键进行聚集，如果没有定义主键，InnoDB 会试着使用唯一的非空索引来代替，
如果没有这种索引，InnoDB 就会定义隐藏的主键然后在上面进行聚集。
由此可见，在 InnoDB 表中，主键必然是聚集索引，而聚集索引则未必是主键。
MyISAM 引擎表是堆组织表（Heap Organize Table)，它没有聚集索引的概念。



5.一个6亿的表 a，一个3亿的表 b，通过外键 tid 关联，
如何最快的查询出满足条件的第50000到第50200中的这200条数据记录？

回答：方法一：如果 a 表 tid 是自增长，并且是连续的，b表的id为索引。SQL语句如下。

select * froma,b where a.tid = b.id and a.tid>500000 limit200;

方法二：如果 a 表的 tid 不是连续的，那么就需要使用覆盖索引，
tid 要么是主键，要么是辅助索引，b 表 id 也需要有索引。SQL语句如下。

select * fromb, (select tid from a limit 50000,200) awhere b.id = a.tid;



6.假如建立联合索引(a,b,c)，下列语句是否可以使用索引，如果可以，
使用了那几列？（考察联合索引最左前缀原则）

where a= 3

答：是，使用了 a 列。

where a= 3 and b = 5

答：是，使用了 a，b 列。

where a = 3 and c = 4 and b = 5

答：是，使用了 a，b，c 列。

where b= 3

答：否。

where a= 3 and c = 4

答：是，使用了 a 列。

where a = 3 and b > 10 andc = 7

答：是，使用了 a，b 列。

where a = 3 and b like 'xx%' andc = 7

答：是，使用了 a，b 列。


建立触发器的语法              before/after   insert/update/delete 
create trigger trigger_name   trigger_time   trigger_event        on tb1_name for each row trigger_stmt
触发器只能建立在永久表上
查看 show triggers \G 

正则表达式 样例  
匹配字符串'abcdefg'是否以字符'a'开始
select 'abcdefg' regexp '^a'  -- 是否以 g 结束 'g$'

随机抽取部分样本
select * from sales2 order by rand() limit 5
