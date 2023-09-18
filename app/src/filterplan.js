import { SecureStorage } from "@aparajita/capacitor-secure-storage";

function ifUndefinedEmptyString(obj) {
    if (!obj) { return "" } else return obj;
}


export async function filter(data) {
    const klassenstufe = ifUndefinedEmptyString(await SecureStorage.getItem("klassenstufe"));
    const klassenbuchstabe = ifUndefinedEmptyString(await SecureStorage.getItem("klassenbuchstabe"));
    const lehrerfilter = ifUndefinedEmptyString(await SecureStorage.getItem("lehrerfilter"));

    return data.filter(entry => {
        let teacherFilter = true;
        if (lehrerfilter) {
            teacherFilter = (entry.Lehrer == lehrerfilter || entry.Vertreter == lehrerfilter || entry.Lehrerkuerzel == lehrerfilter || entry.Vertreterkuerzel == lehrerfilter)
        }
        return entry.Klasse.includes(klassenstufe) && entry.Klasse.includes(klassenbuchstabe) && teacherFilter;
    });
}