console.log("< Server >");
var fs = require("fs");
var http = require("http");
var https = require("https");
var express = require("express");
var cookieParser = require("cookie-parser");
var bodyParser = require("body-parser");
var session = require("express-session");
var request = require("request");
var crypto = require("crypto");
var mime = require("mime");
var AWS = require("aws-sdk");
var DynamoDBStore = require("connect-dynamodb")({
	session
});
var youKnow = require("./data/youknow");
mime.define({
	"text/html": ["njs"]
});
var s3 = new AWS.S3({
	credentials: new AWS.Credentials({
		accessKeyId: youKnow.s3.accessKeyId,
		secretAccessKey: youKnow.s3.secretAccessKey
	}),
	sslEnabled: true
});
var app = express();
app.set("trust proxy", true);
app.use(cookieParser());
app.use(bodyParser.raw({
	limit: "100mb",
	type: "*/*"
}));
app.use(session({
	name: "session",
	secret: "temp",
	resave: false,
	saveUninitialized: false,
	cookie: {
		secure: true,
		expires: new Date(Date.now()+2592000000)
	},
	store: new DynamoDBStore({
		table: "sessions",
		AWSConfigJSON: youKnow.db
	})
}));
app.use(function(req, res) {
	res.set("X-Magic", "real");
	res.set("Access-Control-Expose-Headers", "X-Magic");
	res.set("Access-Control-Allow-Origin", "*");
	if(req.protocol == "http") {
		res.redirect(`https://${req.get("Host") + req.url}`);
	} else {
		var subdomain = req.subdomains.join(".");
		if(subdomain == "www") {
			res.redirect(`https://${req.get("Host").slice(4) + req.url}`);
		} else {
			try {
				decodeURIComponent(req.url);
				for(var i in req.body) {
					if(typeof req.body[i] == "string") {
						req.body[i] = req.body[i].replace(/\r/g, "");
					}
				}
				req.next();
			} catch(err) {
				res.status(400).json(400);
			}
		}
	}
});
app.post("*", function(req, res) {
	var subdomain = req.subdomains.join(".");
	if(subdomain == "") {
		if(req.path == "/github") {
			var signature = req.get("X-Hub-Signature");
			if(signature && signature == `sha1=${crypto.createHmac("sha1", youKnow.gh.secret).update(req.body).digest("hex")}`) {
				res.send();
				var payload = JSON.parse(req.body);
				console.log(1);
				if(payload.repository.name == "web") {
					var branch = payload.ref.slice(payload.ref.lastIndexOf("/")+1);
					console.log(branch);
					if(branch == "public") {
						var added = [];
						var removed = [];
						var modified = [];
						var commits = [payload.head_commit].concat(payload.commits);
						for(var i = 0; i < commits.length; i++) {
							for(var j = 0; j < commits[i].added.length; j++) {
								if(added.indexOf(commits[i].added[j]) == -1) {
									added.push(commits[i].added[j]);
									request.get(`https://raw.githubusercontent.com/${payload.repository.full_name}/${branch}/${commits[i].added[j]}`, function(err, res2, body) {
										if(body) {
											fs.writeFileSync(commits[i].added[j], body);
										}
									});
								}
							}
						}
						console.log(added);
					}
				}
			}
		}
	} else if(subdomain == "pipe") {
		s3.putObject({
			Body: req.body,
			Bucket: "miroware-pipe",
			Key: req.path.slice(1),
			ContentType: mime.lookup(req.path),
			ServerSideEncryption: "AES256"
		}, function(err) {
			res.set("Content-Type", "text/plain");
			if(err) {
				res.status(err.statusCode).send(`Error ${err.statusCode}: ${err.message}`);
			} else {
				res.send(key);
			}
		});
	}
});
var html = function() {
	var string = arguments[0][0];
	var substitutions = [].slice.call(arguments, 1);
	for(var i = 0; i < substitutions.length; i++) {
		string += substitutions[i].toString().replace(/"/g, "&quot;").replace(/'/g, "&#39;").replace(/</g, "&lt;").replace(/>/g, "&gt;") + arguments[0][i+1];
	}
	return string;
};
var evalVal = function(thisCode) {
	return eval(thisCode);
};
var getActualPath = function(path) {
	if(path.indexOf("/") != 0) {
		path = `/${path}`;
	}
	path = `www${path.replace(/\/+/g, "/")}`;
	if(path.lastIndexOf("/") > path.lastIndexOf(".") && !(fs.existsSync(path) && !fs.statSync(path).isDirectory())) {
		if(path.lastIndexOf("/") != path.length-1) {
			path += "/";
		}
		path += "index.njs";
	}
	path = path.replace(/\/\.{1,2}(?=\/)/g, "");
	return path;
};
var loadCache = {};
var load = function(path, context) {
	if(context) {
		context = Object.assign({}, context);
		delete context.cache;
		delete context.value;
		delete context.exit;
	} else {
		context = {};
	}
	var properties = [];
	for(var i in context) {
		properties.push(i);
	}
	context.value = "";
	return new Promise(function(resolve, reject) {
		if(loadCache[path]) {
			resolve(Object.assign(context, loadCache[path]));
		} else {
			context.exit = function() {
				if(context.cache == 1) {
					loadCache[path] = {};
					for(var i in context) {
						if(i != "exit" && properties.indexOf(i) == -1) {
							loadCache[path][i] = context[i];
						}
					}
				}
				resolve(context);
			};
			var val = "";
			try {
				evalVal.call(context, `(async function() {\n${fs.readFileSync(getActualPath(path))}\n}).call(this);`);
			} catch(err) {
				reject(err);
			}
		}
	});
};
setInterval(function() {
	loadCache = {};
}, 86400000);
app.get("*", async function(req, res) {
	var decodedPath = decodeURIComponent(req.path);
	var subdomain = req.subdomains.join(".");
	if(subdomain == "" || subdomain == "d") {
		var path = getActualPath(decodedPath);
		var type = (path.lastIndexOf("/") > path.lastIndexOf(".")) ? "text/plain" : mime.lookup(path);
		var publicPath = path.slice(3);
		if(path.slice(-10) == "/index.njs") {
			publicPath = publicPath.slice(0, -9);
		}
		if(decodedPath != publicPath) {
			res.redirect(publicPath);
		} else if(fs.existsSync(path)) {
			res.set("Content-Type", type);
			if(path.slice(-4) == ".njs") {
				res.set("Content-Type", "text/html");
				res.send((await load(decodedPath, {
					req,
					res
				})).value);
			} else {
				fs.createReadStream(path).pipe(res);
			}
		} else {
			res.status(404);
			if(type == "text/html") {
				res.redirect("/error/404/");
			} else if(type.indexOf("image/") == 0) {
				res.json(404);
			} else {
				res.json(404);
			}
		}
	} else if(subdomain == "pipe") {
		if(decodedPath == "/") {
			res.redirect(`https://${req.get("Host").slice(5)}/pipe/`);
		} else {
			s3.getObject({
				Bucket: "miroware-pipe",
				Key: decodedPath.slice(1)
			}, function(err, data) {
				if(err) {
					res.set("Content-Type", "text/plain").status(err.statusCode).send(`Error ${err.statusCode}: ${err.message}`);
				} else {
					res.set("Content-Type", data.ContentType);
					res.send(data.Body);
				}
			});
		}
	}
});
http.createServer(app).listen(8080);
https.createServer({
	key: fs.readFileSync("/etc/letsencrypt/live/miroware.io/privkey.pem"),
	cert: fs.readFileSync("/etc/letsencrypt/live/miroware.io/cert.pem"),
	ca: fs.readFileSync("/etc/letsencrypt/live/miroware.io/chain.pem")
}, app).listen(8443);
fs.watch(__filename, function(type) {
	process.exit();
});
var stdin = process.openStdin();
stdin.on("data", function(input) {
	console.log(eval(input.toString().trim()));
});
