const request = require("supertest");

const BASE_URL = process.env.TEST_BASE_URL || "http://localhost:5000";
const api = request(BASE_URL);

(async () => {
  try {
    const res = await api.get("/");
    console.log("Status:", res.statusCode);
    console.log("Body:", res.body);
    console.log("Headers:", res.headers);
  } catch (err) {
    console.error("Error:", err.message);
    console.error("Stack:", err.stack);
    if (err.response) {
      console.error("Response Status:", err.response.statusCode);
      console.error("Response Body:", err.response.body);
    }
  }
  process.exit(0);
})();
