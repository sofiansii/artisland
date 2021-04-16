import 'package:artisland/domain/entities/post_data.dart';
import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/pages/homeContent/post/post.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  static var a = 1;
  Widget content;

  Future<List<PostData>> getPosts(BuildContext c) async {
    var postManager = c.read<PostManager>();
    var posts = await postManager.getSorePublicPosts();
    print("we have ${posts.length} posts");
    return posts;
  }

  var cls = [Colors.white, Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: [],
      future: getPosts(context),
      builder: (c, snp) {
        if (snp.data == null) return Center(child: CircularProgressIndicator());
        if (snp.hasError) print(snp.error);
        return LiquidPullToRefresh(
          onRefresh: () {
            print("refresh");
            return Future.delayed(Duration(seconds: 2), () => null);
          },
          child: ListView.builder(
            physics: RangeMaintainingScrollPhysics(),
            cacheExtent: MediaQuery.of(context).size.height * 4,
            addAutomaticKeepAlives: true,
            itemCount: snp.data.length,
            itemBuilder: (c, i) {
              return Post(snp.data[i]);
            },
          ),
        );
      },
    );
  }
}
