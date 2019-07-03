// Managed By : CloudDrove
// Description : This Terratest is used to test the Terraform SNS module.
// Copyright @ CloudDrove. All Right Reserved.

package test

import (
	"testing"
	// "github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSns(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{

		// Source path of Terraform directory.
		TerraformDir: "../_example",
		Upgrade: true,
	}
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)
	// Arn := terraform.OutputList(t, terraformOptions, "domain_identity_arn")

	// expectedArn := "arn:aws:ses:us-east-1:946010253026:identity/crosschecker.io"
	// Verify we're getting back the outputs we expect
	// assert.Equal(t, expectedArn, Arn)
}
