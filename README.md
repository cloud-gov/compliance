# cloud.gov Compliance

This is a public repository following [18F's Open Source Policy](https://github.com/18F/open-source-policy/blob/master/policy.md). See our [LICENSE.md](LICENSE.md) and [CONTRIBUTING.md](CONTRIBUTING.md) files.

See also: https://github.com/18F/compliance-docs and https://github.com/18F/cg-deploy-compliance-documentation

## What's in this repository

This is a **draft** of federal information system security compliance documentation for [cloud.gov](https://cloud.gov/), written in a structured format suited for processing into reader-friendly documents using [Compliance Masonry](https://github.com/opencontrol/compliance-masonry).

Our goal as a cloud.gov team is to maintain our compliance documentation as public structured files in this repository. As we've moved cloud.gov through the FedRAMP compliance process, we've had to revise our System Security Plan and related docs at a rate that exceeded our ability to capture every change in Compliance Masonry YAML. So, we're currently updating our System Security Plan in the standard way that many teams end up working on this: a single canonical non-public Word doc file, maintained by one person.

The bad news is that the material in this repository is currently out of date. The good news is that we're now working on Compliance Masonry with a deeper understanding of the difficulties of maintaining complex, frequently-changing, collaborative documentation in a Word doc.

We're working on a way to [diff the YAML sources with the content of a Word .docx](https://github.com/opencontrol/fedramp-templater/issues/13) and [building a templating tool](https://github.com/opencontrol/fedramp-templater) that will generate a FedRAMP-style Word doc out of Compliance Masonry YAML. This work will help us bring all of the YAML in this repository up to date (and keep it up to date), and it will also help anyone else who collaborates on FedRAMP materials with people who prefer to make change in Word doc format (rather than YAML files).

## Starting ATO Documentation for cloud.gov applications

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
      - url: https://github.com/18F/cg-compliance
        revision: master
  ```

0. Create component documentation using the [opencontrol schema](https://github.com/opencontrol/schemas) and update the `components` object in the opencontrol.yaml with the documentation path.
0. "Import" the cloud.gov dependencies.


  ```bash
  compliance-masonry get
  ```

The get command will import all the data from the cg-compliance repository and drop them into the `opencontrol` directory to serve as a baseline for your SSP

For viewing the documentation in various formats (e.g. gitbook, docx), use the instructions in the [compliance-masonry](https://github.com/opencontrol/compliance-masonry) repository.

For information about working on this repository, see the [contributor documentation](CONTRIBUTING.md).
