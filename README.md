### Surrogate

A simple bash wrapper for Percona's Xtrabackup utility.

_Bring back life form. Priority One. All other priorities rescinded._

----

### Prerequisites

- Qpress, included in the installer, otherwise you can get a copy [here.](http://www.quicklz.com/qpress-11-linux-x64.tar)

- Percona 5.5+
- Percona Xtrabackup 2.0.1 or later
- Ample disk space (even with compression backups are only 2:1 ratio)
- [S3tools](http://s3tools.org/s3cmd) installed and configured

#### Usage

`sh surrogate -<flag> <argument>`

- -h	Usage
- -b	Performs a backup, either incremental or full depending on the argument you supply, for example: "surrogate -b full"
--	Accepts either "full" or "inc" as an argument
- -r  Restore using default digest location
- -c  Restore, accepts a file containing a list of directories to restore.


#### Configuration

Main configuration file
- /etc/surrogate/surrogate.conf

Xtrabackup tuning configuration (for future versions, not currently used)
- /etc/surrogate/xtrabackup.conf

#### Retention directory tree 

    /data (customizable data directory)
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
    |-- mysql (or your my.cnf datadir)
    |-- tmp

#### Default rotation policy (configurable in surrogate.conf)

- 7 days
- 4 weeks
- 6 months

#### Authors

- [Loren Carvalho](https://github.com/sixninetynine)
- [Jesse R. Adams](https://github.com/jesseadams)

#### License

GPLv3
