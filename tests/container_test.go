package main

import (
	"testing"

	helpers "github.com/hydazz/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("esphome:local")
	t.Logf("testing image: %s", image)

	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{
		Port:       "6052",
		Path:       "/version",
		StatusCode: 200,
	}, nil)
}
