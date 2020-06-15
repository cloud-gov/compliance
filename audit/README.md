# README

If you're a cloud.gov team member, set up `aws-vault` per our guidance at https://cloud.gov/docs/ops/secrets/#aws-credentials. 

You'll also need Docker, as `bin/inspec` will run [Chef Inspec](https://www.inspec.io/docs/) using `docker-compose`

# Run the InSpec profile

Update `inputs.yml` with the values for the cloud.gov team. Then run the profile for each of the AWS GovCloud and E-W Commercial accounts:

    aws-vault exec cloud-gov-govcloud -- bin/inspec exec ./aws-mfa/ -t aws:// --input-file inputs.yml
    aws-vault exec cloud-gov-ew -- bin/inspec exec ./aws-mfa/ -t aws:// --input-file inputs.yml


Take note of any failures and correct them

# Explore in the InSpec shell

Start:

    ./bin/inspec shell -t aws://

Handy things you can do in shell:

    hw=aws_iam_user('harriet.welsh')
    hw.list_attached_policies

    admins=aws_iam_group('Administrators')
    admins.users.sort
