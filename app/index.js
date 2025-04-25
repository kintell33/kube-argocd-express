const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

const API_VERSION = process.env.API_VERSION || "v1";
const basePath = `/` + API_VERSION;

const products = [
  { id: 1, name: "Notebook", price: 1200 },
  { id: 2, name: "Smartphone", price: 800 },
  { id: 3, name: "Tablet", price: 500 },
];

app.get(`${basePath}/health`, (req, res) => {
  res.json({ status: "ok" });
});

app.get(`${basePath}/products`, (req, res) => {
  res.json(products);
});

app.listen(port, () => {
  console.log(`API listening at http://localhost:${port}${basePath}/...`);
});
