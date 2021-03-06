package blazegraph

import (
	"fmt"
	"time"

	"github.com/cirss/geist"
	"github.com/cirss/geist/cli"
)

const retryPeriod = 100

func Status(cc *cli.CommandContext) (err error) {

	timeout := cc.Flags.Int("timeout", 0, "Number of `milliseconds` to wait for Blazegraph instance to respond")

	var helped bool
	if helped, err = cc.ParseFlags(); helped || err != nil {
		return
	}

	bc := cc.Resource("BlazegraphClient").(*BlazegraphClient)

	maxTries := max(*timeout/retryPeriod, 1)
	status, err := getStatusInMaxTries(bc, maxTries)

	if err != nil {
		fmt.Fprintln(cc.ErrWriter, err.Error())
	} else {
		fmt.Fprintln(cc.OutWriter, status)
	}

	return
}

func getStatusInMaxTries(bc *BlazegraphClient, maxTries int) (status string, err error) {

	for tries := 1; tries <= maxTries; tries++ {

		// try to get the status
		status, err = bc.GetStatus()

		// exit loop if successful
		if err == nil {
			break
		}

		// if this was the last allowed try, record a timeout error and exit loop
		if tries == maxTries {
			err = geist.NewGeistError("Exceeded timeout connecting to Blazegraph instance", err)
			break
		}

		time.Sleep(retryPeriod * time.Millisecond)
	}

	return
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}