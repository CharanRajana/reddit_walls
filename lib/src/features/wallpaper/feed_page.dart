import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reddit_walls/src/features/home/cubit/collection_cubit.dart';
import 'package:reddit_walls/src/features/wallpaper/widgets/wallpaper_grid_card.dart';
import 'package:reddit_walls/src/features/wallpaper/widgets/wallpaper_grid_card_placeholder.dart';
import 'package:reddit_walls/src/services/reddit_wallpaper_client/lib/reddit_wallpaper_client.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';
import 'package:reddit_walls/src/utils/debouncer.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({required this.subreddit, super.key});

  final Subreddit subreddit;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isFilterVisible = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFilterVisible) {
          setState(() {
            _isFilterVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFilterVisible) {
          setState(() {
            _isFilterVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CustomSliverAppBar(
                  subreddit: widget.subreddit,
                  onAddButtonPressed: () {
                    final isExists = context
                        .read<CollectionNotifier>()
                        .isInCollections(widget.subreddit);
                    if (isExists) {
                      context
                          .read<CollectionNotifier>()
                          .addToCollection(widget.subreddit);
                    } else {
                      context
                          .read<CollectionNotifier>()
                          .removeCollection({widget.subreddit});
                    }
                  },
                ),
              ];
            },
            body: Stack(
              children: [
                TabBarView(
                  children: Sort.values.map((sort) {
                    return Feed(
                      sort: sort,
                      subreddit: widget.subreddit,
                      scrollController: _scrollController,
                    );
                  }).toList(),
                ),
                AnimatedOpacity(
                  opacity: _isFilterVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: FeedFilter(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Feed extends StatefulWidget {
  const Feed({
    required this.sort,
    required this.subreddit,
    required this.scrollController,
    super.key,
  });

  final Sort sort;
  final Subreddit subreddit;
  final ScrollController scrollController;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String _after = '';
  final wallpaperRepository = WallpaperRepository();
  final _debouncer = Debouncer(milliseconds: 500);
  final List<Wallpaper> _wallpapers = [];
  @override
  void initState() {
    super.initState();

    fetchWallpapers();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _debouncer.run(fetchWallpapers);
    }
  }

  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> fetchWallpapers() async {
    final wallpaperResponse = await wallpaperRepository.getWallpapers(
      subreddit: widget.subreddit,
      after: _after,
      sort: widget.sort,
    );
    if (!mounted) return;

    setState(() {
      _wallpapers.addAll(wallpaperResponse.wallpapers);
      _after = wallpaperResponse.after ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => fetchWallpapers(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomScrollView(
            slivers: [
              if (_wallpapers.isEmpty)
                const WallpaperGridPlaceHolderLayout()
              else
                SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: _wallpapers.length,
                  itemBuilder: (context, index) => WallpaperGridCard(
                    key: ValueKey(_wallpapers[index].images.originalImageUrl),
                    wallpaper: _wallpapers[index],
                    height: index.isEven ? 400 : 200,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedFilter extends StatelessWidget {
  const FeedFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.colorScheme.inverseSurface;
    final onSelectedColor = context.colorScheme.onInverseSurface;

    return PreferredSize(
      preferredSize: const Size.fromHeight(52),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                color: onSelectedColor,
              ),
              child: TabBar(
                indicatorPadding: const EdgeInsets.all(6),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: selectedColor,
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                ),
                labelColor: onSelectedColor,
                unselectedLabelColor: selectedColor,
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                  Tab(text: 'Year'),
                  Tab(text: 'All'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({required this.onPressed, required this.isAdded, super.key});

  final VoidCallback onPressed;
  final bool isAdded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: onPressed,
        icon: Icon(isAdded ? Icons.check_circle : Icons.add),
        label: Text(isAdded ? 'Added' : 'Add'),
      ),
    );
  }
}

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    required this.subreddit,
    required this.onAddButtonPressed,
    super.key,
  });

  final Subreddit subreddit;
  final VoidCallback onAddButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 40,
            bottom: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 64),
              Text(
                subreddit.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              AddButton(
                onPressed: onAddButtonPressed,
                isAdded: context
                    .read<CollectionNotifier>()
                    .isInCollections(subreddit),
              ),
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      title: Text(
        subreddit.subredditName,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: true,
      floating: true,
      pinned: true,
    );
  }
}
