import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../preference/bloc/preference_bloc.dart';
import 'bloc/font_select_bloc.dart';

class FontSelect extends StatefulWidget {
  const FontSelect({super.key});

  @override
  State<FontSelect> createState() => _FontSelectState();
}

class _FontSelectState extends State<FontSelect> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final isEnd =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent;
      final isSearchEmpty = _searchController.text.isEmpty;
      if (isEnd && isSearchEmpty) {
        context.read<FontSelectBloc>().add(const FontSelectLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontStyles = context.select(
      (FontSelectBloc bloc) => bloc.state.filteredFontStyles,
    );
    final currentFont = context.select(
      (PreferenceBloc bloc) => bloc.state.fontFamily,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => launchUrl(Uri.parse('https://fonts.google.com/')),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Visit Google Fonts', textAlign: TextAlign.center),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: const Text('Font Options'),
            actions: [
              IconButton(
                tooltip: 'Reset font family',
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<PreferenceBloc>().add(const FontFamilyReset()),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: 'Search font',
                  leading: const Icon(Icons.search),
                  onChanged: (value) => context.read<FontSelectBloc>().add(
                    FontSelectSearchChanged(value),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'To save your internet data, limited options are loaded each time.\n'
                'We recommend visiting Google Fonts to view and feel the full list of fonts.\n'
                'Then, you can search for the font name here and apply it.',
              ),
            ),
          ),
          SliverList.builder(
            itemCount: fontStyles.keys.length,
            itemBuilder: (context, index) {
              final key = fontStyles.keys.elementAt(index);
              final textStyle = fontStyles[key];

              final isSelected = key == currentFont;

              return ListTile(
                selected: isSelected,
                trailing: isSelected ? const Icon(Icons.check) : null,
                title: Text(
                  textStyle?.fontFamily ?? 'Unknown',
                  style: textStyle,
                ),
                onTap: () =>
                    context.read<PreferenceBloc>().add(FontFamilyUpdated(key)),
              );
            },
          ),
        ],
      ),
    );
  }
}
