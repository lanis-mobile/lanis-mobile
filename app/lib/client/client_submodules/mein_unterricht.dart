import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/client/client.dart';

import '../../shared/apps.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../shared/types/upload.dart';

class MeinUnterrichtParser {
  late Dio dio;
  late SPHclient client;

  MeinUnterrichtParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<dynamic> getOverview() async {
    if (!client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
      throw NotSupportedException();
    }

    debugPrint("Get Mein Unterricht overview");

    var result = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

    final response =
        await dio.get("https://start.schulportal.hessen.de/meinunterricht.php");
    var encryptedHTML = client.cryptor.decryptEncodedTags(response.data);
    var document = parse(encryptedHTML);

    //Aktuelle Einträge
    () {
      var schoolClasses = document.querySelectorAll("tr.printable");
      for (var schoolClass in schoolClasses) {
        var teacher = schoolClass.querySelector(".teacher");

        if (schoolClass.querySelector(".datum") != null) {
          result["aktuell"]?.add({
            "name": schoolClass.querySelector(".name")?.text.trim(),
            "teacher": {
              "short": teacher
                  ?.getElementsByClassName(
                      "btn btn-primary dropdown-toggle btn-xs")[0]
                  .text
                  .trim(),
              "name":
                  teacher?.querySelector("ul>li>a>i.fa")?.parent?.text.trim()
            },
            "thema": {
              "title": schoolClass.querySelector(".thema")?.text.trim(),
              "date": schoolClass.querySelector(".datum")?.text.trim()
            },
            "data": {
              "entry": schoolClass.attributes["data-entry"],
              "book": schoolClass.attributes["data-entry"]
            },
            "_courseURL":
                schoolClass.querySelector("td>h3>a")?.attributes["href"]
          });
        }

        //sort by date
        result["aktuell"]?.sort((a, b) {
          var aDate = a["thema"]["date"];
          var bDate = b["thema"]["date"];

          var aDateTime = DateTime(int.parse(aDate.split(".")[2]),
              int.parse(aDate.split(".")[1]), int.parse(aDate.split(".")[0]));
          var bDateTime = DateTime(int.parse(bDate.split(".")[2]),
              int.parse(bDate.split(".")[1]), int.parse(bDate.split(".")[0]));

          return bDateTime.compareTo(aDateTime);
        });
      }
    }();

    //Anwesenheiten
    var anwesendDOM = document.getElementById("anwesend");
    () {
      var thead = anwesendDOM?.querySelector("thead>tr");
      var tbody = anwesendDOM?.querySelectorAll("tbody>tr");

      var keys = [];
      thead?.children.forEach((element) => keys.add(element.text.trim()));

      tbody?.forEach((elem) {
        var textElements = [];
        for (var i = 0; i < elem.children.length; i++) {
          var element = elem.children[i];
          element.querySelector("div.hidden.hidden_encoded")?.innerHtml = "";

          if (keys[i] != "Kurs") {
            textElements.add(element.text.trim());
          } else {
            textElements.add(element.text.trim());
          }
        }

        var rowEntry = {};

        for (int i = 0; i < keys.length; i++) {
          var key = keys[i];
          var value = textElements[i];

          rowEntry[key] = value;
        }

        //get url of course
        var hyperlinkToCourse = elem.getElementsByTagName("a")[0];
        rowEntry["_courseURL"] = hyperlinkToCourse.attributes["href"];

        result["anwesenheiten"]?.add(rowEntry);
      });
    }();

    //Kursmappen
    var kursmappenDOM = document.getElementById("mappen");
    () {
      var parsedMappen = [];

      var mappen = kursmappenDOM?.getElementsByClassName("row")[0].children;

      if (mappen != null) {
        for (var mappe in mappen) {
          parsedMappen.add({
            "title": mappe.getElementsByTagName("h2")[0].text.trim(),
            "teacher": mappe
                .querySelector("div.btn-group>button")
                ?.attributes["title"],
            "_courseURL":
                mappe.querySelector("a.btn.btn-primary")?.attributes["href"]
          });
        }
        result["kursmappen"] = parsedMappen;
      } else {
        result["kursmappen"] = [];
      }
    }();

    debugPrint("Successfully got Mein Unterricht.");
    return result;
  }

  Future<dynamic> getCourseView(String url) async {
    try {
      var result = {
        "historie": [],
        "leistungen": [],
        "leistungskontrollen": [],
        "anwesenheiten": [],
        "halbjahr1": [],
        "name": ["name"],
      };

      String courseID = url.split("id=")[1];

      final response =
          await dio.get("https://start.schulportal.hessen.de/$url");
      var encryptedHTML = client.cryptor.decryptEncodedTags(response.data);
      var document = parse(encryptedHTML);

      //course name
      var heading = document.getElementById("content")?.querySelector("h1");
      heading?.children[0].innerHtml = "";
      result["name"] = [heading?.text.trim()];

      //halbjahr2
      var halbJahrButtons =
          document.getElementsByClassName("btn btn-default hidden-print");
      if (halbJahrButtons.length > 1) {
        if (halbJahrButtons[0].attributes["href"]!.contains("&halb=1")) {
          result["halbjahr1"] = [halbJahrButtons[0].attributes["href"]];
        }
      }

      //historie
      () {
        var historySection = document.getElementById("history");
        var tableRows = historySection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((tableRow) {
          tableRow.children[2]
              .querySelector("div.hidden.hidden_encoded")
              ?.innerHtml = "";

          Map<String, String> markups = {};

          // There is also a css selector :has() but it's not implemented yet.
          final String? content = tableRow.children[1]
              .querySelector("span.markup i.far.fa-comment-alt:first-child")
              ?.parent
              ?.text
              .trim();
          if (content != null && content.startsWith(" ")) {
            markups["content"] = content.substring(1);
          } else if (content != null) {
            markups["content"] = content;
          }

          final String? homework = tableRow.children[1]
              .querySelector("span.homework + br + span.markup")
              ?.text
              .trim();
          bool homeworkDone = false;

          if (homework != null) {
            homeworkDone =
                tableRow.querySelectorAll("span.done.hidden").isEmpty;
            if (homework.startsWith(" ")) {
              markups["homework"] = homework.substring(1);
            } else {
              markups["homework"] = homework;
            }
          }

          List files = [];
          if (tableRow.children[1].querySelector("div.alert.alert-info") !=
              null) {
            String baseURL = "https://start.schulportal.hessen.de/";
            baseURL += tableRow.children[1]
                .querySelector("div.alert.alert-info>a")!
                .attributes["href"]!;
            baseURL = baseURL.replaceAll("&b=zip", "");

            for (var fileDiv
                in tableRow.getElementsByClassName("files")[0].children) {
              String? filename = fileDiv.attributes["data-file"];
              files.add({
                "filename": filename,
                "filesize": fileDiv.querySelector("a>small")?.text,
                "url": "$baseURL&f=$filename",
              });
            }
          }

          List uploads = [];
          final uploadGroups =
              tableRow.children[1].querySelectorAll("div.btn-group");
          for (final uploadGroup in uploadGroups) {
            final openUpload = uploadGroup.querySelector(".btn-warning");
            final closedUpload = uploadGroup.querySelector(".btn-default");

            const String baseURL = "https://start.schulportal.hessen.de/";

            if (openUpload != null) {
              uploads.add({
                "name": openUpload.nodes[2].text?.trim(),
                "status": "open",
                "link": baseURL +
                    uploadGroup
                        .querySelector("ul.dropdown-menu li a")!
                        .attributes["href"]!,
                "uploaded": openUpload.querySelector("span.badge")?.text,
                "date": openUpload
                    .querySelector("small")
                    ?.text
                    .replaceAll("\n", "")
                    .replaceAll(
                        "                                                                ",
                        "")
                    .replaceAll("bis ", "")
                    .replaceAll("um", ""),
              });
            } else if (closedUpload != null) {
              uploads.add({
                "name": closedUpload.nodes[2].text?.trim(),
                "status": "closed",
                "link": baseURL +
                    uploadGroup
                        .querySelector("ul.dropdown-menu li a")!
                        .attributes["href"]!,
                "uploaded": closedUpload.querySelector("span.badge")?.text,
                "date": null,
              });
            }
          }

          result["historie"]?.add({
            "time": tableRow.children[0].text
                .trim()
                .replaceAll("  ", "")
                .replaceAll("\n", " ")
                .replaceAll("  ", " "),
            "title": tableRow.children[1].querySelector("big>b")?.text.trim(),
            "markup": markups,
            "entry-id": tableRow.attributes["data-entry"],
            "course-id": courseID,
            "homework-done": homeworkDone,
            "presence": tableRow.children[2].text.trim(),
            "files": files,
            "uploads": uploads
          });
        });
      }();

      //anwesenheiten
      () {
        var presenceSection = document.getElementById("attendanceTable");
        var tableRows = presenceSection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((row) {
          var encodedElements = row.getElementsByClassName("hidden_encoded");
          for (var e in encodedElements) {
            e.innerHtml = "";
          }

          result["anwesenheiten"]?.add({
            "type": row.children[0].text.trim(),
            "count": row.children[1].text.trim()
          });
        });
      }();

      //leistungen
      () {
        var marksSection = document.getElementById("marks");
        var tableRows = marksSection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((row) {
          var encodedElements = row.getElementsByClassName("hidden_encoded");
          for (var e in encodedElements) {
            e.innerHtml = "";
          }

          if (row.children.length == 3) {
            result["leistungen"]?.add({
              "Name": row.children[0].text.trim(),
              "Datum": row.children[1].text.trim(),
              "Note": row.children[2].text.trim()
            });
          }
        });
      }();

      //leistungskontrollen
      () {
        var examSection = document.getElementById("klausuren");
        var lists = examSection?.children;

        lists?.forEach((element) {
          String exams = "";

          final elements = element.querySelectorAll("ul li");

          for (var element in elements) {
            //todo better solution that splitting the string with "  ...  "
            var exam = element.text.trim().split(
                "                                                                                                    ");
            exams +=
                "${exam.first.trim()} ${exam.last != exam.first ? exam.last.trim() : ""}";
            if (element != elements.last) {
              exams += "\n";
            }
          }

          result["leistungskontrollen"]?.add({
            "title": element.querySelector("h1,h2,h3,h4,h5,h6")?.text.trim(),
            "value": exams == "" ? "Keine Daten!" : exams
          });
        });
      }();

      return result;
    } catch (e, stack) {
      throw LoggedOffOrUnknownException();
    }
  }

  Future<dynamic> setHomework(
      String courseID, String courseEntry, bool status) async {
    //returns the response of the http request. 1 means success.

    final response = await dio.post(
      "https://start.schulportal.hessen.de/meinunterricht.php",
      data: {
        "a": "sus_homeworkDone",
        "entry": courseEntry,
        "id": courseID,
        "b": status ? "done" : "undone"
      },
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "X-Requested-With": "XMLHttpRequest", //this is important
        },
      ),
    );

    return response.data;
  }

  Future<String> deleteUploadedFile(
      {required String course,
      required String entry,
      required String upload,
      required String file,
      required String userPasswordEncrypted}) async {
    try {
      final response = await dio.post(
          "https://start.schulportal.hessen.de/meinunterricht.php",
          data: {
            "a": "sus_abgabe",
            "d": "delete",
            "b": course,
            "e": entry,
            "id": upload,
            "f": file,
            "pw": userPasswordEncrypted
          },
          options: Options(
            headers: {
              "Accept": "*/*",
              "Content-Type":
                  "application/x-www-form-urlencoded; charset=UTF-8",
              "Sec-Fetch-Dest": "empty",
              "Sec-Fetch-Mode": "cors",
              "Sec-Fetch-Site": "same-origin",
              "X-Requested-With": "XMLHttpRequest",
            },
          ));

      // "-1" Wrong password
      // "-2" Delete was not possible
      // "0" Unknown error
      // "1" Lanis had a good day
      return response.data;
    } on (SocketException, DioException) {
      throw NetworkException();
    } catch (e, stack) {
      throw LoggedOffOrUnknownException();
    }
  }

  Future<dynamic> getUploadInfo(String url) async {
    try {
      final response = await dio.get(url);
      final parsed = parse(response.data);

      final requirementsGroup =
          parsed.querySelectorAll("div#content div.row div.col-md-12")[1];

      final String? start = requirementsGroup
          .querySelector("span.editable")
          ?.text
          .trim()
          .replaceAll(" ab", "");
      final String? deadline = requirementsGroup
          .querySelector("b span.editable")
          ?.text
          .trim()
          .replaceAll("  spätestens", "");
      final bool uploadMultipleFiles = requirementsGroup
                  .querySelectorAll(
                      "i.fa.fa-check-square-o.fa-fw + span.label.label-success")[0]
                  .text
                  .trim() ==
              "erlaubt"
          ? true
          : false;
      final bool uploadAnyNumberOfTimes = requirementsGroup
                  .querySelectorAll(
                      "i.fa.fa-check-square-o.fa-fw + span.label.label-success")[1]
                  .text
                  .trim() ==
              "erlaubt"
          ? true
          : false;
      final String? visibility = requirementsGroup
              .querySelector("i.fa.fa-eye.fa-fw + span.label")
              ?.text
              .trim() ??
          requirementsGroup
              .querySelector("i.fa.fa-eye-slash.fa-fw + span.label")
              ?.text
              .trim();
      final String? automaticDeletion = requirementsGroup
          .querySelector("i.fa.fa-trash-o.fa-fw + span.label.label-info")
          ?.text
          .trim();
      final List<String> allowedFileTypes = requirementsGroup
          .querySelectorAll("i.fa.fa-file.fa-fw + span.label.label-warning")[0]
          .text
          .trim()
          .split(", ");
      final String maxFileSize = requirementsGroup
          .querySelectorAll("i.fa.fa-file.fa-fw + span.label.label-warning")[1]
          .text
          .trim();
      final String? additionalText = requirementsGroup
          .querySelector("div.alert.alert-info")
          ?.text
          .split("\n")[1]
          .trim();

      final ownFilesGroup =
          parsed.querySelectorAll("div#content div.row div.col-md-12")[2];
      final List<OwnFile> ownFiles = [];
      for (final group in ownFilesGroup.querySelectorAll("ul li")) {
        final fileIndex = RegExp(r"f=(\d+)");

        ownFiles.add(OwnFile(
            name: group.querySelector("a")!.text.trim(),
            url:
                "https://start.schulportal.hessen.de/${group.querySelector("a")!.attributes["href"]!}",
            time: group.querySelector("small")!.text,
            index: fileIndex
                .firstMatch(group.querySelector("a")!.attributes["href"]!)!
                .group(1)!,
            comment: group.nodes.elementAtOrNull(10) != null
                ? group.nodes[10].text!.trim()
                : null));
      }

      final uploadForm = parsed.querySelector("div.col-md-7 form");
      String? courseId;
      String? entryId;
      String? uploadId;

      if (uploadForm != null) {
        courseId =
            uploadForm.querySelector("input[name='b']")!.attributes["value"]!;
        entryId =
            uploadForm.querySelector("input[name='e']")!.attributes["value"]!;
        uploadId =
            uploadForm.querySelector("input[name='id']")!.attributes["value"]!;
      }

      final publicFilesGroup =
          parsed.querySelector("div#content div.row div.col-md-5");
      final List<PublicFile> publicFiles = [];

      if (publicFilesGroup != null) {
        for (final group in publicFilesGroup.querySelectorAll("ul li")) {
          final fileIndex = RegExp(r"f=(\d+)");

          publicFiles.add(PublicFile(
            name: group.querySelector("a")!.text.trim(),
            url:
                "https://start.schulportal.hessen.de/${group.querySelector("a")!.attributes["href"]!}",
            person: group.querySelector("span.label.label-info")!.text.trim(),
            index: fileIndex
                .firstMatch(group.querySelector("a")!.attributes["href"]!)!
                .group(1)!,
          ));
        }
      }

      return {
        "start": start,
        "deadline": deadline,
        "upload_multiple_files": uploadMultipleFiles,
        "upload_any_number_of_times": uploadAnyNumberOfTimes,
        "visibility": visibility,
        "automatic_deletion": automaticDeletion,
        "allowed_file_types": allowedFileTypes,
        "max_file_size": maxFileSize,
        "course_id": courseId,
        "entry_id": entryId,
        "upload_id": uploadId,
        "own_files": ownFiles,
        "public_files": publicFiles,
        "additional_text": additionalText,
      };
    } on (SocketException, DioException) {
      throw NetworkException();
    } catch (e, stack) {
      throw LoggedOffOrUnknownException();
    }
  }

  Future<List<FileStatus>> uploadFile({
    required String course,
    required String entry,
    required String upload,
    required MultipartFile file1,
    MultipartFile? file2,
    MultipartFile? file3,
    MultipartFile? file4,
    MultipartFile? file5,
  }) async {
    try {
      final FormData uploadData = FormData.fromMap({
        "a": "sus_abgabe",
        "b": course,
        "e": entry,
        "id": upload,
        "file1": file1,
        "file2": file2,
        "file3": file3,
        "file4": file4,
        "file5": file5
      });

      final response = await dio.post(
          "https://start.schulportal.hessen.de/meinunterricht.php",
          data: uploadData,
          options: Options(headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data;",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "same-origin",
          }));

      final parsed = parse(response.data);

      final statusMessagesGroup =
          parsed.querySelectorAll("div#content div.col-md-12")[2];

      final List<FileStatus> statusMessages = [];
      for (final statusMessage
          in statusMessagesGroup.querySelectorAll("ul li")) {
        statusMessages.add(FileStatus(
          name: statusMessage.querySelector("b")!.text.trim(),
          status: statusMessage.querySelector("span.label")!.text.trim(),
          message: statusMessage.nodes[4].text?.trim(),
        ));
      }

      return statusMessages;
    } on (SocketException, DioException) {
      throw NetworkException();
    } catch (e, stack) {
      throw LoggedOffOrUnknownException();
    }
  }
}
