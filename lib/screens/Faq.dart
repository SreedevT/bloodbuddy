//import 'package:blood_buddy/BottomNavBar.dart';
import 'package:flutter/material.dart';
class FAQPage extends StatefulWidget {
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search for anything',
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 231, 231),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
        ),
        child: ListView(
          children: <Widget>[
            ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Who can donate blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generally, individuals who are in good health and meet the specific eligibility criteria set by blood service organizations can donate blood.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
   ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'How often can I donate blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Donors can donate whole blood every 8 to 12 weeks (approximately 56 to 84 days).',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
     ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'How long does a blood donation take?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The entire blood donation process typically takes around 30 to 60 minutes, although it may vary depending on factors such as individual circumstances, the type of donation, and the efficiency of the blood center or organization.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
        ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Are there any side effects of donation?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'While most donors experience no adverse effects, some may encounter minor side effects such as lightheadedness, dizziness, or bruising at the needle insertion site. These symptoms are usually temporary and resolve quickly. Blood collection centers have trained staff to handle any complications that may arise.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
    ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'How can I prepare to donate blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eat at your regular mealtimes and drink plenty of fluid before you donate blood. Have a snack at least four hours before you donate, but do not eat too much right before the donation.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Can I donate if I am taking medicine?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most medicines do not prevent you from donating blood. Common medicines — such as those used to control blood pressure, birth control pills and the type of medicines you can get without a prescription — do not affect your eligibility.If you are taking antibiotics to treat a current infection, you must complete the course before donating. ',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
     ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'What is a “unit” of blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A unit is about 450 ml of donated blood. The average adult has between four and five litres of blood in his or her body, and can easily spare one unit.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
         ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Can I donate if I have diabetes?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'If your diabetes is being treated and is under control, you are most likely able to donate blood. You should let your doctor know that you plan to donate.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
       ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'What is the rarest blood type?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AB negative is the rarest of the eight main blood types - just 1% of our donors have it.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
        ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        ' Why I have to wait between donations?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'While the plasma is replenished quickly, it can take four to six weeks for your body to manufacture the red blood cells that are lost. If you are only donating platelets, which your body replaces within a day, you can give again after a week. However, you are restricted to only 24 total platelet donations a year.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
         ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Is it safe to donate blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yes, donating blood is generally considered safe. Blood collection is conducted using sterile equipment, and all necessary precautions are taken to ensure donor safety and minimize any potential risks.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
 ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Can I donate blood if I have a tattoo?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'There may be a deferral period after getting a tattoo or body piercing,this is to minimize the risk of bloodborne infections. The deferral period can range from a few months to a year or more.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
         ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Can I donate if recently I had surgery?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The eligibility to donate blood after surgery depends on various factors such as the type of surgery, the recovery period, and individual health. In most cases, there is a waiting period before individuals can donate blood after surgery to ensure proper healing and recovery. The waiting period can range from a few weeks to several months.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
         ExpansionTile(
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
      const SizedBox(width: 8.0),
      const Text(
        'Are there any benefits to donating blood?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yes, donating blood can have several benefits. It provides an opportunity to help others and contribute to the community. Additionally, regular blood donation may help in identifying potential health issues as donors undergo a screening process that includes checking for various health parameters such as blood pressure, hemoglobin levels, and infectious diseases.',
          ),
          const SizedBox(height: 8.0), // Add space below the line
        ],
      ),
    ),
  ],
),
            // Add more ExpansionTile widgets for additional questions
          ],
        ),
      ),
    );
  }
}












