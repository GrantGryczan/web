this.title = "Flash to Web";
this.description = "Convert SWF files to HTML5 to be used the web.";
this.tags = ["convert", "converter", "conversion", "file", "files", "flash", "fla", "swf", "html", "html5", "javascript", "js", "deprecation", "deprecated", "deprecate", "deprecating", "adobe", "animate", "animation", "export", "swiffy", "swivel"];
this.value = (await load("load/head", this)).value;
this.value += html`
		<link rel="stylesheet" href="style.css">`;
this.value += (await load("load/body", this)).value;
this.value += (await load("load/pagehead", this)).value;
this.value += html`
				<p>Want to convert your SWF files to HTML5 to evade Flash's deprecation on the web? Use this.</p>
				<p>
					<button id="upload" class="mdc-button mdc-button--raised mdc-ripple" title="Import SWF file">
						<i class="mdc-button__icon material-icons">add</i>Import SWF file
					</button>
				</p>
				<form id="panel" class="mdc-elevation--z3 hidden">
					<div class="mdc-text-field">
						<input id="title" name="title" class="mdc-text-field__input" type="text" autocomplete="off" required>
						<label class="mdc-floating-label" for="title">Title</label>
						<div class="mdc-line-ripple"></div>
					</div>
					<button id="convert" class="mdc-button margined mdc-ripple" type="submit" title="Convert to HTML5">
						<i class="mdc-button__icon material-icons">swap_horizontal</i>Convert to HTML5
					</button>
				</form>`;
this.value += (await load("load/pagefoot", this)).value;
this.value += (await load("load/belt", this)).value;
this.value += html`
		<script src="script.js"></script>`;
this.value += (await load("load/foot", this)).value;
this.done();
