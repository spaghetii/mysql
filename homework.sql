----------------------------可呼叫的procedure-----------------------------------
-- CPINS(新增客戶資料)CPDEL(刪除客戶資料)CPUPD(更新客戶資料)CSPhone(查詢客戶電話)CSName(查詢客戶姓名)
-- SPINS(新增供應商資料)SPDEL(刪除供應商資料)SPUPD(更新供應商資料)SSPhone(查詢供應商資料)SSName(查詢供應商名稱)
-- PPINS(新增產品資訊)PPDEL(刪除產品資訊)PPUPD(更新產品資訊)PSName(查詢產品名稱)
-- OPINS(新增訂單)OPDEL(刪除訂單)
-- ODPINS(新增訂單細項)ODPDEL(刪除訂單細項)ODPUPD(更新訂單細項)
-- SOAO(輸入客戶名稱查詢訂單)SOT(顯示客戶訂單總額)SCBW(輸入商品名稱顯示客戶)SOOP(輸入供應商名稱顯示其提供的清單)
-------------------------------------------------------------------------------

-- 新增iii資料庫
create database iii;
--

-- 使用 iii資料庫
use iii;
--

-- 新增 customs (id,cname,cphone,cemail,caddr)
create table customs (id int primary key auto_increment,cname varchar(20),cphone varchar(20),cemail varchar(100),caddr varchar(100),unique key (cphone));
--

-- 新增 suppliers (id,sname,sphone,saddr)
create table suppliers (id int primary key auto_increment,sname varchar(20),sphone varchar(20),saddr varchar(100));
--

-- 新增 products (id,pname,pid,price,supplierid)
create table products (id int primary key auto_increment,pname varchar(20),pid int,price int,supplierid int,foreign key (supplierid) references suppliers (id));
--

-- 新增 orders (id,orderid,customid)
create table orders (id int primary key auto_increment,orderid int,customid int,unique key (orderid),foreign key (customid) references customs (id));
--

-- 新增 orderdetails (id,orderid,productid,price,quantity)
create table orderdetails (id int primary key auto_increment,orderid int,productid int,price int,quantity int,foreign key (orderid) references orders (id),foreign key (productid) references products (id));
--

-- 新增內容 CPINS(id,cname,cphone,cemail,caddr) 
\d #
CREATE procedure CPINS(in cname varchar(20),in cphone varchar(20),in cemail varchar(100),in caddr varchar(100)) 
BEGIN
    
    set @keyN = cname;
    set @keyP = cphone;
    set @keyE = cemail;
    set @keyA = caddr;
    set @query = 'insert into customs (cname,cphone,cemail,caddr) values (?,?,?,?) ' ;

    prepare stmtp from @query;
    execute stmtp using @keyN,@keyP,@keyE,@keyA;
    select 'Success to insert' log;

END #
\d ;
--

--  在刪除該名客戶資料前，先把他在訂單資料中的資訊先刪除
\d #
CREATE trigger CTDEL before delete on customs for each row
BEGIN
    
    select count(*) into @temp from orders where customid = old.id;
    if @temp != 0 then
        delete from orders where customid = old.id;
    end if;

END #
\d ;
--

-- 刪除第N筆資料
\d #
CREATE procedure CPDEL(in id int) 
BEGIN
    
    set @key = id;
    set @query = 'delete from customs where id = ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;
    select 'Success to delete' log;

END #
\d ;
--

-- 修改第N筆的某個欄位的內容 CPUPD(id,colName,colData)
\d #
CREATE procedure CPUPD(in id int,in colName varchar(10),in colData varchar(100)) 
BEGIN
    
    set @query = '';
    set @keyC = colName;
    set @keyD = colData;
    set @keyI = id;
    if @keyC = 'cname' then 
    set @query = ' update customs set cname = ? where id = ?' ;
    elseif @keyC = 'cphone' then 
    set @query = ' update customs set cphone = ? where id = ?' ;
    elseif @keyC = 'cemail' then 
    set @query = ' update customs set cemail = ? where id = ?' ;
    elseif @keyC = 'caddr' then 
    set @query = ' update customs set caddr = ? where id = ?' ;
    else set @query = 'select "Dont enter incorrect values" log';
    end if;

    if @query != '' then 
    BEGIN
        prepare stmtp from @query;
        execute stmtp using @keyD,@keyI;
        select 'Success to update' log;
    END;
    else select "Don't enter incorrect values" log;
    END IF;

END #
\d ;
--

-- 查詢客戶電話號碼
\d #
CREATE procedure CSPhone(in cphone varchar(20)) 
BEGIN
    
    set @key = concat('%',cphone,'%') collate utf8_unicode_ci;
    set @query = 'select id,cphone from customs where cphone like ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 查詢客戶名稱
\d #
CREATE procedure CSName(in cname varchar(20) ) 
BEGIN
    set @key = concat('%',cname,'%') collate utf8_unicode_ci;
    set @query = 'select cname from customs where cname like ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增內容 SPINS(id,sname,sphone,saddr)
\d #
CREATE procedure SPINS(in sname varchar(20),in sphone varchar(20),in saddr varchar(100)) 
BEGIN
    
    set @keyN = sname;
    set @keyP = sphone;
    set @keyA = saddr;
    set @query = 'insert into suppliers (sname,sphone,saddr) values (?,?,?) ' ;

    prepare stmtp from @query;
    execute stmtp using @keyN,@keyP,@keyA;
    select 'Success to insert' log;

END #
\d ;
--

--  在刪除該名供應商資料前，先把他在產品資料中的資訊先刪除
\d #
CREATE trigger STDEL before delete on suppliers for each row
BEGIN
    
    select count(*) into @temp from products where supplierid = old.id;
    if @temp != 0 then
        delete from products where supplierid = old.id;
    end if;

END #
\d ;
--

-- 刪除第N筆資料 
\d #
CREATE procedure SPDEL(in id int) 
BEGIN
    
    set @key = id;
    set @query = 'delete from suppliers where id = ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;
    select 'Success to delete' log;

END #
\d ;
--

-- 修改第N筆的某個欄位的內容 SPUPD(id,colName,colData) 
\d #
CREATE procedure SPUPD(in id int,in colName varchar(10),in colData varchar(100)) 
BEGIN
    
    set @query = '';
    set @keyC = colName;
    set @keyD = colData;
    set @keyI = id;
    if @keyC = 'sname' then 
    set @query = ' update suppliers set sname = ? where id = ?' ;
    elseif @keyC = 'sphone' then 
    set @query = ' update suppliers set sphone = ? where id = ?' ;
    elseif @keyC = 'saddr' then 
    set @query = ' update suppliers set saddr = ? where id = ?' ;
    else set @query = 'select "Dont enter incorrect values" log';
    end if;

    if @query != '' then 
    BEGIN
        prepare stmtp from @query;
        execute stmtp using @keyD,@keyI;
        select 'Success to update' log;
    END;
    else select "Don't enter incorrect values" log;
    END IF;

END #
\d ;
--

-- 查詢供應商電話號碼
\d #
CREATE procedure SSPhone(in sphone varchar(20)) 
BEGIN
    
    set @key = concat('%',sphone,'%') collate utf8_unicode_ci;
    set @query = 'select id,sphone from suppliers where sphone like ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 查詢供應商名稱
\d #
CREATE procedure SSName(in sname varchar(20) ) 
BEGIN
    set @key = concat('%',sname,'%') collate utf8_unicode_ci;
    set @query = 'select id,sname from suppliers where sname like ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增內容 PPINS(id pname pid price supplierid)
\d #
CREATE procedure PPINS(in pname varchar(20),in pid int,in price int,in supplierid int) 
BEGIN
    DECLARE exit handler for sqlstate '23000'
    BEGIN
        select "Error." log;
    END;
    set @keyN = pname;
    set @keyI = pid;
    set @keyP = price;
    set @keySI = supplierid;
    set @query = 'insert into products(pname,pid,price,supplierid) values (?,?,?,?) ' ;

    prepare stmtp from @query;
    execute stmtp using @keyN,@keyI,@keyP,@keySI;
    select 'Success to insert' log;

END #
\d ;
--

-- 在刪除該商品資料前，先把他在清單細項中的資訊先刪除
\d #
CREATE trigger PTDEL before delete on products for each row
BEGIN
    
    select count(*) into @temp from orderdetails where productid = old.id;
    if @temp != 0 then
        delete from orderdetails where productid = old.id;
    end if;

END #
\d ;
--

-- 刪除第N筆資料
\d #
CREATE procedure PPDEL(in id int) 
BEGIN
    
    set @key = id;
    set @query = 'delete from products where id = ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;
    select 'Success to delete' log;

END #
\d ;
--

-- 修改第N筆的某個欄位的內容 PPUPD(id,colName,colData) 
\d #
CREATE procedure PPUPD(in id int,in colName varchar(10),in colData varchar(100)) 
BEGIN
    
    set @query = '';
    set @keyC = colName;
    set @keyD = colData;
    set @keyI = id;
    if @keyC = 'pname' then 
    set @query = ' update products set pname = ? where id = ?' ;
    elseif @keyC = 'pid' then 
    set @query = ' update products set pid = ? where id = ?' ;
    elseif @keyC = 'price' then 
    set @query = ' update products set price = ? where id = ?' ;
    elseif @keyC = 'supplierid' then 
    set @query = ' update products set supplierid = ? where id = ?' ;
    else set @query = 'select "Dont enter incorrect values" log';
    end if;

    if @query != '' then 
    BEGIN
        prepare stmtp from @query;
        execute stmtp using @keyD,@keyI;
        select 'Success to update' log;
    END;
    else select "Don't enter incorrect values" log;
    END IF;

END #
\d ;
--

-- 查詢商品名稱
\d #
CREATE procedure PSName(in pname varchar(20) ) 
BEGIN
    set @key = concat('%',pname,'%') collate utf8_unicode_ci;
    set @query = 'select id,pname from products where pname like ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增內容 OPINS(id,pname,pid,price,supplierid)
\d #
CREATE procedure OPINS(in orderid int,in customid int) 
BEGIN
    DECLARE exit handler for sqlstate '23000'
    BEGIN
        select "Error. Please check your customs isn't exist." log;
    END;

    set @keyI = orderid;
    set @keyCI = customid;
    set @query = 'insert into orders(orderid,customid) values (?,?) ' ;

    prepare stmtp from @query;
    execute stmtp using @keyI,@keyCI;
    select 'Success to insert' log;

END #
\d ;
--

-- 在刪除該訂單前，先把他在清單細項中的訂單先刪除
\d #
CREATE trigger OTDEL before delete on orders for each row
BEGIN
    
    select count(*) into @temp from orderdetails where orderid = old.id;
    if @temp != 0 then
        delete from orderdetails where orderid = old.id;
    end if;

END #
\d ;
--

-- 刪除第N筆訂單 
\d #
CREATE procedure OPDEL(in id int) 
BEGIN
    
    set @key = id;
    set @query = 'delete from orders where id = ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;
    select 'Success to delete' log;

END #
\d ;
--

-- 新增內容 ODPINS(id,orderid,productid,price,quantity)
\d #
CREATE procedure ODPINS(in orderid int,in productid int,in price int,in quantity int) 
BEGIN
    DECLARE exit handler for sqlstate '23000'
    BEGIN
        select "Error. Please check your orders or products isn't exist." log;
    END;

    set @keyOI = orderid;
    set @keyPI = productid;
    set @keyP = price;
    set @keyQ = quantity;
    set @query = 'insert into orderdetails(orderid,productid,price,quantity) values (?,?,?,?) ' ;

    prepare stmtp from @query;
    execute stmtp using @keyOI,@keyPI,@keyP,@keyQ;
    select 'Success to insert' log;

END #
\d ;
--

-- 刪除第N筆清單細項
\d #
CREATE procedure ODPDEL(in id int) 
BEGIN
    
    set @key = id;
    set @query = 'delete from orderdetails where id = ?' ;

    prepare stmtp from @query;
    execute stmtp using @key;
    select 'Success to delete' log;

END #
\d ;
--

-- 修改第N筆的某個欄位的內容 ODPUPD(id,colName,colData)
\d #
CREATE procedure ODPUPD(in id int,in colName varchar(10),in colData varchar(100)) 
BEGIN
    
    set @query = '';
    set @keyC = colName;
    set @keyD = colData;
    set @keyI = id;

    if @keyC = 'price' then 
    set @query = ' update orderdetails set price = ? where id = ?' ;
    elseif @keyC = 'quantity' then 
    set @query = ' update orderdetails set quantity = ? where id = ?' ;
    end if;

    if @query != '' then 
    BEGIN
        prepare stmtp from @query;
        execute stmtp using @keyD,@keyI;
        select 'Success to update' log;
    END;
    else select "Don't enter incorrect values" log;
    END IF;

END #
\d ;
--

-- 新增 SOAO(search order and orderdetail))
\d #
CREATE procedure SOAO(in cname varchar(20) ) 
BEGIN
    set @key = cname;
    set @query = '
    select c.cname,o.orderid,p.pname,od.price,od.quantity 
    from customs c,orders o,products p,orderdetails od 
    where c.id=o.customid and od.productid=p.id and o.orderid=od.orderid and c.cname=? order by c.cname;
    ' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增 SOT (show order total))
\d #
CREATE procedure SOT(in cname varchar(20) ) 
BEGIN
    set @key = cname;
    set @query = '
    select c.cname,o.orderid,sum(od.price*od.quantity) total 
    from customs c,orders o,orderdetails od 
    where c.id=o.customid and o.orderid=od.orderid and c.cname=? group by o.orderid;
    ' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增 SCBW (show customer buy what)
\d #
CREATE procedure SCBW(in pname varchar(20) ) 
BEGIN
    set @key = pname;
    set @query = '
    select p.pname,c.cname,od.quantity 
    from customs c,orders o,products p,orderdetails od 
    where c.id=o.customid and od.productid=p.id and o.orderid=od.orderid and p.pname=? order by p.pname;
    ' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
--

-- 新增 SOOP (suppliers offer orders products)
\d #
CREATE procedure SOOP(in sname varchar(20) ) 
BEGIN
    set @key = sname;
    set @query = '
    select s.sname,o.orderid,p.pname 
    from suppliers s,orders o,products p,orderdetails od 
    where s.id=p.supplierid and od.productid=p.id and o.orderid=od.orderid and sname=? order by s.sname;
    ' ;

    prepare stmtp from @query;
    execute stmtp using @key;

END #
\d ;
select s.sname,o.orderid,p.pname 
from suppliers s,orders o,products p,orderdetails od 
where s.id=p.supplierid and od.productid=p.id and o.orderid=od.orderid order by s.sname;
--
