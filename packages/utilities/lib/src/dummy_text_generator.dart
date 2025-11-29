import 'dart:math';

const _dummyTextEN = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In pellentesque massa placerat duis ultricies lacus sed. Duis at tellus at urna. Vel risus commodo viverra maecenas. Scelerisque purus semper eget duis at. Augue ut lectus arcu bibendum at varius vel pharetra. Quisque sagittis purus sit amet. At auctor urna nunc id cursus metus aliquam. Amet volutpat consequat mauris nunc congue nisi vitae. Tincidunt ornare massa eget egestas purus. Ipsum nunc aliquet bibendum enim facilisis gravida. Morbi tincidunt augue interdum velit euismod. Euismod elementum nisi quis eleifend quam adipiscing vitae proin. Bibendum at varius vel pharetra vel turpis. Diam maecenas sed enim ut sem. Malesuada pellentesque elit eget gravida. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Vestibulum lectus mauris ultrices eros in cursus turpis massa tincidunt. Enim sit amet venenatis urna cursus. Cras sed felis eget velit aliquet sagittis id consectetur purus.
''';

const _dummyTextAR = '''
لكن لا بد أن أوضح لك أن كل هذه الأفكار المغلوطة حول استنكار  النشوة وتمجيد الألم نشأت بالفعل، وسأعرض لك التفاصيل لتكتشف حقيقة وأساس تلك السعادة البشرية، فلا أحد يرفض أو يكره أو يتجنب الشعور بالسعادة، ولكن بفضل هؤلاء الأشخاص الذين لا يدركون بأن السعادة لا بد أن نستشعرها بصورة أكثر عقلانية ومنطقية فيعرضهم هذا لمواجهة الظروف الأليمة، وأكرر بأنه لا يوجد من يرغب في الحب ونيل المنال ويتلذذ بالآلام، الألم هو الألم ولكن نتيجة لظروف ما قد تكمن السعاده فيما نتحمله من كد وأسي.

و سأعرض مثال حي لهذا، من منا لم يتحمل جهد بدني شاق إلا من أجل الحصول على ميزة أو فائدة؟ ولكن من لديه الحق أن ينتقد شخص ما أراد أن يشعر بالسعادة التي لا تشوبها عواقب أليمة أو آخر أراد أن يتجنب الألم الذي ربما تنجم عنه بعض المتعة ؟ 
علي الجانب الآخر نشجب ونستنكر هؤلاء الرجال المفتونون بنشوة اللحظة الهائمون في رغباتهم فلا يدركون ما يعقبها من الألم والأسي المحتم، واللوم كذلك يشمل هؤلاء الذين أخفقوا في واجباتهم نتيجة لضعف إرادتهم فيتساوي مع هؤلاء الذين يتجنبون وينأون عن تحمل الكدح والألم .
''';

String generateRandomDummyText({num length = 50, bool isArabic = false}) {
  final value = Random().nextInt(length.toInt());
  if (isArabic) return _dummyTextAR.substring(0, value + 1);
  return _dummyTextEN.substring(0, value + 1);
}
