import Fuse from 'fuse.js';
import schoolData from './schools.json';
import { Preferences } from '@capacitor/preferences';



// Initialize app
var app = new Framework7({
    root: '#app',
    name: 'SPH-Plan',
    id: 'io.github.sphplan',
});

function openSettingsScreen() {
    app.loginScreen.open('#settings-screen');
    loadSchoolSelect();
}

function closeSettingsScreen() {
    app.loginScreen.close('#settings-screen');
}


//returns whether the user has a valid session or not
async function loggedIn() {
    const serverURL = (await Preferences.get({key: "serverURL"})).value;
    const sid = (await Preferences.get({key: "sid"})).value;
    const schoolid = (await Preferences.get({key: "schoolid"})).value;

    if (serverURL && sid && schoolid) {
        let response = await fetch(`${serverURL}/isValidSession?schoolid=${schoolid}&sid=${sid}`);
        if (response.status == 200) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}


var schoolSelectAlreadyLoaded = false;
function loadSchoolSelect() {
    if (!schoolSelectAlreadyLoaded) {
        schoolSelectAlreadyLoaded = true;

        let schools = [];
        Array.from(schoolData).forEach(landkreis => {
            schools = schools.concat(landkreis.Schulen);
        });

        console.log(schools)

        let fuse = new Fuse(schools, {
            keys: ["Id", "Name", "Ort"]
        })

        app.autocomplete.create({
            inputEl: '#school-dropdown',
            openIn: 'dropdown',
            source: async (query, render) => {
                let items = fuse.search(query, {limit: 10});
                console.log(items)
                items = items.map((item) => `${item.item["Id"]} - ${item.item["Name"]} - ${item.item["Ort"]}`);
                render(items);
            }
        });
    }
}

document.getElementById("openSettingsScreenButton").addEventListener("click", () => {
    openSettingsScreen()
})

app.tab.show('#instanceConfigTab');
// Event-Handling für das Umschalten zwischen Tabs
app.on('tabShow', function (tabEl) {
    var tabId = tabEl.id;
    app.tab.show(tabId);
});


async function init() {
    
}