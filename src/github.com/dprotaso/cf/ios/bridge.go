package cfios

import (
	"encoding/json"
	"log"
	"os"

	"github.com/cloudfoundry/cli/cf/command_registry"
	"github.com/cloudfoundry/cli/cf/errors"
	"github.com/cloudfoundry/cli/cf/models"
)

var deps command_registry.Dependency

func Init(path string) {
	os.Setenv("CF_HOME", path)
	command_registry.InitI18nFunc()
	deps = command_registry.NewDependency()
}

func SetAPI(endpoint string, disableSSL bool) error {
	config := deps.Config
	endpointRepo := deps.RepoLocator.GetEndpointRepository()

	config.SetSSLDisabled(disableSSL)
	endpoint, err := endpointRepo.UpdateEndpoint(endpoint)

	if err != nil {
		log.Println(err)
		return err
	}
	log.Printf("Targeting Endpoint %v", endpoint)
	return nil
}

func Login(name, password string) error {
	config := deps.Config
	auth := deps.RepoLocator.GetAuthenticationRepository()

	config.ClearSession()

	err := auth.Authenticate(map[string]string{"username": name, "password": password})
	if err != nil {
		log.Printf("Couldn't login %v", err)
		return err
	}
	log.Printf("Logged in as %v", name)
	return nil
}

func Orgs() ([]byte, error) {
	orgRepo := deps.RepoLocator.GetOrganizationRepository()
	orgs, err := orgRepo.ListOrgs()

	if err != nil {
		log.Printf("Failed to fetch orgs %v", err)
		return nil, err
	}

	return json.Marshal(orgs)
}

func TargetOrg(orgName string) error {
	config := deps.Config
	orgRepo := deps.RepoLocator.GetOrganizationRepository()

	// setting an org necessarily invalidates any space you had previously targeted
	config.SetOrganizationFields(models.OrganizationFields{})
	config.SetSpaceFields(models.SpaceFields{})

	org, err := orgRepo.FindByName(orgName)
	if err != nil {
		return err
	}

	config.SetOrganizationFields(org.OrganizationFields)
	log.Printf("Targetted org %v", orgName)
	return nil
}

func Spaces() ([]byte, error) {
	spaceRepo := deps.RepoLocator.GetSpaceRepository()
	spaces := make([]string, 0)

	err := spaceRepo.ListSpaces(func(space models.Space) bool {
		spaces = append(spaces, space.Name)
		return true
	})

	if err != nil {
		return nil, err
	}

	return json.Marshal(spaces)
}

func TargetSpace(spaceName string) error {
	config := deps.Config
	spaceRepo := deps.RepoLocator.GetSpaceRepository()

	config.SetSpaceFields(models.SpaceFields{})

	if !config.HasOrganization() {
		return errors.New("An org must be targeted before targeting a space")
	}

	space, err := spaceRepo.FindByName(spaceName)
	if err != nil {
		return err
	}

	config.SetSpaceFields(space.SpaceFields)
	log.Printf("Targetted space %v", spaceName)
	return nil
}

func Apps() ([]byte, error) {
	appSummaryRepo := deps.RepoLocator.GetAppSummaryRepository()
	apps, err := appSummaryRepo.GetSummariesInCurrentSpace()

	if err != nil {
		return nil, err
	}

	return json.Marshal(apps)
}
