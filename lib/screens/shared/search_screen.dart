import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/style/styling.dart';
import '../../components/pending_task_list_card.dart';
import '../../models/hire_list_item.dart';
import '../../models/task_ad.dart';
import '../user_screens/task_details.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final UserModel? worker;

  const SearchScreen({Key? key, this.worker}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  List<TaskAd>? _taskAdList;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      _firebaseRepository
          .fetchLabourerTasks(widget.worker!.uid)
          .then((List<TaskAd> taskAds) {
        setState(() {
          _taskAdList = taskAds;
        });
      }).catchError((error) {});
    } else {
      _firebaseRepository.fetchAllTasks().then((List<TaskAd> taskAds) {
        setState(() {
          _taskAdList = taskAds;
        });
      }).catchError((error) {});
    }
  }

  Widget _searchAppBar() {
    return AppBar(
      backgroundColor: Styling.navyBlue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
            cursorColor: Theme.of(context).primaryColor,
            autofocus: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => WidgetsBinding.instance
                    .addPostFrameCallback((_) => _searchController.clear()),
              ),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(String query) {
    if (_taskAdList == null ||
        _taskAdList!.isEmpty ||
        _taskAdList!.isEmpty) {
      return Container();
    }
    final List<TaskAd> suggestionList = query.isEmpty
        ? []
        : _taskAdList!.where((TaskAd taskAd) {
            String getProductName = taskAd.title!.toLowerCase();
            String qry = query.toLowerCase();
            bool matchesProductName = getProductName.contains(qry);

            return matchesProductName;
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => HireListItemCard(
        hireListItem: HireListItem(taskAd: suggestionList[index]),
        removeItem: () {},
        onTap: () => Navigator.pushNamed(
          context,
          TaskDetails.routeName,
          arguments: {
            'taskAd': suggestionList[index],
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _searchAppBar() as PreferredSizeWidget?,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildSuggestions(_query),
      ),
    );
  }
}
