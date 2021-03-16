#!/usr/bin/env bash

RUNNER='../../common/run_script_example.sh'

# *****************************************************************************

bash ${RUNNER} SETUP "IMPORT PROVONE TRACE" << END_SCRIPT

geist destroy --dataset kb --quiet
geist create --dataset kb --quiet --infer owl
geist import --file ../data/wt-prov-rules.ttl
geist import --format jsonld --file ../data/branched-pipeline.jsonld

END_SCRIPT

# *****************************************************************************

bash ${RUNNER} RETROSPECTIVE-1 "WHAT DATA WAS USED AS INPUT BY THE PROCESS AS A WHOLE?" \
    << __END_SCRIPT__

geist query --format table << __END_QUERY__

    PREFIX prov: <http://www.w3.org/ns/prov#>
    PREFIX provone: <http://purl.dataone.org/provone/2015/01/15/ontology#>
    PREFIX wt: <http://wholetale.org/ontology/wt/>

    SELECT DISTINCT ?child_process
    WHERE {
        ?tale_execution rdf:type provone:Execution .            # Identify all executions comprising the trace.
        FILTER EXISTS {                                         # Filter out any executions that are part of others
            ?execution provone:wasPartOf ?tale_execution . }    #   leaving just the tale-level execution.
        ?sub_execution (provone:wasPartOf)+ ?tale_execution .   # Find all sub-executions of the run script execution.
        ?sub_execution prov:used ?data .                        # Identify files read by those run subprocesses.
        FILTER NOT EXISTS {                                     # Filter out any data generated by the Tale run, leaving
            ?child_process prov:generated ?writt . }            #   just the input files.
    }

__END_QUERY__

#        ?read_file wt:FilePath ?tale_input_file_path .          # Get the file path for each of the input files.

__END_SCRIPT__


#     }
#     ORDER BY ?tale_input_file_path


# # *****************************************************************************

# bash ${RUNNER} RETROSPECTIVE-2 "WHAT FILES WERE PRODUCED AS OUTPUTS OF THE TALE?" \
#     << __END_SCRIPT__

# geist query --format table << __END_QUERY__

#     PREFIX prov: <http://www.w3.org/ns/prov#>
#     PREFIX provone: <http://purl.dataone.org/provone/2015/01/15/ontology#>
#     PREFIX wt: <http://wholetale.org/ontology/wt/>

#     SELECT DISTINCT ?tale_output_file_path ?written_file
#     WHERE {
#         ?run rdf:type wt:TaleRun .                          # Identify the Tale run described by this JSON-LD document.
#         ?run wt:TaleRunScript ?run_script .                 # Identify the script used to run the Tale as a whole.
#         ?run_process wt:ExecutionOf ?run_script .           # Identify the process that is the execution of that run script.
#         ?run_sub_process (wt:ChildProcessOf)+  ?run_process .    # Find all child processes of the run script execution.
#         ?run_sub_process wt:WroteFile ?written_file .       # Identify files written by those run subprocesses.
#         FILTER NOT EXISTS { ?written_file                   # Filter out intermediate products of the Tale run, leaving
#             wt:FileRole wt:TaleIntermediateData . }         #   just the finial output input files.
#         ?written_file wt:FilePath ?tale_output_file_path .  # Get the file path for each of the output files.
#     }

# __END_QUERY__

# __END_SCRIPT__
