const msalConfig = {
    auth: {
      clientId: '<ClientID>', // Azure Client ID
      authority: 'https://login.microsoftonline.com/<TenantID>', // Azure Tenant ID
      redirectUri: '<redirect to .index.html>',
      prompt: 'select_account'
    },
    cache: {
      cacheLocation: 'sessionStorage',
      storeAuthStateInCookie: false
    }
  };
  const msalInstance = new msal.PublicClientApplication(msalConfig);
  
  async function authenticate() {
    const loginRequest = {
      scopes: ['openid', 'profile', 'email']
    };
  
    try {
      const authResult = await msalInstance.loginPopup(loginRequest);
      // Set the access token in sessionStorage
      sessionStorage.setItem('token', authResult.accessToken);
      // Redirect to the protected page
      window.location.href = 'main.html';
    } catch (error) {
      console.log(error);
      alert('Failed to authenticate. Please try again.');
    }
  }
  