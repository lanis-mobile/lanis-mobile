addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
});
const SPHclient = require("sphclient");

async function handleRequest(request) {
  const url = new URL(request.url);
  const { pathname, search } = url;

  urlParams = new URLSearchParams(search);

  switch (pathname) {
    case '/api/login':
      return handleLogin(urlParams);
    case '/api/isValidSession':
      return handleIsValidSession(urlParams);
    case '/api/plan':
      return handlePlan(urlParams);
    default:
      return new Response(`Not found: ${pathname}`, { status: 404 , headers: {"Access-Control-Allow-Origin": "*"}});
  }
}


async function handleLogin(params) {
  const username = params.get('username');
  const password = params.get('password');
  const schoolid = params.get('schoolid');
  
  if (username && password && schoolid) {
    let client = new SPHclient(username, password, schoolid, false);

    try {
      await client.authenticate();
      return new Response(client.cookies.sid.value, {headers: {"Access-Control-Allow-Origin": "*"}});
    } catch (error) {
      return new Response(error, { status: 500, headers: {"Access-Control-Allow-Origin": "*"}});
    }
  }
}

async function handleIsValidSession(params) {
  const sid = params.get('sid');
  const schoolid = params.get('schoolid');

  if (sid) {
    let client = new SPHclient({ schoolID: schoolid });
    client.cookies.sid = { value: sid };
    client.logged_in = true;

    try {
      await client.getVplan(new Date());
      return new Response("OK", { status: 200, headers: {"Access-Control-Allow-Origin": "*"}});
    } catch (error) {
      return new Response("NO", { status: 401, headers: {"Access-Control-Allow-Origin": "*"}});
    }
  }
}

async function handlePlan(params) {
  const sid = params.get('sid');
  const schoolid = params.get('schoolid');

  if (sid) {
    let client = new SPHclient({ schoolID: schoolid });
    client.cookies.sid = { value: sid };
    client.logged_in = true;

    try {
      const date = await client.getNextVplanDate();
      const plan = await client.getVplan(date);
      
      return new Response(JSON.stringify(plan), { status: 200, headers: {"Access-Control-Allow-Origin": "*"}});
    } catch (error) {
      console.log(error); // Log the error for debugging
      return new Response("Error while authenticating", { status: 401, headers: {"Access-Control-Allow-Origin": "*"}});
    }
  }
}