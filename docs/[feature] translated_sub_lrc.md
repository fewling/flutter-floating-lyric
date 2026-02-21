# Roadmap

Rough Idea (user story):

1. Add support of translated sub-LRCs
   1. Support manual creation + edit
   2. Support automatic creation + AI generated translation
2. AI generated translation:
   1. First use Firebase AI kit for faster deployment
   2. Support user added API keys to make requests to certain AI providers
3. (Optional) add validation logics on the LRC content
4. Implement AI rate limiter function
   1. Records users’ request rates on cloud
   2. Reject request if exceeds the limit

## Translated sub-LRCs

1. DB schema update: add a new box for translated sub-LRCs, which is linked to the original LRC
2. UI update: add a new section for translated sub-LRCs in the LRC editor page, which allows users to add, edit and delete translated sub-LRCs
3. Logic update: when displaying lyrics, check:
   - the preferred translation language of the user
   - if there is a translated sub-LRC in that language
   - if yes, display the translated sub-LRC alongside the original LRC on the overlay window (display format to be determined)

### Phase 1: Data Layer (Database & Models)

**1.1 Create Translation Language Model**

- Create `lib/models/translation_language.dart`
- Define supported translation languages (can be different from app UI languages)
- Use freezed + json_serializable for code generation

**1.2 Create Translated LRC Model**

- Create `lib/models/translated_lrc.dart`
- Fields:
  - `id` (unique identifier)
  - `originalLrcId` (foreign key to parent LRC)
  - `language` (TranslationLanguage)
  - `content` (translated LRC text content)
  - `createdAt`, `updatedAt` timestamps
  - `source` (enum: manual, ai-generated)
- Add Hive type adapter annotations

**1.3 Update Hive Adapters**

- Update hive_adapters.dart to include `TranslatedLrc` adapter
- Generate adapters using build_runner

**1.4 Database Initialization**

- Update main.dart to open new Hive box: `translatedLrcBox`
- Add migration logic if needed

**1.5 Create Translated LRC Repository**

- Create `lib/repos/persistence/local/translated_lrc_repo.dart`
- Methods:
  - `getTranslationsByOriginalId(String originalLrcId)`
  - `getTranslation(String originalLrcId, TranslationLanguage language)`
  - `addTranslation(TranslatedLrc translation)`
  - `updateTranslation(TranslatedLrc translation)`
  - `deleteTranslation(String id)`
  - `deleteTranslationsByOriginalId(String originalLrcId)`

### Phase 2: State Management (BLoC)

**2.1 Create Translation Preference**

- Update preference_state.dart
  - Add `preferredTranslationLanguage` field (nullable)
  - Add `showTranslation` boolean flag
- Update preference_event.dart
  - Add `translationLanguageUpdated` event
  - Add `showTranslationToggled` event

**2.2 Create Translation Management BLoC**

- Create `lib/blocs/translation_manager/` directory
- Files:
  - `translation_manager_bloc.dart`
  - `translation_manager_event.dart` (load, add, update, delete, generate)
  - `translation_manager_state.dart` (loading, loaded, error states)

**2.3 Update Lyric Detail BLoC**

- Update lyric_detail to handle translations
- Add methods to load/manage translations for the current LRC

### Phase 3: UI Updates - Editor Page

**3.1 Update Local Lyric Detail Page Structure**

- Modify local_lyric_detail
- Change from single text field to tabbed interface:
  - Tab 1: Original LRC (existing)
  - Tab 2: Translations (new)

**3.2 Create Translation List Widget**

- Create `lib/apps/main/pages/local_lyric_detail/_widgets/translation_list.dart`
- Display all existing translations for current LRC
- Show language, source (manual/AI), last updated
- Actions: edit, delete, add new

**3.3 Create Translation Editor Widget**

- Create `lib/apps/main/pages/local_lyric_detail/_widgets/translation_editor.dart`
- Language selector dropdown
- Text field for editing translation
- Save button
- Validation (ensure line count matches original)

**3.4 Add Translation Actions to AppBar**

- Add menu button with actions:
  - "Add Manual Translation"
  - "Generate AI Translation" (Phase 4)
  - "Import Translation from File"

### Phase 4: UI Updates - Display Logic

**4.1 Update Overlay Message Model**

- Update to_overlay_msg_model.dart
- Add `translatedLrc` field to `ToOverlayMsgLrcState`

**4.2 Update Overlay Display Logic**

- Modify overlay lyrics page \_overlay_window.dart
- Check user's `preferredTranslationLanguage` preference
- Fetch matching translation if available
- Determine display format (see Phase 5)

**4.3 Create Translation Display Widgets**

- Create `lib/apps/overlay/pages/lyrics/_widgets/lyric_line_with_translation.dart`
- Support multiple display modes (see Phase 5)

### Phase 5: Display Format Options

**5.1 Add Display Format Preference**

- Update preference state with `translationDisplayMode` enum:
  - `sideBySide` - Original and translation side by side
  - `stacked` - Translation below original
  - `alternating` - Alternate between original and translation
  - `translationOnly` - Show only translation

**5.2 Implement Layout Logic**

- Create responsive layouts for each display mode
- Consider font size adjustments for dual-line display
- Ensure proper synchronization with playback time

### Phase 6: Integration & Message Passing

**6.1 Update Message Flow**

- When sending LRC state to overlay, include translation data
- Update msg_to_overlay to fetch translation based on preference
- Ensure translation follows same timing as original

**6.2 Update Lyric Finder BLoC**

- When fetching lyrics from online sources, check if translations are available
- Optionally fetch translations automatically

### Phase 7: Data Validation & Constraints

**7.1 Add Translation Validation**

- Create `lib/utils/translation_validator.dart`
- Validate:
  - Line count matches original LRC
  - Timestamps are valid (if included)
  - Language is specified
  - No duplicate translations for same language

**7.2 Add UI Feedback**

- Show warnings if translation line count differs
- Highlight mismatched lines in editor

### Phase 8: Additional Features

**8.1 Translation Import/Export**

- Support importing .lrc files as translations
- Export translations as separate .lrc files
- Link translations during import based on matching metadata

**8.2 Translation Settings Page**

- Create dedicated settings section for translations
- Options:
  - Default translation language
  - Auto-show translations
  - Display format preference
  - Font size ratio for translations

**8.3 Cascading Deletes**

- When deleting an original LRC, delete all associated translations
- Add confirmation dialog warning user

### Testing Checklist

- [ ] Translation CRUD operations work correctly
- [ ] Cascading delete removes translations
- [ ] Overlay displays translation correctly in all modes
- [ ] Editor validates translation format
- [ ] Preferences persist correctly
- [ ] Multiple translations per LRC supported
- [ ] Translation sync with media playback
- [ ] Edge cases: no translation, mismatched lines, corrupt data

### Migration Strategy

1. **Backward Compatibility**: Existing LRCs work without translations
2. **Gradual Rollout**: Basic manual translation first, AI later
3. **Data Migration**: No migration needed for existing data
4. **Testing**: Use a separate Hive box during development

### Future Enhancements (Post Phase 1)

- AI-powered translation generation (using Firebase AI kit)
- Bulk translation generation
- Community translation sharing
- Translation quality ratings
- Real-time translation editing during playback
- [ ] Translation CRUD operations work correctly
- [ ] Cascading delete removes translations
- [ ] Overlay displays translation correctly in all modes
- [ ] Editor validates translation format
- [ ] Preferences persist correctly
- [ ] Multiple translations per LRC supported
- [ ] Translation sync with media playback
- [ ] Edge cases: no translation, mismatched lines, corrupt data

### Migration Strategy

1. **Backward Compatibility**: Existing LRCs work without translations
2. **Gradual Rollout**: Basic manual translation first, AI later
3. **Data Migration**: No migration needed for existing data
4. **Testing**: Use a separate Hive box during development

### Future Enhancements (Post Phase 1)

- AI-powered translation generation (using Firebase AI kit)
- Bulk translation generation
- Community translation sharing
- Translation quality ratings
- Real-time translation editing during playback
