# preload AWS API calls
# aip = aws_iam_policies
# aip.where(policy_name: /cg-s3.*/).
# notcgs3=aip.where{ policy_name !~ /^cg-s3/ && arn !~ /::aws:policy/ }

class AwsIamPolicy
  def resource_count
    return false unless @policy_document
    document = JSON.parse(URI.decode_www_form_component(@policy_document.policy_version.document), { symbolize_names: true })
    statements = document[:Statement].is_a?(Hash) ? [document[:Statement]] : document[:Statement]
    statements.collect{ |s| s[:Resource] }.count
  end
end


aip = aws_iam_policies.where(policy_name: /^cg-s3/)
control '1.0-s3-iams' do
    impact 1.0
    title 'Ensure s3 iams are only s3'
    aip.entries.each do | policy_name |
        policy_name = "cg-s3-17d833e5-af5d-4913-abae-332376bb01be"
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
        end
        resource_count = policy.policy["Statement"].collect{ |s| s[:resource] }.count

        describe resource_count do
            it { should == 2}
        end
    end
end