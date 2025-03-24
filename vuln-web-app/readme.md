# Vulnerable Web App 

This application intentionally contains several OWASP Top 10 vulnerabilities for you to discover and exploit. It's designed for educational purposes only and should be run in an isolated environment.

## Frontend vulnerabilities

- SQL Injection.
- Cross-Site Scripting (XSS).
- Cross-Site Request Forgery (CSRF).
- Insecure Direct Object References (IDOR).
- Sensitive Data Exposure.

## Backend vulnerabilities

- Path Traversal: Access files outside intended directory.
- Command Injection: In the ping endpoint.
- IDOR on transaction endpoints.
- Information Disclosure in the users endpoint.
- No input validation or sanitization.

## Testing Tools to Use:

- Browser Developer Tools.
- [Burp Suite](https://portswigger.net/burp) (free plan is fine).
- [OWASP ZAP](https://www.zaproxy.org/).
- [Postman for API testing](https://www.postman.com/).

## Security Best Practice Learning:

After finding vulnerabilities, you can implement fixes like:

- Input validation and sanitization.
- Parameterized queries.
- CSRF tokens.
- Proper authentication checks.
- Secure password storage (hashing).

Happy hacking!
