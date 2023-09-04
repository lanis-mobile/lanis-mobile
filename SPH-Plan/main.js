const back = require('androidjs').back;

SPHclient = null

import("sphclient").then(mod => {
	SPHclient = mod;
});

sphclient = null



back.on("sphclient.auth", async (username, pass, schoolID) => {
	sphclient = new SPHclient(username, pass, schoolID);
	try {
		await sphclient.authenticate();
		back.send("loginSuccessful", true);
	} catch (_err) {
		back.send("loginSuccessful", false);
	}
});

back.on("sphclient.isAuth", async () => {
	try {
		await sphclient.getVplan(new Date());
		back.send("sphclient.isAuth", true);
	} catch {
		back.send("sphclient.isAuth", false);
	}
});

back.on("sphclient.getVplan", async () => {
	try {
		back.send(
			"sphclient.Vplan", 
			await sphclient.getVplan(await sphclient.getNextVplanDate())
		);
	} catch {
		back.send("sphclient.isAuth", false);
	}
});