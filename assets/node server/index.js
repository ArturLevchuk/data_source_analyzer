const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000; // Port number can be changed as per requirement
const PUBLIC_DIRECTORY = path.join(__dirname, 'public');

const server = http.createServer((req, res) => {
  // Basic security measure to prevent directory traversal attacks
  if (req.url.indexOf('..') > -1) {
    res.statusCode = 400;
    res.end('Bad Request');
    return;
  }

  const filePath = path.join(PUBLIC_DIRECTORY, req.url === '/' ? 'index.html' : req.url);

  fs.exists(filePath, exists => {
    if (!exists) {
      res.writeHead(404, {'Content-Type': 'text/plain'});
      res.end('404 Not Found');
      return;
    }

    fs.stat(filePath, (err, stats) => {
      if (err) {
        res.writeHead(500, {'Content-Type': 'text/plain'});
        res.end('Internal server error');
        return;
      }

      // Set CORS headers
      res.setHeader('Access-Control-Allow-Origin', '*'); // Allows all origins. Adjust as necessary for production.
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
      res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
      res.setHeader('Access-Control-Allow-Credentials', true);

      // Set Content-Length header
      res.setHeader('Content-Length', stats.size);

      // Optionally set the Content-Type based on the file
      res.writeHead(200, {'Content-Type': 'application/octet-stream'}); // Forces download

      // Stream the file to the client
      fs.createReadStream(filePath).pipe(res);
    });
  });
});

server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
