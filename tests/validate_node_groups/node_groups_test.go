package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestValidNodeGroups(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "./valid_node_groups", // valid test case
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
}

func TestInvalidNodeGroupsTooLarge(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "./invalid_node_groups_too_large", // invalid test case
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "desired_size must be between 1 and 10")
}

func TestInvalidNodeGroupsTooSmall(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "./invalid_node_groups_too_small", // invalid case
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions) 
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "desired_size must be between 1 and 10")
}
