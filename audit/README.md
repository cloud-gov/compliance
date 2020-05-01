
To run, first load your AWS credentials: `aws-vault exec cloud-gov-govcloud bash`


# Run the InSpec profile

    bin/inspec exec ./inspec-aws-mfa/ -t aws:// --input-file input.yml

# Explore in the InSpec shell

Start:

    ./bin/inspec shell -t aws://

Handy things you can do in shell:

    pb=aws_iam_user('peter.burkholder)
    pb.list_attached_policies

    admins=aws_iam_group('Administrators')
    admins.users.sort
