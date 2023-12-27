import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import '../../client/client.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:styled_text/styled_text.dart';
import 'package:marked/marked.dart';

import '../../shared/errorView.dart';

class DetailedConversationAnsicht extends StatefulWidget {
  final String uniqueID;
  final String? title;

  const DetailedConversationAnsicht(
      {super.key, required this.uniqueID, required this.title});

  @override
  State<DetailedConversationAnsicht> createState() =>
      _DetailedConversationAnsichtState();
}

class _DetailedConversationAnsichtState
    extends State<DetailedConversationAnsicht> {
  late final Future<dynamic> _getSingleConversation;

  void showSnackbar(String text, {seconds = 1, milliseconds = 0}) {
    if (mounted) {
      // Hide the current SnackBar if one is already visible.
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          duration: Duration(seconds: seconds, milliseconds: milliseconds),
        ),
      );
    }
  }

  Future<dynamic> fetchConversation({secondTry = false}) async {
    try {
      if (secondTry) {
        await client.login();
      }

      return client.getSingleConversation(widget.uniqueID);
    } catch (e) {
      if (!secondTry) {
        fetchConversation(secondTry: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getSingleConversation = fetchConversation();
  }

  Widget getConversationWidget(
      Map<String, dynamic> conversation, bool rootMessage) {
    final contentParsed = parse(conversation["Inhalt"]);
    final content = contentParsed.body!.text;

    final usernameParsed = parse(conversation["username"]);
    final username =
        usernameParsed.querySelector("span")?.text ?? conversation["username"];

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    username == " , " ? Icons.person_off : Icons.person,
                    size: 18,
                  ),
                ),
                Text(
                  username == " , " ? "Kein Name" : username,
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            ),
          ),
          // Do not show title again in a comment.
          if (rootMessage) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Text(
                      conversation["Betreff"],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                /*Flexible(
                  flex: 10,
                  child: Linkify(
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(link.url))) {
                        showSnackbar(
                            '${link.url} konnte nicht geöffnet werden.');
                      }
                    },
                    text: content,
                    style: Theme.of(context).textTheme.bodyMedium,
                    linkStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                )*/
                Flexible(
                  flex: 10,
                  child: StyledText(
                    text: convertLanisSyntax("""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc porttitor erat in condimentum laoreet. Sed velit sapien, vehicula et tristique hendrerit, porta quis metus. Integer euismod velit sed erat porta consequat. Donec a imperdiet ante. Integer euismod diam ornare mi blandit facilisis a sed justo. Curabitur vehicula sit amet leo vitae bibendum. Pellentesque scelerisque cursus mattis. Fusce ultrices ipsum eget eros vulputate gravida.

fett wird zu **fett**
unterstrichen wird zu __unterstrichen__
entfernt wird zu --entfernt--
~~italic~~
- Aufzählung 1
- Aufzählung 2
- Aufzählung 3
Quellcode wird zu `Lorem ipsum`
Langer Quellcode wird zu `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc porttitor erat in condimentum laoreet. Sed velit sapien, vehicula et tristique hendrerit, porta quis metus. Integer euismod velit sed erat porta consequat. Donec a imperdiet ante. Integer euismod diam ornare mi blandit facilisis a sed justo. Curabitur vehicula sit amet leo vitae bibendum. Pellentesque scelerisque cursus mattis. Fusce ultrices ipsum eget eros vulputate gravida.`
Datum v1  12.04.2018 
Datum v1  12.04.18
Datum v2  (12.04.2018) 
Datum v2  (12.04.18)
Uhrzeitenangabe 11:13
Link https://example.com/
Linkkürzung https://example.com/abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyz_abcdefghijklmnopqrstuvwxyz
Email test@example.com
Zahl sonderfall v1 _1 
Zahl sonderfall v1 _(1)
Zahlen sonderfall v1 _(123)
Zahl sonderfall v2 ^1 
Zahl sonderfall v2 ^(1)
Zahlen sonderfall v2 ^(123)"""),
                    tags: {
                      "bold": StyledTextTag(
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      "underline": StyledTextTag(
                          style: const TextStyle(
                              decoration: TextDecoration.underline)),
                      "italic": StyledTextTag(
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                      "remove": StyledTextTag(
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough)),
                      "code": StyledTextWidgetBuilderTag(
                          (context, _, textContent) => Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.25),
                                  ),
                                  child: Text(
                                    textContent!,
                                    style: const TextStyle(
                                      fontFamily: "Roboto Mono",
                                    ),
                                  ),
                                ),
                          )),
                      "subscript": StyledTextTag(
                          style: const TextStyle(
                              fontFeatures: [FontFeature.subscripts()])),
                      "superscript": StyledTextTag(
                          style: const TextStyle(
                              fontFeatures: [FontFeature.superscripts()])),
                      "url": StyledTextWidgetBuilderTag(
                          (context, attributes, textContent) => Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: InkWell(
                                  onTap: () async {
                                    if (!await launchUrl(
                                        Uri.parse(attributes["link"]!))) {
                                      showSnackbar(
                                          '${attributes["link"]} konnte nicht geöffnet werden.');
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 7, right: 8, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Icon(Icons.link,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          Flexible(
                                            child: Text(
                                              textContent!,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                          )),
                      "email": StyledTextWidgetBuilderTag(
                          (context, attributes, textContent) => Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: InkWell(
                                  onTap: () async {
                                    if (!await launchUrl(
                                        Uri.parse(attributes["address"]!))) {
                                      showSnackbar(
                                          '${attributes["address"]} konnte nicht geöffnet werden.');
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 7, right: 8, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.25),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Icon(
                                              Icons.email_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              textContent!,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                          )),
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  conversation["Datum"],
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String convertLanisSyntax(String lanisStyledText) {
    final lanisToXML = Markdown.map({
      "**": (text, match) => "<bold>$text</bold>",
      "__": (text, match) => "<underline>$text</underline>",
      "~~": (text, match) => "<italic>$text</italic>",
      "--": (text, match) => "<remove>$text</remove>",
      r"regexp: - (.*)": (text, match) => "\u2022 $text", // \u2022 = •
      "`": (text, match) => "<code>$text</code>",
      "```": (text, match) => "<code>$text</code>",
      r"regexp: _(\d) ": (text, match) => "<subscript>$text</subscript>",
      r"regexp: _\((\d*)\)": (text, match) => "<subscript>$text</subscript>",
      r"regexp: \^(\d) ": (text, match) => "<superscript>$text</superscript>",
      r"regexp: \^\((\d*)\)": (text, match) =>
          "<superscript>$text</superscript>",
    });

    final List<LinkifyElement> linkifiedElements = linkify(lanisStyledText,
        options: const LinkifyOptions(humanize: true, removeWww: true),
        linkifiers: const [EmailLinkifier(), UrlLinkifier()]);

    String linkifiedText = "";

    for (LinkifyElement element in linkifiedElements) {
      if (element is UrlElement) {
        linkifiedText += "<url link='${element.url}'>${element.text}</url>";
      } else if (element is EmailElement) {
        linkifiedText +=
            "<email address='${element.url}'>${element.text}</email>";
      } else {
        linkifiedText += element.text;
      }
    }

    return lanisToXML.apply(linkifiedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Nachricht"),
      ),
      body: FutureBuilder(
          future: _getSingleConversation,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              // Error content
              if (snapshot.data is int) {
                return ErrorView(
                  data: snapshot.data,
                  fetcher: null,
                );
              }
              // Successful content
              return ListView.builder(
                  itemCount: snapshot.data["reply"].length + 1,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Shows on the first comment a "reply" icon.
                        if (index == 1) ...[
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Transform.flip(
                                    flipY: true,
                                    child: const Icon(Icons.reply)),
                              ),
                            ),
                          ),
                        ],
                        // Make a empty box to align it with the first comment.
                        if (index >= 2) ...[
                          const Flexible(
                            flex: 1,
                            child: SizedBox.shrink(),
                          )
                        ],
                        Flexible(
                          flex: 10,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: Card(
                                  // Get root conversation widget or comments.
                                  child: getConversationWidget(
                                      index == 0
                                          ? snapshot.data
                                          : snapshot.data["reply"][index - 1],
                                      index == 0 ? true : false))),
                        ),
                      ],
                    );
                  });
            }
            // Waiting content
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
