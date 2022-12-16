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
      title: map['login'] as String,
      content: map['html_url'] as String,
      img: map['avatar_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultSearchModel.fromJson(String source) =>
      ResultSearchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
