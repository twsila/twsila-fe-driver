import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import '../state_renderer/dialogs.dart';

class MutliPickImageWidget extends StatefulWidget {
  final Function(List<XFile>? images) onPickedImages;
  const MutliPickImageWidget({Key? key, required this.onPickedImages})
      : super(key: key);

  @override
  State<MutliPickImageWidget> createState() => _MutliPickImageWidgetState();
}

class _MutliPickImageWidgetState extends State<MutliPickImageWidget> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];

  openImages() async {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedfiles = await imgpicker.pickMultiImage();

                        imagefiles = pickedfiles;
                        widget.onPickedImages(imagefiles);
                        setState(() {});
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.gallery.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedfile = await imgpicker.pickImage(
                          source: ImageSource.camera,
                        );

                        imagefiles.add(pickedfile!);
                        widget.onPickedImages(imagefiles);
                        setState(() {});
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.camera.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 8, 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: openImages,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.file_upload_outlined),
                const SizedBox(width: 8),
                Text(
                  AppStrings.attachFurnitureImages.tr(),
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          imagefiles.isNotEmpty
              ? Wrap(
                  children: imagefiles.map((imageone) {
                    return Stack(
                      children: [
                        Card(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(File(imageone.path)),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                imagefiles
                                    .removeAt(imagefiles.indexOf(imageone));
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                )
              : Container()
        ],
      ),
    );
  }
}
