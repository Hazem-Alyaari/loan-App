import 'package:flutter/material.dart';
import 'package:loan/core/theme/app_theme.dart';

/// سياسة خصوصية عامة للتطبيق — يُنصح بمراجعتها مع مستشار قانوني قبل النشر التجاري.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'آخر تحديث: ${DateTime.now().year}',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _section(
                  title: '1. مقدمة',
                  body:
                      'نلتزم بحماية خصوصيتك. توضح هذه السياسة كيفية جمع واستخدام ومشاركة المعلومات عند استخدام التطبيق (إدارة المجموعات والمعاملات والأرصدة والإشعارات). باستخدامك للتطبيق فإنك توافق على هذه السياسة.',
                ),
                _section(
                  title: '2. البيانات التي نجمعها',
                  body:
                      '• معلومات الحساب: الاسم، رقم الهاتف أو البريد، وبيانات تسجيل الدخول عبر مزودي الهوية (مثل Google) عند تفعيلهم.\n'
                      '• بيانات المجموعات والمعاملات: المبالغ، الأطراف، الحالات، والملاحظات التي تُدخلها داخل المجموعات.\n'
                      '• بيانات الجهاز والاستخدام: معرفات تقنية ضرورية لتشغيل الخدمة (مثل معرف المستخدم في النظام الخلفي).\n'
                      '• الإشعارات: محتوى الإشعارات المتعلقة بالمعاملات والموافقات والتسويات.',
                ),
                _section(
                  title: '3. أساس الاستخدام',
                  body:
                      'نستخدم البيانات لتشغيل التطبيق، وعرض الأرصدة والمعاملات، وإرسال الإشعارات للمستخدمين المعنيين، وتحسين الأمان والاستقرار، والامتثال للالتزامات القانونية عند الاقتضاء.',
                ),
                _section(
                  title: '4. المشاركة مع أطراف ثالثة',
                  body:
                      'قد نعتمد على مزودي خدمات (مثل استضافة البيانات والمصادقة والإشعارات) لمعالجة البيانات نيابةً عنا وفق عقودهم وسياساتهم. لا نبيع بياناتك الشخصية لأطراف ثالثة لأغراض تسويقية.',
                ),
                _section(
                  title: '5. التخزين والأمان',
                  body:
                      'نتخذ تدابير تقنية وتنظيمية معقولة لحماية البيانات. لا يوجد نظام آمن بنسبة 100٪؛ يرجى استخدام كلمة مرور قوية وعدم مشاركة حسابك.',
                ),
                _section(
                  title: '6. الاحتفاظ بالبيانات',
                  body:
                      'نحتفظ بالبيانات طالما كان حسابك نشطًا أو حسب الحاجة لتقديم الخدمة والالتزامات القانونية. يمكنك طلب حذف الحساب وفق إمكانيات التطبيق والقانون المعمول به.',
                ),
                _section(
                  title: '7. حقوقك',
                  body:
                      'حسب القانون المعمول ببلدك، قد يحق لك الوصول إلى بياناتك أو تصحيحها أو حذفها أو تقييد المعالجة. تواصل معنا عبر قنوات الدعم الرسمية للتطبيق.',
                ),
                _section(
                  title: '8. التحديثات',
                  body:
                      'قد نعدّل هذه السياسة من وقت لآخر. سيتم إشعارك بشكل معقول عند التغييرات الجوهرية عندما يقتضي القانون أو التطبيق ذلك.',
                ),
                _section(
                  title: '9. التواصل',
                  body:
                      'للاستفسارات المتعلقة بالخصوصية، يرجى التواصل عبر وسيلة الدعم الرسمية المعلنة في التطبيق أو على صفحة المطوّر.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section({required String title, required String body}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

extension OpenPrivacyPolicy on BuildContext {
  void openPrivacyPolicy() {
    Navigator.of(this).push<void>(
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }
}
