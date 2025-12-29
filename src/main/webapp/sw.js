// TecnoDeposit Service Worker
const CACHE_NAME = 'tecnodeposit-v1';
const STATIC_ASSETS = [
    '/TecnoDeposit/css/Login.css',
    '/TecnoDeposit/css/dashboard.css',
    '/TecnoDeposit/img/Icon.png',
    '/TecnoDeposit/scripts/login.js',
    '/TecnoDeposit/scripts/dashboard.js'
];

// Install: cache static assets
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(STATIC_ASSETS))
            .then(() => self.skipWaiting())
    );
});

// Activate: clean old caches
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(keys =>
            Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
        ).then(() => self.clients.claim())
    );
});

// Fetch: network-first for HTML, cache-first for assets
self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);

    // Skip non-GET and external requests
    if (event.request.method !== 'GET' || !url.origin.includes(self.location.origin)) {
        return;
    }

    // Cache-first for static assets
    if (url.pathname.match(/\.(css|js|png|jpg|jpeg|gif|webp|woff2?)$/)) {
        event.respondWith(
            caches.match(event.request).then(cached => {
                return cached || fetch(event.request).then(response => {
                    const clone = response.clone();
                    caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
                    return response;
                });
            })
        );
        return;
    }

    // Network-first for HTML/API
    event.respondWith(
        fetch(event.request)
            .catch(() => caches.match(event.request))
    );
});
