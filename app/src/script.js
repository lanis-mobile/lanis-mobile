import schoolData from './schools.json';
import { SecureStorage } from '@aparajita/capacitor-secure-storage'
import { CapacitorHttp } from '@capacitor/core';
import { Browser } from '@capacitor/browser';

const REQUEST_TIMEOUT = 2500;

// Initialize app
const app = new Framework7({
  root: '#app',
  name: 'SPH-Plan',
  id: 'io.github.sphplan',
  toast: {
    closeTimeout: 2500,
    closeButton: true,
    position: "top"
  }
});

function openSettingsScreen() {
  loadMemoryEntryOptions();
  loadSchoolSelect();

  app.loginScreen.open('#settings-screen');
}

function closeSettingsScreen() {
  app.loginScreen.close('#settings-screen');
}


//returns whether the user has a valid session or not
async function isLoggedIn() {
  const serverURL = (await SecureStorage.getItem("serverURL"));
  const sid = (await SecureStorage.getItem("sid"));

  if (serverURL && sid) {
    let response = await CapacitorHttp.get({
      url: `${serverURL}/api/isValidSession`,
      params: {
        sid: sid
      },
      responseType: "text",
      connectTimeout: REQUEST_TIMEOUT
    }).catch(_error => {
      app.toast.create({ text: 'Error calling the server!' }).open();
      document.getElementById("loginInformationLabel").innerText = "keine Verbindung";
    });

    if (response.status == 200) {
      document.getElementById("loginInformationLabel").innerText = "eingeloggt";
      return true;
    } else {
      document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
      return false;
    }
  } else {
    document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
    return false;
  }
}

async function auth(serverURL, username, password, schoolid) {
  app.dialog.preloader("authenticating...");

  try {
    CapacitorHttp.get({
      url: `${serverURL}/api/login`,
      params: {
        username: username,
        password: password,
        schoolid: schoolid
      },
      responseType: "text",
      connectTimeout: REQUEST_TIMEOUT
    }).then(async response => {
      app.dialog.close();
      if (response.status == 200) {
        let sid = await response.data;
        console.log(sid);
        await SecureStorage.setItem("sid", sid);
        app.toast.create({ text: 'logged in!' }).open()

        console.log(await SecureStorage.getItem("sid"));
        closeSettingsScreen()
        updatePlanView();

        document.getElementById("loginInformationLabel").innerText = "eingeloggt";

      } else if (response.status == 500) {
        app.toast.create({ text: 'login failed!' }).open();
        document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
      } else {
        app.toast.create({ text: 'login failed: unknown error' }).open();
        document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
      }
    }).catch(error => {
      console.error(error);
      app.dialog.close();
      app.toast.create({ text: 'Login Failed: unknown error' }).open();
      document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
    });

  } catch (err) {
    app.dialog.close();
    app.toast.create({ text: 'Login Failed: unknown error' }).open();
    document.getElementById("loginInformationLabel").innerText = "nicht eingeloggt";
  }
}

async function loginButton() {
  let username = document.getElementById("login-username").value;
  let password = document.getElementById("login-password").value;
  let schoolid_raw = document.getElementById("login-schoolid").value
  let schoolid = schoolid_raw.match(/^(\d+)/)[0];
  let serverURL = (document.getElementById("login-instance").value).match(/^(https?:\/\/[a-zA-Z0-9.-]+)(:\d+)?/)[0];
  let autologin = document.getElementById("login-autologin").checked;

  if (autologin) {
    await SecureStorage.setItem("password", password);
    await SecureStorage.setItem("autologin", "true");
  } else {
    await SecureStorage.setItem("password", "");
    await SecureStorage.setItem("autologin", "");
  }

  await SecureStorage.setItem("serverURL", serverURL);
  await SecureStorage.setItem("schoolid_raw", schoolid_raw);
  await SecureStorage.setItem("schoolid", schoolid);
  await SecureStorage.setItem("username", username);

  auth(serverURL, username, password, schoolid);
}

function createCardItem(data) {
  const listItem = document.createElement('li');
  const card = document.createElement('div');
  card.classList.add('card');

  const cardHeader = document.createElement('div');
  cardHeader.classList.add('card-header');
  cardHeader.innerHTML = `Stunde ${data.Stunde} <b>${data.Klasse}</b> <strong>${data.Art}</strong>`;
  card.appendChild(cardHeader);

  const cardContent = document.createElement('div');
  cardContent.classList.add('card-content', 'card-content-padding');
  const table = document.createElement('table');
  const tbody = document.createElement('tbody');

  // Funktion zum Hinzufügen von Zeilen
  function addRow(label, value) {
    if (value !== null && value !== "" && value.length !== 0) {
      const row = document.createElement('tr');
      const labelCell = document.createElement('td');
      labelCell.classList.add('label-cell');
      labelCell.style.paddingRight = "16vw"; // TODO better solution
      labelCell.textContent = label;
      const numericCell = document.createElement('td');
      numericCell.classList.add('numeric-cell');
      numericCell.innerHTML = `<strong>${value}</strong>`;
      row.appendChild(labelCell);
      row.appendChild(numericCell);
      tbody.appendChild(row);
    }
  }

  let keys = Object.keys(data);
  keys.forEach(key => {
    if (data[key] && !(["Tag_en", "_hervorgehoben", "Tag", "Stunde", "Fach", "Art", "Klasse"].includes(key))) {
      addRow(`${key.replace("_", " ")}:`, data[key])
    }
  });

  table.appendChild(tbody);
  cardContent.appendChild(table);
  card.appendChild(cardContent);

  const cardFooter = document.createElement('div');
  cardFooter.classList.add('card-footer');
  cardFooter.innerHTML = `${data.Tag} <strong>${data.Fach}</strong>`;
  card.appendChild(cardFooter);

  listItem.appendChild(card);

  return listItem;
}

async function updatePlanView() {
  const serverURL = (await SecureStorage.getItem("serverURL"));
  const sid = (await SecureStorage.getItem("sid"));
  const schoolid = (await SecureStorage.getItem("schoolid"));
  if (serverURL && sid && schoolid) {
    app.dialog.preloader('Lade Plan...');
    var cardContainer = document.getElementById("cardContainer");
    cardContainer.innerHTML = ``;

    CapacitorHttp.get({
      url: `${serverURL}/api/plan`,
      params: {
        sid: sid,
        schoolid: schoolid,
        connectTimeout: REQUEST_TIMEOUT
      },
      responseType: "json"
    }).then(async response => {
      response.data.forEach(entry => {
        cardContainer.appendChild(createCardItem(entry))
      });
      app.dialog.close();
    }).catch(_error => {
      app.dialog.close();
      app.toast.create({ text: 'Netzwerkfehler!' }).open();
    })
  } else {
    app.toast.create({ text: 'Du bist nicht eingeloggt!' }).open();
  }
}

var schoolSelectAlreadyLoaded = false;

async function loadSchoolSelect() {
  if (!schoolSelectAlreadyLoaded) {
    schoolSelectAlreadyLoaded = true;

    let schools = [];
    Array.from(schoolData).forEach(landkreis => {
      schools = schools.concat(landkreis.Schulen);
    });

    app.autocomplete.create({
      inputEl: '#login-schoolid',
      openIn: 'dropdown',
      source: async (query, render) => {
        query = query.toLowerCase(); // Convert the query to lowercase for case-insensitive search
        let items = schools.filter((item) => {
          const id = item["Id"].toLowerCase();
          const name = item["Name"].toLowerCase();
          const ort = item["Ort"].toLowerCase();
          return id.includes(query) || name.includes(query) || ort.includes(query);
        }).slice(0, 7); // Limit the number of results to 7

        items = items.map((item) => `${item["Id"]} - ${item["Name"]} - ${item["Ort"]}`);
        render(items);
      }
    });
  }
}

async function loadMemoryEntryOptions() {
  let serverURL = (await SecureStorage.getItem("serverURL"));
  if (!serverURL) {
    serverURL = "https://production.sphvertretungsplan.alessioc42.workers.dev";
  }
  document.getElementById("login-instance-li").classList.add("item-input-with-value");

  let username = (await SecureStorage.getItem("username"));
  if (username) {
    document.getElementById("login-username-li").classList.add("item-input-with-value");
  } else {
    document.getElementById("login-username-li").classList.remove("item-input-with-value");
  }

  document.getElementById("login-schoolid").value = (await SecureStorage.getItem("schoolid_raw"));
  document.getElementById("login-username").value = username;
  document.getElementById("login-instance").value = serverURL;
  document.getElementById("login-password").value = "";
}

async function wipeStorageAndRestartApp() {
  SecureStorage.clear()
  document.location.href = 'index.html';
}

async function openInBrowser(url) {
  await Browser.open({ url: url });
}

document.getElementById("openSettingsScreenButton").addEventListener("click", openSettingsScreen);
document.getElementById("closeSettingsScreenButton").addEventListener("click", closeSettingsScreen);
document.getElementById("loginButton").addEventListener("click", loginButton);
document.getElementById("reloadPlanDataButton").addEventListener("click", updatePlanView);
document.getElementById("resetAppButton").addEventListener("click", wipeStorageAndRestartApp);


//Buttons on startpage
document.getElementById("browserOpenBugreport").addEventListener("click", () => { openInBrowser("https://github.com/alessioC42/SPH-vertretungsplan/issues") });
document.getElementById("browserOpenFeatureRequest").addEventListener("click", () => { openInBrowser("https://github.com/alessioC42/SPH-vertretungsplan/issues") });
document.getElementById("browserOpenLatestrelease").addEventListener("click", () => { openInBrowser("https://github.com/alessioC42/SPH-vertretungsplan/releases/latest") });
document.getElementById("browserOpenGitHubPage").addEventListener("click", () => { openInBrowser("https://github.com/alessioC42/SPH-vertretungsplan") });


app.tab.show('#instanceConfigTab');
// Event-Handling für das Umschalten zwischen Tabs
app.on('tabShow', function (tabEl) {
  var tabId = tabEl.id;
  app.tab.show(tabId);
});


async function init() {
  loadMemoryEntryOptions();
  let loggedIn = await isLoggedIn();
  console.log(`user logged in: ${loggedIn}`)
  if (loggedIn) {
    updatePlanView();
  } else {
    let autologin = await SecureStorage.getItem("autologin");
    let serverURL = await SecureStorage.getItem("serverURL");
    let password =  await SecureStorage.getItem("password");
    let username =  await SecureStorage.getItem("username");
    let schoolid =  await SecureStorage.getItem("schoolid");

    if (autologin && serverURL && username && password && schoolid) {
      auth(serverURL, username, password, schoolid).then(() => {
        updatePlanView();
      }).catch(error => {
        console.log(error);
        app.toast.create({ text: 'Login Failed' }).open();
        openSettingsScreen();
      });
    } else {
      openSettingsScreen();
      app.toast.create({ text: 'Du musst dich mit deinem LANIS account Anmelden, um diese App zu verwenden!' }).open()
    }
  }
}

init();