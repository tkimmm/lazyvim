# Strandbags OAuth App Setup Guide - Microsoft Entra ID

## Quick Reference
| Environment | App Name | Redirect URI |
|-------------|----------|--------------|
| Production | `strandbags-mcp-prod` | `https://strandbags-mcp.com/oauth/callback` |
| UAT | `strandbags-mcp-uat` | `https://strandbags-mcp-uat.com/oauth/callback` |

---

## Prerequisites
- **Global Administrator** or **Application Administrator** role in Entra ID
- Access to [Azure Portal](https://portal.azure.com)

---

## Setup Steps

### 1. Create App Registration
1. Go to [Azure Portal](https://portal.azure.com) → **Microsoft Entra ID** → **App registrations**
2. Click **+ New registration**
3. Configure:
   - **Name**: Use app name from table above
   - **Account types**: "Accounts in this organizational directory only (Single tenant)"
   - **Redirect URI**: Select "Web" and enter URI from table above
4. Click **Register**

### 2. Record Important Values
After registration, copy these values (needed for MCP server configuration):
```
Application (client) ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Directory (tenant) ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### 3. Configure API Permissions
1. In your app registration, go to **API permissions**
2. Click **+ Add a permission** → **Microsoft Graph** → **Delegated permissions**
3. Add these permissions:

| Permission | Purpose |
|------------|---------|
| `User.Read` | Read user profile |
| `Mail.Read` | Read user mail |
| `Mail.Send` | Send mail as user |
| `Calendars.ReadWrite` | Manage user calendar |
| `Files.ReadWrite.All` | Access user files |
| `Sites.ReadWrite.All` | Access SharePoint sites |

4. Click **Grant admin consent for [Your Organization]**
5. Verify all permissions show "Granted" status

### 4. Create Client Secret
1. Go to **Certificates & secrets** → **Client secrets**
2. Click **+ New client secret**
3. Configure:
   - **Description**: `strandbags-mcp-[env]-secret-2026` (replace [env] with prod/uat)
   - **Expires**: 12 months
4. Click **Add**
5. **IMMEDIATELY COPY** the secret value (only shown once)

⚠️ **CRITICAL**: Store the client secret securely - [PLACEHOLDER FOR SECRET HANDLING INSTRUCTIONS]

### 5. Verify Authentication Settings
1. Go to **Authentication**
2. Confirm redirect URI is correct
3. Ensure these are **UNCHECKED**:
   - Access tokens (used for implicit flows)
   - ID tokens (used for implicit and hybrid flows)

---

## Configuration Summary
After setup, provide these values to the development team:

```bash
# Environment Configuration
ENTRA_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ENTRA_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ENTRA_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ENTRA_REDIRECT_URI=[redirect-uri-from-table]
OAUTH_SCOPES=offline_access User.Read Mail.Read Mail.Send Calendars.ReadWrite Files.ReadWrite.All Sites.ReadWrite.All
```

---

## Testing the Setup

### Quick Test Script
Use this Node.js script to verify the OAuth configuration:

```javascript
// test-oauth.js
const msal = require('@azure/msal-node');

const config = {
    auth: {
        clientId: process.env.ENTRA_CLIENT_ID,
        authority: `https://login.microsoftonline.com/${process.env.ENTRA_TENANT_ID}`,
        clientSecret: process.env.ENTRA_CLIENT_SECRET
    }
};

const cca = new msal.ConfidentialClientApplication(config);

async function testAuth() {
    const authCodeUrlParameters = {
        scopes: ["user.read"],
        redirectUri: process.env.ENTRA_REDIRECT_URI,
    };

    try {
        const authUrl = await cca.getAuthCodeUrl(authCodeUrlParameters);
        console.log("✅ Auth URL generated successfully:");
        console.log(authUrl);
    } catch (error) {
        console.error("❌ Error generating auth URL:", error);
    }
}

testAuth();
```

### Manual Test
1. Visit the generated auth URL
2. Sign in with your Entra ID account
3. Verify you're redirected to the callback URL with an authorization code

---

## Common Issues & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| "Redirect URI mismatch" | URI doesn't match registration | Verify redirect URI exactly matches (no trailing slash) |
| "User has not consented" | Missing admin consent | Click "Grant admin consent" in API permissions |
| "Invalid client secret" | Wrong/expired secret | Check secret value and expiration date |
| "Missing client_secret parameter" | Secret not included in request | Ensure client_secret is in token request |

### Diagnostic Tools
- **Graph Explorer**: [Test API calls](https://developer.microsoft.com/en-us/graph/graph-explorer)
- **JWT Decoder**: [Inspect tokens](https://jwt.ms)
- **Sign-in Logs**: Entra ID → Monitoring → Sign-in logs

---

## Security Reminders
- ✅ Use HTTPS redirect URIs in production
- ✅ Rotate client secrets every 12 months
- ✅ Monitor sign-in logs regularly
- ❌ Never commit secrets to version control
- ❌ Never share secrets in plain text

---

## Support
- **Microsoft Documentation**: [OAuth 2.0 Authorization Code Flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- **Internal Support**: Contact DevOps team for MCP server configuration assistance

---

*Document Version: 1.1 | Last Updated: January 13, 2026*

