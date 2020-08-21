#!/usr/bin/env bash

RUNNER='../../common/run_script_example.sh'

# *****************************************************************************

bash ${RUNNER} SETUP "IMPORT PROVONE TRACE" << END_SCRIPT

blazegraph drop
blazegraph import --format jsonld --file ../data/branched-pipeline.jsonld

END_SCRIPT


bash ${RUNNER} GRAPH-1 "EMPTY DOT FILE" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

    {{ include "graphviz-macros.gst" }}
    % A graphviz file
    {{ expand "gv_graph" "wt_run" }}
    {{ expand "gv_end" }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__



bash ${RUNNER} GRAPH-2 "TITLED EMPTY DOT FILE" \
    << '__END_SCRIPT__'

blazegraph report << '__END_REPORT_TEMPLATE__'

    {{ include "graphviz-macros.gst" }}
    {{ include "wt-queries.gst" }}

    {{ with $RunID := runquery "GetRunID" | value}}
        % Run ID: {{ $RunID }} \\n

        {{ expand "gv_graph" "wt_run" }}
    
        {{ expand "gv_title" (runquery "GetTaleName" $RunID | value) }}
    {{ end }}

    {{ expand "gv_end" }}

__END_REPORT_TEMPLATE__

__END_SCRIPT__