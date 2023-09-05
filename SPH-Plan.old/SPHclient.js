class SPHclient {
  logged_in = false;
  cookies = {};

  constructor(username, password, schoolID, loggingLevel = 1) {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;
    this.loggingLevel = loggingLevel;
    this.loginURL = `https://login.schulportal.hessen.de/?i=${schoolID}`;
  }

  async authenticate() {
    if (this.logged_in) {
      throw new Error("Client already authenticated!");
    }

    try {
      const response = await fetch(this.loginURL, {
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        redirect: "manual",
        body: encodeURI(
          `user2=${this.username}&user=${this.schoolID}.${this.username}&password=${this.password}`
        ),
        method: "POST",
      });

      if (response.headers.has("location")) {
        this.parseSetCookieHeader(response.headers.get("set-cookie"));
        this.log("auth request 1 successful.", 0);

        const response2 = await fetch(response.headers.get("location"), {
          redirect: "manual",
          method: "GET",
          headers: {
            cookie: this.getCookieHeader(),
          },
        });

        if (response2.headers.get("location")) {
          this.log("auth request 2 successful.", 0);

          const response3 = await fetch(response2.headers.get("location"), {
            method: "GET",
            redirect: "manual",
            headers: {
              cookie: this.getCookieHeader(),
            },
          });

          this.parseSetCookieHeader(response3.headers.get("set-cookie"));
          this.logged_in = true;
          this.log(`authenticated successful with sid=${this.cookies.sid.value}`, 1);
        } else {
          this.log("error during auth request 2", 0);
          this.logged_in = false;
          throw new Error("Unexpected error during request");
        }
      } else {
        this.log("error during auth request 1", 0);
        this.logged_in = false;
        throw new Error("Wrong credentials or the lanis team changed the API again ;D");
      }
    } catch (error) {
      throw error;
    }
  }

  async logout() {
    if (!this.logged_in) {
      throw new Error("Client not authenticated!");
    }

    const url = "https://start.schulportal.hessen.de/index.php?logout=all";

    try {
      const response = await fetch(url, {
        method: "GET",
        headers: {
          cookie: this.getCookieHeader(),
        },
      });

      this.parseSetCookieHeader(response.headers.get("set-cookie"));
      this.logged_in = false;
      this.log(`deauthenticated successful.`, 1);
    } catch (error) {
      throw error;
    }
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


  async getVplan(date) {
    date = date.toLocaleDateString("en-CH");
    const url = `https://start.schulportal.hessen.de/vertretungsplan.php?ganzerPlan=true&tag=${date}`;
    const formData = new URLSearchParams();
    formData.append("tag", date);
    formData.append("ganzerPlan", "true");

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          Host: "start.schulportal.hessen.de",
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          Cookie:
            "sph-login-upstream=4;schulportal_lastschool=" +
            this.schoolID +
            "; i=" +
            this.schoolID +
            "; sid=" +
            this.cookies.sid.value,
        },
        body: formData,
      });

      const data = await response.json();
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }

  async getNextVplanDate() {
    try {
      const response = await fetch("https://start.schulportal.hessen.de/vertretungsplan.php", {
        headers: {
          Host: "start.schulportal.hessen.de",
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          Cookie:
            "sph-login-upstream=4;schulportal_lastschool=" +
            this.schoolID +
            "; i=" +
            this.schoolID +
            "; sid=" +
            this.cookies.sid.value,
        },
        method: "GET",
      });

      const text = await response.text();
      const datePattern = /data-tag="(\d{2})\.(\d{2})\.(\d{4})"/;
      const match = text.match(datePattern);

      if (match) {
        const day = parseInt(match[1]);
        const month = parseInt(match[2]) - 1;
        const year = parseInt(match[3]);
        const extractedDate = new Date(year, month, day);
        return extractedDate;
      } else {
        return null;
      }
    } catch (error) {
      console.error(error);
      throw error;
    }
  }

  async getCalendar(start, end) {
    const url = `https://start.schulportal.hessen.de/kalender.php`;
    const formData = new URLSearchParams();
    formData.append("f", "getEvents");
    formData.append("start", start.toISOString().split("T")[0]);
    formData.append("end", end.toISOString().split("T")[1]);

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          Host: "start.schulportal.hessen.de",
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          Cookie:
            "sph-login-upstream=4;schulportal_lastschool=" +
            this.schoolID +
            "; i=" +
            this.schoolID +
            "; sid=" +
            this.cookies.sid.value,
        },
        body: formData,
      });

      const data = await response.json();
      return data;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }

  log(message, loglevel = 0) {
    if (this.loggingLevel == 0) {
      console.log(`[SPHclient] ${(new Date()).toLocaleString("en-CH")} (${this.schoolID}.${this.username}) : ${message}`)
    } else if (this.loggingLevel == 1 && loglevel == 1) {
      console.log(`[SPHclient] ${(new Date()).toLocaleString("en-CH")} (${this.schoolID}.${this.username}) : ${message}`)
    } else if (this.loggingLevel == 2) {
      return;
    }
  }
}

module.exports = SPHclient