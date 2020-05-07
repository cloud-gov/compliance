# preload AWS API calls
all_users = aws_iam_users
smc_policy=aws_iam_policy('self-managed-credentials')

input('non-admins', value: [])
input('admins', value: [])

control '1.0-deny-all-if-no-mfa-policy' do
    impact 1.0
    title 'Ensure there is policy deny actions when MFA is not used'

    describe smc_policy do
        it { should exist }
    end

    deny_statement = smc_policy
                        .policy['Statement']
                        .detect{
                            |s| s["Sid"]["DenyAllExceptListedIfNoMFA"]
                        }

    describe deny_statement do
        its('length') { should be == 5 }
    end
end

control '1.1-count-console-users' do
    impact 1.0
    title 'Ensure all console users match number of audited users'
    console_users = all_users.where(has_console_password?: true)

    describe console_users.usernames.length do
        it { should be == 11 }
    end
end

control '1.2-mfa-for-console-users' do
    impact 1.0
    title 'Ensure multi-factor auth for all usrs'
    
    console_users_without_mfa = all_users
                                  .where(has_console_password?: true)
                                  .where(has_mfa_enabled?: false)

    describe console_users_without_mfa do
        it { should_not exist}
    end
end

control '1.3-non-admins-have-self-managed-credentials' do
    impact 1.0
    title 'Ensure non-admins have the policy that enforces MFA for all access'

    input('non-admins').each do |user| 
        describe aws_iam_user(user) do
            its('attached_policy_names') { should include('self-managed-credentials') }
        end
    end
end

control '1.4-mfa-enforcement-attached-to-admins' do
    impact 1.0
    title 'Ensure the MFA enforcement policy is attached to Administrators'

    describe smc_policy do
        it { should be_attached_to_group('Administrators') }
    end
end

control '1.5-admin-group-membership' do
    impact 1.0
    title 'Ensure our admins exactly match our known sorted list'
    our_admins=input('admins').sort

    describe aws_iam_group('Administrators').users.sort do
        it { should cmp our_admins }
    end
end
