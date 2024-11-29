import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaamsay/components/categories_list.dart';
import 'package:kaamsay/constants/values.dart';
import 'package:kaamsay/screens/user_screens/notifications_screen.dart';
import 'package:kaamsay/utils/storage_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/user_model.dart';
import '/models/task_category.dart';
import '/providers/task_categories_provider.dart';
import '/screens/user_screens/task_details.dart';
import '../../components/flush_bar.dart';
import '../../components/loading_widgets.dart';
import '../../models/task_ad.dart';
import '../../providers/user_location_provider.dart';
import '../../resources/firebase_repository.dart';
import '../../style/images.dart';
import '../../style/styling.dart';
import '../../utils/utilities.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main-page';
  const MainPage({
    required this.duration,
    required this.firebaseRepository,
    required this.toggleDrawer,
    Key? key,
  }) : super(key: key);

  final Duration duration;
  final FirebaseRepository firebaseRepository;
  final VoidCallback toggleDrawer;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    Utils.changeStatusBarBrightness(Brightness.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TaskCategory> categories =
        Provider.of<TaskCategoriesProvider>(context).categories;
    TaskCategoriesProvider categoriesProvider =
        Provider.of<TaskCategoriesProvider>(context);

    return Material(
      animationDuration: widget.duration,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              toolbarHeight: 40,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: widget.toggleDrawer,
                  child:
                      Icon(Icons.menu, color: Theme.of(context).primaryColor)),
              title: SvgPicture.asset(
                Images.logoVectorB,
                height: 35,
              ),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  child: Icon(CupertinoIcons.bell,
                          color: Theme.of(context).primaryColor)
                      .px(16),
                  onTap: () async {
                    // showInfoDialog(context,
                    //     'Notification feature will be available soon.');
                    Navigator.pushNamed(context, NotificationsScreen.routeName);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            KaamSayCategoriesList(categories: categories),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: LottieBuilder.asset(
                    Images.liveDotAnim,
                    height: 12,
                  ),
                ),
                8.widthBox,
                Text(
                  "Workers Nearby",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            12.heightBox,
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 32,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (s) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'What are you looking for today?',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      size: 18,
                    ),
                    border: InputBorder.none,
                  ),
                )),
            12.heightBox,
            categories.isEmpty
                ? Center(
                    child: CircularProgress(
                    color: Theme.of(context).primaryColor,
                  ))
                : Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: widget.firebaseRepository.getTasksByCategory(
                            categories[categoriesProvider.selectedCategoryIndex]
                                .id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || categories.isEmpty) {
                            return Center(
                              child: CircularProgress(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return NoResultsWidget();
                          }

                          // Search thingy
                          var filteredTasksList = snapshot.data!.docs
                              .filter((element) => TaskAd.fromMap(
                                      element.data() as Map<String, dynamic>)
                                  .title!
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()))
                              .toList();

                          if (filteredTasksList.isEmpty) {
                            return NoResultsWidget();
                          }
                          return FutureBuilder<
                                  List<QueryDocumentSnapshot<Object?>>>(
                              future: filterLabourersByLocation(
                                  context, filteredTasksList),
                              builder: (c, s) {
                                if (!s.hasData) {
                                  return Center(
                                    child: CircularProgress(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );
                                }
                                if (s.data!.isEmpty) {
                                  return NoResultsWidget(
                                    noNearby: true,
                                  );
                                }
                                var finalTasks = s.data!;
                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    TaskAd taskAd = TaskAd.fromMap(
                                        finalTasks[index].data()
                                            as Map<String, dynamic>);

                                    // return (taskAd.description!.toUpperCase() ==
                                    //             categories[categoriesProvider
                                    //                     .selectedCategoryIndex]
                                    //                 .name
                                    //                 .toUpperCase() ||
                                    //         categories[categoriesProvider
                                    //                     .selectedCategoryIndex]
                                    //                 .name ==
                                    //             "All") ?
                                    return Column(
                                      children: [
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onTap: () => Navigator.pushNamed(
                                              context, TaskDetails.routeName,
                                              arguments: {
                                                'taskAd': taskAd,
                                              }),
                                          leading: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        taskAd.thumbnailURL!)),
                                          ),
                                          title: Text(
                                            taskAd.title!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            taskAd.description!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    Styling.blueGreyFontColor),
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Rs ${taskAd.baseRate}/hr',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              4.heightBox,
                                              SizedBox(
                                                width: 100,
                                                child: FutureBuilder(
                                                    future: Utils
                                                        .getAverageRatingAndCountFromQuerySnapshot(
                                                            taskAd),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        var data = snapshot.data
                                                            as Map;
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .star_rate_rounded,
                                                              size: 20,
                                                              color: Colors
                                                                  .amber
                                                                  .shade600,
                                                            ),
                                                            Text(
                                                                '${data["counter"] == 0 ? "0.00" : ((data["rating"] / data["counter"]) as double).toStringAsFixed(2)} (${data["counter"]})',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Styling
                                                                      .blueGreyFontColor,
                                                                  fontSize: 14,
                                                                )),
                                                          ],
                                                        );
                                                      } else {
                                                        return const Text(
                                                          'Loading...',
                                                          style: TextStyle(
                                                            color: Styling
                                                                .blueGreyFontColor,
                                                            fontSize: 12,
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // FutureBuilder(
                                        //   future: () async {
                                        //     return await fire
                                        //   },
                                        //   builder:
                                        //   (c,s) => Text('OK'),
                                        // ),
                                        const Divider(
                                          height: 16,
                                          thickness: 0.2,
                                          color: Styling.blueGreyFontColor,
                                        ).px(8)
                                      ],
                                    ).px(8);
                                    // : SizedBox.shrink();
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox.shrink(),
                                  itemCount: filteredTasksList.length,
                                );
                              });
                        }),
                  )
          ],
        ),
      ),
    );
  }

  Future<List<QueryDocumentSnapshot<Object?>>> filterLabourersByLocation(
      BuildContext context, List<QueryDocumentSnapshot<Object?>> list) async {
    List<QueryDocumentSnapshot<Object?>> newList = [];
    Position? position =
        Provider.of<UserLocationProvider>(context, listen: false).position;
    if (position == null) {
      StorageService.readUser().then((UserModel? user) {
        Utils.determinePosition(context, user);
      });

      showFailureDialog(context,
              'Unable to access your location, please allow location services!')
          .show(context);
      return [];
    }
    Position? labourerPosition;
    list.forEach((element) async {
      labourerPosition = await widget.firebaseRepository
          .getLocation((element.data() as Map<String, dynamic>)['labourer_id']);
      if (labourerPosition != null) {
        if (Geolocator.distanceBetween(
                labourerPosition!.latitude,
                labourerPosition!.longitude,
                position.latitude,
                position.longitude) <=
            MAX_DISTANCE_FOR_SEARCH) {
          newList.add(element);
        }
      } else {
        newList.add(element);
      }
    });
    return list;
  }
}

// ignore: must_be_immutable
class NoResultsWidget extends StatelessWidget {
  NoResultsWidget({
    Key? key,
    this.noNearby = false,
  }) : super(key: key);

  bool noNearby = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Lottie.asset(
              Images.noResults,
              height: 100,
            ),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  noNearby
                      ? 'Sorry, couldn\'t find any nearby labourer!'
                      : 'Nothing to show!',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
