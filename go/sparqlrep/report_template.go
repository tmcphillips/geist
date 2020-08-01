package sparqlrep

import (
	"io"
	"os"
	"text/template"
)

var GraveDelimiters DelimiterPair

func init() {
	GraveDelimiters = DelimiterPair{"`", "`"}
}

// ReportTemplate is customizable to create reports from different kinds of templates.
type ReportTemplate struct {
	template *template.Template
}

// NewReportTemplate returns a ReportTemplate with the given customizations.
func NewReportTemplate(delimiters DelimiterPair, funcs template.FuncMap, text string) *ReportTemplate {
	text = EscapeRawText(delimiters, text)
	template := template.New("test")
	if funcs != nil {
		template = template.Funcs(funcs)
	}
	template, _ = template.Parse(text)
	rt := new(ReportTemplate)
	rt.template = template
	return rt
}

func (rp *ReportTemplate) Expand(wr io.Writer, data interface{}) error {
	err := rp.template.Execute(os.Stdout, data)
	return err
}