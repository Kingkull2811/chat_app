class TermPolicyModel {
  final int index;
  final String title, content;

  TermPolicyModel({
    required this.index,
    required this.title,
    required this.content,
  });
}

List<TermPolicyModel> listTermPolicy = [
  TermPolicyModel(
    index: 1,
    title: 'Account Registration',
    content:
        'To access the features of our Learning Results Management App and Information Exchange platform, users are required to create an account. By registering, users agree to provide accurate and complete information and to maintain the confidentiality of their account credentials. Users are responsible for all activities that occur under their account',
  ),
  TermPolicyModel(
    index: 2,
    title: 'Data Collection and Usage',
    content:
        'We collect and process personal information in accordance with applicable data protection laws. The information collected may include user names, contact details, and academic data. This data is used to provide personalized services, facilitate communication between teachers and parents, and improve the overall user experience. We do not sell or share personal information with third parties without explicit consent, except as required by law or for legitimate business purposes.',
  ),
  TermPolicyModel(
    index: 3,
    title: 'Information Exchange',
    content:
        'Our app facilitates the exchange of information between teachers and parents of students in an online school setting. Users understand that any information shared through the platform, including messages, announcements, and academic data, may be visible to authorized users. Users are responsible for the content they share and should exercise caution when disclosing personal or sensitive information.',
  ),
  TermPolicyModel(
    index: 4,
    title: 'User Conduct',
    content:
        'Users are expected to use the Learning Results Management App and Information Exchange platform responsibly and in compliance with applicable laws and regulations. Any form of harassment, abuse, or inappropriate behavior towards other users is strictly prohibited. Users shall not engage in activities that may disrupt the app\'s functionality or compromise the security of the platform.',
  ),
  TermPolicyModel(
    index: 5,
    title: 'Intellectual Property',
    content:
        'All intellectual property rights, including but not limited to trademarks, copyrights, and proprietary content, associated with our app and its features, belong to us or our licensors. Users are prohibited from reproducing, modifying, or distributing any part of the app or its content without obtaining explicit permission.',
  ),
  TermPolicyModel(
    index: 6,
    title: 'Third-Party Integration',
    content:
        'Our app may integrate with third-party services or websites to enhance functionality or provide additional resources. Users acknowledge that the use of such third-party services is subject to their respective terms and policies, and we are not responsible for any actions or consequences resulting from interactions with these third-party services.',
  ),
  TermPolicyModel(
    index: 7,
    title: 'Limitation of Liability',
    content:
        'While we strive to provide accurate and reliable information, we do not guarantee the completeness, accuracy, or reliability of the content within our app. Users acknowledge that the use of the app is at their own risk, and we shall not be held liable for any direct or indirect damages arising from the use of our app or reliance on its content.',
  ),
  TermPolicyModel(
    index: 8,
    title: 'Modifications to the App and Policies',
    content:
        'We reserve the right to update, modify, or discontinue any aspect of our Learning Results Management App and Information Exchange platform, as well as its terms and policies, at any time. Users will be notified of any significant updates, and continued use of the app constitutes acceptance of the modified terms.',
  ),
];
