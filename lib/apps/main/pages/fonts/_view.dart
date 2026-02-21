part of 'page.dart';

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
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
        context.read<FontSelectionBloc>().add(
          const FontSelectionEvent.loadMore(),
        );
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
    final l10n = context.l10n;
    final fontStyles = context.select(
      (FontSelectionBloc bloc) => bloc.state.filteredFontStyles,
    );
    final currentFont = MainAppDependency.of(
      context,
    ).select((PreferenceBloc bloc) => bloc.state.fontFamily);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => launchUrl(Uri.parse('https://fonts.google.com/')),
        icon: const Icon(Icons.open_in_new),
        label: Text(
          l10n.font_select_visit_google_fonts,
          textAlign: TextAlign.center,
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: Text(l10n.font_select_font_options),
            actions: [
              IconButton(
                tooltip: l10n.font_select_reset_font_family,
                icon: const Icon(Icons.refresh),
                onPressed: () => MainAppDependency.of(context)
                    .read<PreferenceBloc>()
                    .add(const PreferenceEvent.fontFamilyReset()),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: l10n.font_select_search_font,
                  leading: const Icon(Icons.search),
                  onChanged: (value) => context.read<FontSelectionBloc>().add(
                    FontSelectionEvent.search(value),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(l10n.font_select_disclaimer),
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
                  textStyle?.fontFamily ?? l10n.font_select_unknown,
                  style: textStyle,
                ),
                onTap: () => MainAppDependency.of(context)
                    .read<PreferenceBloc>()
                    .add(PreferenceEvent.fontFamilyUpdated(key)),
              );
            },
          ),
        ],
      ),
    );
  }
}
