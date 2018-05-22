console.log("< Server >");
const fs = require("fs-extra");
const {serve, html} = require("servecube");
const cookieParser = require("cookie-parser");
const request = require("request-promise-native");
const mime = require("mime");
const {MongoClient} = require("mongodb");
const session = require("express-session");
const MongoStore = require("connect-mongo")(session);
const {OAuth2Client} = require("google-auth-library");
const youKnow = require("./data/youknow.js");
const production = process.argv[2] === "production";
const emailTest = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
(async () => {
	const googleAuthClient = new OAuth2Client(youKnow.google.id);
	const db = (await MongoClient.connect(youKnow.db.url, {
		compression: "snappy"
	})).db("web");
	const users = db.collection("users");
	const cube = await serve({
		eval: v => eval(v),
		domain: production ? "miroware.io" : "localhost:8081",
		errorDir: "error",
		httpPort: 8081,
		httpsRedirect: production,
		subdomains: {
			d: "www/",
			api: "api/"
		},
		githubSubdomain: "api",
		githubPayloadURL: "/githubwebhook",
		githubSecret: youKnow.github.secret,
		githubToken: youKnow.github.token,
		middleware: [cookieParser(), session({
			secret: youKnow.session.secret,
			resave: false,
			saveUninitialized: false,
			name: "sess",
			cookie: {
				secure: true,
				maxAge: 2592000000
			},
			store: new MongoStore({
				db,
				collection: "sessions",
				stringify: false
			})
		}), (req, res) => {
			if(req.dir === "api") {
				res.set("Content-Type", "application/json");
				try {
					req.body = JSON.parse(req.body);
				} catch(err) {
					res.status(400).send({
						message: err.message
					});
					return;
				}
			}
			req.next();
		}]
	});
	const {load} = cube;
	evalInput = input => {
		console.log(eval(String(input)));
	};
})();
let evalInput = input => {
	console.log(eval(String(input)));
};
process.openStdin().on("data", input => {
	evalInput(input);
});
