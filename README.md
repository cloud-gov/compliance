# cloud.gov Compliance

This repository contains shared compliance data for [cloud.gov](https://cloud.gov).

## Starting ATO documentation for cloud.gov applications

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

0. Create component documentation using the [opencontrol schema](https://github.com/opencontrol/schemas) and update the `components` object in the `opencontrol.yaml` with the documentation path.
0. "Import" the cloud.gov dependencies.

    ```bash
    compliance-masonry get
    ```

The `get` command will import all the data from the cg-compliance repository and drop them into the `opencontrols/` directory to serve as a baseline for your SSP.

## Creating Gitbook

Run

```bash
compliance-masonry get
compliance-masonry docs gitbook LATO # `LATO` or `FedRAMP-low` .. etc.
npm install gitbook-cli -g
cd exports
gitbook serve
```

### Create PDF

0. [Install `ebook-convert`](https://github.com/GitbookIO/gitbook/issues/333) from [Calibre](http://calibre-ebook.com/download)
0. Run

    ```bash
    npm install gitbook-pdf -g
    cd exports
    gitbook pdf .
    ```

## BDD tests

This repository also contains [setup and run instructions for a set of BDD test](https://github.com/18F/cg-compliance/tree/master/BDD) that help verify [Cloud Foundry](https://www.cloudfoundry.org/) control implementations.
