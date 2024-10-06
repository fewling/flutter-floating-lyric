import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../preference/bloc/preference_bloc.dart';
import 'bloc/font_select_bloc.dart';

class FontSelect extends StatelessWidget {
  const FontSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Options'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search font',
              leading: const Icon(Icons.search),
              onChanged: (value) => context.read<FontSelectBloc>().add(FontSelectSearchChanged(value)),
            ),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        final fontStyles = context.select((FontSelectBloc bloc) => bloc.state.filteredFontStyles);
        final currentFont = context.select((PreferenceBloc bloc) => bloc.state.fontFamily);

        return ListView.builder(
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
              onTap: () => context.read<PreferenceBloc>().add(FontFamilyUpdated(key)),
            );
          },
        );
      }),
    );
  }
}
