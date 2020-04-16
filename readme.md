Installing Dependencies
=======================

    sudo apt update
    sudo apt-get install libdbd-mysql-perl
    sudo apt install mysql-client

Configuration
=============

Create file with credentials to mysql tools:

    touch ~/.my.cnf
    vim ~/.my.cnf
    [client]
    user=<user>
    password=<password>

Set host in etc/config.ini:

    vim etc/config.ini
    MYSQLHOST='<database url>'