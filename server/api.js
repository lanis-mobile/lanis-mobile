const SPHclient = require("sphclient");
const cors = require("cors");


const api = require("express").Router();

// Variable to store all SPHclient Objects in.

api.get("/login", cors() ,(req, res) => {
  try {
    let username = req.query.username;
    let password = req.query.password;
    let schoolid = req.query.schoolid;

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

api.get("/isValidSession", cors(),  async (req, res) => {
  let sid = req.query.sid;
  let schoolid = req.query.schoolid;

  if (sid) {
    try {
      let client = new SPHclient({ schoolID: schoolid });
      client.cookies.sid = { value: sid };
      client.logged_in = true;

      await client.getVplan(new Date());
      
      res.status(200).send("OK").end();
    } catch (error) {
      //console.log(error);
      res.status(401).send("NO");
    }
  }
});

api.get("/plan", cors(), async (req, res) => {
  let sid = req.query.sid;
  let schoolid = req.query.schoolid;

  if (sid) {
    try {
      let client = new SPHclient({ schoolID: schoolid });
      client.cookies.sid = { value: sid };
      client.logged_in = true;

      const date = await client.getNextVplanDate();
      const plan = await client.getVplan(date);
      
      res.status(200).json(plan).end();
    } catch (error) {
      console.log(error); // Log the error for debugging
      res.status(401).send("Error while authenticating");
    }
  }
});

module.exports = api;
