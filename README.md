# cloud.gov Compliance
This repository contains shared compliance data for cloud.gov.

This is a public repository following [18F's Open Source Policy](https://github.com/18F/open-source-policy/blob/master/policy.md). See our [LICENSE.md](LICENSE.md) and [CONTRIBUTING.md](CONTRIBUTING.md) files.

See also: https://github.com/18F/compliance-docs

# A note on the status of this material
As we've moved cloud.gov through the FedRAMP compliance process, we've had to revise our SSP and related docs at a rate that exceeded our ability to capture every change in Compliance Masonry YAML. This leaves us in the same state as many compliance efforts: A single person holds the reins on a single canonical Word .docx version, and all changes are funneling through her. 
The bad news is that the material in this repository is out of date. The good news is that we're now working on Compliance Masonry with _that much more empathy_ for the pain people normally go through. We're now focused on the ability to [diff the YAML sources with the content of a Word .docx](https://github.com/opencontrol/fedramp-templater/issues/13). This feature will help us bring all of the YAML in this repository up-to-date, and will also help anyone who collaborates on FedRAMP materials with people who will only provide changes in Word.

# Starting ATO Documentation for cloud.gov applications
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
0. "Import" the cloud.gov dependencies.


  ```bash
  compliance-masonry get
  ```

The get command will import all the data from the cg-compliance repository and drop them into the `opencontrol` directory to serve as a baseline for your SSP

For viewing the documentation in various formats (e.g. gitbook, docx), use the instructions in the [compliance-masonry](https://github.com/opencontrol/compliance-masonry) repository.

# BDD Tests
This repository also contains [setup and run instructions for a set of BDD tests](https://github.com/18F/cg-compliance/tree/master/BDD) that help verify Cloud Foundry control implementations.
