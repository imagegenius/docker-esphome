package main

import (
	"context"
	"testing"

	"github.com/imagegenius/docker-esphome/tests/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("esphome:local")
	t.Logf("testing image: %s", image)

	testhelpers.TestHTTPEndpoint(t, ctx, image, testhelpers.HTTPTestConfig{
		Port:       "6052",
		Path:       "/version",
		StatusCode: 200,
	}, nil)
}
