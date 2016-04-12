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
      - url: github.com/18F/cg-complinace
        revision: master
  ```

0. Create component documentation using the [opencontrol schema](https://github.com/opencontrol/schemas) and update the `components` object in the opencontrol.yaml with the documentation path.
0. "Import" the Cloud.gov dependencies.

  The get command will import all the data from the cg-complinace repository and serve as a baseline for your SSP
  ```bash
  compliance-masonry get
  ```

# Creating Gitbook
0. Install [Compliance Masonry CLI](https://github.com/opencontrol/compliance-masonry)
0. Download Compliance Documentation and Navigate to Repository

  ```bash
  git clone https://github.com/18F/cg-compliance
  cd cg-compliance
  ```

0. Install dependencies

  ```
  compliance-masonry get
  ```

0. Create Gitbook Documentation

  ```bash
  compliance-masonry docs gitbook LATO # `LATO` or `FedRAMP-low` .. etc.
  ```

0. Serve the Gitbook locally

  ```bash
  npm install gitbook-cli -g # Install Gitbook CLI
  cd exports # Navigate to exports dir
  gitbook serve
  ```

### Create PDF
Req: Install ebook-convert from Calibre
[May need to install ebook-convert from Calibre installed](https://github.com/GitbookIO/gitbook/issues/333)
0. Install gitbook pdf extension

  ```bash
  npm install gitbook-pdf -g
  ```

0. Navigate to the exports dir

  ```bash
  cd exports
  ```

0. Create PDF

  ```bash
  gitbook pdf .
  ```


  # BDD Tests
  This repository also contains [setup and run instructions for a set of BDD test](https://github.com/18F/cg-compliance/tree/master/BDD) that help verify Cloud Foundry control implementations.
