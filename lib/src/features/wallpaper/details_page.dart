import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reddit_walls/src/services/data.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';
import 'package:reddit_walls/src/utils/extensions.dart';
import 'package:reddit_walls/src/utils/wallpaper_management.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.wallpaper, super.key});

  final Wallpaper wallpaper;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = false;
  late bool _isLiked;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _isLiked = WallpaperDataHandler.isFavourite(widget.wallpaper);
  }

  Future<void> _setwallpaper({required int location}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // ignore: unused_local_variable
      final result = await WallpaperManagementUtility.setWallpaper(
        widget.wallpaper.images.originalImageUrl,
        location,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  Future<void> _saveWallpaper() async {
    setState(() {
      _isDownloading = true;
    });
    try {
      // ignore: unused_local_variable
      final result = await WallpaperManagementUtility.downloadWallpaper(
        widget.wallpaper.subreddit.subredditName,
        widget.wallpaper.images.originalImageUrl,
      );
      setState(() {
        _isDownloading = false;
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      debugPrint(e.toString());
    }
  }

  void _favouriteButtonAction() {
    if (WallpaperDataHandler.isFavourite(widget.wallpaper)) {
      WallpaperDataHandler.remove(widget.wallpaper);
    } else {
      WallpaperDataHandler.add(widget.wallpaper);
    }
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Future<void> _showInfoDialog(
    BuildContext context,
    Wallpaper wallpaper,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('More Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _InfoWidget(
                  keyText: 'Posted By',
                  valueText: 'u/${wallpaper.author}',
                ),
                _InfoWidget(
                  keyText: 'Subreddit',
                  valueText: wallpaper.subreddit.subredditName,
                ),
                _InfoWidget(
                  keyText: 'Resolution',
                  valueText:
                      '${wallpaper.images.width} X ${wallpaper.images.height}',
                ),
                _InfoWidget(
                  keyText: 'Upvotes',
                  valueText: '${wallpaper.upvotes}',
                ),
                _InfoWidget(
                  keyText: 'Posted On',
                  valueText: wallpaper.createdAt.toReadableString(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 8,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: Hero(
                  tag: widget.wallpaper.images.originalImageUrl,
                  child: WallpaperCard(
                    wallpaper: widget.wallpaper,
                    isLiked: _isLiked,
                    onFavouritePressed: _favouriteButtonAction,
                    onInfoPressed: () async => _showInfoDialog(
                      context,
                      widget.wallpaper,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ButtonRow(
                  isLoading: _isLoading,
                  isDownloading: _isDownloading,
                  onWallpaperButtonPressed: () => showWallpaperSetupMenu(
                    context,
                    onHomeScreen: () {
                      _setwallpaper(location: 1);
                      Navigator.of(context).pop();
                    },
                    onLockScreen: () {
                      _setwallpaper(location: 2);
                      Navigator.of(context).pop();
                    },
                    onBoth: () {
                      _setwallpaper(location: 3);
                      Navigator.of(context).pop();
                    },
                  ),
                  onDownloadButtonPressed: _saveWallpaper,
                  onLinkButtonPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    required this.wallpaper,
    required this.isLiked,
    required this.onFavouritePressed,
    required this.onInfoPressed,
    super.key,
  });

  final Wallpaper wallpaper;
  final bool isLiked;
  final VoidCallback onFavouritePressed;
  final VoidCallback onInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: wallpaper.images.originalImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: onFavouritePressed,
              style: _overlayButtonStyle(),
              child: Icon(
                isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_outlined,
                color: isLiked ? Colors.red.shade800 : null,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: onInfoPressed,
              style: _overlayButtonStyle(),
              child: const Icon(
                Icons.info_outline_rounded,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _overlayButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(8),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    required this.isLoading,
    required this.isDownloading,
    required this.onWallpaperButtonPressed,
    required this.onDownloadButtonPressed,
    required this.onLinkButtonPressed,
    super.key,
  });

  final bool isLoading;
  final bool isDownloading;
  final VoidCallback onWallpaperButtonPressed;
  final VoidCallback onDownloadButtonPressed;
  final VoidCallback onLinkButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: ElevatedButton(
              onPressed: onDownloadButtonPressed,
              child: isDownloading
                  ? SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        color: context.colorScheme.onInverseSurface,
                      ),
                    )
                  : const Icon(
                      Icons.download,
                      size: 16,
                    ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 16,
            child: ElevatedButton(
              onPressed: onWallpaperButtonPressed,
              child: isLoading
                  ? SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        color: context.colorScheme.onInverseSurface,
                      ),
                    )
                  : Text(
                      'Set Wallpaper',
                      style: context.textTheme.titleMedium!.copyWith(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onInverseSurface,
                      ),
                    ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: ElevatedButton(
              onPressed: onLinkButtonPressed,
              child: const Icon(
                Icons.open_in_new,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.keyText,
    required this.valueText,
  });
  final String keyText;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$keyText: ',
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: valueText,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showWallpaperSetupMenu(
  BuildContext context, {
  required VoidCallback onLockScreen,
  required VoidCallback onHomeScreen,
  required VoidCallback onBoth,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Set Your Wallpaper',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...[
                {'title': 'Home Screen', 'onPressed': onHomeScreen},
                {'title': 'Lock Screen', 'onPressed': onLockScreen},
                {'title': 'Home & Lock Screen', 'onPressed': onBoth},
              ].map((button) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: button['onPressed']! as VoidCallback,
                      child: Text(
                        button['title']! as String,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: context.colorScheme.onInverseSurface,
                                ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
