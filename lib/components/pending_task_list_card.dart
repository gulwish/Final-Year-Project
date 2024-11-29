import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/hire_list_item.dart';
import '/style/styling.dart';

class HireListItemCard extends StatelessWidget {
  final HireListItem hireListItem;
  final Function removeItem;
  final Function onTap;
  final bool isDismissible;

  const HireListItemCard({
    Key? key,
    required this.hireListItem,
    required this.removeItem,
    required this.onTap,
    this.isDismissible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDismissible
        ? Dismissible(
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) removeItem();
            },
            direction: DismissDirection.endToStart,
            background: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: removeItem as void Function()?,
                    icon: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
            key: Key(hireListItem.taskAd!.taskId!),
            child: ProductCard(
              hireListItem: hireListItem,
              onTap: onTap,
              isDismissible: isDismissible,
            ),
          )
        : ProductCard(
            hireListItem: hireListItem,
            onTap: onTap,
            isDismissible: isDismissible,
          );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(
      {required this.hireListItem,
      required this.onTap,
      Key? key,
      required this.isDismissible})
      : super(key: key);

  final Function onTap;
  final HireListItem hireListItem;
  final isDismissible;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Styling.blueGreyFontColor, width: 0.5),
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.3),
        onTap: onTap as void Function()?,
        isThreeLine: true,
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(hireListItem.taskAd!.thumbnailURL!),
            ),
          ),
        ),
        title: Text(
          hireListItem.taskAd!.title!,
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),
        subtitle: Text(
          isDismissible
              ? 'HRS: ${hireListItem.duration}'
              : 'Rate: ${hireListItem.charges!.toInt()} PKR',
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),
        trailing: Text(
          'Rate: ${hireListItem.charges!.toInt()} PKR',
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
