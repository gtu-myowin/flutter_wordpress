import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class SinglePostPage extends StatelessWidget {
  final wp.WordPress wordPress;
  final wp.Post post;

  const SinglePostPage({Key? key, required this.wordPress, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title!.rendered!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PostWithComments(wordPress: wordPress, post: post),
      ),
    );
  }
}

class PostWithComments extends StatefulWidget {
  final wp.WordPress wordPress;
  final wp.Post post;

  const PostWithComments({Key? key, required this.wordPress, required this.post}) : super(key: key);

  @override
  PostWithCommentsState createState() => PostWithCommentsState();
}

class PostWithCommentsState extends State<PostWithComments> {
  String? _content;

  Future<List<wp.CommentHierarchy>>? _comments;

  @override
  void initState() {
    super.initState();

    _content = widget.post.content!.rendered;
    _content = _content!.replaceAll('localhost', '192.168.6.165');

    fetchComments();
  }

  void fetchComments() {
    setState(() {
      _comments = widget.wordPress.fetchCommentsAsHierarchy(
          params: wp.ParamsCommentList(
        includePostIDs: [
          widget.post.id!
        ],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Html(
                data: _content,
                // blockSpacing: 0.0,
              ),
              const Divider(),
              Row(
                children: const <Widget>[
                  Icon(Icons.comment),
                  Text('Comments'),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        FutureBuilder(
          future: _comments,
          builder: (context, snapshot) {
            return SliverList(
              // delegate: _buildCommentsSection(snapshot as AsyncSnapshot<List<CommentHierarchy>>),
              delegate: _buildCommentsSection(snapshot as AsyncSnapshot<List<wp.CommentHierarchy>>),
            );
          },
        ),
      ],
    );
  }

  SliverChildDelegate _buildCommentsSection(AsyncSnapshot<List<wp.CommentHierarchy>> snapshot) {
    if (snapshot.hasData) {
      return _buildComments(snapshot.data);
    } else if (snapshot.hasError) {
      return SliverChildListDelegate([
        Text(
          'Error fetching comments: ${snapshot.error.toString()}',
          style: const TextStyle(
            color: Colors.red,
          ),
        )
      ]);
    }

    return SliverChildListDelegate(
      [
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ),
      ],
    );
  }

  SliverChildBuilderDelegate _buildComments(List<wp.CommentHierarchy>? comments) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int i) {
        if (comments == null || comments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No comments',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }

        if (i % 2 != 0) {
          return const Divider();
        }
        return _buildCommentTile(comments[(i / 2).ceil()]);
      },
      childCount: comments == null || comments.isEmpty ? 1 : comments.length * 2,
    );
  }

  Widget _buildCommentTile(wp.CommentHierarchy root) {
    if (root.children == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Html(
              data: root.comment.content!.rendered,
              // blockSpacing: 0.0,
            ),
            Text(
              root.comment.authorName!,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      );
    } else {
      return ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Html(
              data: root.comment.content!.rendered,
              // blockSpacing: 0.0,
            ),
            Text(
              root.comment.authorName!,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        children: root.children!.map((c) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _buildCommentTile(c),
          );
        }).toList(),
      );
    }
  }
}
