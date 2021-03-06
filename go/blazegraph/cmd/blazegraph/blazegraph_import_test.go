package main

import (
	"strings"
	"testing"

	"github.com/cirss/geist/util"
)

func TestBlazegraphCmd_import_two_triples(t *testing.T) {

	var outputBuffer strings.Builder
	Main.OutWriter = &outputBuffer
	Main.ErrWriter = &outputBuffer

	t.Run("import_nt", func(t *testing.T) {

		run("blazegraph destroy --dataset kb")
		run("blazegraph create --dataset kb")

		Main.InReader = strings.NewReader(`
			<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven" .
			<http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight" .
		`)

		assertExitCode(t, "blazegraph import --format nt", 0)

		outputBuffer.Reset()
		run("blazegraph export --format nt --sort=true")
		util.LineContentsEqual(t, outputBuffer.String(),
			`<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven" .
			 <http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight" .
			`)
	})

	t.Run("import_ttl", func(t *testing.T) {

		run("blazegraph destroy --dataset kb")
		run("blazegraph create --dataset kb")

		Main.InReader = strings.NewReader(
			`@prefix data: <http://tmcphill.net/data#> .
			 @prefix tags: <http://tmcphill.net/tags#> .

			 data:y tags:tag "eight" .
			 data:x tags:tag "seven" .
			`)

		assertExitCode(t, "blazegraph import --format ttl", 0)

		outputBuffer.Reset()
		run("blazegraph export --format nt --sort=true")
		util.LineContentsEqual(t, outputBuffer.String(),
			`<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven" .
			 <http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight" .
			`)
	})

	t.Run("import_jsonld", func(t *testing.T) {

		run("blazegraph destroy --dataset kb")
		run("blazegraph create --dataset kb")

		Main.InReader = strings.NewReader(
			`
			[
				{
					"@id": "http://tmcphill.net/data#x",
					"http://tmcphill.net/tags#tag": "seven"
				},
				{
					"@id": "http://tmcphill.net/data#y",
					"http://tmcphill.net/tags#tag": "eight"
				}
			]
			`)

		assertExitCode(t, "blazegraph import --format jsonld", 0)

		outputBuffer.Reset()
		run("blazegraph export --format nt --sort=true")
		util.LineContentsEqual(t, outputBuffer.String(),
			`<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven"^^<http://www.w3.org/2001/XMLSchema#string> .
			 <http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight"^^<http://www.w3.org/2001/XMLSchema#string> .
			`)
	})

	t.Run("import_ttl", func(t *testing.T) {

		run("blazegraph destroy --dataset kb")
		run("blazegraph create --dataset kb")

		Main.InReader = strings.NewReader(
			`@prefix data: <http://tmcphill.net/data#> .
			 @prefix tags: <http://tmcphill.net/tags#> .

			 data:y tags:tag "eight" .
			 data:x tags:tag "seven" .
			`)

		assertExitCode(t, "blazegraph import --format ttl", 0)

		outputBuffer.Reset()
		run("blazegraph export --format nt --sort=true")
		util.LineContentsEqual(t, outputBuffer.String(),
			`<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven" .
			 <http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight" .
			`)
	})

	t.Run("import_xml", func(t *testing.T) {

		run("blazegraph destroy --dataset kb")
		run("blazegraph create --dataset kb")

		Main.InReader = strings.NewReader(
			`<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

			 <rdf:Description rdf:about="http://tmcphill.net/data#y">
				<tag xmlns="http://tmcphill.net/tags#">eight</tag>
		 	 </rdf:Description>

 			 <rdf:Description rdf:about="http://tmcphill.net/data#x">
				<tag xmlns="http://tmcphill.net/tags#">seven</tag>
  			 </rdf:Description>

			 </rdf:RDF>
			`)

		assertExitCode(t, "blazegraph import --format xml", 0)

		outputBuffer.Reset()
		run("blazegraph export --format nt --sort=true")
		util.LineContentsEqual(t, outputBuffer.String(),
			`<http://tmcphill.net/data#x> <http://tmcphill.net/tags#tag> "seven" .
			 <http://tmcphill.net/data#y> <http://tmcphill.net/tags#tag> "eight" .
			`)
	})
}

func TestBlazegraphCmd_import_help(t *testing.T) {

	var outputBuffer strings.Builder
	Main.OutWriter = &outputBuffer
	Main.ErrWriter = &outputBuffer

	assertExitCode(t, "blazegraph import help", 0)

	util.LineContentsEqual(t, outputBuffer.String(),
		`
		Imports triples in the specified format into an RDF dataset.

		Usage: blazegraph import [<flags>]

		Flags:

		-dataset name
				name of RDF dataset to import triples into (default "kb")
		-file string
				File containing triples to import (default "-")
		-format string
				Format of triples to import [jsonld, nt, ttl, or xml] (default "ttl")
		-instance URL
				URL of Blazegraph instance (default "http://127.0.0.1:9999/blazegraph")
	  	-quiet
				Discard normal command output

	`)
}

func TestBlazegraphCmd_help_import(t *testing.T) {

	var outputBuffer strings.Builder
	Main.OutWriter = &outputBuffer
	Main.ErrWriter = &outputBuffer

	assertExitCode(t, "blazegraph help import", 0)

	util.LineContentsEqual(t, outputBuffer.String(),
		`
		Imports triples in the specified format into an RDF dataset.

		Usage: blazegraph import [<flags>]

		Flags:

		-dataset name
				name of RDF dataset to import triples into (default "kb")
		-file string
				File containing triples to import (default "-")
		-format string
				Format of triples to import [jsonld, nt, ttl, or xml] (default "ttl")
		-instance URL
				URL of Blazegraph instance (default "http://127.0.0.1:9999/blazegraph")
	  	-quiet
				Discard normal command output

	`)
}

func TestBlazegraphCmd_import_bad_flag(t *testing.T) {

	var outputBuffer strings.Builder
	Main.OutWriter = &outputBuffer
	Main.ErrWriter = &outputBuffer

	assertExitCode(t, "blazegraph import --not-a-flag", 1)

	util.LineContentsEqual(t, outputBuffer.String(),
		`
		flag provided but not defined: -not-a-flag

		Usage: blazegraph import [<flags>]

		Flags:

		-dataset name
				name of RDF dataset to import triples into (default "kb")
		-file string
				File containing triples to import (default "-")
		-format string
				Format of triples to import [jsonld, nt, ttl, or xml] (default "ttl")
		-instance URL
				URL of Blazegraph instance (default "http://127.0.0.1:9999/blazegraph")
	  	-quiet
				Discard normal command output

	`)
}