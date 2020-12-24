{{ prefix "sdtl" "https://rdf-vocabulary.ddialliance.org/sdtl#" }}

{{ macro "sdtl_program_node_style" '''
    node[shape=box style="filled" fillcolor="#CCFFCC" peripheries=1 fontname=Courier]
''' }}

{{ query "sdtl_select_program" '''
    SELECT ?program
    WHERE {
        ?program rdf:type sdtl:Program .
    }
'''}}

{{ query "sdtl_select_saves" "ProgramID" '''
    SELECT ?command ?dataframe
    WHERE {
        <{{$ProgramID}}> sdtl:Commands ?command_inventory .
        ?command_inventory rdfs:member ?command .
        ?command rdf:type sdtl:Save .
        ?command sdtl:ConsumesDataframe ?dataframe .
    }
'''}}

{{ query "sdtl_select_dataframe_variables" "DataframeID" '''
    SELECT ?variable
    WHERE {
        <{{$DataframeID}}> sdtl:VariableInventory/rdfs:member/sdtl:VariableName ?variable .
    }
'''}}


{{ query "sdtl_select_commands" "ProgramID" '''
    SELECT DISTINCT ?command ?source_text
    WHERE {
        $ProgramID sdtl:Commands ?commandinventory .
        ?commandinventory ?index ?command .
        ?command sdtl:SourceInformation ?source_info .
        ?source_info sdtl:OriginalSourceText ?source_text .
    }
''' }}

{{ query "sdtl_select_dataframe_edges" "ProgramID" '''
    SELECT DISTINCT ?upstream_command ?downstream_command ?dataframe ?dataframe_name
    WHERE {
        $ProgramID sdtl:Commands ?commandinventory .
        ?commandinventory ?index ?upstream_command .
        ?upstream_command sdtl:ProducesDataframe ?dataframe .
        ?downstream_command sdtl:ConsumesDataframe  ?dataframe .
        ?dataframe sdtl:DataframeName ?dataframe_name
    }
''' }}

{{ query "sdtl_select_compute_variable_compute_edges" "ProgramID" '''
    SELECT DISTINCT ?upstream_command ?downstream_command ?variable_name
    WHERE {
        $ProgramID sdtl:Commands ?commandinventory .
        ?commandinventory ?index ?downstream_command .
        ?upstream_command sdtl:ProducesDataframe ?dataframe .
        ?downstream_command sdtl:ConsumesDataframe  ?dataframe .
        ?downstream_command sdtl:OperatesOn/sdtl:VariableName ?variable_name .
        ?upstream_command sdtl:Variable/sdtl:VariableName ?variable_name .
    }
''' }}

{{ query "sdtl_select_load_variable_compute_edges" "ProgramID" '''
    SELECT DISTINCT ?upstream_command ?downstream_command ?variable_name
    WHERE {
        $ProgramID sdtl:Commands ?commandinventory .
        ?commandinventory ?index ?downstream_command .
        ?downstream_command sdtl:ConsumesDataframe  ?dataframe .
        ?downstream_command sdtl:OperatesOn/sdtl:VariableName ?variable_name .
        ?upstream_command a sdtl:Load .
        ?upstream_command_load_command sdtl:ProducesDataframe/sdtl:VariableInventory ?variable_name .
    }
''' }}
