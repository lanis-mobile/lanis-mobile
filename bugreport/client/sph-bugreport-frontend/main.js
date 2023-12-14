import './style.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.js';

document.getElementById("loadDataButton")
    .addEventListener("click", loadData);

const tbody = document.getElementById("tbody");

async function loadData() {
    tbody.innerHTML = "LADE...";
    let token = document.getElementById("token_input").value;
    let data = await fetch(`https://sph-bugreport-service.alessioc42.workers.dev/api/all?access_token=${token}`);
    try {
        let rows = await data.json();

        tbody.innerHTML = "";
        rows.forEach(row => {
            tbody.innerHTML +=
            `
            <tr>
                <td>${escapeHtml(row.id)}</td>
                <td>${escapeHtml(row.username)}</td>
                <td>${escapeHtml(row.report)}</td>
                <td>${escapeHtml(row.contact_information)}</td>
                <td>
                <a href="https://sph-bugreport-service.alessioc42.workers.dev/api/device_data?id=${row.id}&access_token=${token}" target="_blank" class="m-1 btn btn-outline-danger">parsed</a>
                <a href="https://sph-bugreport-service.alessioc42.workers.dev/api/del?id=${row.id}&access_token=${token}" target="_top" class=" m-1 btn btn-outline-danger">DELETE</a>
                </td>
            </tr>
            `
        });
    } catch(e) {
        alert("Error occurred. Maybe the token is invalid or there is an other problem. Look in the console.");
        console.error(e)
    }
}


//https://stackoverflow.com/questions/24816/escaping-html-strings-with-jquery

const entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
};
function escapeHtml (string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
        return entityMap[s];
    });
}
