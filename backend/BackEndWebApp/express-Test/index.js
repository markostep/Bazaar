const express = require('express');
const path = require('path');
const exampleInformation = require('./clothingData.json');
const app = express();

// Serve the static files from the React app
app.use(express.static(path.join(__dirname, '/client/build')));

app.get('/session', (req,res) => {
  const session = exampleSession;
  res.json(session);
  console.log('Sent session');
});

// An api endpoint that returns a short list of items
app.get('/api/v1/info', (req,res) => {
  const information = exampleInformation;
  res.json(information);
  console.log('Sent session');
});

// Handles any requests that don't match the ones above
app.get('*', (req,res) =>{
  res.sendFile(path.join(__dirname+'/client/build/index.html'));
});

const port = process.env.PORT || 3000;
app.listen(port);

console.log('App is listening on port ' + port);
