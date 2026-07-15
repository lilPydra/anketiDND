export 'database_helper_basic.dart' // Fallback / Analysis stub
    if (dart.library.io) 'database_helper_mobile.dart' // Mobile target path
    if (dart.library.js_interop) 'database_helper_web.dart'; // Web target path