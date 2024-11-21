import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/favorite_provider.dart';

class TeamFavoriteWidget extends ConsumerStatefulWidget {
  final String? userEmail;
  final String? teamNo;
  const TeamFavoriteWidget({
    Key? key,
    required this.userEmail,
    required this.teamNo,
  }) : super(key: key);
  @override
  _TeamFavoriteSate createState() => _TeamFavoriteSate();
}

class _TeamFavoriteSate extends ConsumerState<TeamFavoriteWidget> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).fetchFavorite(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteList = ref.watch(favoriteProvider);

    final isFavorite = favoriteList.any(
      (favorite) =>
          favorite.team_no == widget.teamNo && (favorite.is_favorite ?? false),
    );

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 30,
      ),
      onPressed: () async {
        try {
          if (isFavorite) {
            await ref
                .read(favoriteProvider.notifier)
                .deleteFavorite(widget.userEmail, widget.teamNo);
          } else {
            await ref
                .read(favoriteProvider.notifier)
                .createFavorite(widget.userEmail, widget.teamNo);
          }
          await ref
              .read(favoriteProvider.notifier)
              .fetchFavorite(widget.userEmail);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Không thể thay đổi trạng thái yêu thích: $error')),
          );
        }
      },
    );
  }
}
