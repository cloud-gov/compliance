
If you're a cloud.gov team member, set `aws-vault` per our guidance at https://cloud.gov/docs/ops/secrets/#aws-credentials. Then open a shell with those credentials loaded: `aws-vault exec cloud-gov-govcloud bash`

You'll also need Docker, as `bin/inspec` will run [Chef Inspec](https://www.inspec.io/docs/) using `docker-compose`


# Run the InSpec profile

Update `input.yml` with the values for the cloud.gov team. Then:

    bin/inspec exec ./inspec-aws-mfa/ -t aws:// --input-file input.yml
    
Take note of any failures and correct them

# Explore in the InSpec shell

Start:

    ./bin/inspec shell -t aws://

Handy things you can do in shell:

    hw=aws_iam_user('harriet.welsh')
    hw.list_attached_policies

    admins=aws_iam_group('Administrators')
    admins.users.sort
