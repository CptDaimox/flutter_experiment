import 'package:flutter/material.dart';
import 'package:flutter_experiment/api/request.dart';
import 'package:flutter_experiment/components/back_button.dart';
import 'package:flutter_experiment/components/list_tile.dart';
import 'package:flutter_experiment/responsive.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Future<dynamic> getUsers() async {
    var response = await RequestHelper().send("GET", "/users");
    if (response != null) {
      return response;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<dynamic>? users = snapshot.data;
              return Column(
                children: [
                  // back button
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 25, bottom: 50),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),

                  Expanded(
                    child: DynMouseScroll(builder: (context, scroll, physics) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              context.responsive(2, md: 3, lg: 4, xl: 5),
                        ),
                        controller: scroll,
                        physics: physics,
                        itemCount: users!.length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final user = users[index];

                          String name =
                              "${user["firstname"]} ${user["lastname"]}";
                          String email = user["email"];

                          return MyListTile(title: name, subtitle: email);
                        },
                      );
                    }),
                  ),
                ],
              );
            } else {
              return const Text("No data");
            }
          },
        ));
  }
}
