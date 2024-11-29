import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaamsay/models/task_ad.dart';
import 'package:kaamsay/models/task_category.dart';
import 'package:kaamsay/providers/task_categories_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '/components/dialog_widgets.dart';
import '/components/flush_bar.dart';
import '/components/loading_widgets.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/screens/labour_screens/labourer_home_screen.dart';
import '/screens/user_screens/user_dashboard.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '/utils/utilities.dart';
import '../../components/buttons.dart';
import '../../components/input_digits_field.dart';
import '../../components/text_input_field.dart';
import '../../utils/storage_service.dart';

class AddTaskAdScreen extends StatefulWidget {
  static const String routeName = '/add-task-ad';
  final bool isEdit;
  final TaskAd? taskAd;

  const AddTaskAdScreen({Key? key, this.isEdit = false, this.taskAd})
      : super(key: key);

  @override
  _AddTaskAdScreenState createState() => _AddTaskAdScreenState();
}

class _AddTaskAdScreenState extends State<AddTaskAdScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  TextEditingController taskAdTitleController = TextEditingController();
  TextEditingController baseRateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TaskCategory? selectedCategory;

  late UserModel _user;
  File? _thumbnail;

  bool _isLoading = false;
  void _loading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    StorageService.readUser().then((UserModel? user) {
      setState(() {
        _user = user!;
      });
    });
    if (widget.isEdit) {
      setState(() {
        taskAdTitleController.text = widget.taskAd!.title!;
        baseRateController.text = (widget.taskAd!.baseRate!.toInt()).toString();
        descriptionController.text = widget.taskAd!.description!;
      });
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _validateFields() {
    descriptionController.text = selectedCategory?.name ?? 'Other';
    if (_thumbnail == null &&
        taskAdTitleController.text.trim().isEmpty &&
        baseRateController.text.trim().isEmpty &&
        descriptionController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter complete details').show(context);
    } else if (_thumbnail == null) {
      showFailureDialog(context, 'Choose Relevant Image').show(context);
    } else if (taskAdTitleController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter Task Name').show(context);
    } else if (baseRateController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter Task Charges').show(context);
    } else if (descriptionController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter Description').show(context);
    } else {
      _loading(true);
      _uploadthumbnail();
    }
  }

  void _pickImage(ImageSource imageSource) {
    Navigator.maybePop(context);
    Utils.pickImage(imageSource).then((selectedImage) {
      if (selectedImage != null) {
        setState(() {
          _thumbnail = selectedImage;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  void _uploadthumbnail() {
    _firebaseRepository
        .uploadthumbnail(imageFile: _thumbnail!)
        .then((imageUrl) {
      _saveTaskAd(imageUrl);
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _saveTaskAd(String thumbnailUrl) {
    TaskAd product = TaskAd(
      thumbnailURL: thumbnailUrl,
      title: taskAdTitleController.text.trim(),
      baseRate: double.parse(baseRateController.text.trim()),
      description: descriptionController.text.trim(),
      labourerId: _user.uid,
      serviceCategory: selectedCategory!.id,
    );

    _firebaseRepository.saveTaskToFirestore(product).then((value) async {
      TaskAd correctTaskAd = TaskAd(
        taskId: value.id,
        thumbnailURL: thumbnailUrl,
        title: taskAdTitleController.text.trim(),
        baseRate: double.parse(baseRateController.text.trim()),
        description: descriptionController.text.trim(),
        labourerId: _user.uid,
        serviceCategory: selectedCategory!.id,
      );
      await _firebaseRepository.updateTask(correctTaskAd);
      _loading(false);
      Navigator.pushNamedAndRemoveUntil(
          context,
          _user.isUser!
              ? HirerDashboard.routeName
              : LabourerHomeScreen.routeName,
          (Route<dynamic> route) => false,
          arguments: {
            'dialogMessage': 'Task Added Successfully',
          });
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _validateFieldsWhileUpdating() {
    if (taskAdTitleController.text.trim().isEmpty &&
        baseRateController.text.trim().isEmpty &&
        descriptionController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter complete details').show(context);
    } else if (taskAdTitleController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter task Name').show(context);
    } else if (baseRateController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter Product Price').show(context);
    } else if (descriptionController.text.trim().isEmpty) {
      showFailureDialog(context, 'Enter Description').show(context);
    } else {
      _loading(false);
      _updateTaskAd();
    }
  }

  void _updateTaskAd() {
    widget.taskAd!.title = taskAdTitleController.text.trim();
    widget.taskAd!.baseRate = double.parse(baseRateController.text.trim());
    widget.taskAd!.description = descriptionController.text.trim();

    _firebaseRepository.updateTask(widget.taskAd!).then((value) {
      _loading(false);
      Navigator.pushNamedAndRemoveUntil(
          context,
          _user.isUser!
              ? HirerDashboard.routeName
              : LabourerHomeScreen.routeName,
          (Route<dynamic> route) => false,
          arguments: {
            'dialogMessage': 'Task Updated Successfully',
          });
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  void _deleteProduct() {
    Navigator.maybePop(context);
    _loading(false);
    _firebaseRepository.deleteTask(widget.taskAd!.taskId).then((value) {
      _loading(false);
      Navigator.pushNamedAndRemoveUntil(
          context,
          _user.isUser!
              ? HirerDashboard.routeName
              : LabourerHomeScreen.routeName,
          (Route<dynamic> route) => false,
          arguments: {
            'dialogMessage': 'Task Deleted Successfully',
          });
    }).catchError((error) {
      _loading(false);
      showFailureDialog(context, error.message.toString()).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var taskCategoriesProvider = Provider.of<TaskCategoriesProvider>(context);

    selectedCategory ??= taskCategoriesProvider.categories
        .firstWhere((element) => element.name == 'All');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox.shrink(),
        backgroundColor: Styling.navyBlue,
        title: Text(
          widget.isEdit ? 'Edit task' : 'Add task',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            24.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.isEdit
                  ? _productNetworkImage()
                  : _thumbnail != null
                      ? _productFileImage()
                      : SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: GestureDetector(
                            onTap: () => showImageOptionBox(
                              context,
                              () => _pickImage(ImageSource.camera),
                              () => _pickImage(ImageSource.gallery),
                            ),
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Center(
                                child: Image.asset(
                                  Images.imageIcon,
                                  color: Colors.white,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
            ),
            20.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextInputField(
                hintText: 'Title',
                label: 'Title',
                controller: taskAdTitleController,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
            ),
            20.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClayInputFieldDigitsOnly(
                hintText: 'Hourly Charges',
                label: 'Charges',
                controller: baseRateController,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            20.heightBox,
            const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                .p(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: DropdownButton(
                  isExpanded: true,
                  items: [
                    for (int i = 0;
                        i < taskCategoriesProvider.categories.length;
                        i++)
                      DropdownMenuItem(
                        value: taskCategoriesProvider.categories[i],
                        child: Text(
                          taskCategoriesProvider.categories[i].name == 'All'
                              ? 'Other'
                              : taskCategoriesProvider.categories[i].name,
                        ),
                      ),
                  ],
                  onChanged: (dynamic v) {
                    setState(() {
                      selectedCategory = v;
                    });
                  },
                  value: selectedCategory,
                ).px(8),
              ),
            ),
            30.heightBox,
            _isLoading
                ? CircularProgress(color: Theme.of(context).primaryColor)
                : widget.isEdit
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                buttonText: 'Update',
                                onPressed: _validateFieldsWhileUpdating,
                              ),
                            ),
                            8.widthBox,
                            Expanded(
                              child: PrimaryButton(
                                buttonText: 'Delete',
                                color: Colors.red[400],
                                onPressed: () => showConfirmDialog(
                                  context,
                                  'Are you sure you want to delete this task ad?',
                                  _deleteProduct,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          buttonText: 'Post TaskAd',
                          onPressed: _validateFields,
                        ),
                      ),
            30.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _productFileImage() {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: GestureDetector(
        onTap: () => showImageOptionBox(
            context,
            () => _pickImage(ImageSource.camera),
            () => _pickImage(ImageSource.gallery)),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: FileImage(_thumbnail!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productNetworkImage() {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: GestureDetector(
        // onTap: () => showImageOptionBox(
        //     context,
        //     () => _pickImage(ImageSource.camera),
        //     () => _pickImage(ImageSource.gallery)),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(widget.taskAd!.thumbnailURL!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
