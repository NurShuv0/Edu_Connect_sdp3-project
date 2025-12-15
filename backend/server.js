const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const http = require("http");
const socketIo = require("socket.io");

// Swagger
let swaggerUi; let YAML;
try {
  swaggerUi = require('swagger-ui-express');
  YAML = require('yamljs');
} catch (e) {
  // swagger packages are optional in development here; instruct developer to install
  console.warn('swagger-ui-express or yamljs not installed — API docs will not be available until installed. Run: npm install swagger-ui-express yamljs');
}

dotenv.config();

const app = express();

// Create HTTP server for Socket.io
const server = http.createServer(app);

// Initialize Socket.io with CORS
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: true
  },
  transports: ["websocket", "polling"]
});

app.use(cors());
app.use(express.json());

// DEBUG: Log all incoming requests
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// HEALTH CHECK
app.get("/", (req, res) => {
  res.json({ message: "EduConnect API is running" });
});

// AUTH ROUTES
app.use("/api/auth", require("./routes/authRoutes"));

// PROFILE ROUTES
app.use("/api/profile", require("./routes/profileRoutes"));

// TUITION ROUTES (test expects /api/tuition/*, so mount at /api/tuition not /api/tuition-posts)
app.use("/api/tuition", require("./routes/tuitionRoutes"));

// Serve OpenAPI docs if packages available
if (swaggerUi && YAML) {
  const openapiDocument = YAML.load(__dirname + '/docs/openapi.yaml');

  // Protect the docs in production: allow in non-production, otherwise require a secret key.
  const swaggerAuth = (req, res, next) => {
    // allow when not in production
    if (process.env.NODE_ENV !== 'production') return next();

    // require SWAGGER_UI_KEY env var to be set for production access
    const key = process.env.SWAGGER_UI_KEY;
    if (!key) return res.status(403).send('API docs disabled in production');

    // allow via header `x-api-docs-key: <key>` or Authorization: Bearer <key>
    const header = req.get('x-api-docs-key') || '';
    const auth = req.get('authorization') || '';
    if (header === key) return next();
    if (auth === `Bearer ${key}`) return next();

    return res.status(403).send('Forbidden');
  };

  app.use('/api/docs', swaggerAuth, swaggerUi.serve, swaggerUi.setup(openapiDocument));
}


// MATCH ROUTES  ✅ FIXED
app.use("/api/matches", require("./routes/matchRoutes"));

// DEMO SESSIONS ROUTES  ✅ FIXED
app.use("/api/demo", require("./routes/demoRoutes"));

// CHAT ROUTES
app.use("/api/chat", require("./routes/chatRoutes"));

// NOTIFICATION ROUTES
app.use("/api/notifications", require("./routes/notificationRoutes"));

// SEARCH ROUTES
app.use("/api/search", require("./routes/searchRoutes"));

// ADMIN ROUTES
app.use("/api/admin", require("./routes/adminRoutes"));

// ANNOUNCEMENT ROUTES
app.use("/api/announcements", require("./routes/announcementRoutes"));

// 404 HANDLER
app.use((req, res) => {
  res.status(404).json({ message: "Not Found" });
});

const PORT = process.env.PORT || 5000;

// Start server only after DB connection
connectDB().then(() => {
  // Initialize Socket.io chat handlers
  const initChatSocket = require("./sockets/chatSocket");
  initChatSocket(io);

  // Listen on all interfaces so Flutter desktop app can connect
  server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Server listening on 0.0.0.0:${PORT}`);
    console.log(`Access from localhost: http://localhost:${PORT}`);
    console.log(`Access from 127.0.0.1: http://127.0.0.1:${PORT}`);
    console.log(`Socket.io ready for connections`);
  });
  
  server.on('error', (err) => {
    console.error('Server error:', err);
    process.exit(1);
  });
}).catch(err => {
  console.error("Failed to start server - DB connection failed:", err);
  process.exit(1);
});
