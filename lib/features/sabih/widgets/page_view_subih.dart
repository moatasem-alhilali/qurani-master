import 'package:flutter/material.dart';
import 'package:quran_app/core/components/custom_svg_container.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';

class PageViewSubih extends StatelessWidget {
  const PageViewSubih({super.key, required this.controller});
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical! * 20,
      child: PageView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var data = subihdata[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: titleMedium(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.content,
                    style: titleSmall(context).copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: subihdata.length,
      ),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomSvgContainer(
        image: AssetsManager.tasbih,
        child: child,
      ),
    );
  }
}

//

class SubihModel {
  final String title;
  final String content;

  SubihModel({required this.title, required this.content});
}

List<SubihModel> subihdata = [
  SubihModel(title: "لا إاله إلا الله", content: "أفضل الذكر لا اله الا الله"),
  SubihModel(
      title: "سبحان الله", content: "يكتب له الف حسنة او يحط عنه ألف خطيئة"),
  SubihModel(
      title: "سبحان الله والحمدلله ", content: "تملان ما بين السماوات والارأض"),
  SubihModel(
      title: "سبحان الله وبحمده سبحان الله العظيم",
      content: "ثقيلتان في الميزان حبيبتان للرحمن"),
  SubihModel(title: "لا حول ولا قوة إلا بالله", content: "كنز من كنوز الجنة"),
  SubihModel(
      title: "اللهم صلي وسلم وبارك على نبينا محمد",
      content: "من صلى عليه حين يصبح وحين يمسي ادركته شفاعتي يوم القيامة"),
  SubihModel(title: "أستغفر الله", content: "لفعل الرسول صلى الله عليه وسلم"),
  SubihModel(
      title: "سبحان الله والحمدلله ولإله إلا الله والله أكبر",
      content:
          "أنهن أحب الكلام إلا الله ومكفرات للذنوب وغرس الجنة ,وجنة لقائلهن من النار ,وأحب إلى النبي عليه السلام مما طلعت عليه الشمس والباقيات الصالحات"),
  SubihModel(
      title: "الله أكبر",
      content:
          "من قال الله أكبر كتبت له عشرون حسنة وحطت عنه عشرون سيئة الله أكبر من كل شيء"),
  SubihModel(
      title: "الله أكبر وكبيرا,والحمدلله بكرة وأصيلا ",
      content: "قال النبي صلى الله عليه وسلم  :عجبت لها فتحت لها ابواب السماء"),
  SubihModel(
      title: "الحمدلله حمد كثيرا طيبا مباركا فيه",
      content:
          "قال النبي صلى الله عليه وسلم :لقد رأيت اثني عشر ملكا يبتدرونها أيهم يرفعها"),
  SubihModel(
      title: "الحمد لله رب العالمين", content: "تملأ ميزان العبد بالحسنات"),
];
