import 'package:flutter_wordpress/constants.dart';

import 'avatar_urls.dart';
import 'content.dart';
import 'links.dart';

/// A [WordPress Comment](https://developer.wordpress.org/rest-api/reference/comments/)
///
/// Refer the above link to see which arguments are set based on different
/// context modes ([WordPressContext]).
class Comment {
  /// ID of the comment.
  int? id;

  /// ID of the post on which to comment.
  int? post;

  /// ID of the parent comment in case of reply.
  /// This should be 0 in case of a new comment.
  int? parent;

  /// ID of the author who is going to comment.
  int? author;
  String? authorName;
  String? authorEmail;
  String? authorUrl;
  String? authorIp;
  String? authorUserAgent;

  /// The date the comment was written, in the site's timezone.
  String? date;

  /// The date the comment was written, in GMT.
  String? dateGmt;

  /// Content of the comment.
  Content? content;
  String? link;

  /// This can only be set by an editor/administrator.
  CommentStatus? status;

  /// This can only be set by an editor/administrator.
  CommentType? type;
  AvatarUrls? authorAvatarUrls;
  Links? lLinks;

  Comment({
    required this.author,
    required this.post,
    required String content,
    this.authorEmail,
    this.authorIp,
    this.authorName,
    this.authorUrl,
    this.authorUserAgent,
    this.date,
    this.dateGmt,
    this.parent = 0,
    this.status,
  }) : content = Content(rendered: content);

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = json['post'];
    parent = json['parent'];
    author = json['author'];
    authorName = json['author_name'];
    authorEmail = json['author_email'];
    authorUrl = json['author_url'];
    authorIp = json['author_ip'];
    authorUserAgent = json['author_user_agent'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    content = (json['content'] != null
        ? Content.fromJson(json['content']!)
        : null)!;
    link = json['link'];
    if (json['status'] != null) {
      for (var val in CommentStatus.values) {
        if (enumStringToName(val.toString()) == json['status']) {
          status = val;
          continue;
        }
      }
    }
    if (json['type'] != null) {
      for (var val in CommentType.values) {
        if (enumStringToName(val.toString()) == json['type']) {
          type = val;
          continue;
        }
      }
    }
    authorAvatarUrls = json['author_avatar_urls'] != null
        ? AvatarUrls.fromJson(json['author_avatar_urls'])
        : null;
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['post'] = post;
    data['parent'] = parent;
    data['author'] = author;
    data['author_name'] = authorName;
    data['author_email'] = authorEmail;
    data['author_url'] = authorUrl;
    data['author_ip'] = authorIp;
    data['author_user_agent'] = authorUserAgent;
    data['date'] = date;
    data['date_gmt'] = dateGmt;
    data['content'] = content?.toJson();
    data['status'] = enumStringToName(status.toString());

    return data;
  }

  @override
  String toString() {
    return 'Comment: {id: $id, author: $authorName, post: $post, parent: $parent}';
  }
}
