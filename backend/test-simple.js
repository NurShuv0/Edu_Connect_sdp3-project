require("dotenv").config();
const request = require("supertest");

const BASE_URL = process.env.TEST_BASE_URL || "http://localhost:5000";
const api = request(BASE_URL);

(async () => {
  console.log("Testing BASE_URL:", BASE_URL);
  
  try {
    console.log("\n1. Testing Health endpoint...");
    const res = await api.get("/");
    console.log("Status:", res.statusCode);
    console.log("Body:", JSON.stringify(res.body, null, 2));
  } catch (err) {
    console.error("ERROR:", err.message);
    if (err.response) {
      console.error("Response Status:", err.response.statusCode);
      console.error("Response Body:", err.response.body);
    }
  }

  try {
    console.log("\n2. Testing Auth Register...");
    const res = await api.post("/api/auth/register").send({
      email: "test@example.com",
      password: "Test123!",
      role: "student"
    });
    console.log("Status:", res.statusCode);
    console.log("Body:", JSON.stringify(res.body, null, 2));
  } catch (err) {
    console.error("ERROR:", err.message);
    if (err.response) {
      console.error("Response Status:", err.response.statusCode);
      console.error("Response Body:", err.response.body);
    }
  }

  process.exit(0);
})();
