import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:moor/moor.dart' hide Column;
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/utils/matchers.dart';

enum DetailMode { present, edit }

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

class FlowerPageController extends GetxController {
  final FlowersDao _dao;
  final int id;
  Rx<FlowerWithLinks> model = Rx();

  FlowerPageController(this.id, this._dao);

  @override
  void onInit() async {
    model.bindStream(_dao.watch(id));
  }

  var mode = Rx<DetailMode>();
  var image = Rx<File>();
  var isValid = Rx<bool>();
  var linkControllers = Rx<List<LinkController>>();
}

class GFlowerPage extends StatelessWidget {
  FlowerPageController controller;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  final void Function(FlowerWithLinksInsertable value) onSubmit;
  final void Function() onDelete;

  void validate() {
    controller.isValid.value = _nameController.text.isNotEmpty;
  }

  static TextEditingController _createController(String initialValue, void Function() validate) =>
      TextEditingController.fromValue(
        TextEditingValue(text: initialValue ?? ''),
      )..addListener(validate ?? () {});

  GFlowerPage(
    int id, {
    DetailMode mode = DetailMode.present,
    this.onDelete,
    this.onSubmit,
  }) {
    controller = FlowerPageController(id, Get.find());
    _nameController = _createController(controller.model.value?.flower?.name, validate);
    _descriptionController = _createController(controller.model.value?.flower?.description, null);
    controller.linkControllers.value = controller.model.value?.links
            ?.map(
              (link) => LinkController(
                link: link.toCompanion(true),
              ),
            )
            ?.toList() ??
        [];
    controller.isValid.value = _nameController.text.isNotEmpty;
  }

  void loadImage() async {
    final image = await FilePicker.getFile(
      type: FileType.image,
    );
    controller.image.value = image;
  }

  void switchMode() {
    if (controller.mode.value == DetailMode.edit) {
      submit();
    }
    controller.mode.value = DetailMode.values.where(notEquals(to: controller.mode.value)).first;
  }

  void submit() {
    onSubmit?.call(
      FlowerWithLinksInsertable(
        flower: FlowersCompanion(
          id: controller.model.value?.flower?.id != null ? Value(controller.model.value.flower.id) : Value.absent(),
          name: Value(_nameController.text),
          description: Value(_descriptionController.text),
          image: controller.image.value != null
              ? Value(
                  controller.image.value?.readAsBytesSync(),
                )
              : Value.absent(),
        ),
        links: controller.linkControllers.value
            .map(
              (e) => LinksCompanion(
                id: e.id != null ? Value(e.id) : Value.absent(),
                url: Value(e.url.text),
                name: Value(e.name.text),
              ),
            )
            .toList(),
      ),
    );
  }

  bool get isEditMode => controller.mode.value == DetailMode.edit;

  Widget _buildImage() => Stack(
        children: [
          controller.image.value != null
              ? Image.file(
                  controller.image.value,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : (controller.model.value?.flower?.image != null
                  ? Image.memory(
                      controller.model.value.flower.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container()),
          if (isEditMode)
            Material(
              color: Colors.black45,
              child: InkWell(
                onTap: loadImage,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 32,
                      height: 32,
                      color: Colors.white24,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      );

  Widget _buildHeader(BuildContext context, double radius) => SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            _buildImage(),
            SafeArea(
              child: BackButton(
                color: Colors.white,
              ),
            ),
            if (controller.model.value != null)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    color: Colors.white,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Удалить?'),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Нет',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Colors.grey.shade700,
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete?.call();
                            },
                            child: Text(
                              'Да',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: -0.2,
              height: 32,
              left: 0,
              right: 0,
              child: Container(
                height: radius,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildName(BuildContext context) {
    return TextField(
      controller: _nameController,
      enabled: isEditMode,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(hintText: 'Название'),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      enabled: isEditMode,
      maxLines: null,
      decoration: InputDecoration(hintText: 'Описание'),
    );
  }

  Widget _buildLink(BuildContext context, int index, LinkController controller) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.link,
              size: 12,
            ),
            SizedBox(
              width: 8,
            ),
            if (isEditMode) ...[
              Expanded(
                child: TextField(
                  enabled: isEditMode,
                  controller: controller.name,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  enabled: isEditMode,
                  controller: controller.url,
                  decoration: InputDecoration(hintText: 'URL'),
                ),
              ),
            ] else
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: controller.name.text.isEmpty ? controller.url : controller.name,
                ),
              ),
            if (isEditMode)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  this.controller.linkControllers.update((value) {
                    value.removeAt(index);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(22.0).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            _buildName(context),
            SizedBox(
              height: 12,
            ),
            _buildDescription(context),
            SizedBox(
              height: 16,
            ),
            Text(
              'Links',
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  ...controller.linkControllers.value
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildLink(context, entry.key, entry.value),
                      )
                      .toList(),
                  if (isEditMode)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        onPressed: () {
                          controller.linkControllers.update((value) {
                            value.add(LinkController(
                                link: LinksCompanion(
                                    url: Value(''), name: Value(''), flower: Value(controller.model.value.flower.id))));
                          });
                        }
                        //setState(() {
                        //_linkControllers.add(LinkController(link: Link(url: '', name: '')));
                        //}),
                        ,
                        child: Text('Добавить'),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, 32),
              _buildBody(context),
            ],
          ),
        ),
        floatingActionButton: isEditMode && controller.isValid.value || !isEditMode
            ? FloatingActionButton(
                onPressed: switchMode,
                child: Icon(
                  isEditMode ? Icons.check : Icons.edit,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}

class FlowerPage extends StatefulWidget {
  final FlowerWithLinks tuple;
  final void Function(FlowerWithLinksInsertable value) onSubmit;
  final void Function() onDelete;

  FlowerPage({
    this.tuple,
    this.onSubmit,
    Key key,
    this.onDelete,
  }) : super(key: key);

  @override
  _FlowerPageState createState() => _FlowerPageState(
        tuple,
        mode: tuple?.flower?.id == null ? DetailMode.edit : null,
        onSubmit: onSubmit,
        onDelete: onDelete,
      );
}

class _FlowerPageState extends State<FlowerPage> {
  DetailMode mode;
  File _image;

  TextEditingController _nameController;
  TextEditingController _descriptionController;
  List<LinkController> _linkControllers;
  final void Function(FlowerWithLinksInsertable value) onSubmit;
  final void Function() onDelete;

  bool isValid;

  void validate() {
    setState(() {
      isValid = _nameController.text.isNotEmpty;
    });
  }

  static TextEditingController _createController(String initialValue, void Function() validate) =>
      TextEditingController.fromValue(
        TextEditingValue(text: initialValue ?? ''),
      )..addListener(validate ?? () {});

  _FlowerPageState(
    FlowerWithLinks tuple, {
    this.mode = DetailMode.present,
    this.onDelete,
    this.onSubmit,
  }) {
    _nameController = _createController(tuple?.flower?.name, validate);
    _descriptionController = _createController(tuple?.flower?.description, null);
    _linkControllers = tuple?.links
            ?.map(
              (link) => LinkController(link: link.toCompanion(true)),
            )
            ?.toList() ??
        [];
    isValid = _nameController.text.isNotEmpty;
  }

  void loadImage() async {
    final image = await FilePicker.getFile(
      type: FileType.image,
    );

    setState(() {
      _image = image;
    });
  }

  void switchMode() {
    if (mode == DetailMode.edit) {
      submit();
    }

    setState(() {
      mode = DetailMode.values.where(notEquals(to: mode)).first;
    });
  }

  void submit() {
    onSubmit?.call(
      FlowerWithLinksInsertable(
        flower: FlowersCompanion(
          id: widget.tuple?.flower?.id != null ? Value(widget.tuple.flower.id) : Value.absent(),
          name: Value(_nameController.text),
          description: Value(_descriptionController.text),
          image: _image != null
              ? Value(
                  _image?.readAsBytesSync(),
                )
              : Value.absent(),
        ),
        links: _linkControllers
            .map(
              (e) => LinksCompanion(
                id: e.id != null ? Value(e.id) : Value.absent(),
                url: Value(e.url.text),
                name: Value(e.name.text),
              ),
            )
            .toList(),
      ),
    );
  }

  bool get isEditMode => mode == DetailMode.edit;

  Widget _buildImage() => Stack(
        children: [
          _image != null
              ? Image.file(
                  _image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : (widget.tuple?.flower?.image != null
                  ? Image.memory(
                      widget.tuple.flower.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container()),
          if (isEditMode)
            Material(
              color: Colors.black45,
              child: InkWell(
                onTap: loadImage,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 32,
                      height: 32,
                      color: Colors.white24,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      );

  Widget _buildHeader(double radius) => SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            _buildImage(),
            SafeArea(
              child: BackButton(
                color: Colors.white,
              ),
            ),
            if (widget.tuple != null)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    color: Colors.white,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Удалить?'),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Нет',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Colors.grey.shade700,
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete?.call();
                            },
                            child: Text(
                              'Да',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: -0.2,
              height: 32,
              left: 0,
              right: 0,
              child: Container(
                height: radius,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildName(BuildContext context) {
    return TextField(
      controller: _nameController,
      enabled: isEditMode,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(hintText: 'Название'),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      enabled: isEditMode,
      maxLines: null,
      decoration: InputDecoration(hintText: 'Описание'),
    );
  }

  Widget _buildLink(BuildContext context, int index, LinkController controller) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.link,
              size: 12,
            ),
            SizedBox(
              width: 8,
            ),
            if (isEditMode) ...[
              Expanded(
                child: TextField(
                  enabled: isEditMode,
                  controller: controller.name,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  enabled: isEditMode,
                  controller: controller.url,
                  decoration: InputDecoration(hintText: 'URL'),
                ),
              ),
            ] else
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: controller.name.text.isEmpty ? controller.url : controller.name,
                ),
              ),
            if (isEditMode)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(
                  () {
                    _linkControllers.removeAt(index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(22.0).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            _buildName(context),
            SizedBox(
              height: 12,
            ),
            _buildDescription(context),
            SizedBox(
              height: 16,
            ),
            Text(
              'Links',
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  ..._linkControllers
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildLink(context, entry.key, entry.value),
                      )
                      .toList(),
                  if (isEditMode)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        onPressed: () => setState(() {
                          _linkControllers.add(
                            LinkController(
                              link: LinksCompanion(
                                url: Value(''),
                                name: Value(''),
                              ),
                            ),
                          );
                        }),
                        child: Text('Добавить'),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(32),
            _buildBody(context),
          ],
        ),
      ),
      floatingActionButton: isEditMode && isValid || !isEditMode
          ? FloatingActionButton(
              onPressed: switchMode,
              child: Icon(
                isEditMode ? Icons.check : Icons.edit,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
