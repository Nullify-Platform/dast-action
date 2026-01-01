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
| nullify-version   | Version of the Nullify CLI to use                                                                | `false`  | 0.11.6                   |
| header            | Header to include in all requests to your app for authorization                                  | `false`  |                          |
| local             | Run the scan from the GitHub action instead of on Nullify Cloud                                  | `false`  | false                    |
| image-label       | Label to identify the Docker image being tested                                                  | `false`  |                          |

### Authentication Parameters

| Name                | Description                                                                | Required | Default |
|---------------------|----------------------------------------------------------------------------|----------|---------|
| auth-method         | Authentication method to use (basic, bearer, session, oauth2, jwt, custom) | `false`  | bearer  |
| auth-username       | Username for Basic Auth authentication                                     | `false`  |         |
| auth-password       | Password for Basic Auth authentication                                     | `false`  |         |
| auth-token          | Token for Bearer Token, JWT, or OAuth2 authentication                      | `false`  |         |
| auth-client-id      | Client ID for OAuth2 authentication                                        | `false`  |         |
| auth-client-secret  | Client Secret for OAuth2 authentication                                    | `false`  |         |
| auth-token-url      | Token URL for OAuth2 authentication                                        | `false`  |         |
| auth-scope          | Scope for OAuth2 authentication                                            | `false`  |         |
| auth-login-url      | URL to perform login for session-based authentication                      | `false`  |         |
| auth-login-body     | JSON body to send for session-based authentication login                   | `false`  |         |
| auth-login-selector | CSS selector to extract session token/cookie from login response           | `false`  |         |
| auth-custom-headers | JSON string of custom headers for authentication                           | `false`  |         |
| auth-custom-params  | JSON string of custom query parameters for authentication                  | `false`  |         |

### Role-Based Authorization Testing Parameters

| Name                  | Description                                | Required | Default |
|-----------------------|--------------------------------------------|----------|---------|
| user-1-role           | Role name for user 1                       | `false`  |         |
| user-1-description    | Custom description for user 1              | `false`  |         |
| user-1-username       | Username for user 1 (basic auth)           | `false`  |         |
| user-1-password       | Password for user 1 (basic auth)           | `false`  |         |
| user-1-token          | Token for user 1 (bearer auth)             | `false`  |         |
| user-1-client-id      | Client ID for user 1 (OAuth2)              | `false`  |         |
| user-1-client-secret  | Client Secret for user 1 (OAuth2)          | `false`  |         |
| user-1-token-url      | Token URL for user 1 (OAuth2)              | `false`  |         |
| user-1-scope          | Scope for user 1 (OAuth2)                  | `false`  |         |
| user-1-login-url      | Login URL for user 1 (session auth)        | `false`  |         |
| user-1-login-body     | Login body for user 1 (session auth)       | `false`  |         |
| user-1-login-selector | Login selector for user 1 (session auth)   | `false`  |         |
| user-1-custom-headers | Custom headers for user 1 (custom auth)    | `false`  |         |
| user-1-custom-params  | Custom parameters for user 1 (custom auth) | `false`  |         |

*Note: Parameters for user-2, user-3, and user-4 follow the same pattern as user-1.*

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

## Authentication Examples

### Basic Auth Example

```yaml
name: nullify-dast-basic-auth
on:
  push:
    branches:
      - main
jobs:
  nullify-dast:
    name: Nullify DAST with Basic Auth
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          app-name: 'My REST API'
          spec-path: 'openapi.json'
          target-host: 'api.myapp1234.dev'
          auth-method: 'basic'
          auth-username: ${{ secrets.API_USERNAME }}
          auth-password: ${{ secrets.API_PASSWORD }}
          local: 'true'
```

### OAuth2 Example

```yaml
name: nullify-dast-oauth
on:
  schedule:
    - cron: '0 0 * * 1'  # Run weekly on Mondays
jobs:
  nullify-dast:
    name: Nullify DAST with OAuth2
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          app-name: 'My OAuth API'
          spec-path: 'openapi.json'
          target-host: 'api.myapp1234.dev'
          auth-method: 'oauth2'
          auth-client-id: ${{ secrets.OAUTH_CLIENT_ID }}
          auth-client-secret: ${{ secrets.OAUTH_CLIENT_SECRET }}
          auth-token-url: 'https://auth.myapp1234.dev/oauth/token'
          auth-scope: 'read write'
          local: 'true'
```

### Session-based Authentication Example

```yaml
name: nullify-dast-session
on:
  pull_request:
jobs:
  nullify-dast:
    name: Nullify DAST with Session Auth
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          app-name: 'My Web App'
          spec-path: 'openapi.json'
          target-host: 'app.myapp1234.dev'
          auth-method: 'session'
          auth-login-url: 'https://app.myapp1234.dev/login'
          auth-login-body: '{"username":"${{ secrets.APP_USERNAME }}","password":"${{ secrets.APP_PASSWORD }}"}'
          auth-login-selector: 'response.headers.set-cookie'
          local: 'true'
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

### Authorization Model Assessment

For authorization testing, you can provide multiple users with different roles to verify access controls:
**Important**: When using `auth-users`, any other single-user authentication parameters (like `auth-token`, `auth-username`, etc.) will be ignored.

### Role-Based Authorization with Individual User Parameters

```yaml
name: nullify-dast-rbac
on:
  schedule:
    - cron: '0 0 * * 1'  # Run weekly on Mondays
jobs:
  nullify-dast:
    name: Nullify DAST with Role-Based Access Control Testing
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Nullify vulnerability scanner
        uses: nullify-platform/dast-action@main
        with:
          app-name: 'My Role-Based API'
          spec-path: 'openapi.json'
          target-host: 'api.myapp1234.dev'
          # Admin user with bearer token
          user-1-role: 'admin'
          user-1-description: 'Administrator with full system access. User belongs to the internal platform team to occasionaly perform system maintanence activities.'
          user-1-token: ${{ secrets.ADMIN_TOKEN }}
          # Regular user with basic auth
          user-2-role: 'user'
          user-2-description: 'Standard user with limited permissions.'
          user-2-username: ${{ secrets.USER_USERNAME }}
          user-2-password: ${{ secrets.USER_PASSWORD }}
          # API client with OAuth2
          user-3-role: 'api-client'
          user-3-client-id: ${{ secrets.CLIENT_ID }}
          user-3-client-secret: ${{ secrets.CLIENT_SECRET }}
          user-3-token-url: 'https://auth.myapp1234.dev/oauth/token'
          user-3-scope: 'read write'
          local: 'true'
```
