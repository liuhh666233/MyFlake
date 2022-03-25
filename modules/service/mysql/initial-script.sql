CREATE DATABASE zyyx CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';

CREATE USER 'zyyx'@'%' IDENTIFIED BY '123456';

GRANT ALL ON zyyx.* TO 'zyyx'@'%';

GRANT REPLICATION SLAVE ON *.* TO 'zyyx'@'%' identified by '123456';

DELETE FROM mysql.user WHERE user='';

flush privileges;