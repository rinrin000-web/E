import 'package:client/pages/constants.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:client/provider/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Searchbar extends ConsumerStatefulWidget {
  final int? eventId;
  const Searchbar({super.key, required this.eventId});

  @override
  ConsumerState<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends ConsumerState<Searchbar> {
  late TextEditingController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   final searchQuery = ref.read(searchProvider);
  //   _controller = TextEditingController(text: searchQuery);
  // }
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final searchQuery = ref.watch(searchProvider);
    _controller.text = searchQuery;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchProvider);
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();

    return
        // Center(
        Container(
      height: 46.h,
      width: 1.sw,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xff068288),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xff068288)),
      ),
      child: TextField(
        controller: _controller,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: '作品番号検索 I25-105',
          hintStyle: const TextStyle(color: Color(0xff62B9BE)),
          prefixIcon: GestureDetector(
            onTap: () {
              final query = _controller.text;
              ref.read(searchProvider.notifier).updateQuery(query);
              ref
                  .read(teamListProvider.notifier)
                  .searchByTeamNo(query, widget.eventId);
            },
            child: const Icon(Icons.search, color: Colors.black),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.black26),
            onPressed: () {
              _controller.clear();
              ref.read(searchProvider.notifier).updateQuery('');
              ref
                  .read(teamListProvider.notifier)
                  .fetchTeamsbyId(widget.eventId);
            },
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          border: InputBorder.none,
        ),
        onSubmitted: (query) {
          // Tìm kiếm khi nhấn Enter
          try {
            ref.read(searchProvider.notifier).updateQuery(query);
            ref
                .read(teamListProvider.notifier)
                .searchByTeamNo(query, widget.eventId);
          } catch (e) {
            ShowSnackBarE.showSnackBar(context, 'Error: $e');
          }
        },
      ),
      // ),
    );
  }
}
