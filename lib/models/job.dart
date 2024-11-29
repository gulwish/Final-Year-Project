import 'package:kaamsay/enum/task_state.dart';

import 'hire_list_item.dart';

class Job {
  String? jobId;
  JobState? state;
  String? hirerId;
  String? labourerId;
  String? thumbnail;
  String? title;
  String? service;
  String? address;
  String? contact;
  String? email;
  HireListItem? hireListItem;

  Job({
    this.jobId,
    this.state,
    this.hirerId,
    this.labourerId,
    this.thumbnail,
    this.title,
    this.service,
    this.address,
    this.contact,
    this.email,
    this.hireListItem,
  });

  Map toMap(Job job) {
    var data = <String, dynamic>{};
    data['job_id'] = job.jobId;
    data['state'] = jobStateToString(job.state ?? JobState.PENDING);
    data['hirer_id'] = job.hirerId;
    data['labourer_id'] = job.labourerId;
    data['profile_image'] = job.thumbnail;
    data['title'] = job.title;
    data['service_provided'] = job.service;
    data['address'] = job.address;
    data['contact'] = job.contact;
    data['email'] = job.email;
    data['hirelist_item'] = job.hireListItem!.toMap(hireListItem!);
    return data;
  }

  Job.fromMap(Map<String, dynamic> mapData) {
    jobId = mapData['job_id'];
    state = parseJobState(mapData['state']);
    hirerId = mapData['hirer_id'];
    labourerId = mapData['labourer_id'];
    thumbnail = mapData['profile_image'];
    title = mapData['title'];
    service = mapData['service_provided'];
    address = mapData['address'];
    contact = mapData['contact'];
    email = mapData['email'];
    hireListItem = HireListItem.fromMap(mapData['hirelist_item']);
  }
}
