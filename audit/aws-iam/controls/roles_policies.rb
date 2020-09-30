# preload AWS API calls
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

s3_iam_pattern='cg-s3-[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}'
# use next pattern for testing the snowflake
#s3_iam_pattern='cg-s3-16[0-9a-fA-F]{7}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}'

s3_policies = aws_iam_policies.where(policy_name: /#{s3_iam_pattern}/).entries
s3_policy_count = s3_policies.count

snowflake_iam_policy = "cg-s3-16709a09-0eca-4597-bbf5-b1df98e41cae" 
s3_policies.delete_if{ |p| p.policy_name == snowflake_iam_policy }

# There's a 'cg-s3-' user with no matching policy...
control 'S3 IAM policy and user congruence' do
    title 'Ensure number of s3 policies matches number of s3 users'

    describe aws_iam_users.where(user_name: /#{s3_iam_pattern}/) do
      its('count') { should cmp s3_policy_count }
    end
end

control "Ensure S3 Snowflake for Federalist staging docker registry is well-formed" do
    snowflake = aws_iam_policy(snowflake_iam_policy)
    describe snowflake do 
        it { should be_attached_to_user('cg-s3-b0cd0c6e-5e27-4813-9d31-a2b5a9579129') }
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
