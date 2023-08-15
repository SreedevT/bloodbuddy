//import 'package:blood_buddy/BottomNavBar.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});
  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0,
        title: const Text(
          "FAQS",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
        ),
        child: ListView(
          children: <Widget>[
            faqTile(
                question: 'Who can donate blood?',
                answer:
                    'Generally, individuals who are in good health and meet the specific eligibility criteria set by blood service organizations can donate blood.'),
            faqTile(
                question: "How often can I donate blood?",
                answer:
                    "Donors can donate whole blood every 8 to 12 weeks (approximately 56 to 84 days)."),
            //convert this to expansion tile
            faqTile(
                question: "How long does a blood donation take?",
                answer:
                    "The entire blood donation process typically takes around 30 to 60 minutes, although it may vary depending on factors such as individual circumstances, the type of donation, and the efficiency of the blood center or organization."),
            //convert this to expansion tile
            faqTile(
                question: "Are there any side effects of donation?",
                answer:
                    "While most donors experience no adverse effects, some may encounter minor side effects such as lightheadedness, dizziness, or bruising at the needle insertion site. These symptoms are usually temporary and resolve quickly. Blood collection centers have trained staff to handle any complications that may arise."),
            //convert this to expansion tile
            faqTile(
                question: "How can I prepare to donate blood?",
                answer:
                    "Eat at your regular mealtimes and drink plenty of fluid before you donate blood. Have a snack at least four hours before you donate, but do not eat too much right before the donation."),
            //convert this to expansion tile
            faqTile(
                question: "Can I donate if I am taking medicine?",
                answer:
                    "Most medicines do not prevent you from donating blood. Common medicines — such as those used to control blood pressure, birth control pills and the type of medicines you can get without a prescription — do not affect your eligibility.If you are taking antibiotics to treat a current infection, you must complete the course before donating. "),
            //convert this to expansion tile
            faqTile(
                question: "What is a “unit” of blood?",
                answer:
                    "A unit is about 450 ml of donated blood. The average adult has between four and five litres of blood in his or her body, and can easily spare one unit."),
            //convert this to expansion tile
            faqTile(
                question: "Can I donate if I have diabetes?",
                answer:
                    "If your diabetes is being treated and is under control, you are most likely able to donate blood. You should let your doctor know that you plan to donate."),
            //convert this to expansion tile
            faqTile(
                question: "What is the rarest blood type?",
                answer:
                    "AB negative is the rarest of the eight main blood types - just 1% of our donors have it."),
            //convert this to expansion tile
            faqTile(
                question: "Why I have to wait between donations?",
                answer:
                    "While the plasma is replenished quickly, it can take four to six weeks for your body to manufacture the red blood cells that are lost. If you are only donating platelets, which your body replaces within a day, you can give again after a week. However, you are restricted to only 24 total platelet donations a year."),
            //convert this to expansion tile
            faqTile(
                question: "Is it safe to donate blood?",
                answer:
                    "Yes, donating blood is generally considered safe. Blood collection is conducted using sterile equipment, and all necessary precautions are taken to ensure donor safety and minimize any potential risks."),
            //convert this to expansion tile
            faqTile(
                question: "Can I donate blood if I have a tattoo?",
                answer:
                    "There may be a deferral period after getting a tattoo or body piercing,this is to minimize the risk of bloodborne infections. The deferral period can range from a few months to a year or more."),
            //convert this to expansion tile
            faqTile(
                question: "Can I donate if recently I had surgery?",
                answer:
                    "The eligibility to donate blood after surgery depends on various factors such as the type of surgery, the recovery period, and individual health. In most cases, there is a waiting period before individuals can donate blood after surgery to ensure proper healing and recovery. The waiting period can range from a few weeks to several months."),
            faqTile(
                question: 'Are there any benefits to donating blood?',
                answer:
                    'Yes, donating blood can have several benefits. It provides an opportunity to help others and contribute to the community. Additionally, regular blood donation may help in identifying potential health issues as donors undergo a screening process that includes checking for various health parameters such as blood pressure, hemoglobin levels, and infectious diseases.')
            // Add more ExpansionTileCard widgets for additional questions
          ],
        ),
      ),
    );
  }

  ExpansionTileCard faqTile(
      {required String question, required String answer}) {
    return ExpansionTileCard(
      baseColor: Colors.white,
      initialPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      title: Row(
        children: [
          Container(
            height: 12.0,
            width: 12.0,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 15.0,
              // fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }
}
