#!/usr/bin/env bash

# *****************************************************************************

bash_dot_cell static_dot_file << 'END_CELL'

geist report << 'END_TEMPLATE'

    digraph static_dot_file {

        rankdir=BT
        fontname=Courier; fontsize=12; labelloc=t
        label="Class Hierarchy"

        B -> A
        C -> A
    }

END_TEMPLATE

END_CELL


# *****************************************************************************

bash_dot_cell dot_file_with_variables << 'END_CELL'

geist report << 'END_TEMPLATE'

    {{ $GraphID     := "dot_file_with_variables" }}
    {{ $GraphTitle  := "Class Hierarchy"}}
    {{ $ParentClass := "A" }}
    {{ $ChildClass1 := "B" }}
    {{ $ChildClass2 := "C" }}

    digraph {{ $GraphID }} {

        rankdir=BT
        fontname=Courier; fontsize=12; labelloc=t
        label="{{ $GraphTitle }}"

        {{ $ChildClass1 }} -> {{ $ParentClass }}
        {{ $ChildClass2 }} -> {{ $ParentClass }}
    }

END_TEMPLATE

END_CELL


# *****************************************************************************

bash_dot_cell dot_file_with_macros << 'END_CELL'

geist report << 'END_TEMPLATE'

    {{{
        {{ macro "gv_graph" "Name" "Direction" '''
            digraph {{$Name}} {
            rankdir={{$Direction}}
        ''' }}

        {{ macro "gv_title" "Title" '''
            fontname=Courier; fontsize=12; labelloc=t
            label="{{$Title}}"
        ''' }}

        {{ macro "gv_edge" "Tail" "Head" '''
            "{{$Tail}}" -> "{{$Head}}"
        ''' }}

        {{ macro "gv_end" '''
            }
        ''' }}
    }}}

    {{ $ParentClass := "A" }}
    {{ $ChildClass1 := "B" }}
    {{ $ChildClass2 := "C" }}

    {{ gv_graph "dot_file_with_macros" "BT" }}
    {{ gv_title "Class Hierarchy" }}
    {{ gv_edge $ChildClass1 $ParentClass }}
    {{ gv_edge $ChildClass2 $ParentClass }}
    {{ gv_end }}

END_TEMPLATE

END_CELL


# *****************************************************************************

bash_dot_cell dot_file_with_included_macros << 'END_CELL'

geist report << 'END_TEMPLATE'

    {{{
        {{ include "graphviz_macros.g" }}
    }}}

    {{ $ParentClass := "A" }}
    {{ $ChildClass1 := "B" }}
    {{ $ChildClass2 := "C" }}

    {{ gv_graph "dot_file_with_included_macros" "BT" }}
    {{ gv_title "Class Hierarchy" }}
    {{ gv_edge $ChildClass1 $ParentClass }}
    {{ gv_edge $ChildClass2 $ParentClass }}
    {{ gv_end }}

END_TEMPLATE

END_CELL
