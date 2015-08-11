package cfios

import (
	"log"

	"github.com/cloudfoundry/cli/cf/command_registry"
)

var deps = command_registry.NewDependency()
var cmdRegistry = command_registry.Commands

func SetAPI(endpoint string, disableSSL bool) {
	config := deps.Config
	endpointRepo := deps.RepoLocator.GetEndpointRepository()

	config.SetSSLDisabled(disableSSL)
	endpoint, err := endpointRepo.UpdateEndpoint(endpoint)

	if err != nil {
		log.Println(err)
	}
}

func Login(name, password string) {
	config := deps.Config
	auth := deps.RepoLocator.GetAuthenticationRepository()

	config.ClearSession()

	apiErr := auth.Authenticate(map[string]string{"username": name, "password": password})
	if apiErr != nil {
		log.Printf("Couldn't login %v", apiErr)
		return
	}
}

func Orgs() string {
	orgRepo := deps.RepoLocator.GetOrganizationRepository()
	orgs, apiErr := orgRepo.ListOrgs()

	if apiErr != nil {
		log.Printf("Failed to fetch orgs %v", apiErr)
	}

	orgNames := make([]string, 0, len(orgs))

	for _, org := range orgs {
		orgNames = append(orgNames, org.Name)
	}

	return orgNames[0]
}
