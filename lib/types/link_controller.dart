import 'package:flutter/material.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:plants/data/database.dart';


class LinkController {
  final int id;
  final TextEditingController name;
  final TextEditingController url;
  void Function(LinksCompanion data) onLinkChange;

  onChange() {
    onLinkChange?.call(LinksCompanion(
      id: Value(id),
      name: Value(name.text),
      url: Value(url.text),
    ));
  }

  LinkController({
    @required LinksCompanion link,
    this.onLinkChange,
  })  : id = link.id.value,
        name = TextEditingController.fromValue(
          TextEditingValue(
            text: link.name?.value ?? '',
          ),
        ),
        url = TextEditingController.fromValue(
          TextEditingValue(
            text: link.url.value,
          ),
        );
}