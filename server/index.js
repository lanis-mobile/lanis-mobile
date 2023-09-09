const express = require("express");
const api = require("./usermanager");

const { WEBSERVERCONFIG } = require("./config");


const app = express();

app.use("/api", api);



if (WEBSERVERCONFIG.https) {
    const https = require("https");
    const http = require("http");

    http.createServer(app).listen(WEBSERVERCONFIG.port.http, () => {
        `running on http://localhost:${WEBSERVERCONFIG.port.http}/`
    })

    https
        .createServer(
            {
                key: fs.readFileSync(WEBSERVERCONFIG.certificate.key),
                cert: fs.readFileSync(WEBSERVERCONFIG.certificate.cert),
                ca: fs.readFileSync(WEBSERVERCONFIG.certificate.ca),
            },
            app
        )
        .listen(WEBSERVERCONFIG.port.https, () => console.log(`running on https://localhost:${WEBSERVERCONFIG.port.https}/`))
} else {
    app.listen(WEBSERVERCONFIG.port.http, () => console.log(`running on http://localhost:${WEBSERVERCONFIG.port.http}/`))
}
