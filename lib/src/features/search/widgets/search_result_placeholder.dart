import 'package:flutter/material.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class SearchResultCardPlaceholder extends StatelessWidget {
  const SearchResultCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      color: context.colorScheme.surfaceContainerLowest,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.surfaceContainerHighest,
        ),
        title: Container(
          height: 16,
          width: 120,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        trailing: SizedBox(
          height: 32,
          width: 32,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultPlaceholderLayout extends StatelessWidget {
  const SearchResultPlaceholderLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => const SearchResultCardPlaceholder(),
    );
  }
}
