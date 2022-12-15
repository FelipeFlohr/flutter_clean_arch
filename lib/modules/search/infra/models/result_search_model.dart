// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';

class ResultSearchModel extends ResultSearch {
  @override
  final String title;
  @override
  final String content;
  @override
  final String img;

  ResultSearchModel(
      {required this.title, required this.content, required this.img})
      : super(title: title, content: content, img: img, '');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'img': img,
    };
  }

  factory ResultSearchModel.fromMap(Map<String, dynamic> map) {
    return ResultSearchModel(
      title: map['title'] as String,
      content: map['content'] as String,
      img: map['img'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultSearchModel.fromJson(String source) =>
      ResultSearchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
