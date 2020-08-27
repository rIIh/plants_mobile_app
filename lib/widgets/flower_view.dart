import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:image_picker/image_picker.dart';
import 'package:moor/moor.dart' show Value;
import 'package:plants/data/database.dart';
import 'package:plants/viewmodel/flower_view_model.dart';
import 'package:plants/types/link_controller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class FlowerView extends StatelessWidget {
  FlowerViewModel _viewModel;

  TextEditingController _nameController;
  TextEditingController _descriptionController;
  List<LinkController> _linkControllers;

  initFlowerControllers(FlowersCompanion data) {
    _nameController = TextEditingController(text: data?.name?.value ?? '');
    _descriptionController = TextEditingController(text: data?.description?.value ?? '');
  }

  initLinksControllers(List<LinksCompanion> data) {
    _linkControllers = data?.map((e) => LinkController(link: e))?.toList() ?? [];
  }

  FlowerView({Key key, int flowerKey}) : super(key: key) {
    _viewModel = FlowerViewModel(flowerKey, Get.find(), onDelete: () => Get.back());
    initFlowerControllers(null);
    initLinksControllers(null);
    _viewModel.onLoad.listen((event) async {
      final data = (await _viewModel.flower.first);
      initFlowerControllers(data);
    });
    _viewModel.links.where((event) => event.length != _linkControllers.length).listen((event) async {
      final data = (await _viewModel.links.first);
      initLinksControllers(data);
    });
  }

  void loadImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await showCupertinoModalPopup(
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async => Navigator.of(context).pop(
              picker.getImage(source: ImageSource.camera).then((value) => value?.readAsBytes()),
            ),
            child: Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async => Navigator.of(context).pop(
              picker.getImage(source: ImageSource.gallery).then((value) => value?.readAsBytes()),
            ),
            child: Text('Gallery'),
            isDefaultAction: true,
          ),
        ],
      ),
      context: context,
    );

    if (image != null) {
      _viewModel.edit(FlowersCompanion(image: Value(image)));
    }
  }

  Widget _buildImage() => StreamBuilder<FlowersCompanion>(
      stream: _viewModel.flower,
      builder: (context, snapshot) {
        return Stack(
          children: [
            Hero(
              tag: snapshot.data?.id ?? 'null',
              child: snapshot.data?.image?.value != null
                  ? Image.memory(
                      snapshot.data.image.value,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : (snapshot.data?.image?.value != null
                      ? Image.memory(
                          snapshot.data.image.value,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey,
                        )),
            ),
            if (_viewModel.isEditMode)
              Material(
                color: Colors.black45,
                child: InkWell(
                  onTap: () => loadImage(context),
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
      });

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
            if (_viewModel.isExists)
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
                              _viewModel.delete();
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
      enabled: _viewModel.isEditMode,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(hintText: 'Название'),
      onChanged: (value) => _viewModel.edit(
        FlowersCompanion(
          name: Value(value),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      enabled: _viewModel.isEditMode,
      maxLines: null,
      decoration: InputDecoration(hintText: 'Описание'),
      onChanged: (value) => _viewModel.edit(
        FlowersCompanion(
          description: Value(value),
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, int index, LinksCompanion link) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(link.url.value)) {
          launch(link.url.value);
        } else {
          Get.snackbar('Неправильный URL', '');
          print('Wrong URL');
        }
      },
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
            if (_viewModel.isEditMode) ...[
              Expanded(
                child: TextField(
                  controller: _linkControllers[index].name,
                  enabled: _viewModel.isEditMode,
                  decoration: InputDecoration(hintText: 'Name', isCollapsed: true),
                  onChanged: (value) => _viewModel.editLink(index, LinksCompanion(name: Value(value))),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  enabled: _viewModel.isEditMode,
                  controller: _linkControllers[index].url,
                  decoration: InputDecoration(hintText: 'URL', isCollapsed: true),
                  onChanged: (value) => _viewModel.editLink(
                    index,
                    LinksCompanion(
                      url: Value(value),
                    ),
                  ),
                ),
              ),
            ] else
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: _linkControllers[index].name.text.isNotEmpty
                      ? _linkControllers[index].name
                      : _linkControllers[index].url,
                  decoration: InputDecoration(isCollapsed: true),
                ),
              ),
            if (_viewModel.isEditMode)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _viewModel.removeLink(index);
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
              child: StreamBuilder<List<LinksCompanion>>(
                  stream: _viewModel.links,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        ...snapshot.data
                                ?.asMap()
                                ?.entries
                                ?.map(
                                  (entry) => _buildLink(
                                    context,
                                    entry.key,
                                    entry.value,
                                  ),
                                )
                                ?.toList() ??
                            [],
                        if (_viewModel.isEditMode)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              onPressed: () {
                                _viewModel.addLink(LinksCompanion(
                                  url: Value(''),
                                  name: Value(''),
                                ));
                              },
                              child: Text('Добавить'),
                            ),
                          )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.flower.cast().mergeWith([_viewModel.links, _viewModel.mode]),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: StreamBuilder<FlowersCompanion>(
                stream: _viewModel.flower,
                builder: (context, snapshot) => Text(snapshot.data?.name?.value ?? ''),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context, 32),
                  _buildBody(context),
                ],
              ),
            ),
            floatingActionButton: _viewModel.isEditMode && _viewModel.isValid || !_viewModel.isEditMode
                ? FloatingActionButton(
                    onPressed: _viewModel.switchMode,
                    child: Icon(
                      _viewModel.isEditMode ? Icons.check : Icons.edit,
                      color: Colors.white,
                    ),
                  )
                : null,
          );
        });
  }
}
