import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisdom_central_library/core/utils/configuration/locator.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/bible_verse_card.dart';
import 'package:wisdom_central_library/features/categories/presentation/screens/categories_part.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/continue_reading_list.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/featured_books_list.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/home_header.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/newly_added_list.dart';
import 'package:wisdom_central_library/features/home/presentation/widgets/search_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const HomeHeader(),
            const SearchBox(),
            const BibleVerseCard(),
            const CategoriesPart(),
            ContinueReadingList(userId: ''),
            NewlyAddedList(),
            FeaturedBooksList(),
          ],
        ),
      ),
    );
  }
}
