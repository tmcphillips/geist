#!/usr/bin/env bash

# save command line arguments
script_id=$1
script_description=$2

scratch_dir=.scratch

# define name of result file
script_file=${scratch_dir}/${script_id}.sh
output_file=${scratch_dir}/${script_id}.txt

# copy query from stdin to the query file
printf "# ${script_description}\n" > ${script_file}
IFS=''; while read line
do
    printf "$line\n" >> ${script_file}
done

# execute the script on the given data file and save results
bash ${script_file} > ${output_file}

# print the script results
echo
echo "******************************************* EXAMPLE ${script_id} ************************************************"
echo
cat ${script_file}
echo "------------------------------------------- ${script_id} OUTPUTS ------------------------------------------------"
echo
cat ${output_file}
echo