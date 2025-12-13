---
title: WhoAmI Resource
---
In authenticated APIs, clients often need to determine information about the current authenticated user or session context, such as user identity, permissions, roles, or current authentication state.

> # How can clients discover information about their current authenticated context?
> Create a WhoAmI Resource that provides information about the currently authenticated user or session.

The WhoAmI Resource typically includes user identity, permissions, roles, and other contextual information relevant to the current session.

In situations where a client cannot introspect its own credentials, as in the case of [HttpOnly cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies#block_access_to_your_cookies), this resource can be used to verify whether the credentials are present and, if not, direct the user to a login/registration page.

# Sequence Diagram

![Sequence Diagram for the WhoAmI resource pattern](whoami_resource.svg)

# Example client code

```jsx
const UserProfile = () => {
  const [userInfo, setUserInfo] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    fetch('/api/whoami')
    .then(response => response.json())
    .then(data => {
      setUserInfo(data);
    })
    .catch(error => {
      console.error('Failed to fetch user info:', error);
    })
    .finally(() => setLoading(false);
  }, []);

  if (loading) return <div>Loading...</div>;
  if (!userInfo) return <div>Not authenticated</div>;

  return (
    <div className="user-profile">
      <h2>Welcome, {userInfo.name}</h2>
      <p>Email: {userInfo.email}</p>
    </div>
  );
};
```

# Properties

## Strengths

### Authentication provider agnostic

The API provides 

### Security

For browser based apps, enables use of [HttpOnly Cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies#block_access_to_your_cookies),  which reduces the risk of [Cross-Site Scripting (XSS)](https://owasp.org/www-community/attacks/xss/) vulnerabilities.

## Weaknesses

### Additional request

Requires an extra API call to get information that could be extracted from a [JWT token](https://www.jwt.io/introduction#what-is-json-web-token)

# Related Patterns

## [Root Resource][root-resource-pattern]

The WhoAmI resource is often linked from the root resource as a way for clients to discover their authentication context from the API entry point.

[root-resource-pattern]: root_resource
