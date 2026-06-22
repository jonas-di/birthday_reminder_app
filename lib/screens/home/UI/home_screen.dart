import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tier_birthday/core/theme/colors.dart';
import 'package:tier_birthday/core/widgets/contact_list_tile.dart';
import 'package:tier_birthday/screens/home/bloc/home_bloc.dart';
import 'package:tier_birthday/screens/options/UI/options_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeBloc = HomeBloc();
  @override
  void initState() {
    debugPrint('Home Screen Created');
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToOptionsPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OptionsScreen()),
          );
        }
      },
      builder: (context, state) {
        switch (state) {
          case HomeLoadingState():
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColor.textBlack),
              ),
            );

          case HomeErrorState homeErrorState:
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text(
                      'An Error accured',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(homeErrorState.exception.toString()),
                    IconButton(
                      onPressed: () {
                        homeBloc.add(HomeRefreshAfterErrorClickedEvent());
                      },
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            );

          case HomeLoadedSucsessState homeLoadedSucsessState:
            final contacts = homeLoadedSucsessState.contacts;
            return Scaffold(
              appBar: AppBar(
                title: Text('Birthday Reminder App'),
                actions: [
                  IconButton(
                    onPressed: () {
                      homeBloc.add(HomeOptionsButtonClickedEvent());
                    },
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) =>
                      ContactListTile(contact: contacts[index]),
                ),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
