import express from 'express';
import fetch from 'node-fetch';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to add CORS headers
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

// Proxy endpoint
app.get('/cors/*', async (req, res) => {
  const targetUrl = req.originalUrl.replace('/cors/', '');
  console.log(`Proxying request to: ${targetUrl}`);
  
  try {
    const response = await fetch(targetUrl);
    
    // Forward headers from the target response
    for (const [key, value] of response.headers.entries()) {
        res.setHeader(key, value);
    }
    
    const data = await response.text();
    res.status(response.status).send(data);
  } catch (error) {
    console.error('Proxy error:', error);
    res.status(500).send({ error: 'Proxy request failed', details: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`✅ CORS Proxy server running on http://localhost:${PORT}`);
  console.log('Use this proxy by prefixing your target URL, e.g., http://localhost:3000/cors/https://maps.googleapis.com/...');
}); 