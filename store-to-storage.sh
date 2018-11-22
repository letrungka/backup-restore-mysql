#!/bin/bash

export LC_ALL=C

parent_dir="/backups/mysql"
days_of_backup=1 # copy last day to storage
days_of_rotate=30
storage_dir="/backup-to-storage"
log_file="${storage_dir}/storage.log"

if [ ! -f "${log_file}" ]; then
        touch "${log_file}"
    fi

rotate_old () {
    # Remove the oldest backup in rotation
    day_dir_to_remove="${storage_dir}/$(date --date="${days_of_rotate} days ago" +%Y%m%d)"

    if [ -d "${day_dir_to_remove}" ]; then
        rm -rf "${day_dir_to_remove}"
    fi
}

copy_to_storage () {
    # Remove the oldest backup in rotation
    day_dir_to_copy="${parent_dir}/$(date --date="${days_of_backup} days ago" +%Y%m%d)"

    if [ -d "${day_dir_to_copy}" ]; then
                cp -r "${day_dir_to_copy}" "${storage_dir}"
                echo " "$(date)" "${day_dir_to_copy}" is copied sucessfully !!!" >> ${log_file}
        else
                echo " "$(date)" "${day_dir_to_copy}" is not exist !!!" >> ${log_file}
        fi
}

rotate_old && copy_to_storage
