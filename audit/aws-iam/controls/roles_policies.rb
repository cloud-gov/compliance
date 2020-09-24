# preload AWS API calls
# aip = aws_iam_policies
# aip.where(policy_name: /cg-s3.*/).
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

aip = aws_iam_policies.where(policy_name: /^cg-s3-0/)
control '1.0-s3-iams' do
    impact 1.0
    title 'Ensure s3 iams are only s3'
    aip.entries.each do | policy_name |
        policy_name = "cg-s3-000a0b6a-e9ca-46d5-9040-98710b153a67"
        policy = aws_iam_policy(policy_name)
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
end