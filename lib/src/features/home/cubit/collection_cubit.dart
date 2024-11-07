import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';

enum CollectionStatus { initial, success, failure }

final class CollectionState extends Equatable {
  const CollectionState({
    this.collections = const {},
    this.selectedCollections = const {},
    this.collectionStatus = CollectionStatus.initial,
  });

  final Set<Subreddit> collections;
  final Set<Subreddit> selectedCollections;
  final CollectionStatus collectionStatus;

  @override
  List<Object> get props =>
      [collectionStatus, collections, selectedCollections];
  CollectionState copyWith({
    Set<Subreddit>? collections,
    Set<Subreddit>? selectedCollections,
    CollectionStatus? collectionStatus,
  }) {
    return CollectionState(
      collections: collections ?? this.collections,
      selectedCollections: selectedCollections ?? this.selectedCollections,
      collectionStatus: collectionStatus ?? this.collectionStatus,
    );
  }
}

class CollectionNotifier extends Notifier<CollectionState> {
  void addToCollection(Subreddit subreddit) {
    final newCollection = {...state.collections, subreddit};
    state = state.copyWith(
      collections: newCollection,
      collectionStatus: CollectionStatus.success,
    );
  }

  void removeCollection(Set<Subreddit> subreddits) {
    final collection = {...state.collections}
      ..removeWhere((sub) => subreddits.contains(sub));
    state = state.copyWith(
      collections: collection,
      collectionStatus: CollectionStatus.success,
    );
  }

  void removeSelectedCollection() {
    state = state.copyWith(
      selectedCollections: {},
      collectionStatus: CollectionStatus.success,
    );
  }

  bool isInCollections(Subreddit subreddit) {
    return state.collections.contains(subreddit);
  }

  bool isInSelected(Subreddit subreddit) {
    return state.selectedCollections.contains(subreddit);
  }

  void performMultiSelect(Subreddit subreddit) {
    if (isInSelected(subreddit)) {
      state = state.copyWith(
        selectedCollections: {...state.selectedCollections}
          ..removeWhere((item) => item == subreddit),
        collectionStatus: CollectionStatus.success,
      );
    } else {
      state = state.copyWith(
        selectedCollections: {...state.selectedCollections, subreddit},
        collectionStatus: CollectionStatus.success,
      );
    }
  }

  @override
  CollectionState build() {
    return const CollectionState();
  }
}

final collectionNotifierProvider =
    NotifierProvider<CollectionNotifier, CollectionState>(
  CollectionNotifier.new,
);
