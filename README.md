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

The Nullify DAST GitHub Action requests a [Nullify](https://nullify.ai) pentest assessment of an application from your CI pipeline. It installs the [Nullify CLI](https://github.com/Nullify-Platform/cli) and runs `nullify pentest`.

Nullify reviews every request before the pentest runs. The action returns once the request is recorded: the scan is awaiting review and no traffic has been sent to your application yet.

## Getting Started

* Configure the application in Nullify first: its web services, deployments (targets) and credentials. Confirm that the target to test is non-production; Nullify refuses a request for a target that is production or not confirmed.
* Set `nullify-host` to your Nullify instance.
* There is no need to configure a token: the action exchanges the workflow's GitHub token for a Nullify token.

## Inputs

| Name            | Description                                                                               | Required | Default             |
|-----------------|-------------------------------------------------------------------------------------------|----------|---------------------|
| nullify-host    | Your Nullify instance, e.g. `acme.nullify.ai`                                             | `true`   |                     |
| app-id          | ID of the application to assess, as shown in the Nullify dashboard                        | `false`  |                     |
| app-name        | Name of the application to assess, used when `app-id` is not set                          | `false`  |                     |
| target-host     | URL of the deployment to assess, needed when the application has more than one deployment | `false`  |                     |
| base-args       | Space-separated global CLI arguments, e.g. `-v` or `-d`                                   | `false`  | -v                  |
| github-token    | GitHub token which is exchanged for a Nullify token                                       | `false`  | ${{ github.token }} |
| nullify-version | Version of the Nullify CLI to use                                                         | `false`  | 0.29.0              |
| os-arch         | Nullify CLI platform, e.g. `linux_amd64`; detected from the runner when empty             | `false`  |                     |

Set `app-id` or `app-name`.

## Outputs

| Name    | Description                                                                   |
|---------|-------------------------------------------------------------------------------|
| scan_id | ID of the requested pentest scan                                              |
| status  | Status of the scan. It is `awaiting_manual` while Nullify reviews the request |

## Example Usage

```yaml
name: nullify-pentest
on:
  push:
    branches:
      - main
jobs:
  nullify-pentest:
    name: Nullify pentest
    runs-on: ubuntu-latest
    steps:
      - name: Request a Nullify pentest assessment
        id: pentest
        uses: nullify-platform/dast-action@main
        with:
          nullify-host: acme.nullify.ai
          app-name: 'Payments API'
          target-host: 'https://api.staging.example.dev'
      - name: Show the request
        run: echo "Scan ${{ steps.pentest.outputs.scan_id }} is ${{ steps.pentest.outputs.status }}"
```

The action runs on Linux and macOS runners and needs `curl`, `tar` and `jq`, which GitHub-hosted runners provide.

## Migrating from an earlier version

The action now calls `nullify pentest` from Nullify CLI 0.29.0, which requests an assessment of an application configured in Nullify.

* `nullify-host` is required.
* `spec-path` and `header`, every `auth-*` input and every `user-N-*` input are removed. Configure the API schema and credentials on the application in Nullify instead.
* `local` and `image-label` are removed. A target that is not reachable from the internet is assessed by Nullify with access to your network: contact Nullify to arrange it.
* `github-repository` is removed: the action uses the workflow's repository.
* `scan_id` and `status` are new outputs.
