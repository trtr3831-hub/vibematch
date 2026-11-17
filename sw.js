// VibeMatch service worker: uygulama kabuğunu önbelleğe alır, çevrimdışı açılmasını sağlar.
const CACHE = "vibematch-v1";
const KABUK = [
  "./",
  "./manifest.webmanifest",
  "./icon-192.png",
  "./icon-512.png"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE).then(c => c.addAll(KABUK)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(anahtarlar => Promise.all(anahtarlar.filter(a => a !== CACHE).map(a => caches.delete(a))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  if (event.request.method !== "GET") return;
  event.respondWith(
    caches.match(event.request).then(onbellek => {
      const agdan = fetch(event.request)
        .then(yanit => {
          if (yanit && (yanit.ok || yanit.type === "opaque")) {
            const kopya = yanit.clone();
            caches.open(CACHE).then(c => c.put(event.request, kopya));
          }
          return yanit;
        })
        .catch(() => onbellek || caches.match("./vibematch.html"));
      return onbellek || agdan;
    })
  );
});
