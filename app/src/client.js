import { CapacitorHttp } from '@capacitor/core';


export class SPHClient {
    cookies = {};

    constructor() {}

    async login(username, password, schoolid) {
        this.cookies = {};
        let response1 = await CapacitorHttp.post({
            url: `https://login.schulportal.hessen.de/?i=${schoolid}`,
            headers: {
                "content-type": "application/x-www-form-urlencoded"
            },
            disableRedirects: true,
            params: {
                password: password,
                user: `${schoolid}.${username}`,
                user2: username
            }
        });

        if (!response1.headers.location) throw new Error("Error while authenticating!");
        this.parseSetCookieHeader(response1.headers["set-cookie"])

        let response2 = await CapacitorHttp.get({
            url: response1.headers.location, //should be "https://connect.schulportal.hessen.de"
            disableRedirects: true,
            webFetchExtra: { mode: 'no-cors' },
            headers: {
                cookie: this.getCookieHeader()
            }
        });

        if (!response2.headers.location) throw new Error("Error while authenticating!");
        let response3 = await CapacitorHttp.get({
            url: response2.headers.location,
            disableRedirects: true,
            webFetchExtra: { mode: 'no-cors' },
            headers: {
                cookie: this.getCookieHeader()
            }
        });

        this.parseSetCookieHeader(String(response3.headers["set-cookie"]));
        if (this.cookies.sid) {
            return this.cookies.sid.value;
        } else {
            throw new Error("Error while authenticating!");
        }
    }

    async getVplan(sid, schoolid, date) {
        date = date.toLocaleDateString("en-CH");

        let response = await CapacitorHttp.post({
            url: `https://start.schulportal.hessen.de/vertretungsplan.php?ganzerPlan=true&tag=${date}`,
            params: {
                tag: date,
                ganzerPlan: "true"
            },
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                cookie: `sph-login-upstream=4;schulportal_lastschool=${this.schoolID} +"; i=${schoolid}; sid=${sid}`
            },
            data: `tag=${date}&ganzerPlan=true`
        });
        return JSON.parse(response.data);
    }

    async getVplanDates(sid, schoolid) {
        let response = await CapacitorHttp.get({
            url: "https://start.schulportal.hessen.de/vertretungsplan.php",
            webFetchExtra: { mode: 'no-cors' },
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                cookie: `sph-login-upstream=4;schulportal_lastschool=${this.schoolID} +"; i=${schoolid}; sid=${sid}`
            }
        });
        let text = response.data;

        let datePattern = /data-tag="(\d{2})\.(\d{2})\.(\d{4})"/g;
        let matches = [...text.matchAll(datePattern)];

        let uniqueDates = [];

        for (let match of matches) {
            let day = parseInt(match[1]);
            let month = parseInt(match[2]) - 1;
            let year = parseInt(match[3]);
            let extractedDate = new Date(year, month, day);

            if (!uniqueDates.some((date) => date.getTime() === extractedDate.getTime())) {
                uniqueDates.push(extractedDate);
            }
        }

        return uniqueDates;
    }

    parseSetCookieHeader(setCookieHeader) {
        const cookiesArray = setCookieHeader.split(",");

        cookiesArray.forEach((cookieString) => {
            const [cookie, ...options] = cookieString.trim().split(";");
            const [name, value] = cookie.trim().split("=");
            this.cookies[name] = { value };

            options.forEach((option) => {
                const [key, val] = option.trim().split("=");
                this.cookies[name][key] = val || true;
            });
        });
    }

    getCookieHeader() {
        return Object.keys(this.cookies)
            .map((name) => {
                const cookie = this.cookies[name];
                const options = Object.keys(cookie)
                    .filter((key) => key !== "value")
                    .map((key) => (cookie[key] === true ? key : `${key}=${cookie[key]}`))
                    .join("; ");

                return `${name}=${cookie.value}; ${options}`;
            })
            .join(", ");
    }
}