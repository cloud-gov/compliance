@Component/Policy_Update_Test/18F/AC-Policy
@Component/Policy_Update_Test/18F/AT-Policy
@Component/Policy_Update_Test/18F/AU-Policy
@Component/Policy_Update_Test/18F/CA-Policy
@Component/Policy_Update_Test/18F/CM-Policy
@Component/Policy_Update_Test/18F/CP-Policy
@Component/Policy_Update_Test/18F/IA-Policy
@Component/Policy_Update_Test/18F/IR-Policy
@Component/Policy_Update_Test/18F/MA-Policy
@Component/Policy_Update_Test/18F/MP-Policy
@Component/Policy_Update_Test/18F/PE-Policy
@Component/Policy_Update_Test/18F/PL-Policy
@Component/Policy_Update_Test/18F/PS-Policy
@Component/Policy_Update_Test/18F/RA-Policy
@Component/Policy_Update_Test/18F/SA-Policy
@Component/Policy_Update_Test/18F/SC-Policy
@Component/Policy_Update_Test/18F/SI-Policy
Feature: 18F Policies

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
