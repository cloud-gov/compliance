# README

If you're a cloud.gov team member, set up `aws-vault` per our guidance at https://cloud.gov/docs/ops/secrets/#aws-credentials. 

You'll also need Docker, as `bin/inspec` will run [Chef Inspec](https://www.inspec.io/docs/) using `docker-compose`

# Set up

```
docker pull chef/inspec
```

# Run the InSpec profile

## AWS

The AWS tests need to run with an IAM user, and for operators we use `aws-vault` to create short-lived access keys. I (Peter) use the vault profiles `cg-govcloud` and `cg-ew`, yours may differ.  


Run the profile for each of the AWS GovCloud and E-W Commercial accounts:

    aws-vault exec cg-govcloud -- bin/inspec exec ./aws-mfa/ -t aws:// --input-file inputs.yml --silence-deprecations=aws
    aws-vault exec cg-ew -- bin/inspec exec ./aws-mfa/ -t aws:// --input-file inputs.yml
    aws-vault exec cg-govcloud -- bin/inspec exec ./aws-iam/ -t aws:// --silence-deprecations=aws
    inspec exec ./SC

Take note of any failures and correct them

# Explore in the InSpec shell

Start:

    ./bin/inspec shell -t aws://

Handy things you can do in shell:

    hw=aws_iam_user('harriet.welsh')
    hw.list_attached_policies

    admins=aws_iam_group('Administrators')
    admins.users.sort
