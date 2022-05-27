# Cloud Custodian tasks for cloud.gov 

This is a demonstration of using cloud custodian (https://cloudcustodian.io/docs/aws/gettingstarted.html)
for some auditing of cloud.gov S3 and Cloudfront resources.

The directory includes the MacOS GoLang exec `custodian-cask` for running custodian via a Docker image.

Examples:

* Analyze all the S3 buckets' cross-account ownership

    ```sh
    aws-vault exec cg-govcloud -- ./custodian-cask run -s ./out s3-cross-account.yml
    ```

  * This saves the results in `./out/s3-cross-account`
* List all the S3 buckets that have cross-account ownership (must do `run` first)

    ```sh
    aws-vault exec cg-govcloud -- ./custodian-cask report -s ./out s3-cross-account.yml -p 's3-cross-account'
    ```

* List all the S3 buckets that DO NOT have cross-account ownership (must do `run` first)

    ```sh
    aws-vault exec cg-govcloud -- ./custodian-cask report -s ./out s3-cross-account.yml -p 'not-s3-cross-account'
    ```

* List all CloudFront distributions that have logging enabled:

    ```sh
    aws-vault exec cg-ew -- ./custodian-cask run -s ./out cloudfront.yml
    aws-vault exec cg-ew -- ./custodian-cask report -s ./out cloudfront.yml
    ```

* All the unencrypted EBS volumes:
    ```sh
    aws-vault exec cg-govcloud -- ./custodian-cask run -s ./out ebs-encrypted.yml -p unencrypted-ebs
    aws-vault exec cg-govcloud -- ./custodian-cask report -s ./out ebs-encrypted.yml -p unencrypted-ebs
    ```