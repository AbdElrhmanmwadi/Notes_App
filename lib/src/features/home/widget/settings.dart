import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/src/common/SharedPref/sharedPref.dart';
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/cubit/fontsize_cubit.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

import '../../../../generated/l10n.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FontsizeCubit cubitChangeFontSize = BlocProvider.of<FontsizeCubit>(context);
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0,
          floating: true,
          pinned: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          expandedHeight: 100,
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 16),
                centerTitle: constraints.biggest.height < 100,
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Text('${S.of(context).Notes}',
                      style: robotoBlack.copyWith(
                          fontSize: Dimensions.fontSizeOverLarge,
                          fontWeight: FontWeight.w100,
                          color: Colors.black)),
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).APPSERVICES}',
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(.7)),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    '${S.of(context).DeletenotesinApp}',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                  trailing: InkWell(
                    child: const Icon(Icons.delete_forever),
                    onTap: () {
                      NoteLocalDataSourceImpl().deleteMyDatabase();
                      SystemNavigator.pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).STYLE}',
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(.7)),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    '${S.of(context).FontSize}',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                  trailing: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Icon(Icons.keyboard_arrow_down),
                    onSelected: (value) {
                      cubitChangeFontSize.changeFontSize(value);
                      SharedPrefController().setData('fontSize', value);
                    },
                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(
                          value: Dimensions.fontSizeLarge,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text('${S.of(context).small}'),
                            trailing: SharedPrefController()
                                        .getData(key: 'fontSize') ==
                                    Dimensions.fontSizeLarge
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                        PopupMenuItem(
                          value: Dimensions.fontSizeExtraLarge,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('${S.of(context).Medium}'),
                            trailing: SharedPrefController()
                                        .getData(key: 'fontSize') ==
                                    Dimensions.fontSizeExtraLarge
                                ? Icon(Icons.check)
                                : null,
                          ),
                        ),
                        PopupMenuItem(
                          value: Dimensions.fontSizeOverLarge,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('${S.of(context).Large}'),
                            trailing: SharedPrefController()
                                        .getData(key: 'fontSize') ==
                                    Dimensions.fontSizeOverLarge
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                        PopupMenuItem(
                          value: Dimensions.fontSizeVeryOverLarge,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text('${S.of(context).Huge}'),
                            trailing: SharedPrefController()
                                        .getData(key: 'fontSize') ==
                                    Dimensions.fontSizeVeryOverLarge
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    '${S.of(context).Sort}',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                  trailing: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(Icons.keyboard_arrow_down),
                    onSelected: (value) {
                      // your logic
                    },
                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(
                          value: '1',
                          child: Text(
                            '${S.of(context).ByCreationdate}',
                          ),
                        ),
                        PopupMenuItem(
                          value: '2',
                          child: Text(
                            '${S.of(context).Bymodificationdate}',
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      '${S.of(context).layout}',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge),
                    ),
                    trailing: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down),
                      onSelected: (value) {
                        BlocProvider.of<CrudBloc>(context)
                            .add(GetAllNoteEvent());
                        SharedPrefController().setData('layout', value);
                      },
                      itemBuilder: (BuildContext bc) {
                        return [
                          PopupMenuItem(
                            value: 1.0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('${S.of(context).gridview}'),
                              trailing: SharedPrefController()
                                          .getData(key: 'layout') ==
                                      1.0
                                  ? const Icon(Icons.check)
                                  : null,
                            ),
                          ),
                          PopupMenuItem(
                            value: 2.0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('${S.of(context).Listview}'),
                              trailing: SharedPrefController()
                                          .getData(key: 'layout') ==
                                      2.0
                                  ? const Icon(Icons.check)
                                  : null,
                            ),
                          ),
                        ];
                      },
                    ))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).size.height * .47),
        ),
      ],
    );
  }
}
