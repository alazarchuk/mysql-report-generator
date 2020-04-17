Description
===========

It is slightly modified Debian/Ubuntu version of mysqlmymonlite.sh file from mysqlmymon.com. Paths to external files were changed and unnecessary report section were disabled when MySQL is on remote server.

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

Download
--------

    git clone https://github.com/alazarchuk/mysql-report-generator.git
    cd mysql-report-generator

MySQL General Report
--------------------

    ./mysqlmymonlite.sh mysql # For full report
    ./mysqlmymonlite.sh mysqlreport # Only output of mysqlreport tool

MySQL Table Indexes Report
--------------------------

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

MySQL Benchmark or Report Replay Repeat
=======================================

There is additional in the repository that can run percona playback tool with provided slow query log and generate report couple times to see progress. You need to have `percona-playback` installed, `~/.my.cnf` created and slow query log generated.

Usage
-----

    ./mysql-report-replay-repeat.sh -f ~/ip-172-31-36-170-slow.log -t 4 -d employees

Options:

    -f - path to slow query log

    -t - how many times repeat report replay cycle

    -d - target database
    
    -r - report folder where reports will be saved, optional. Default value `reports/$(date "+%m%d%H%M%Y.%S")`

Installing Percona Playback Tool
--------------------------------

    sudo apt-get install percona-toolkit mysql-client git vim
    sudo apt-get install libtbb-dev libmysqlclient-dev libboost-program-options-dev libboost-thread-dev libboost-regex-dev libboost-system-dev libboost-chrono-dev pkg-config cmake  libssl-dev
    git clone https://github.com/Percona-Lab/query-playback.git
    cd query-playback/
    sed -i 's/find_library(MYSQL_LIB "mysqlclient_r" PATH_SUFFIXES "mysql")/find_library(MYSQL_LIB "mysqlclient" PATH_SUFFIXES "mysql")/' percona_playback/mysql_client/CMakeLists.txt
    // The above Sed command fixes type in the CMakeLists.txt file.
    // You can manually edit the file and fix the typo as suggested below.
    // vim percona_playback/mysql_client/CMakeLists.txt
    // Remove _r, https://dba.stackexchange.com/questions/218736/replay-re-execute-mysql-select-queries-from-a-log-file

    mkdir build_dir
    cd build_dir
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    make
    sudo make install