### Surrogate

A simple bash wrapper for Percona's Xtrabackup utility.

_Bring back life form. Priority One. All other priorities rescinded._

----

### System Requirements

Percona 5.5 (Reccomended, adjust the "binversion" configuration in xtrabackup.conf for older versions)


#### Usage

`sh surrogate -<switch> <argument>`

- -h	Usage
- -b	Performs a backup, either incremental or full depending on the argument you supply, for example: "surrogate -b full"
--	Accepts either "full" or "inc" as an argument
- -r 	Restore, accepts the full path of a restorable directory


