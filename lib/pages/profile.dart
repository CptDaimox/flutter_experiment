import 'package:flutter/material.dart';
import 'package:flutter_experiment/api/request.dart';
import 'package:flutter_experiment/components/back_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> getProfile() async {
    var response = await RequestHelper().send("GET", "/user/me");
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder(
          future: getProfile(),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              Map<dynamic, dynamic>? user = snapshot.data;
              return Center(
                child: Column(
                  children: [
                    // back button
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 50.0,
                        left: 25,
                      ),
                      child: Row(
                        children: [
                          MyBackButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    // profile picture
                    Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.all(25),
                        child: const Icon(Icons.person, size: 64)),
                    const SizedBox(height: 25),

                    // name
                    Text("${user!["firstname"]} ${user["lastname"]}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    Text(user["email"]),
                    Text(user["role"]),
                  ],
                ),
              );
            } else {
              return const Text("No data");
            }
          },
        ));
  }
}
