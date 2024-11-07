import 'package:equatable/equatable.dart';

class SubredditResponse extends Equatable {
  const SubredditResponse({required this.after, required this.subreddits});

  final String? after;
  final List<Subreddit> subreddits;

  @override
  List<Object?> get props => [after, subreddits];

  SubredditResponse copyWith({String? after, List<Subreddit>? wallpapers}) {
    return SubredditResponse(
      after: after ?? this.after,
      subreddits: wallpapers ?? subreddits,
    );
  }
}

class Subreddit extends Equatable {
  const Subreddit({
    required this.subredditName,
    required this.subscribersCount,
    this.description,
    this.iconImageUrl,
    this.bannerImageUrl,
    this.primaryColor,
  });

  final String subredditName;
  final int subscribersCount;
  final String? description;
  final String? iconImageUrl;
  final String? bannerImageUrl;
  final String? primaryColor;

  @override
  List<Object?> get props => [subredditName, subscribersCount];
}
