### Surrogate
#### _ Bring back life form. Priority One. All other priorities rescinded. _

A simple bash wrapper for Percona's Xtrabackup utility.

----

#### Usage

`sh surrogate -<switch> <argument>`

- -h	Shows this message
- -b	Performs a backup, either incremental or full, for example: "sh surrogate -b full"
--	Accepts either "full" or "inc" as an argument
- -r 	Restore, accepts the full path of a restorable directory "-r /path/to/dir"
- -c	Compress, compresses everything in 'last_backup'
- -p	Promote * work in progress *
