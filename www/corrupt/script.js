"use strict";
const factor = document.body.querySelector("#factor");
const input = document.body.querySelector("#input > img");
const output = document.body.querySelector("#output > img");
let buffer;
const readFile = file => {
	input.src = URL.createObjectURL(file);
	const reader = new FileReader();
	reader.addEventListener("loadend", () => {
		console.log(buffer = reader.result);
	});
	reader.readAsArrayBuffer(file);
};
const fileInput = document.createElement("input");
fileInput.type = "file";
fileInput.accept = "image/*";
fileInput.addEventListener("change", () => {
	readFile(fileInput.files[0]);
	fileInput.value = null;
});
document.body.querySelector("#upload").addEventListener("click", fileInput.click.bind(fileInput));
document.body.querySelector("#corrupt");
document.body.querySelector("#download");

(() => {
	var corruptFactor = document.querySelector("#corruptFactor");
	var corrupt = function(text) {
		text = text.split("");
		var corruptFactorValue = parseInt(corruptFactor.value);
		for(var i = 0; i < corruptFactorValue; i++) {
			text[Math.round(Math.random()*text.length)] = String.fromCharCode(Math.round(Math.random()*255));
		}
		return text.join("");
	};
	var pre = "";
	var text = "";
	var newimg;
	document.querySelector("#file").addEventListener("change", function(evt) {
		var imgs = document.querySelectorAll("#img");
		while(imgs.length) {
			imgs[0].parentNode.removeChild(imgs[0]);
		}
		var reader = new FileReader();
		reader.addEventListener("load", function(evt) {
			var res = evt.target.result;
			var oldimg = document.createElement("img");
			oldimg.addEventListener("load", function() {
				newimg.width = oldimg.naturalWidth;
				newimg.height = oldimg.naturalHeight;
			});
			oldimg.src = res;
			document.querySelector("#original").appendChild(oldimg);
			pre = res.substring(0, res.indexOf(",")+1);
			text = atob(res.substring(pre.length, res.length));
			newimg = document.createElement("img");
			newimg.src = pre + btoa(corrupt(text));
			newimg.addEventListener("error", function() {
				newimg.src = pre + btoa(corrupt(text));
			});
			newimg.style.backgroundImage = "url(\"" + oldimg.src + "\")";
			document.querySelector("#new").appendChild(newimg);
			document.querySelector("#options").style.display = "";
			document.querySelector("#results").style.display = "";
		});
		reader.readAsDataURL(evt.target.files[0]);
	});
	document.querySelector("#refresh").addEventListener("click", function() {
		newimg.src = pre + btoa(corrupt(text));
	});
	var anim = document.querySelector("#anim");
	setInterval(function() {
		if(anim.checked) {
			newimg.src = pre + btoa(corrupt(text));
		}
	}, 75);
});
