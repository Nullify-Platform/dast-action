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
</p>

The [Nullify DAST](https://docs.nullify.ai/features/api-scanning) GitHub Action enables you to integrate continuous API fuzzing and DAST into your CI pipeline.

## Getting Started
 * Add this Nullify Action to your GitHub repository
 * See our [quickstart guide](https://docs.nullify.ai/features/api-testing) for more info

## Inputs

| Name               | Description                                               | Required | Default |
|--------------------|-----------------------------------------------------------|----------|---------|
| **`app-name`**     | Name of the application to be tested                      | `true`   |         |
| **`args`**         | Arguments to be passed to the scan as a multi-line option | `true`   |         |
| **`github-owner`** | Name of the GitHub owner (Username or Organization)       | `true`   |         |
| **`github-repo`**  | Name of the GitHub repository                             | `true`   |         |
| **`github-token`** | GitHub Action job token                                   | `true`   |         |
| **`spec-path`**    | Absolute directory of the API specification to be tested  | `true`   |         |
| **`target-host`**  | Target host endpoint of the application to be tested      | `true`   |         |
| **`header`**       | Header to include in authorization request                | `false`  |         |

## Example usage

**Required** Pass in the following arguments using the inputs.

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
        uses: nullify-platform/dast-action@0.0.1
        with:
          github-token: ${{ github.token }}
          app-name: 'My REST API'
          spec-path: '${{ github.workspace }}/openapi.json'
          target-host: 'api.myapp1234.ai'
          github-owner: my-github
          github-repo: my-repo
          header: 'Authorization: Bearer 1234'
```
