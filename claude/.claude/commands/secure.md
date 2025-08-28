---
allowed-tools: Glob, Read, Edit, MultiEdit, Grep, Bash, Write
description: Comprehensive security audit and vulnerability fixes for the codebase.
---

## Security Audit & Fix Command

Performs a thorough security analysis of the codebase and automatically fixes common vulnerabilities while providing recommendations for complex security issues.

### Process:

1. **Dependency Security Scan**:
   - Run `npm audit`, `pip-audit`, `cargo audit` etc. based on project type
   - Check for known vulnerabilities in dependencies
   - Update vulnerable packages to secure versions
   - Generate security report with CVSS scores

2. **Code Security Analysis**:
   - **Input Validation**: Detect missing sanitization and validation
   - **SQL Injection**: Find unsafe database queries and parameterize them
   - **XSS Prevention**: Identify and fix cross-site scripting vulnerabilities
   - **CSRF Protection**: Ensure proper token validation
   - **Authentication Flaws**: Check for weak auth implementations
   - **Authorization Issues**: Verify proper access controls

3. **Configuration Security**:
   - **Environment Variables**: Check for hardcoded secrets
   - **HTTPS Enforcement**: Ensure secure connections
   - **CORS Configuration**: Validate cross-origin policies
   - **Security Headers**: Add missing security headers
   - **File Permissions**: Check for overly permissive access

4. **Cryptography Review**:
   - **Weak Algorithms**: Replace deprecated crypto methods
   - **Key Management**: Secure storage and rotation practices
   - **Password Hashing**: Ensure strong hashing algorithms
   - **Token Security**: JWT and session token best practices

### Security Fixes Applied:

**JavaScript/TypeScript:**
- Replace `eval()` with safe alternatives
- Add input sanitization with libraries like DOMPurify
- Implement Content Security Policy headers
- Fix prototype pollution vulnerabilities
- Add rate limiting middleware

**Python:**
- Replace `pickle` with safer serialization
- Add SQL parameterization with SQLAlchemy/Django ORM
- Implement CSRF tokens in forms
- Fix path traversal vulnerabilities
- Add input validation with Pydantic/Marshmallow

**General:**
- Remove hardcoded secrets and API keys
- Add environment variable validation
- Implement proper error handling (no sensitive data leaks)
- Add security logging and monitoring
- Update security-related dependencies

### Security Report Generated:
```
security-report.md
├── Executive Summary
├── High Priority Vulnerabilities
├── Medium Priority Issues
├── Low Priority Recommendations
├── Fixed Issues Log
├── Dependency Audit Results
└── Security Best Practices Checklist
```

### Tools Integrated:
- **npm audit** / **yarn audit** (Node.js)
- **pip-audit** / **safety** (Python)
- **cargo audit** (Rust)
- **OWASP dependency-check** (Java)
- **Semgrep** (Static analysis)
- **CodeQL patterns** (Security scanning)

### Features:
- **Automated Fixes**: Apply safe, well-tested security patches
- **Risk Assessment**: Categorize vulnerabilities by severity
- **Compliance Checks**: OWASP Top 10, CWE standards
- **Before/After Comparison**: Show security improvements
- **Rollback Safety**: All changes are tracked and reversible

### Example Fixes:

**Before:**
```javascript
// Vulnerable to SQL injection
const query = `SELECT * FROM users WHERE id = ${userId}`;
// Hardcoded secret
const API_KEY = "sk-1234567890abcdef";
```

**After:**
```javascript
// Parameterized query
const query = 'SELECT * FROM users WHERE id = ?';
const result = await db.query(query, [userId]);
// Environment variable
const API_KEY = process.env.API_KEY;
if (!API_KEY) throw new Error('API_KEY not configured');
```

### Options:
- `--audit-only`: Generate security report without applying fixes
- `--severity`: Only fix issues above specified severity (low/medium/high)
- `--exclude`: Skip certain vulnerability types
- `--deps-only`: Only check dependencies, skip code analysis
- `--compliance`: Check against specific standards (OWASP, PCI-DSS, etc.)