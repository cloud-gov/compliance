# preload AWS API calls
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

#s3_iam_pattern='^cg-s3-1'
s3_iam_pattern='^cg-s3'

s3_policies = aws_iam_policies.where(policy_name: /#{s3_iam_pattern}/).entries

snowflake_iam_policy = "cg-s3-16709a09-0eca-4597-bbf5-b1df98e41cae" 
s3_policies.delete_if{ |p| p.policy_name == snowflake_iam_policy }

s3_policy_count = s3_policies.count
control 'X S3 IAM policies match S3 IAM users' do
    impact 1.0
    title 'Ensure s3 iams are only s3'

    describe aws_iam_users.where(user_name: /#{s3_iam_pattern}/) do
      its('count') { should cmp s3_policy_count }
    end
end

control "Ensure Snowflake policy is well-formed" do
    snowflake = aws_iam_policy(snowflake_iam_policy)
    describe snowflake do 
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
        its('statement_count') { should cmp 3 }
    end
end

s3_policies.each do | p|
    policy = aws_iam_policy(p.policy_name)
    control "Ensure S3 policy #{policy} is well-formed" do
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
