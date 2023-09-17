import { LocalNotifications } from '@capacitor/local-notifications';
import { SecureStorage } from '@aparajita/capacitor-secure-storage';

/**
 * @returns {Promise<boolean>} permissions
 */

let counter = 0;


export async function getPermissions() {
    let permissionsState = await LocalNotifications.checkPermissions();

    switch (permissionsState.display) {
        case "prompt":
            let perm = await LocalNotifications.requestPermissions()
            if (perm.display == "granted") return true;
            if (perm.display == "denied") return false;
            break;
        case "granted":
            return true;
        case "denied":
            return false;
        case "prompt-with-rationale":
            return false;
    }
    alert(JSON.stringify(permissionsState));
}

export async function createNotificationsFromPlanData(data) {
    let dataAlreadyDone = {};
    try {
        const storedData = await SecureStorage.getItem("notifications-done");
        dataAlreadyDone = storedData ? JSON.parse(storedData) : {};
    } catch (_err) {
        dataAlreadyDone = {};
    }

    const notifications = [];
    const twoDaysAgo = new Date();
    twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

    data.forEach(row => {
        const UUID = (Object.keys(row).map(key => row[key])).join("");
        const creationDate = new Date();

        if (!(UUID in dataAlreadyDone) || new Date(dataAlreadyDone[UUID]) < twoDaysAgo) {
            const [day, month, year] = row.Tag.split(".");
            const tag = new Date(year, month - 1, day).toLocaleDateString('de-DE', { weekday: 'short', year: 'numeric', month: 'numeric', day: 'numeric' }).split(',')[0];
            counter += 1;

            // Filter and map non-null and non-undefined values for the title
            const titleValues = [
                tag,
                row.Stunde,
                row.Art,
                row.Raum,
                row.Klasse,
            ].filter(value => value !== null && value !== undefined);

            // Filter and map non-null and non-undefined values for largeBody
            const largeBodyValues = [
                `${tag}-${row.Tag}`,
                row.Stunde,
                row.Art,
                row.Raum,
                `Fach: ${row.Fach}`,
                `Lehrer: ${row.Lehrer}`,
                `Vertreter: ${row.Vertreter}`,
                row.Hinweis,
                row.Hinweis2,
            ].filter(value => value !== null && value !== undefined);

            notifications.push({
                title: titleValues.join(', '),
                largeBody: largeBodyValues.join('\n'),
                id: counter,
                smallIcon: 'house',
                actionTypeId: 'OPEN_PRODUCT'
            });

            dataAlreadyDone[UUID] = creationDate.toISOString();
        }
    });

    // Filter out UUIDs that are older than 2 days
    for (const UUID in dataAlreadyDone) {
        if (new Date(dataAlreadyDone[UUID]) < twoDaysAgo) {
            delete dataAlreadyDone[UUID];
        }
    }

    await SecureStorage.setItem("notifications-done", JSON.stringify(dataAlreadyDone));
    await LocalNotifications.schedule({ notifications: notifications });
}
