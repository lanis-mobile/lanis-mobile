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

module.exports = {WEBSERVERCONFIG}