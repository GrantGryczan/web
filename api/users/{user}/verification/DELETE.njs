const {user, isMe} = await parseUser(this);
if (isMe) {
	if (user.verified) {
		this.update.$set.unverified = this.update.$set.emailCode = null;
	} else {
		this.value = {
			error: "You cannot cancel verification without a verified email."
		};
		this.status = 422;
	}
} else {
	this.value = {
		error: "You do not have permission to access that user."
	};
	this.status = 403;
}
this.done();
