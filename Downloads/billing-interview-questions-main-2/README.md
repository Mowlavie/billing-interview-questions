# README

The repository contains a simplified app for a billing service.
Compute clusters send a report to S3 per virtual machine on every change / 24 hours.
The billing service fetches reports from S3 and process them.
The billing service processing will create events of changes for virtual_machines that can be later used to create invoices.
In this demo we will use file based reports and not S3, but please assume the production service will use S3.


### Running the billing service
```
rake run_reports_handler
```

### Deleting and copying reports from template
rake fetch_and_process

DB schema

### compute_cluster

    uuid    string
    name    string

### virtual_machine

    uuid    string
    status  string
    compute_cluster_id  integer
    created_at  datetime
    updated_at  datetime
    deleted_at  datetime
    deleted boolean

### event

    created_at  datetime
    vm_id       integer
    event_type  string

###

the following cron unit is necessary to run system check for hourly to illustrate "delete" updates 

crontab -e


then:

0 * * * * cd /path/to/app && bin/rails runner -e production 'ReportsHandler.new.check_for_timed_out_vms'

the 0**** checks per hour (interval)

This method can be run on a regular basis using a task scheduler like cron on Unix-like systems or the Task Scheduler on Windows. This allows the billing application to keep track of deleted virtual machines and stop billing for them even if no "delete event" is received.

###