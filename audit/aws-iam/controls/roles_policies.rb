# preload AWS API calls
# aip = aws_iam_policies
# aip.where(policy_name: /cg-s3.*/).
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

s3_iam_pattern='^cg-s3-0'

aip = aws_iam_policies.where(policy_name: /#{s3_iam_pattern}/)
control '1.0-s3-iams' do
    impact 1.0
    title 'Ensure s3 iams are only s3'
    aip.entries.each do | policy|
        policy = aws_iam_policy(policy.policy_name)
        describe policy do
            it { should have_statement(
                    Resource: [
                        /^arn:aws-us-gov:s3:::cg-[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$/
                    ]
                )
            }
            it { should have_statement(
                    Resource: [
                        /^arn:aws-us-gov:s3:::cg-[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}\/\*$/
                    ]
                )
            }
            its('statement_count') { should cmp 2 }
        end
    end

    s3_policy_count = aip.count

    describe aws_iam_users.where(user_name: /#{s3_iam_pattern}/) do
      its('count') { should cmp s3_policy_count }
    end



end


s3_policy_count = aip.count

# count of s3 users should match o