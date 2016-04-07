@Verify-Policy_Update_Test-AC_Policy
@Verify-Policy_Update_Test-AT_Policy
@Verify-Policy_Update_Test-AU_Policy
@Verify-Policy_Update_Test-CA_Policy
@Verify-Policy_Update_Test-CM_Policy
@Verify-Policy_Update_Test-CP_Policy
@Verify-Policy_Update_Test-IA_Policy
@Verify-Policy_Update_Test-IR_Policy
@Verify-Policy_Update_Test-MA_Policy
@Verify-Policy_Update_Test-MP_Policy
@Verify-Policy_Update_Test-PE_Policy
@Verify-Policy_Update_Test-PL_Policy
@Verify-Policy_Update_Test-PS_Policy
@Verify-Policy_Update_Test-RA_Policy
@Verify-Policy_Update_Test-SA_Policy
@Verify-Policy_Update_Test-SC_Policy
@Verify-Policy_Update_Test-SI_Policy
Feature: 18F Policies Update

  Scenario Outline: Check that policies are reviewed and updated.
    Given the github link - <policy>
      Then the policy has been updated within the last 180 days

   Examples: 18F policies on github
    | policy                                                                  |
    | https://api.github.com/repos/18f/compliance-docs/contents/18f-Gov-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/AC-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/AT-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/AU-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/CA-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/CM-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/CP-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/IA-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/IR-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/PL-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/PS-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/RA-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/SA-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/SC-Policy.md  |
    | https://api.github.com/repos/18f/compliance-docs/contents/SI-Policy.md  |
