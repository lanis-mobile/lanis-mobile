export interface Env {
	DB: D1Database;
}

export default {
	async fetch(request: Request, env: Env) {
		const { pathname, searchParams } = new URL(request.url);

		const hasPermission = async () => {
			const access_token = searchParams.get("access_token");
			const query = "SELECT * FROM Developers WHERE access_token=?";
			const results = (await env.DB.prepare(query).bind(access_token).all()).results;
			return results.length !== 0;
		};

		const formatDate = () => {
			// Use a proper method to format dates
			return new Date().toISOString();
		};

		if (pathname === "/api/add") {
			const query =
				"INSERT INTO Reports (username, report, contact_information, device_data, time_stamp) VALUES (?, ?, ?, ?, ?)";
			const params = [
				searchParams.get("username"),
				searchParams.get("report"),
				searchParams.get("contact_information"),
				searchParams.get("device_data"),
				formatDate(),
			];

			const { results } = await env.DB.prepare(query).bind(params).run();
			return Response.json(results ?? "Ok");
		} else if (pathname === "/api/del") {
			if (await hasPermission()) {
				const id = parseInt(searchParams.get("id") ?? "-1");
				const query = "DELETE FROM Reports WHERE id=?";
				await env.DB.prepare(query).bind(id).run();
				return new Response("Entry with ID was deleted.");
			}
		} else if (pathname === "/api/all") {
			if (await hasPermission()) {
				const query = "SELECT * FROM Reports";
				const { results } = await env.DB.prepare(query).all();
				return Response.json(results);
			} else {
				return new Response("No permission to access the data!");
			}
		}

		return new Response("Why are you here?\nMaybe you want to take a look at https://github.com/alessioc42/SPH-vertretungsplan and contribute");
	},
};
