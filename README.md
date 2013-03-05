### Surrogate

A simple bash wrapper for Percona's Xtrabackup utility.

_Bring back life form. Priority One. All other priorities rescinded._

----

### Prerequisites

- Qpress [Download, extract & mv to /usr/bin](http://www.quicklz.com/qpress-11-linux-x64.tar)

- Percona 5.5
 - Functionality for older version of MySQL is on the TODO list
- Percona Xtrabackup 2.0.1 or later
- Ample disk space (even with compression backups are only 2:1 ratio)

#### Usage

`sh surrogate -<switch> <argument>`

- -h	Usage
- -b	Performs a backup, either incremental or full depending on the argument you supply, for example: "surrogate -b full"
--	Accepts either "full" or "inc" as an argument
- -r  Restore using default digest location
- -c  Restore, accepts a file containing a list of directories to restore.


#### Configuration

Main configuration file
- /etc/surrogate/surrogate.conf

Xtrabackup tuning configuration (TODO)
- /etc/surrogate/xtrabackup.conf

#### Retention directory tree 

    /data
    |-- backups
    |   |-- daily
    |   |   |-- Fri
    |   |   |-- Mon
    |   |   |-- Sat
    |   |   |-- Sun
    |   |   |-- Thu
    |   |   |-- Tue
    |   |   `-- Wed
    |   |-- monthly
    |   `-- weekly
    |-- log
    |   `-- bin
    |-- mysql
    |-- tmp

#### Default rotation policy (configurable in surrogate.conf)

- 7 days
- 4 weeks
- 6 months

#### Authors

- Loren Carvalho
- Jesse R. Adams

#### License
GPLv3
