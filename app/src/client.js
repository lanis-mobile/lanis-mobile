import { CapacitorHttp } from '@capacitor/core';


export class SPHClient {
    cookies = {};

    constructor() { }

    async login(username, password, schoolid) {
        this.cookies = null;
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
            return this.getCookieHeader();
        } else {
            throw new Error("Error while authenticating!");
        }
    }

    async getVplan(cookieHeader, date) {
        date = date.toLocaleDateString("en-CH");

        try {
            const response = await CapacitorHttp.post({
                url: `https://start.schulportal.hessen.de/vertretungsplan.php`,
                params: {
                    tag: date,
                    ganzerPlan: "true"
                },
                headers: {
                    "Accept": "*/*",
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "Sec-Fetch-Dest": "empty",
                    "Sec-Fetch-Mode": "cors",
                    "Sec-Fetch-Site": "same-origin",
                    "cookie": cookieHeader
                },
                webFetchExtra: {
                    credentials: "include",
                    referrer: "https://start.schulportal.hessen.de/vertretungsplan.php",
                    mode: "cors"
                },
                data: `tag=${date}&ganzerPlan=true`,
            });

            return JSON.parse(response.data);
        } catch (error) {
            throw error;
        }
    }

    async getVplanDates(cookieHeader) {
        let response = await CapacitorHttp.get({
            url: "https://start.schulportal.hessen.de/vertretungsplan.php",
            disableRedirects: true,
            webFetchExtra: { mode: 'no-cors' },
            headers: {
                Host: "start.schulportal.hessen.de",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                Cookie: cookieHeader
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

        if (uniqueDates.length === 0) {
            throw new Error("No valid Dates Found or not Authenticated!");
        }

        return uniqueDates;
    }

    async getAllVplanData(cookieHeader) {
        const dates = await this.getVplanDates(cookieHeader);
        const fetchPromises = [];

        dates.forEach(date => {
            fetchPromises.push(
                this.getVplan(cookieHeader, date)
            );
        });

        const plans = await Promise.all(fetchPromises);
        return [].concat(...plans);
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