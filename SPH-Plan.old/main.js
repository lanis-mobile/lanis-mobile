const back = require('androidjs').back;
const SPHclient = require("./SPHclient")



var sphclient = new SPHclient("", "", 0)

/*
back.on("auth",  (data) => {
	sphclient = new SPHclient(data.username, data.pass, data.schoolID);
	back.send("ping", {})
	try {
		sphclient.authenticate().then(() => {
			back.send("loginSuccessful", {data: true});
		})
		
	} catch (_err) {
		back.send("loginSuccessful", {data: false});
	}
});

back.on("isAuth", async () => {
	try {
		await sphclient.getVplan(new Date());
		back.send("isAuth", {data: true});
	} catch {
		back.send("isAuth", {data: false});
	}
});

back.on("getVplan", async () => {
	try {
		back.send(
			"sphclient.Vplan", 
			{data: await sphclient.getVplan(await sphclient.getNextVplanDate())}
		);
	} catch {
		back.send("isAuth", {data: false});
	}
});
*/