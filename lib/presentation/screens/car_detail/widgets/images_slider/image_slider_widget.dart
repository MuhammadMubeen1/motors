import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/data/models/car_detail/car_detail_response.dart';
import 'package:motors_app/presentation/screens/car_detail/widgets/images_slider/widgets/video_widget.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:photo_view/photo_view.dart';

class ImageSliderWidget extends StatefulWidget {
  const ImageSliderWidget({Key? key, required this.carDetailResponse}) : super(key: key);

  final CarDetailResponse? carDetailResponse;

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  // final _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.carDetailResponse!.gallery!.isEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.fitWidth,
        imageUrl: '${widget.carDetailResponse?.imgUrl}',
        placeholder: (context, url) => LoaderWidget(
          loaderColor: Colors.white,
        ),
        errorWidget: (context, url, error) => Image.asset('assets/images/placeholder_car.png'),
      );
    }

    return CarouselSlider.builder(
      // carouselController: _carouselController,
      itemCount: widget.carDetailResponse?.gallery?.length ?? null,
      options: CarouselOptions(
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        viewportFraction: 1.0,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          if (_currentIndex != widget.carDetailResponse?.imgCount) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.of(context).push(_createRoute());

            if (result != null) {
              // _carouselController.jumpToPage(result);
            }
          },
          child: Stack(
            children: [
              Image(
                image: NetworkImage(
                  widget.carDetailResponse!.gallery![itemIndex].url,
                ),
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
              // Price
              if (widget.carDetailResponse?.sold ?? false)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorApp.mainColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'sold'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorApp.mainColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.carDetailResponse?.discountPrice ?? (widget.carDetailResponse?.price != null && widget.carDetailResponse!.price != '' ? widget.carDetailResponse!.price : 'No info'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              // Index page
              Positioned(
                bottom: 0.5,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: .0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 3, right: 10, bottom: 3),
                    child: Text(
                      '${_currentIndex + 1}/${widget.carDetailResponse?.gallery?.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.carDetailResponse?.videoCount != 0)
                VideoWidget(
                  videoLink: widget.carDetailResponse?.videoLink,
                  videoCount: widget.carDetailResponse!.videoCount,
                  videoLinks: widget.carDetailResponse!.videoLinks,
                ),
            ],
          ),
        );
      },
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FullSliderScreen(
          gallery: widget.carDetailResponse?.gallery,
          imgCount: widget.carDetailResponse!.imgCount!,
          currentIndex: _currentIndex,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class FullSliderScreen extends StatefulWidget {
  const FullSliderScreen({
    super.key,
    this.gallery,
    required this.imgCount,
    required this.currentIndex,
  });

  final List<GalleryResponse>? gallery;
  final int imgCount;
  final int currentIndex;

  @override
  State<FullSliderScreen> createState() => _FullSliderScreenState();
}

class _FullSliderScreenState extends State<FullSliderScreen> {
  int _currentIndex = 0;
  bool _hideAppBar = false;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _hideAppBar = !_hideAppBar;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Dismissible(
                key: const Key('key'),
                direction: DismissDirection.vertical,
                onDismissed: (_) => Navigator.of(context).pop(_currentIndex),
                resizeDuration: Duration(microseconds: 100),
                child: CarouselSlider.builder(
                  itemCount: widget.gallery?.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return PhotoView(
                      enableRotation: true,
                      imageProvider: NetworkImage(
                        widget.gallery![itemIndex].url,
                      ),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  options: CarouselOptions(
                    initialPage: _currentIndex,
                    enableInfiniteScroll: true,
                    reverse: false,
                    viewportFraction: 1,
                    height: MediaQuery.of(context).size.height / 1.3,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      if (_currentIndex != widget.imgCount) {
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    },
                  ),
                ),
              ),
              if (!_hideAppBar)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      '${_currentIndex + 1}/${widget.gallery?.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (!_hideAppBar)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(_currentIndex),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
