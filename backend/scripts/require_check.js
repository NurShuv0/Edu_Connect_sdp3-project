const path = require('path');
const paths = [
  'server.js',
  'routes/authRoutes.js',
  'routes/profileRoutes.js',
  'routes/tuitionRoutes.js',
  'routes/matchRoutes.js',
  'routes/demoRoutes.js',
  'routes/chatRoutes.js',
  'routes/notificationRoutes.js',
  'routes/searchRoutes.js',
  'routes/adminRoutes.js',
  'routes/announcementRoutes.js',
  'controllers/authController.js',
  'controllers/adminController.js',
  'controllers/tuitionController.js',
  'controllers/matchController.js',
  'controllers/demoController.js',
  'controllers/chatController.js',
  'middleware/authMiddleware.js',
  'middleware/adminMiddleware.js',
  'middleware/parentControlMiddleware.js',
  'models/User.js',
  'models/TuitionPost.js',
  'models/Match.js'
];

let errors = 0;
paths.forEach(p => {
  const full = path.resolve(__dirname, '..', p);
  try {
    require(full);
    console.log('OK:', p);
  } catch (e) {
    console.error('ERROR requiring', p);
    console.error(e && e.stack ? e.stack : e);
    errors++;
  }
});

if (errors) {
  console.error(`Completed with ${errors} error(s).`);
  process.exit(1);
} else {
  console.log('All modules loaded successfully.');
}
