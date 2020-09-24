# preload AWS API calls
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

#s3_iam_pattern='^cg-s3-84'
s3_iam_pattern='^cg-s3'

s3_policies = aws_iam_policies.where(policy_name: /#{s3_iam_pattern}/)
s3_policy_count = s3_policies.count
control '1.0-s3-iams' do
    impact 1.0
    title 'Ensure s3 iams are only s3'

    describe aws_iam_users.where(user_name: /#{s3_iam_pattern}/) do
      its('count') { should cmp s3_policy_count }
    end

    s3_policies.entries.each do | p|
        policy = aws_iam_policy(p.policy_name)
        describe policy do
            it { should be_attached_to_user(p.policy_name) }
            it { should have_statement(
                    Resource: [
                        /^arn:aws-us-gov:s3:::(staging-)?cg-[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$/
                    ]
                )
            }
            it { should have_statement(
                    Resource: [
                        /^arn:aws-us-gov:s3:::(staging-)?cg-[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}\/\*$/
                    ]
                )
            }
            its('statement_count') { should cmp 2 }
        end
    end

end
