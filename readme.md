Description
===========

It is slightly modified debian version of mysqlmymonlite.sh file from mysqlmymon.com. Main changes are related to changes to file paths and disabling unnecessary report section when MySQL is on remote server.

Installing Dependencies
=======================

    sudo apt update
    sudo apt-get install libdbd-mysql-perl
    sudo apt install mysql-client

Configuration
=============

Create file with credentials for mysql CLI tools:

    touch ~/.my.cnf
    vim ~/.my.cnf
    [client]
    user=<user>
    password=<password>

Set host in etc/config.ini:

    vim etc/config.ini
    MYSQLHOST='<database url>'

Usage
=====

Download:

    git clone https://github.com/alazarchuk/mysql-report-generator.git
    cd mysql-report-generator

MySQL Reporting:

    ./mysqlmymonlite.sh mysql # For full report
    ./mysqlmymonlite.sh mysqlreport # Only output of mysqlreport tool

MySQL Indexes:

    ./mysqlmymonlite.sh dblist
    employees innodb mysql performance_schema sys

    ./mysqlmymonlite.sh showindex

    What is your mysql database name ? employees


    Do you want to display all employees tables' indexes ? [y/n] y

    Do you want save output to text file ? Answering no will output only to screen. [y/n] n
    +-------------+------------+-----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table       | Non_unique | Key_name  | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +-------------+------------+-----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | departments |          0 | PRIMARY   |            1 | dept_no     | A         |           9 |     NULL | NULL   |      | BTREE      |         |               |
    | departments |          0 | dept_name |            1 | dept_name   | A         |           9 |     NULL | NULL   |      | BTREE      |         |               |
    +-------------+------------+-----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table    | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | dept_emp |          0 | PRIMARY  |            1 | emp_no      | A         |      299904 |     NULL | NULL   |      | BTREE      |         |               |
    | dept_emp |          0 | PRIMARY  |            2 | dept_no     | A         |      331570 |     NULL | NULL   |      | BTREE      |         |               |
    | dept_emp |          1 | dept_no  |            1 | dept_no     | A         |           8 |     NULL | NULL   |      | BTREE      |         |               |
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    +--------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table        | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +--------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | dept_manager |          0 | PRIMARY  |            1 | emp_no      | A         |          24 |     NULL | NULL   |      | BTREE      |         |               |
    | dept_manager |          0 | PRIMARY  |            2 | dept_no     | A         |          24 |     NULL | NULL   |      | BTREE      |         |               |
    | dept_manager |          1 | dept_no  |            1 | dept_no     | A         |           9 |     NULL | NULL   |      | BTREE      |         |               |
    +--------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table     | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | employees |          0 | PRIMARY  |            1 | emp_no      | A         |      299778 |     NULL | NULL   |      | BTREE      |         |               |
    +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table    | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | salaries |          0 | PRIMARY  |            1 | emp_no      | A         |      299341 |     NULL | NULL   |      | BTREE      |         |               |
    | salaries |          0 | PRIMARY  |            2 | from_date   | A         |     2838426 |     NULL | NULL   |      | BTREE      |         |               |
    +----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    +--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | Table  | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
    +--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
    | titles |          0 | PRIMARY  |            1 | emp_no      | A         |      296893 |     NULL | NULL   |      | BTREE      |         |               |
    | titles |          0 | PRIMARY  |            2 | title       | A         |      442426 |     NULL | NULL   |      | BTREE      |         |               |
    | titles |          0 | PRIMARY  |            3 | from_date   | A         |      442426 |     NULL | NULL   |      | BTREE      |         |               |
    +--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+