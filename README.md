# cloud.gov Compliance

Data Validation Tests: [![Build Status](https://travis-ci.org/18F/cg-compliance.svg?branch=master)](https://travis-ci.org/18F/cg-compliance)  

This repository contains the data for [cloud.gov](https://cloud.gov)'s compliance with [NIST](http://www.nist.gov/) controls. The documentation is generated from the data in this repository via [Compliance Masonry](https://github.com/opencontrol/compliance-masonry), then published to [compliance.cloud.gov](https://compliance.cloud.gov/).

# Creating Gitbook
### Install Compliance Masonry CLI
```bash
pip install git+https://github.com/opencontrol/compliance-masonry.git
```
### Create certifications
```bash
masonry certs <Certification ex. LATO>
```
### Create Gitbook Documentation
```bash
masonry docs gitbook <Certification ex. LATO>
```
### Serve the Gitbook locally
```bash
cd exports/gitbook
npm install gitbook-cli -g
gitbook serve
```
### Create PDF
Req: Install ebook-convert from Calibre
```
# inside exports/gitbook
npm install gitbook-pdf -g
gitbook pdf .
```

# Create Inventory of components and controls
### Create certifications
```bash
masonry certs <Certification ex. LATO>
masonry inventory <Certification ex. LATO>
```

# Running BDD test
Instruction for running BDD tests are located in the [`tests`](https://github.com/18F/cg-compliance/tree/master/tests) directory
