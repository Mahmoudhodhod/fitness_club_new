import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_coach/Helpers/network.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.isArabic;
    return Scaffold(
      appBar: CAppBar(header: LocaleKeys.about_credits.tr()),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.person_3_fill,
                  size: screenSize.width * 0.3,
                  color: CColors.switchable(
                    context,
                    dark: CColors.fancyBlack,
                    light: Colors.grey.shade400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(_about(context)),
                ),
                _HeadLine(
                  title: LocaleKeys.about_app_owner.tr() + "\t💪\t",
                  details: 'محمود سعد',
                ),
                const Space.v10(),
                _Certs(),
                const Space.v10(),
                _HeadLine(
                  onTap: () {
                    launchUri("https://coachmahmoud.com/online-training/");
                  },
                  title: "Facebook",
                  details: 'زوروا صفحتنا على الفيسبوك',
                ),
                const Divider(endIndent: 30, indent: 30),
                _HeadLine(
                  onTap: null,
                  // () {
                  //   launchUri(
                  //       "https://www.linkedin.com/in/ahmed-mahmoud-609b951a5/");
                  //   // _openUrl(
                  //   //   context,
                  //   //   url: _Url('https://www.linkedin.com/in/ahmed-mahmoud-609b951a5/'),
                  //   //   linkedIn: 'Ahmed Mahmoud',
                  //   // );
                  // },
                  title: LocaleKeys.about_front_end.tr(),
                  details: isArabic ? 'احمد محمود' : 'Ahmed Mahmoud',
                ),
                _HeadLine(
                  onTap: null,
                  title: LocaleKeys.about_support_front_end.tr(),
                  details: isArabic ? 'محمد صالحه' : 'Mohammed Salha',
                ),
                _HeadLine(
                  onTap: null,
                  // () {
                  //   launchUri(
                  //       "https://www.linkedin.com/in/michael-nabil-015825210/");
                  //   // _openUrl(
                  //   //   context,
                  //   //   url: _Url('https://www.linkedin.com/in/michael-nabil-015825210/'),
                  //   //   linkedIn: 'Michael Nabil',
                  //   // );
                  // },
                  title: LocaleKeys.about_back_end.tr(),
                  details: isArabic ? 'مايكل نبيل' : 'Michael Nabil',
                ),
                _ThanksTo(
                  title: LocaleKeys.about_thanks_to.tr(args: ['']),
                  details: [
                    _ThanksToDetails(
                      onTap: () {
                        _openUrl(
                          context,
                          url: _Url(
                            'https://notificationsounds.com/',
                            'notificationsounds.com',
                          ),
                        );
                      },
                      details: 'notificationsounds.com',
                    ),
                    _ThanksToDetails(
                      onTap: () {
                        _openUrl(
                          context,
                          url: _Url(
                            'https://fonts.google.com/specimen/Tajawal?subset=arabic',
                            'Google Fonts - Tajawal',
                          ),
                        );
                      },
                      details: 'Google Fonts',
                    ),
                  ],
                ),
                const Space.v30(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openUrl(BuildContext context,
      {_Url? url, String? whatsApp, String? linkedIn}) {
    final _ = [
      if (whatsApp != null)
        ListTile(
          onTap: () => launchUri("https://wa.me/$whatsApp"),
          leading: Icon(FontAwesomeIcons.whatsapp),
          title: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              whatsApp,
              textDirection: ui.TextDirection.ltr,
            ),
          ),
        ),
      if (linkedIn != null)
        ListTile(
          onTap: () {
            assert(url != null);
            launchUri(url!.data);
          },
          leading: Icon(
            FontAwesomeIcons.linkedinIn,
            color: CColors.primary(context),
          ),
          title: Text(linkedIn),
        ),
      if (url?.name != null)
        ListTile(
          onTap: () => launchUri(url.data),
          leading: Icon(FontAwesomeIcons.globeAfrica),
          title: Text(url!.name ?? url.data),
        ),
    ];

    CustomBottomSheet(
      delegate: BottomSheetDelegate(
        listDelegate: ListDelegate(
          itemCount: _.length,
          builder: (context, index) => _[index],
        ),
      ),
    ).show(NavigationService.context!);
  }

  String _about(BuildContext context) {
    final isArabic = context.locale.isArabic;
    if (isArabic) {
      return '''
اهلا بيك في تطبيق الكابتن ، انا محمود سعد مدرب معتمد دوليا من اكادمية issa من كالفورنيا اخصائي تغذية و تجهيز برامج تمارين .
بدات اروح الچيم من ٢٠٠٨ و كانت الهواية المفضلة بالنسبالي و فضلت مكمل فترة كبيرة و بعد تخرجي من كلية الهندسة جامعة القاهرة كنت مقرر اني اكمل في المجال اللي انا بحبه كمال اجسام و الفيتنس .
فكرت اني اعمل start up اوصل بيه لاكبر عدد من الناس اساعدهم في التمرين و اشجعهم على الرياضة بشكل عام و الحفاظ على الصحة العامة .
بدات ٢٠١٩ و قدرت اوصل لعدد اكبر من ١٠٠ الف متدرب في اول ٣ سنين الحمد لله و ان شاء مكمل و اقدر اوصل لكل المتدربين في الدول العربية .
''';
    }
    return '''
Welcome to the Captain app, I am Mahmoud Saad, an internationally certified trainer from Issa Academy in California , a nutritionist and training program provider .
I started going to the gym in 2008, and it was my favorite hobby , and I preferred to continue for a long time . 
After graduating from the Faculty of Engineering , Cairo University , I decided to continue in the field that I love bodybuilding and fitness .
I thought that I would make start up and connect it to the largest number of people, help them to exercise and encourage them in general and maintain public health.
I started at 2019 and I was able to reach more than 100,000 trainees in the first 3 years , my division is to reach more people around the middle east .
''';
  }
}

class _Certs extends StatelessWidget {
  const _Certs({
    Key? key,
  }) : super(key: key);

  void _openUri(String path) async {
    final uri = Uri.parse("https://el-captain.net/storage/certs")
        .addSegment("/" + path + ".pdf");
    await url_launcher.launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle s = TextButton.styleFrom(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      minimumSize: Size(64, 30),
    );
    return Column(
      children: [
        Text("حاصلون علي اعرق الشهادات العالمية"),
        const Space.v5(),
        TextButton.icon(
          onPressed: openISSACert,
          style: s,
          icon: Icon(Icons.open_in_new, size: 14),
          label: Text("ISSA Certificate"),
        ),
        TextButton.icon(
          onPressed: () {
            _openUri("bodycompat_certificate");
          },
          style: s,
          icon: Icon(Icons.open_in_new, size: 14),
          label: Text("Bodycompat Certificate"),
        ),
        TextButton.icon(
          onPressed: () {
            _openUri("bodypump_certificate");
          },
          style: s,
          icon: Icon(Icons.open_in_new, size: 14),
          label: Text("Bodypump Certificate"),
        ),
        TextButton.icon(
          onPressed: () {
            _openUri("saudi_reps_certificate");
          },
          style: s,
          icon: Icon(Icons.open_in_new, size: 14),
          label: Text("Saudi Reps Certificate"),
        ),
      ],
    );
  }
}

@immutable
class _Url {
  final String data;
  final String? name;
  _Url(this.data, [this.name]);
}

class _HeadLine extends StatelessWidget {
  final String title;
  final String details;
  final VoidCallback? onTap;

  const _HeadLine({
    Key? key,
    required this.title,
    required this.details,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CColors.secondary(context),
                ),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    details,
                    style: theme(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const Space.h5(),
                  if (onTap != null)
                    Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: CColors.primary(context),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _ThanksToDetails {
  final String details;
  final VoidCallback? onTap;
  _ThanksToDetails({
    required this.details,
    this.onTap,
  });
}

class _ThanksTo extends StatelessWidget {
  final String title;
  final List<_ThanksToDetails> details;

  const _ThanksTo({
    Key? key,
    required this.title,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme(context).textTheme.bodySmall?.copyWith(
                  color:
                      CColors.nullableSwitchable(context, light: Colors.black),
                ),
            textAlign: TextAlign.center,
          ),
          const Space.v5(),
          Column(
            children: List.generate(details.length, (index) {
              final detail = details[index];
              return InkWell(
                onTap: detail.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        detail.details,
                        style: theme(context).textTheme.bodySmall?.copyWith(
                              color: CColors.nullableSwitchable(context,
                                  light: Colors.black),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Space.h5(),
                      if (detail.onTap != null)
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: CColors.primary(context),
                        ),
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
