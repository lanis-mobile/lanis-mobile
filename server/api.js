const SPHclient = require("sphclient");

const api = require("express").Router();

// Variable to store all SPHclient Objects in.

api.get("/login", (req, res) => {
  try {
    let username = req.query.username;
    let password = req.query.password;
    let schoolid = req.query.schoolid;

    console.log(username + " " + password + " " + schoolid);

    if (username && password && schoolid) {
      let client = new SPHclient(username, password, schoolid, false);

      client.authenticate().then(() => {
        res.send(client.cookies.sid.value);
      });
    }
  } catch (error) {
    res.status(500).send(error);
  }
});

api.get("/plan", async (req, res) => {
  let sid = req.query.sid;
  let schoolid = req.query.schoolid;

  if (sid) {
    try {
      let client = new SPHclient({ schoolID: schoolid });
      client.cookies.sid = { value: sid };
      client.logged_in = true;

      console.log("hello");
      const date = await client.getNextVplanDate();
      const plan = await client.getVplan(date);
      
      res.status(200).json(plan).end();
    } catch (error) {
      console.error(error); // Log the error for debugging
      res.status(500).send("Error while authenticating");
    }
  }
});

module.exports = api;
