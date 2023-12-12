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
				"INSERT INTO Reports (username, report, contact_information, device_data, time_stamp) VALUES (?, ?, ?, ?, ?)";
			const params = [
				username,
				report,
				contact_information,
				device_data,
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
				const query = "SELECT device_data FROM Reports WHERE id=?;";
				const { results } = await env.DB.prepare(query).bind(parseInt(searchParams.get("id") ?? "-1")).all();
				let returnData;
				try {
					returnData = JSON.parse(<string>results[0].device_data ?? "{}");
				} catch (_e) {
					returnData = {".": "The user did not supply information"};
				}
				return Response.json(returnData, {headers: { "Access-Control-Allow-Origin": "*" }});
			} else {
				return new Response("No permission to access the data!", {headers: { "Access-Control-Allow-Origin": "*" }});
			}
		}

		return new Response("Why are you here?\nMaybe you want to take a look at https://github.com/alessioc42/SPH-vertretungsplan and contribute", {headers: { "Access-Control-Allow-Origin": "*" }});
	},
};
