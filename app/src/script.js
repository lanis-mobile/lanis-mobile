import Fuse from 'fuse.js';
import schoolData from './schools.json';
import { Preferences } from '@capacitor/preferences';
import { CapacitorHttp } from '@capacitor/core';

// Initialize app
var app = new Framework7({
  root: '#app',
  name: 'SPH-Plan',
  id: 'io.github.sphplan',
  toast: {
    closeTimeout: 3000,
    closeButton: true,
    position: "top"
  }
});

function openSettingsScreen() {
  app.loginScreen.open('#settings-screen');
  loadSchoolSelect();
}

function closeSettingsScreen() {
  app.loginScreen.close('#settings-screen');
}


//returns whether the user has a valid session or not
async function isLoggedIn() {
  const serverURL = (await Preferences.get({ key: "serverURL" })).value;
  const sid = (await Preferences.get({ key: "sid" })).value;
  const schoolid = (await Preferences.get({ key: "schoolid" })).value;

  if (serverURL && sid && schoolid) {
    let response = await CapacitorHttp.get({
      url: `${serverURL}/api/isValidSession`,
      params: {
        schoolid: schoolid,
        sid: sid
      },
      responseType: "text"
    });

    if (response.status == 200) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

async function login() {
  app.dialog.preloader("Logging in...");

  try {
    let username = document.getElementById("login-username").value;
    let password = document.getElementById("login-password").value;
    let schoolid_raw = document.getElementById("login-schoolid").value
    let schoolid = schoolid_raw.match(/^(\d+)/)[0];
    let serverURL = (document.getElementById("login-instance").value).match(/^(https?:\/\/[a-zA-Z0-9.-]+)(:\d+)?/)[0];


    CapacitorHttp.get({
      url: `${serverURL}/api/login`,
      params: {
        username: username,
        password: password,
        schoolid: schoolid
      },
      responseType: "text"
    }).then(async response => {
      app.dialog.close();
      if (response.status == 200) {
        let sid = await response.data;
        await Preferences.set({ key: "sid", value: sid });
        await Preferences.set({ key: "serverURL", value: serverURL });
        await Preferences.set({ key: "schoolid", value: schoolid });
        await Preferences.set({ key: "username", value: username });
        app.toast.create({ text: 'logged in!' }).open()

        console.log((await Preferences.get({ key: "sid" })).value);
        closeSettingsScreen()
        /*
        TODO: Auto show Plan data. 
        */
      } else if (response.status == 500) {
        app.toast.create({ text: 'login failed!' }).open()
      } else {
        app.toast.create({ text: 'login failed: unknown error' }).open()
      }
    })



  } catch (err) {
    app.dialog.close();
    app.toast.create({ text: 'Login Failed: unknown error' }).open()
  }
}

function createCardItem(data) {
  const listItem = document.createElement('li');
  const card = document.createElement('div');
  card.classList.add('card');

  const cardHeader = document.createElement('div');
  cardHeader.classList.add('card-header');
  cardHeader.innerHTML = `Stunde ${data.Stunde} <strong>${data.Art}</strong>`;
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
      labelCell.style.paddingRight =  "20vw"; // TODO better solution
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
    if (data[key] && !(["Tag_en", "_hervorgehoben", "Tag", "Stunde", "Fach"].includes(key))) {
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
  const serverURL = (await Preferences.get({ key: "serverURL" })).value;
  const sid = (await Preferences.get({ key: "sid" })).value;
  const schoolid = (await Preferences.get({ key: "schoolid" })).value;

  if (serverURL && sid && schoolid) {
    CapacitorHttp.get({
      url: `${serverURL}/api/plan`,
      params: {
        sid: sid,
        schoolid: schoolid
      },
      responseType: "json"
    }).then(async response => {

      let cardContainer = document.getElementById("cardContainer")

      response.data.forEach(entry => {
        cardContainer.appendChild(createCardItem(entry))
      });
    });
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

    let fuse = new Fuse(schools, {
      keys: ["Id", "Name", "Ort"]
    })

    app.autocomplete.create({
      inputEl: '#login-schoolid',
      openIn: 'dropdown',
      source: async (query, render) => {
        let items = fuse.search(query, { limit: 10 });
        items = items.map((item) => `${item.item["Id"]} - ${item.item["Name"]} - ${item.item["Ort"]}`);
        render(items);
      }
    });
  }
}

document.getElementById("openSettingsScreenButton").addEventListener("click", openSettingsScreen);
document.getElementById("closeSettingsScreenButton").addEventListener("click", closeSettingsScreen);
document.getElementById("loginButton").addEventListener("click", login);
document.getElementById("reloadPlanDataButton").addEventListener("click", updatePlanView);

app.tab.show('#instanceConfigTab');
// Event-Handling für das Umschalten zwischen Tabs
app.on('tabShow', function (tabEl) {
  var tabId = tabEl.id;
  app.tab.show(tabId);
});


async function init() {
}
