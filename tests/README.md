## Cloud.gov Tests
BBD style tests for verifying Cloud.gov's compliance with FedRAMP controls

## Usage

#### Install Dependencies  
`pip install -r requirements.txt`

#### Setup environment variables
`export CF_DOMAIN=<<Local Cloud Foundry domain>>`
`export CF_USER=<<Local Cloud Foundry user>>`
`export CF_PASSWORD=<<Local Cloud Foundry user password>>`

#### Run tests
`behave`
