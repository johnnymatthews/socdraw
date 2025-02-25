// app.js - A simple Node.js Express server with intentional vulnerabilities
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

// Mock database
let users = [
    { id: '12345', username: 'admin', password: 'admin123', role: 'admin' },
    { id: '67890', username: 'user', password: 'password123', role: 'user' }
];

let transactions = [
    { id: '1', userId: '12345', amount: 500, description: 'Salary' },
    { id: '2', userId: '12345', amount: -200, description: 'Rent' },
    { id: '3', userId: '67890', amount: 100, description: 'Gift' }
];

// Vulnerable login endpoint (SQL Injection simulation)
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;
    
    // Simulating SQL query vulnerability
    // Imagine this being: SELECT * FROM users WHERE username = '${username}' AND password = '${password}'
    
    console.log(`Login attempt: username=${username}, password=${password}`);
    
    // Handle SQL injection simulation (e.g., admin' --) 
    if (username.includes("' --")) {
        const injectedUsername = username.split("' --")[0];
        const user = users.find(u => u.username === injectedUsername);
        if (user) {
            // Create session without checking password
            return res.json({ success: true, user: { id: user.id, username: user.username, role: user.role } });
        }
    }
    
    // Normal login check
    const user = users.find(u => u.username === username && u.password === password);
    if (user) {
        return res.json({ success: true, user: { id: user.id, username: user.username, role: user.role } });
    }
    
    res.json({ success: false, message: 'Invalid credentials' });
});

// Vulnerable user registration (no input validation)
app.post('/api/register', (req, res) => {
    const { username, password, email } = req.body;
    
    // No validation on input - vulnerability
    
    const newId = Math.floor(10000 + Math.random() * 90000).toString();
    const newUser = {
        id: newId,
        username,
        password, // Storing plain text password - vulnerability
        email,
        role: 'user'
    };
    
    users.push(newUser);
    res.json({ success: true, user: { id: newUser.id, username: newUser.username } });
});

// Vulnerable file reading (Path Traversal)
app.get('/api/files', (req, res) => {
    const filename = req.query.file;
    
    // Vulnerable to path traversal - no path validation
    // Example: /api/files?file=../../../etc/passwd
    try {
        const filePath = path.join(__dirname, 'files', filename);
        const content = fs.readFileSync(filePath, 'utf8');
        res.send(content);
    } catch (error) {
        res.status(404).json({ error: 'File not found' });
    }
});

// Vulnerable command execution
app.get('/api/ping', (req, res) => {
    const host = req.query.host;
    
    // Vulnerable to command injection
    // Example: /api/ping?host=google.com;cat /etc/passwd
    exec(`ping -c 1 ${host}`, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ error: stderr });
        }
        res.send(stdout);
    });
});

// Vulnerable direct object reference (IDOR)
app.get('/api/transactions/:id', (req, res) => {
    const transactionId = req.params.id;
    
    // No authorization check - vulnerability
    const transaction = transactions.find(t => t.id === transactionId);
    
    if (transaction) {
        res.json(transaction);
    } else {
        res.status(404).json({ error: 'Transaction not found' });
    }
});

// Vulnerable user data endpoint (Information disclosure)
app.get('/api/users', (req, res) => {
    // Missing authentication - vulnerability
    // Exposing sensitive data - vulnerability
    res.json(users);
});

// Update user (XSS vulnerability)
app.put('/api/users/:id', (req, res) => {
    const userId = req.params.id;
    const { bio, fullName } = req.body;
    
    const user = users.find(u => u.id === userId);
    if (!user) {
        return res.status(404).json({ error: 'User not found' });
    }
    
    // No input sanitization - XSS vulnerability
    user.bio = bio;
    user.fullName = fullName;
    
    res.json({ success: true, user });
});

// Missing CSRF protection on all endpoints

app.listen(port, () => {
    console.log(`Vulnerable server running at http://localhost:${port}`);
});
