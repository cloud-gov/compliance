# Cloud Foundry Compliance
This repository contains shared compliance data for Cloud.gov

# Starting ATO Documentation for Cloud.gov applications.
0. Install [Compliance Masonry CLI](https://github.com/opencontrol/compliance-masonry)
0. [Create an opencontrol.yaml](https://github.com/opencontrol/compliance-masonry#creating-an-opencontrol-project) based on the data below.
  ```yaml
  schema_version: "1.0.0"
  name: Your_Application_Name # Name of the project
  metadata:
    description: "A description of the application"
    maintainers:
      - maintainer_email@email.com
  components: # A list of paths to components written in the opencontrol format for more information view: https://github.com/opencontrol/schemas
    - ./your_app_component
  dependencies:
    systems:
      - url: github.com/18F/cg-compliance
        revision: master
  ```

0. Create component documentation using the [opencontrol schema](https://github.com/opencontrol/schemas) and update the `components` object in the opencontrol.yaml with the documentation path.
0. "Import" the Cloud.gov dependencies.


  ```bash
  compliance-masonry get
  ```

The get command will import all the data from the cg-compliance repository and drop them into the `opencontrol` directory to serve as a baseline for your SSP

For viewing the documentation in various formats (e.g. gitbook, docx), use the instructions in the [compliance-masonry](https://github.com/opencontrol/compliance-masonry) repository.

# BDD Tests
This repository also contains [setup and run instructions for a set of BDD test](https://github.com/18F/cg-compliance/tree/master/BDD) that help verify Cloud Foundry control implementations.
