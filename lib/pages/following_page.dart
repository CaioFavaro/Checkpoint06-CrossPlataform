import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/Stars.dart';
import 'package:github_api_demo/models/repositories.dart';

import '../models/user.dart';

class FollowingPage extends StatefulWidget {
  final User user;
  const FollowingPage({required this.user});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final api = GitHubApi();
  late Future<List<User>> _futureFollowings;
  late Future<List<User>> _futureFollowers;
  late Future<List<Repository>> _futureRepositories;
  late Future<List<StarredRepository>> _futureStarredRepositories;

  @override
  void initState() {
    _futureFollowings = api.getFollowing(widget.user.login);
    _futureFollowers = api.getFollowers(widget.user.login);
    _futureRepositories = api.getRepositories(widget.user.login);
    _futureStarredRepositories = api.getStarredRepositories(widget.user.login);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.user.avatarUrl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.user.login,
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Followings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<User>>(
            future: _futureFollowings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var followings = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: followings.length,
                  itemBuilder: ((context, index) {
                    var user = followings[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl)),
                      title: Text(user.login),
                      trailing: const Text(
                        "Following",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }),
                );
              }
            },
          )),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Followers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<User>>(
            future: _futureFollowers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var followers = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: followers.length,
                  itemBuilder: ((context, index) {
                    var user = followers[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl)),
                      title: Text(user.login),
                      trailing: const Text(
                        "followers",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }),
                );
              }
            },
          )),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Repositories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Repository>>(
              future: _futureRepositories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final repositories = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: repositories.length,
                    itemBuilder: (context, index) {
                      final repository = repositories[index];
                      return ListTile(
                        title: Text(repository.name),
                        subtitle: Text(repository.description),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Stars',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StarredRepository>>(
              future: _futureStarredRepositories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final starredRepositories = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: starredRepositories.length,
                    itemBuilder: (context, index) {
                      final repository = starredRepositories[index];
                      return ListTile(
                        title: Text(repository.name),
                        subtitle: Text(repository.description),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
