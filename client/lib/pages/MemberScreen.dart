import 'package:flutter/material.dart';
import 'package:client/provider/memberImages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/FullScreenImage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberScreen extends ConsumerStatefulWidget {
  String? selectedTeamNo;
  MemberScreen({super.key, required this.selectedTeamNo});

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends ConsumerState<MemberScreen> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    ref
        .read(memberImagesProvider.notifier)
        .fetchMemberImages(widget.selectedTeamNo);
  }

  @override
  Widget build(BuildContext context) {
    final mem_images = ref.watch(memberImagesProvider);

    // Kiểm tra xem danh sách hình ảnh có trống không
    if (mem_images.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final circle_list = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(mem_images.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                selectedIndex == index ? const Color(0xff068288) : Colors.grey,
          ),
        );
      }),
    );

    final carousel = CarouselSlider.builder(
      options: CarouselOptions(
        height: 150.h,
        viewportFraction: 0.6,
        onPageChanged: (index, reason) {
          setState(() {
            selectedIndex = index; // Cập nhật selectedIndex khi thay đổi trang
          });
        },
      ),
      itemCount: mem_images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () {
            // Khi nhấn vào hình ảnh, điều hướng đến màn hình hiển thị hình ảnh toàn màn hình
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FullScreenImage(selectedIndex: index),
              ),
            );
          },
          child: Container(
            width: 1.sw,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: const BoxDecoration(color: Colors.amber),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                mem_images[index].memberfileimages,
                // width: 250.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        );
      },
    );

    return SizedBox(
      child: Column(
        children: [
          carousel,
          SizedBox(height: 10.h),
          circle_list,
        ],
      ),
    );
  }
}
