const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

const products = [
  { id: 1, name: "Notebook", price: 1200 },
  { id: 2, name: "Smartphone", price: 800 },
  { id: 3, name: "Tablet", price: 500 },
];

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.get("/products", (req, res) => {
  res.json(products);
});

app.listen(port, () => {
  console.log(`API listening at http://localhost:${port}`);
});
