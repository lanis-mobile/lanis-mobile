const SPHclient = require("sphclient");
const betterSQLite3 = require("better-sqlite3");
const {DBFILENAME, UPDATEINTERVAL} = require("./config");

const api = require("express").Router();
const db = betterSQLite3(__dirname + "/"+DBFILENAME, { "fileMustExist": true, "verbose": (message) => { console.log(`[BETTER-SQLITE3-EXEC]:  ${message}`) } });

const dbQuerys = {
    getAllCredits: db.prepare("SELECT schoolid, username, password FROM Credits;"),
    addCredits: db.prepare("INSERT INTO Credits (schoolid, username, password, deltoken) VALUES (?, ?, ?, ?)"),
    isCreditAvailable: db.prepare("SELECT schoolid FROM Credits WHERE schoolid=?;"),
    isValidDelToken: db.prepare("SELECT schoolid FROM Credits WHERE schoolid=? AND deltoken=?;"),
    removeCredits: db.prepare("DELETE FROM Credits WHERE schoolid=? AND deltoken=?"),
    
    getPlan: db.prepare("SELECT data1, data2 FROM Plans WHERE schoolID=?;"),
    updateVplan: db.prepare("INSERT OR REPLACE INTO Plans (schoolID, data1) VALUES (?, ?);")
}

// Variable to store all SPHclient Objects in.
var clients = {}


async function addClient(username, password, schoolid) {
    if (!clients[schoolid]) {
        let client = new SPHclient(username, password, schoolid);

        try {
            await client.authenticate();
            clients[schoolid] = client;
        } catch (err) {
            console.log(err);
        }
    }
}

function initAllDBClients() {
    let accountsData = dbQuerys.getAllCredits.all()

    accountsData.forEach(accountData => {
        addClient(accountData.username, accountData.password, accountData.schoolid)
    })
}

function generateRandomToken(length = 8) {
    const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let token = "";

    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        token += charset.charAt(randomIndex);
    }

    return token;
}

function updatePlanData() {
    let clientKeys = Object.keys(clients);

    clientKeys.forEach(key => {
        let client = clients[key];
        let schoolid = client.schoolID;
        try {
            client.getNextVplanDate().then(date => {
                client.getVplan(date).then(plan => {
                    dbQuerys.updateVplan.run(schoolid, JSON.stringify(plan));
                })
            })
        } catch (err) {
            console.log(err)
        }
    });
}



api.get("/plan", (req, res) => {
    let data = dbQuerys.getPlan.get(req.query.schoolid);

    try {
        if (data) {
            res.status(200).json(data).end();
        } else {
            res.status(404).send("Your school does not have valid credits!");
        }
    } catch (err) {
        res.status(500).end();
    }
});

api.post("/addCredits", (req, res) => {
    let schoolid = req.query.schoolid;
    let username = req.query.username;
    let password = req.query.password;

    let isCreditAvailable = dbQuerys.isCreditAvailable.get(req.query.schoolid);

    if (!isCreditAvailable && schoolid && username && password) {
        try {
            let client = new SPHclient(username, password, schoolid);

            client.authenticate().then(() => {
                clients[schoolid] = client;

                let deltoken = generateRandomToken();

                dbQuerys.addCredits.run(schoolid, username, password, deltoken);
                res.status(200).send(deltoken);
            });

            res.status(500).send("This should never happen!?");
        } catch (err) {
            res.status(500).send(err);
        }
    } else {
        res.status(500).send("Invalid request or there is already a record for this schoolid. If you think this is an error, please contact the server administrator.")
    }
});

api.post("/removeCredits", (req, res) => {
    let schoolid = req.query.schoolid;
    let deltoken = req.query.deltoken;

    if (schoolid && deltoken) {
        let isValidDelToken = dbQuerys.isValidDelToken(schoolid, deltoken);

        if (isValidDelToken) {
            dbQuerys.removeCredits.run(schoolid, deltoken);

            try {
                delete clients[schoolid];

            } catch (err) {
                console.log(err);
            }

            res.send("Deleteted all data!");
        } else {
            res.status(500).send("Invalid request.")
        }
    }
});

initAllDBClients();
setInterval(updatePlanData, UPDATEINTERVAL);
updatePlanData();


module.exports = api;