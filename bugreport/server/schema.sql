DROP TABLE IF EXISTS Reports;
CREATE TABLE IF NOT EXISTS Reports (id integer PRIMARY KEY AUTOINCREMENT, username TEXT, report TEXT, time_stamp TEXT, contact_information TEXT, device_data TEXT);
INSERT INTO Reports (username, report, contact_information, device_data, time_stamp) VALUES ('5182.user1.name1', 'this feature does not seem to work well... Here is how I made the error:', 'some.mail@server.none', '{here is the data...}', 'Sun Dec 10 2023 12:18:52 GMT+0100 (Central European Standard Time) ');

DROP TABLE IF EXISTS Developers;
CREATE TABLE IF NOT EXISTS Developers (id integer PRIMARY KEY AUTOINCREMENT, github_username TEXT, access_token TEXT);
--INSERT INTO Developers (github_username, access_token) VALUES ('alessioC42', 'example');
--Access tokens are set in cloudflare admin panel