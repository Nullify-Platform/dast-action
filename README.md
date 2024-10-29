<a href="https://nullify.ai">
  <img src="https://uploads-ssl.webflow.com/6492db86d53f84f396b6623d/64dad6c12b98dee05eb08088_nullify%20logo.png" alt="Nullify" width="300"/>
</a>

# Nullify DAST Action

<p align="center">
  <a href="https://join.slack.com/t/nullifycommunity/shared_invite/zt-1ve4xgket-PfkFjSDJK_kG8l~OA_GXUg">
      <img src="https://img.shields.io/badge/Slack-10%2B%20members-black" alt="Slack invite" />
  </a>
  <a href="https://docs.nullify.ai/features/api-scanning/cli/">
      <img src="https://img.shields.io/badge/docs-docs.nullify.ai-purple" alt="Documentation" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
      <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
  </a>
  <a href="https://securityscorecards.dev/viewer/?uri=github.com/Nullify-Platform/dast-action">
      <img src="https://api.securityscorecards.dev/projects/github.com/Nullify-Platform/dast-action/badge" alt="OpenSSF Scorecard" />
  </a>
</p>

The [Nullify DAST](https://docs.nullify.ai/features/api-scanning) GitHub Action enables you to integrate continuous API fuzzing and DAST into your CI pipeline. This action installs and orchestrates the [Nullify CLI](https://github.com/Nullify-Platform/cli).

## Getting Started
 * Add this Nullify Action to your GitHub repository
 * There is no need to configure a token - Nullify automatically authenticates with your GitHub organization
 * See our [quickstart guide](https://docs.nullify.ai/features/apis) for more info

## Inputs

| Name              | Description                                                                                      | Required | Default                  |
|-------------------|--------------------------------------------------------------------------------------------------|----------|--------------------------|
| app-name          | Name of the application to be tested                                                             | `true`   |                          |
| spec-path         | Absolute directory of the API specification to be tested                                         | `true`   |                          |
| target-host       | Target host endpoint of the application to be tested                                             | `true`   |                          |
| base-args         | Arguments to be passed to the scan as a multi-line option                                        | `false`  | -v                       |
| github-repository | The owner and repository name t0 create the issue dashboard on. For example, octocat/Hello-World | `false`  | ${{ github.repository }} |
| github-token      | The GitHub API token to authenticate with Nullify                                                | `false`  | ${{ github.token }}      |
| nullify-host      | Nullify API host                                                                                 | `false`  | api.nullify.ai           |
| nullify-version   | Version of the Nullify CLI to use                                                                | `false`  | 0.10.12                  |
| header            | Header to include in all requests to your app for authorization                                  | `false`  |                          |
| local             | Run the scan from the GitHub action instead of on Nullify Cloud                                  | `false`  | false                    |
| image-label       | Label to identify the Docker image being tested                                                  | `false`  |                          |

Often the `target-host` is a staging environment in a private network.
In this case, deploy a GitHub Action runner in the same private network then set `local: 'true'` to run the scan from the GitHub action.

## Example Usage

```yaml
name: nullify-dast
on:
  push:
    branches:
      - main
  pull_request:
jobs:
  nullify-dast:
    name: Nullify DAST
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          app-name: 'My REST API'
          header: 'Authorization: Bearer 1234'
          spec-path: 'openapi.json'
          target-host: 'api.myapp1234.dev'
```

## Example Usage (Enterprise Tier)

Enterprise tier customers have a custom domain name for the Nullify API.
This must be set using the `nullify-host` input.

```yaml
name: nullify-dast
on:
  push:
    branches:
      - main
  pull_request:
jobs:
  nullify-dast:
    name: Nullify DAST
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          nullify-host: api.mycompany.nullify.ai
          app-name: 'My REST API'
          header: 'Authorization: Bearer 1234'
          spec-path: 'openapi.json'
          target-host: 'api.myapp1234.dev'
```
