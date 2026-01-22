## 3.0.0

* **ADD:**
	* Tajweed fonts (hafs).

* **FIX:**
	* Restructuring the code for downloading fonts.

* **DELETE:**
	* Unused parameters. 

## 2.3.6

* **FIX:**
	* Ayah highlights display for tablets & iPad.

## 2.3.5

* **FIX:**
	* Make the `viewportFraction` display two pages of the Quran on desktop, web, and landscape display for tablets & iPad.

## 2.3.3

* **FIX:**
	* Organize code in `SurahDisplayScreen`.
	* Organize code in `QuranPagesScreen`.

## 2.3.2

* **DELETE:**
	* Delete flutter_sliding_panel package and replace it with AnimatedSize and AnimatedCrossFade.
* **ADD:**
	* Add Kashida to Tafsir & Surah info text.
	* Add `svgBannerColor` to `BannerStyle` to change SVG banner color.
	* Add possibility of deleting the Tafsir or translation that was previously downloaded by `deleteTafsirOrTranslation(int itemIndex)`.
* **FIX:**
	* Prepare fonts if fonts is local.
	* Dark mode issue in Ayah audio download manager.
	* Custom Tafsir Performance.
	* Download Tafsir & translation icon color in dark mode.
	* Surah last listen.

## 2.3.1

* **CHANGES:**
	* Surah name shape.
	* Ayah icon shape.
* **FIX:**
	* Separating the playing of Ayahs from the playing of Surahs.
	* Audio widget width.
	* Surah skip to previous color.

## 2.3.0

* **BREAKING FIX:**
	`Ayah 19 in Surah 24.`
	`Ayah 28 in Surah 19.`

## 2.2.6

* **Fix: Tafsir widget UI in dark mode.**
* **Add: Scroll to current Surah in Surah list.**
* **Add: Scroll to current Juz in Juz list.**
* **Fix: Some UI issue.**

## 2.2.5

* **Fix: Replace unsupported** `Dialog(constraints: ...)` **with**
	`Dialog(child: ConstrainedBox(...))` **to support older Flutter SDKs. Files:**
	`lib/src/tafsir/widgets/change_tafsir.dart`,
	`lib/src/audio/surah_audio/widgets/surah_change_reader.dart`,
	`lib/src/audio/widgets/ayah_change_reader.dart`.

## 2.2.4+1

* **Fix change Tafsir font size.**
* **Fix support local fonts.**
* **Fix Surah header display issue in default fonts.**
* **Fix selected Ayah color in default fonts.**

## 2.2.4

* **Add more optinos to `AyahAudioStyle`.**
* **Add more optinos to `TafsirStyle`.**
* **Add more optinos to `SurahAudioStyle`.**
* **Add more optinos to `AyahDownloadManagerStyle`.**
* **Add `AyahMenuStyle` to customization Ayah menu style.**
* **Add `IndexTabStyle` to customization Surah & Juz list style.**
* **Add `SearchTabStyle` to customization search tab style.**
* **Add `BookmarksTabStyle` to customization bookmark tab style.**
* **Add `SnackBarStyle` to customization SnackBar style.**
* **Add `AyahDownloadManagerStyle` to customization Ayah download manager style.**
* **Add `TopBottomQuranStyle` to customization top/bottom style for the Quran.**
* **Add new Bismillah.**
* **Ability to add a custom widget to tapbar.**
* **Support for turning pages using the keyboard in the web and desktop.**
* **Ability to change Surah info bottom sheet height & width.**
* **Change Surah banner.**
* **Make the surahs playlist. When the surah ends, the next one begins.**
* **Fix move to next page after the last Ayah in page.**
* **Display Ayah download manager with change reader.**

## 2.2.3+1

* **Fix the way Tafsir texts are displayed.**
* **Add variable to check if the tafsir is currently being downloaded.**

## 2.2.3

* **Fix some UI issue.**
* **Add method to preparing fonts.**

## 2.2.2

* **Fix some UI issue.**
* **Add method to delete old font.**

## 2.2.1

* **Add fontWeight options.**
* **Add getFontsPrepareMethod.**

## 2.2.0

* **Upgrade Quran Mushaf fonts to v4 (replacing the legacy version).**
* **Add Web and Windows platform support.**
* **UI improvements.**
* **Performance improvements.**

## 2.1.4

* **Fix playing Surah in background.**

## 2.1.3

* **Fix Ayah selection.**

## 2.1.2

* **Fix Ayah selection in default fonts.**

## 2.1.1

* **Add `QuranPagesScreen` to display a single page or a range of pages.**
* **Add programmatic ayah highlighting by:**
	* Surah + Ayah numbers (`highlightedAyahNumbersBySurah`)
	* Page range + ayah numbers (`highlightedAyahNumbersInPages`)
	* Direct UQ list (`highlightedAyahs`) for advanced users
* **Optional multi-select mode for ayah selection (long-press to add/remove without clearing).**
* **Update README with usage examples for partial pages and highlighting.**
* **Library UI redesign**
* **Performance improvements**

## 2.1.0

* **BREAKING CHANGE: The Tafsir (interpretation) is now loaded from JSON files only, replacing the previous SQL-based implementation.**
* **Removed dependencies: The drift library has been removed.**
* **Android setup simplified: Users no longer need to add the drift_flutter library to their Android project.**
* **Upgrade Flutter to latest stable version #19**
* **Updated all packages to their latest compatible versions**

## 2.0.16

* **Fix README**
* **Fix SliderWidget rendering exception**

## 2.0.15

* **Fix README**

## 2.0.14+1

* **Fix README**

## 2.0.14

* **Fix README**
* **Fix TafsirStyle**
* **Fix some UI**

## 2.0.13+1

* **Fix README**
* **Fix TafsirStyle**
* **Fix get single Ayah**

## 2.0.13

* **Fix get single Ayah**
* **Fix Page View viewport fraction**

## 2.0.12

* **Fix TafsirStyle**
* **Add GetSingleAyah**

## 2.0.11+9

* **Fix TafsirStyle**

## 2.0.10+8

* **Fix change Tafsir**
* **Add some Tafsirs and translation #18**

## 2.0.9+7

* **Fix first two Surahs font size**
* **Fix Just_audio two streams running at the same time #17**

## 2.0.8+6

* **add top title child**

## 2.0.7+5

* **Remove deprecated PluginRegistry import and registerWith method**
* **Update to use only Android embedding v2 (FlutterPlugin)**
* **Fixes compilation error on newer Flutter versions**

## 2.0.6+4

* **ability to add Custom Tafsirs**

## 2.0.1

* **Fixed some issues**

## 2.0.0

* **Add comprehensive audio playback system for Quran recitation**
* **Implement verse-by-verse audio playback with navigation controls**
* **Add complete surah audio playback functionality**
* **Implement background audio playback support for Android and iOS**
* **Add audio download management for offline playback**
* **Implement resume functionality to continue from last position**
* **Add position tracking and time formatting utilities**
* **Implement seek controls for next/previous ayah and surah navigation**
* **Add comprehensive audio example with complete UI controls**
* **Enhance documentation with detailed Arabic and English comments**
* **Add interactive table of contents to README**
* **Improve code documentation with extensive function explanations**
* **Add audio features summary with all capabilities listed**
* **Implement proper permissions handling for audio playback**

## 1.3.2

*   **Fix Surah serach method**
*   **Add Surah serach result**
*   **View two pages instead of one page, for the desktop**

## 1.3.1

*   **Fix page number**

## 1.3.0

*   **Restructure `lib` folder**
*   **Improvements to `quran.dart`**
*   **Improvements to GetX usage**
*   **Improvements to Extensions**
*   **Improve handling of assets and fonts**
*   **Apply SOLID principles**
*   **Add documentation comments**
*   **Fix Ayah menu dialog**

## 1.2.7

* **Add SurahDisplayScreen widget for displaying individual surahs with custom pagination**
* **Implement dynamic line height calculation for better text distribution**
* **Fix Sajda (prostration) display in surah-only mode**
* **Add enhanced pagination logic for first/last pages in surah display**
* **Improve error handling for RangeError in page access**

## 1.2.6

* **Fix the problem of showing the Tafsir**

## 1.0.3

* **Fix the problem of showing the Tafsir**
* **Fix PageView viewport Fraction**

## 1.0.2

* **Remove GlobalKey**
* **Fix issue #14 RenderFlex overflowed**

## 1.0.1

* **Fix pub points.**

## 1.0.0

* **First major release.**
* **Fix some UI.**

## 0.1.11

* **Merge AyahFontModel with AyahModel.**
* **Fix the issue of opening Tafsir database multiple times.**
* **Fix dark mode.**
* **Fix some UI.**

## 0.1.9

* **BREAKING FIX: Fix the problem for MaterialApp.**
* **fix showing tafsir.**

## 0.1.8

* **add showing tafsir.**
* **fix README.**

## 0.1.7

* **fix Ayah 7 in Surah Ibrahim.**
* **fix Ayah 12 in Surah Fatir.**

## 0.1.6

* **fix get surah art path.**

## 0.1.5

* **Add get surah art path.**

## 0.1.4

* **Add Tafsir & Translations.**
* **Improve scroll.**
* **Fix bookmark color.**
* **Edit download method.**
* **Add jumpToAyah.**
* **Add docs.**
* **General improvements in performance.**

## 0.1.3

* **Modify DownloadFontsDialogStyle.**

## 0.1.2

* **Improvements in the code.**

## 0.1.1

* **dispose QuranState, QuranCtrl, BookmarksCtrl.**
* **some refactoring.**

## 0.1.0

* **Modifications and improvements in the code.**
* **Organizing the imports.**
* **Adding dark mode.**

## 0.0.9

* **fix all null check.**

## 0.0.8

* **Create fonts download widget.**

## 0.0.7

* **remove collection package.**
* **remove intl package.**
* **add getter to find out which font has been selected [currentFontsSelected].**

## 0.0.6

* **make collection package: ^1.18.0.**

## 0.0.5

* **Improve the search and make it also search for the page number and verse number.**
* **Adding a function to search for the name and number of the surah.**
* **You can now search by Arabic and English numbers.**

## 0.0.4

* **add a getter to Surah info dialog.**

## 0.0.3

* **add a widget next to the joz (optional).**

## 0.0.2

* **downgrade intl package to 0.19.0.**
* **add a widget next to the surah name (optional).**

## 0.0.1

* **First and early version of the package.**