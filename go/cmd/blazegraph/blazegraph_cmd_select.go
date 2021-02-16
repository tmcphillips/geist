package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/cirss/geist"
	"github.com/cirss/geist/blazegraph"
)

func handleSelectSubcommand(flags *flag.FlagSet) {
	addCommonOptions(flags)
	dryrun := flags.Bool("dryrun", false, "Output query but do not execute it")
	file := flags.String("file", "-", "File containing select query to execute")
	format := flags.String("format", "json", "Format of result set to produce")
	separators := flags.Bool("columnseparators", true, "Display column separators in table format")
	if err := flags.Parse(os.Args[2:]); err != nil {
		fmt.Println(err)
		flags.Usage()
		return
	}
	doSelectQuery(*dryrun, *file, *format, *separators)
}

func doSelectQuery(dryrun bool, file string, format string, columnSeparators bool) {

	bc := blazegraph.NewBlazegraphClient(*options.url)
	queryText, err := readFileOrStdin(file)
	if err != nil {
		fmt.Fprintf(Main.ErrWriter, err.Error())
		return
	}

	queryTemplate := geist.NewTemplate("query", string(queryText), nil, bc)
	err = queryTemplate.Parse()
	if err != nil {
		fmt.Fprintf(Main.ErrWriter, "Error expanding query template:\n")
		fmt.Fprintf(Main.ErrWriter, "%s\n", err.Error())
		return
	}

	q, err := queryTemplate.Expand(nil)

	if err != nil {
		fmt.Fprintf(Main.ErrWriter, "Error expanding query template: ")
		fmt.Fprintf(Main.ErrWriter, "%s\n", err.Error())
		return
	}

	if dryrun {
		fmt.Print(string(q))
		return
	}

	switch format {

	case "csv":
		resultCSV, _ := bc.SelectCSV(string(q))
		if err != nil {
			break
		}
		fmt.Fprintf(Main.OutWriter, resultCSV)
		return

	case "json":
		rs, err := bc.Select(string(q))
		if err != nil {
			break
		}
		resultJSON, _ := rs.JSONString()
		fmt.Fprintf(Main.OutWriter, resultJSON)
		return

	case "table":
		rs, err := bc.Select(string(q))
		if err != nil {
			break
		}
		table := rs.FormattedTable(columnSeparators)
		fmt.Fprintf(Main.OutWriter, table)
		return

	case "xml":
		resultXML, err := bc.SelectXML(string(q))
		if err != nil {
			break
		}
		fmt.Fprintf(Main.OutWriter, resultXML)
		return
	}

	if err != nil {
		fmt.Fprintf(Main.ErrWriter, err.Error())
		return
	}

}
