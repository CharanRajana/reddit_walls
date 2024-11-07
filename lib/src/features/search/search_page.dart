import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_walls/src/features/home/cubit/collection_cubit.dart';
import 'package:reddit_walls/src/features/search/widgets/search_result_placeholder.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';
import 'package:reddit_walls/src/utils/debouncer.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late FocusNode _searchBarFocusNode;
  late TextEditingController _searchTextEditingController;
  final wallpaperRepository = WallpaperRepository();
  final _debouncer = Debouncer(milliseconds: 800);
  List<Subreddit> _subreddits = [];

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode = FocusNode();
    _searchTextEditingController = TextEditingController();
    Future.delayed(const Duration(milliseconds: 350), () {
      _searchBarFocusNode.requestFocus();
    });
  }

  Future<void> _searchSubreddits(String query) async {
    _debouncer.run(() async {
      final subredditResponse = await wallpaperRepository.searchSubreddits(
        query: query,
      );
      if (!mounted) return;

      setState(() {
        _subreddits = subredditResponse.subreddits;
      });
    });
  }

// Dispose
  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    _searchTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Hero(
            tag: '_subredditSearchToggle',
            child: Material(
              color: Colors.transparent,
              child: CustomSearchBar(
                searchBarFocusNode: _searchBarFocusNode,
                searchTextEditingController: _searchTextEditingController,
                onChanged: (text) {
                  setState(() {
                    _searchSubreddits(text.trim());
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _searchTextEditingController.text.isEmpty
            ? const SizedBox.shrink()
            : _subreddits.isEmpty
                ? const SearchResultPlaceholderLayout()
                : ListView.builder(
                    itemCount: _subreddits.length,
                    itemBuilder: (context, index) {
                      final subreddit = _subreddits[index];

                      return Consumer(
                        builder: (context, ref, child) {
                          // final state = ref.watch(collectionNotifierProvider);
                          final collectionsNotifier =
                              ref.read(collectionNotifierProvider.notifier);
                          final isExists = ref
                              .watch(collectionNotifierProvider.notifier)
                              .isInCollections(subreddit);
                          return SearchResultCard(
                            subreddit: subreddit,
                            onAddButtonPressed: () {
                              if (isExists) {
                                collectionsNotifier.addToCollection(subreddit);
                              } else {
                                collectionsNotifier
                                    .removeCollection({subreddit});
                              }
                            },
                            isExists: isExists,
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.subreddit,
    required this.onAddButtonPressed,
    required this.isExists,
    super.key,
  });

  final Subreddit subreddit;
  final VoidCallback onAddButtonPressed;
  final bool isExists;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.surfaceContainerLowest,
      elevation: 0.3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: subreddit.iconImageUrl.isNull
            ? const CircleAvatar(
                child: Icon(
                  Icons.reddit_rounded,
                  size: 32,
                ),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(
                  subreddit.iconImageUrl!,
                ),
              ),
        title: Text(
          subreddit.subredditName,
          style: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${subreddit.subscribersCount.format} Subscribers',
          style: context.textTheme.labelLarge,
        ),
        trailing: SizedBox(
          height: 32,
          width: 32,
          child: IconButton.filledTonal(
            padding: EdgeInsets.zero,
            onPressed: onAddButtonPressed,
            icon: Icon(isExists ? Icons.check_circle : Icons.add),
          ),
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    required FocusNode searchBarFocusNode,
    required TextEditingController searchTextEditingController,
    super.key,
    this.onChanged,
    this.onSubmitted,
  })  : _searchBarFocusNode = searchBarFocusNode,
        _searchTextEditingController = searchTextEditingController;

  final FocusNode _searchBarFocusNode;
  final TextEditingController _searchTextEditingController;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: SearchBar(
        focusNode: _searchBarFocusNode,
        controller: _searchTextEditingController,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        elevation: const WidgetStatePropertyAll(0.5),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: context.colorScheme.onSurface,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        trailing: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.search,
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
        hintText: 'Search for a subreddit',
      ),
    );
  }
}
