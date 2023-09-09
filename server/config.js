//name of the database file. (must be in the same directory)
const DBFILENAME = "database.db";

//interval to fetch the new plan data. (in ms)
const UPDATEINTERVAL = 1200000 //=20min

const WEBSERVERCONFIG = {
    https : false,
    port: {
        http: 3000,
        https: 443
    },
    certificate: {
        key: "path to key",
        cert: "path to cert",
        ca: "path to chain"
    }
}

module.exports = {DBFILENAME, UPDATEINTERVAL, WEBSERVERCONFIG}