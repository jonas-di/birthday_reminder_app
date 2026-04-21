import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tier_birthday/core/models/friend_model.dart';
import 'package:tier_birthday/core/services/local_notification_service.dart';
import 'package:tier_birthday/screens/home/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add),
            onPressed: () {
              LocalNotificationService().sendTestNotification();
            },
          ),
        ],
      ),
      // the Home Screen Body consists of 2 Areas a [Friendslist] and a [FriendsCreator] Widget.
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The [FriendsList] displays [friends] variable of the HomeViewmodel as a [ListView] Widget.
              // [friends] contains a List of [FriendModel] - Objekts.
              // The Icon Button in every Column Removes the [FriendModel] for the List
              Expanded(child: FriendsList()),

              // The [FriendsCrator] Displays 2 [TextField] a [DatePicker] Widget and a [FilledButton].
              // In the [TextField]s the User Inputs the Friends Name.
              // In the [DatePicker] he Picks his Birthday.
              // With the [Filled Button] he creates a new Friend with values of [TextField]s and [DatePicker].
              FriendCreator(),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Friend> friendsList = context.watch<HomeViewmodel>().friendsList;

    return SizedBox(
      height: 1000,
      width: 600,
      child: friendsList.isEmpty
          ? null
          : ListView.builder(
              itemCount: friendsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  //Title contains [firstName] and [lastName] Strings of [FriendModel] - Objekts
                  title: Text(
                    '${friendsList[index].firstName}, ${friendsList[index].lastName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Title contains [birthDay], [birthYear], [birthMonth] of the [FriendsModel] - Objekts
                  subtitle: Text(
                    '${friendsList[index].birthday.day}.${friendsList[index].birthday.month}.${friendsList[index].birthday.year}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      debugPrint('Removing friend ...');
                      context.read<HomeViewmodel>().removeFriend.execute(
                        friendsList[index].id,
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}

class FriendCreator extends StatefulWidget {
  const FriendCreator({super.key});

  @override
  State<FriendCreator> createState() => _FriendCreatorState();
}

class _FriendCreatorState extends State<FriendCreator> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthdayController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _birthdayController = TextEditingController();
    context.read<HomeViewmodel>().addFriend.addListener(_onAdd);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    context.read<HomeViewmodel>().addFriend.removeListener(_onAdd);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(width: 1.6),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(hintText: 'First Name'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(hintText: 'Last Name'),
                ),
              ),
            ],
          ),
          TextField(
            controller: _birthdayController,
            decoration: InputDecoration(hintText: 'Birthday'),
            onTap: () async {
              DateTime? birthday = await showDatePicker(
                context: context,
                firstDate: DateTime(1900, 1, 1),
                lastDate: DateTime.now(),
              );
              if (birthday != null) {
                String birthdayAsString = birthday.toIso8601String().substring(
                  0,
                  10,
                );
                setState(() {
                  _birthdayController.text = birthdayAsString;
                });
              }
            },
          ),
          FilledButton(
            onPressed: () {
              context.read<HomeViewmodel>().addFriend.execute({
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'birthday': _birthdayController.text,
              });
              debugPrint('Adding new friend ...');
            },
            child: Text('add Friend'),
          ),
        ],
      ),
    );
  }

  void _onAdd() {
    if (context.read<HomeViewmodel>().addFriend.completed) {
      context.read<HomeViewmodel>().addFriend.clearResult();
      _firstNameController.clear();
      _lastNameController.clear();
      _birthdayController.clear();
      debugPrint('Cleared Textfields');
    }
  }
}
