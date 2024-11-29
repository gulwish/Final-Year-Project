import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaamsay/components/loading_widgets.dart';
import 'package:provider/provider.dart';

import '../providers/task_categories_provider.dart';

class KaamSayCategoriesList extends StatefulWidget {
  const KaamSayCategoriesList({Key? key, required this.categories})
      : super(key: key);
  final List categories;

  @override
  State<KaamSayCategoriesList> createState() => _KaamSayCategoriesListState();
}

class _KaamSayCategoriesListState extends State<KaamSayCategoriesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView(
        onPageChanged: (page) {
          setState(() {
            Provider.of<TaskCategoriesProvider>(context, listen: false)
                .setSelectedCategoryIndex(page);
          });
        },
        physics: const BouncingScrollPhysics(),
        controller: PageController(viewportFraction: 1),
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        children: <Widget>[
          for (int i = 0; i < widget.categories.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    //   boxShadow: [
                    //     BoxShadow(
                    //         blurStyle: BlurStyle.outer,
                    //         blurRadius: 13,
                    //         spreadRadius: 1,
                    //         offset: Offset(4, 4),
                    //         color: Colors.grey.shade300)
                    //   ],
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: widget.categories[i].thumbnail,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            color: Colors.black45,
                            colorBlendMode: BlendMode.darken,
                            placeholder: (context, str) => const CircularProgress(),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.categories[i].name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
