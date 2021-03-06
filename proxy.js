"use strict";
console.log("< Proxy >");
const fs = require("fs");
const http = require("http");
const https = require("https");
const tls = require("tls");
const httpProxy = require("http-proxy");
const ioContextOptions = {
	key: fs.readFileSync("/etc/letsencrypt/live/miroware.io/privkey.pem"),
	cert: fs.readFileSync("/etc/letsencrypt/live/miroware.io/cert.pem"),
	ca: fs.readFileSync("/etc/letsencrypt/live/miroware.io/chain.pem")
};
const ioContext = tls.createSecureContext(ioContextOptions);
const ggContext = tls.createSecureContext({
	key: fs.readFileSync("/etc/letsencrypt/live/miro.gg/privkey.pem"),
	cert: fs.readFileSync("/etc/letsencrypt/live/miro.gg/cert.pem"),
	ca: fs.readFileSync("/etc/letsencrypt/live/miro.gg/chain.pem")
});
const proxy = httpProxy.createProxyServer();
const pipeTest = /^piped?\./;
const listener = (req, res) => {
	let target = "http://localhost:8081";
	if (req.headers.host) {
		if (req.headers.host.endsWith(".gold")) {
			target = "http://localhost:8180";
		} else if (req.headers.host.endsWith(".gg")) {
			target = "http://localhost:8083";
		} else if (pipeTest.test(req.headers.host)) {
			target = "http://localhost:8082";
		}
	}
	proxy.web(req, res, {
		target
	});
};
http.createServer(listener).listen(8080);
https.createServer({
	SNICallback: (domain, callback) => {
		callback(null, domain.endsWith(".gg") ? ggContext : ioContext);
	},
	...ioContextOptions
}, listener).listen(8443);
fs.watch(__filename, () => {
	setTimeout(() => {
		process.exit();
	}, 1000);
});
require("replthis")(v => eval(v));
