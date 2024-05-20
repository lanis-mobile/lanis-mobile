// https://stackoverflow.com/questions/74126807/how-to-scroll-and-animate-an-object-onto-an-app-bar

import 'package:flutter/material.dart';

class DynamicAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final Text title;
  final List<Widget> expanded;
  final double maxHeaderHeight;

  const DynamicAppBar({super.key, required this.scrollController, required this.title, required this.expanded, this.maxHeaderHeight = 200});

  @override
  State<DynamicAppBar> createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends State<DynamicAppBar> {
  final ValueNotifier<double> opacity = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(scrollListener);
    scrollListener();
  }

  scrollListener() {
    if (widget.maxHeaderHeight > widget.scrollController.offset && widget.scrollController.offset > 1) {
      opacity.value = 1 - widget.scrollController.offset / widget.maxHeaderHeight;
    } else if (widget.scrollController.offset > widget.maxHeaderHeight && opacity.value != 1) {
      opacity.value = 0;
    } else if (widget.scrollController.offset <= 0) {
      opacity.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: ValueListenableBuilder<double>(
          valueListenable: opacity,
          builder: (context, value, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 1),
              opacity: 1 - value,
              child: widget.title
            );
          }),
      pinned: true,
      expandedHeight: widget.maxHeaderHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.expanded
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}