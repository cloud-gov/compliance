# cloud.gov Compliance

Data Validation Tests: [![Build Status](https://travis-ci.org/18F/cg-compliance.svg?branch=master)](https://travis-ci.org/18F/cg-compliance)  

This repository contains the data for [cloud.gov](https://cloud.gov)'s compliance with [NIST](http://www.nist.gov/) controls. The documentation is generated from the data in this repository via [Compliance Masonry](https://github.com/opencontrol/compliance-masonry), then published to [compliance.cloud.gov](https://compliance.cloud.gov/).

# Creating Gitbook
### 1. Install Compliance Masonry CLI
```bash
pip install git+https://github.com/opencontrol/compliance-masonry.git
```
### 2. Download Compliance Documentation and Navigate to Repository
```bash
git clone https://github.com/18F/cg-compliance
cd cg-compliance
```
### 3. Create certifications
```bash
masonry certs LATO # `LATO` or `FedRAMP-low` .. etc.
```
### 4. Create Gitbook Documentation
```bash
masonry docs gitbook LATO # `LATO` or `FedRAMP-low` .. etc.
```
### 5. Serve the Gitbook locally
```bash
npm install gitbook-cli -g # Install Gitbook CLI
cd exports/gitbook # Navigate to exports dir
gitbook serve
```

### Create PDF
Req: Install ebook-convert from Calibre
[May need to install ebook-convert from Calibre installed](https://github.com/GitbookIO/gitbook/issues/333)
```bash
npm install gitbook-pdf -g # Install git gitbook pdf extension
cd exports/gitbook # Navigate to exports dir
gitbook pdf .
```

# Create Inventory of components and controls
### Create certifications
```bash
masonry certs LATO # `LATO` or `FedRAMP-low` .. etc.
masonry inventory LATO # `LATO` or `FedRAMP-low` .. etc.
```

# Running BDD test
Instruction for running BDD tests are located in the [`tests`](https://github.com/18F/cg-compliance/tree/master/tests) directory
