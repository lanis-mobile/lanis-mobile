import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

Widget styledTextWidget(String text) {
  return StyledText(
    text: text,
    tags: {
      "bold": StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
      "underline": StyledTextTag(
          style: const TextStyle(decoration: TextDecoration.underline)),
      "italic":
      StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic)),
      "remove": StyledTextTag(
          style: const TextStyle(decoration: TextDecoration.lineThrough)),
      "code": StyledTextWidgetBuilderTag((context, _, textContent) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Container(
          padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.25),
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
          style: const TextStyle(fontFeatures: [FontFeature.subscripts()])),
      "superscript": StyledTextTag(
          style: const TextStyle(fontFeatures: [FontFeature.superscripts()])),
      "date": StyledTextWidgetBuilderTag((context, _, textContent) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(Icons.calendar_today,
                size: 20, color: Theme.of(context).colorScheme.primary),
          ),
          Flexible(
            child: Text(
              textContent!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
      "time": StyledTextWidgetBuilderTag((context, _, textContent) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(Icons.access_time_filled,
                size: 20, color: Theme.of(context).colorScheme.primary),
          ),
          Flexible(
            child: Text(
              textContent!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
      "url": StyledTextWidgetBuilderTag((context, attributes, textContent) =>
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: InkWell(
              onTap: () async {
                if (!await launchUrl(Uri.parse(attributes["link"]!))) {
                  debugPrint(
                      '${attributes["link"]} konnte nicht geöffnet werden.');
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                  padding:
                  const EdgeInsets.only(left: 7, right: 8, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(Icons.link,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Flexible(
                        child: Text(
                          textContent!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )),
            ),
          )),
      "email": StyledTextWidgetBuilderTag((context, attributes, textContent) =>
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: InkWell(
              onTap: () async {
                if (!await launchUrl(Uri.parse(attributes["address"]!))) {
                  debugPrint(
                      '${attributes["address"]} konnte nicht geöffnet werden.');
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                  padding:
                  const EdgeInsets.only(left: 7, right: 8, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          textContent!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    },
  );
}
