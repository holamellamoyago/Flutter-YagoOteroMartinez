import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:flutter/material.dart';

class GeneralTableWidget extends StatelessWidget {
  final UsersViewmodel socialViewmodel;
  const GeneralTableWidget({super.key, required this.socialViewmodel});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<AppUser> users = socialViewmodel.users;
    return Expanded(
      child: ListView.builder(
        itemCount: users.length >= 5 ? 5 : users.length,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          color: Colors.white,
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: SizedBox(
              width: screenWidth * 0.25,
              child: Row(
                children: [
                  Text("${index + 1}º", style: TextStyle(fontSize: 16)),
                  ClipOval(
                    child: Image.asset(
                      AppStrings.logoImage,
                      width: screenWidth * 0.2,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(users[index].username),
            subtitle: Text(users[index].totalPoints.toString()),
            trailing: Icon(Icons.person_add_alt_1_outlined),
          ),
        ),
      ),
    );
  }
}
