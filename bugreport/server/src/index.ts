export interface Env {
	DB: D1Database;
}

export default {
	async fetch(request: Request, env: Env) {
		const { pathname, searchParams } = new URL(request.url);
		const requestBody = await request.text();

		const hasPermission = async () => {
			const access_token = searchParams.get("access_token");
			const query = "SELECT * FROM Developers WHERE access_token=?";
			const results = (await env.DB.prepare(query).bind(access_token).all()).results;
			return results.length !== 0;
		};

		const formatDate = () => {
			return new Date().toISOString();
		};

		if (pathname === "/api/add") {
			const {
				username,
				report,
				contact_information,
				device_data,
			} = JSON.parse(requestBody);

			const query =
				"INSERT INTO Reports (username, report, contact_information, userinfo, vertretungsplan, kalender, mein_unterricht, nachrichten, time_stamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			const params = [
				username,
				report,
				contact_information,
				JSON.stringify({
					"app": device_data.app ?? [],
					"school": device_data.school ?? [],
					"user": device_data.user ?? []
				}),
				JSON.stringify(device_data.applets["vertretungsplan"] ?? []),
				JSON.stringify(device_data.applets["kalender"] ?? []),
				JSON.stringify(device_data.applets["mein_unterricht"] ?? []),
				JSON.stringify(device_data.applets["nachrichten"] ?? []),
				formatDate(),
			];

			const { results } = await env.DB.prepare(query).bind(...params).run();
			return Response.json(results ?? "Ok", {headers: { "Access-Control-Allow-Origin": "*" }});
		} else if (pathname === "/api/del") {
			if (await hasPermission()) {
				const id = searchParams.get("id");
				const query = "DELETE FROM Reports WHERE id=?";
				await env.DB.prepare(query).bind(id).run();
				return new Response("Entry with ID was deleted.", {headers: { "Access-Control-Allow-Origin": "*" }});
			}
		} else if (pathname === "/api/all") {
			if (await hasPermission()) {
				const query = "SELECT id, username, report, time_stamp, contact_information FROM Reports";
				const { results } = await env.DB.prepare(query).all();
				return Response.json(results, {headers: { "Access-Control-Allow-Origin": "*" }});
			} else {
				return new Response("No permission to access the data!", {headers: { "Access-Control-Allow-Origin": "*" }});
			}
		} else if (pathname === "/api/device_data") {
			if (await hasPermission()) {
				const query = "SELECT vertretungsplan, kalender, mein_unterricht, nachrichten ,userinfo FROM Reports WHERE id=?;";
				const { results } = await env.DB.prepare(query).bind(parseInt(searchParams.get("id") ?? "-1")).all();

				if (results[0]) {
					return Response.json(
						{
							"userinfo": JSON.parse(<string>results[0]["userinfo"] ?? "[]"),
							"vertretungsplan": JSON.parse(<string>results[0]["vertretungsplan"] ?? "[]"),
							"kalender": JSON.parse(<string>results[0]["kalender"] ?? "[]"),
							"mein_unterricht": JSON.parse(<string>results[0]["mein_unterricht"] ?? "[]"),
							"nachrichten": JSON.parse(<string>results[0]["nachrichten"] ?? "[]"),
						},
						{headers: { "Access-Control-Allow-Origin": "*" }}
					);
				} else {
					return new Response("No data with that ID!", {headers: { "Access-Control-Allow-Origin": "*" }});
				}
			} else {
				return new Response("No permission to access the data!", {headers: { "Access-Control-Allow-Origin": "*" }});
			}
		}

		return new Response("Why are you here?\nMaybe you want to take a look at https://github.com/alessioc42/lanis-mobile and contribute", {headers: { "Access-Control-Allow-Origin": "*" }});
	},
};
