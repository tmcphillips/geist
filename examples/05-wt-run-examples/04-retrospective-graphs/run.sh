#!/usr/bin/env bash

DOT_RUNNER='../../common/run_dot_examples.sh'
SCRIPT_RUNNER='../../common/run_script_example.sh'


# *****************************************************************************

bash ${SCRIPT_RUNNER} SETUP "IMPORT PROVONE TRACE" << END_SCRIPT

blazegraph drop
blazegraph import --format jsonld --file ../data/branched-pipeline.jsonld

END_SCRIPT


bash ${DOT_RUNNER} GRAPH-1 "EMPTY DOT FILE" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

{{{
    {{ include "graphviz.g" }}
    {{ include "wt.g" }}
}}}

    # A graphviz file
    {{ gv_graph "wt_run" }}
    {{ gv_end }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__





bash ${DOT_RUNNER} GRAPH-2 "TITLED EMPTY DOT FILE" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

{{{
    {{ include "graphviz.g" }}
    {{ include "wt.g" }}
}}}

    {{ with $RunID := SelectRunID | value}}

        # Run ID: {{ $RunID }}
        {{ gv_graph "wt_run" }} 
        {{ gv_title (SelectTaleName $RunID | value) }}
        {{ gv_end }}
    
    {{ end }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__


bash ${DOT_RUNNER} GRAPH-3 "Node for Tale Run" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "graphviz.g" }}
        {{ include "wt.g" }}
    }}}

    {{ with $RunID := SelectRunID | value }}

        # Run ID: {{ $RunID }}
        {{ gv_graph "wt_run" }} 
        {{ gv_title (SelectTaleName $RunID | value) }}
        {{ wt_run_node_style }}
        {{ wt_node_run $RunID }}
        {{ gv_end }}
    
    {{ end }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__


bash ${DOT_RUNNER} GRAPH-4 "Node for Tale Run" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

    {{{
        {{ include "graphviz.g" }}
        {{ include "wt.g" }}
    }}}

    {{ with $RunID := SelectRunID | value }}                                                                \\
    {{ with $TaleName := SelectTaleName $RunID | value }}                                                   \\
    {{ with $RunScript := (select "SELECT ?s WHERE {<{{.}}> wt:TaleRunScript ?s}" $RunID | value) }}        \\
 
         # Run ID: {{ $RunID }}
        {{ gv_graph "wt_run" }}

        # graph title
        {{ gv_title "Tale Inputs and Outputs" }}
        
        # the tale run
        {{ wt_run_node_style }}
        {{ wt_node_run $TaleName }}
        
        # output files
        {{ gv_cluster "outputs" }}
            {{ wt_node_style_file }}
            {{ range $OutputFilePath := (SelectTaleOutputFilePaths $RunScript | rows) }}                    \\
               {{ labeled_node $OutputFilePath }} 
            {{ end }}                                                                                       \\
        {{ gv_cluster_end }}

        {{ gv_end }}
    
    {{ end }}
    {{ end }}
    {{ end }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__