import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';

class ListDocumentsImages extends StatefulWidget {
  String title;
  List<String> imagesUrl;

  ListDocumentsImages({required this.title, required this.imagesUrl});

  @override
  State<ListDocumentsImages> createState() => _ListDocumentsImagesState();
}

class _ListDocumentsImagesState extends State<ListDocumentsImages> {
  @override
  Widget build(BuildContext context) {
    return documentImages(widget.imagesUrl, widget.title);
  }

  Widget documentImages(List<String> imageUrls, String title) {
    return imageUrls.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.titlesTextColor),
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 5,
                children: List.generate(imageUrls.length,
                    (index) => TripImageItem(imageUrls[index])),
              ),
            ],
          )
        : Container();
  }

  Widget imageUrlWithHandle(String url) {
    try {
      return SizedBox(
        height: 110,
        width: 110,
        child: FullScreenWidget(
          disposeLevel: DisposeLevel.Medium,
          child: Hero(
            tag: "customTag",
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  url,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorManager.primary,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ));
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      ImageAssets.newAppBarLogo,
                      color: ColorManager.splashBGColor,
                    );
                  },
                )),
          ),
        ),
      );
    } catch (e) {
      return Image.asset(
        ImageAssets.newAppBarLogo,
        color: ColorManager.splashBGColor,
      );
    }
  }

  Widget TripImageItem(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrlWithHandle(imageUrl),
        ],
      ),
    );
  }
}
