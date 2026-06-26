import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class AiPlannerScreen extends StatefulWidget {
  const AiPlannerScreen({super.key});

  @override
  State<AiPlannerScreen> createState() => _AiPlannerScreenState();
}

class _AiPlannerScreenState extends State<AiPlannerScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _showItinerary = false;

  final List<Map<String, String>> _quickPrompts = [
    {'label': 'Weekend Trip 🏖️', 'prompt': 'আমি একটি weekend trip plan করতে চাই'},
    {'label': 'Family Trip 👨‍👩‍👧', 'prompt': 'পরিবার নিয়ে ৪ দিনের ট্রিপ plan করুন'},
    {'label': 'Budget Travel 💰', 'prompt': 'কম বাজেটে ভ্রমণের পরামর্শ দিন'},
    {'label': 'Solo Adventure 🎒', 'prompt': 'একা ভ্রমণের জন্য সেরা জায়গা কোনগুলো?'},
    {'label': 'Honeymoon 💑', 'prompt': 'রোমান্টিক হানিমুন ট্রিপ plan করুন'},
  ];

  @override
  void initState() {
    super.initState();
    _addAiMessage('স্বাগতম! 🌍 আমি আপনার AI Travel Planner। আপনি কোথায় এবং কতদিনের জন্য ভ্রমণ করতে চান? বাজেট এবং পছন্দ জানালে সম্পূর্ণ ভ্রমণ পরিকল্পনা তৈরি করে দেব।');
  }

  void _addAiMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _inputController.clear();
    _scrollToBottom();

    await Future.delayed(2000.ms);
    if (!mounted) return;
    setState(() => _isTyping = false);

    // Simulate AI response with itinerary
    if (text.contains('বান্দরবান') || text.contains('Bandarban') || _messages.length >= 4) {
      _addAiMessage('দারুণ পরিকল্পনা! আপনার জন্য একটি বিস্তারিত ভ্রমণ পরিকল্পনা তৈরি করেছি 👇');
      setState(() => _showItinerary = true);
    } else {
      _addAiMessage('আচ্ছা! আপনি কত জন যাবেন এবং বাজেট কত? তাহলে আরও নির্দিষ্ট পরিকল্পনা করতে পারব। 😊');
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text('AI Trip Planner', style: AppTextStyles.headlineSm),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _messages.clear();
                _showItinerary = false;
              });
              _addAiMessage('নতুন পরিকল্পনা শুরু করা হয়েছে। আপনি কোথায় যেতে চান?');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick prompts
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _quickPrompts.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _sendMessage(_quickPrompts[i]['prompt']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outlineVariant),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                    ),
                    child: Text(_quickPrompts[i]['label']!, style: AppTextStyles.labelMd),
                  ),
                ),
              ),
            ),
          ),

          // Chat messages
          Expanded(
            child: Stack(
              children: [
                // Dot pattern bg
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 15,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (_, __) => CircleAvatar(
                        radius: 2,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0) + (_showItinerary ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i < _messages.length) {
                      return _ChatBubble(message: _messages[i])
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.2, duration: 300.ms);
                    }
                    if (_isTyping && i == _messages.length) {
                      return const _TypingIndicator();
                    }
                    if (_showItinerary) {
                      return const _ItineraryCard()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3);
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),

          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: TextField(
                      controller: _inputController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'আপনার ভ্রমণ পরিকল্পনা লিখুন...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_inputController.text),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 15, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.primary : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.bodyMd.copyWith(
                  color: message.isUser ? AppColors.onPrimary : AppColors.onBackground,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, size: 16, color: AppColors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            width: 8, height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(color: AppColors.outline, shape: BoxShape.circle),
          ).animate(onPlay: (c) => c.repeat()).fadeIn(delay: (i * 200).ms).then().fadeOut()),
        ),
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  const _ItineraryCard();

  @override
  Widget build(BuildContext context) {
    final days = [
      {'day': 'দিন ১', 'theme': 'আগমন', 'desc': 'বান্দরবান পৌঁছানো, হোটেলে check-in, বাজার ঘোরা ও রাতের খাবার।'},
      {'day': 'দিন ২', 'theme': 'এক্সপ্লোর', 'desc': 'নীলগিরি, শৈলপ্রপাত, চিম্বুক পাহাড় ভ্রমণ।'},
      {'day': 'দিন ৩', 'theme': 'ট্রেক', 'desc': 'বগালেক ট্রেক, সূর্যোদয় দেখা, সাঙ্গু নদী।'},
      {'day': 'দিন ৪', 'theme': 'প্রস্থান', 'desc': 'সকালে নাশতা, শেষ কেনাকাটা এবং ঢাকার উদ্দেশ্যে রওনা।'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Stack(
              children: [
                Image.network(AppConstants.bandarbanImage, fit: BoxFit.cover, width: double.infinity,
                    errorBuilder: (_, __, ___) => const SizedBox()),
                Container(decoration: const BoxDecoration(gradient: AppColors.heroGradient)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: AppColors.secondaryContainer, size: 16),
                          const SizedBox(width: 6),
                          Text('AI Generated Plan', style: AppTextStyles.labelMd.copyWith(color: AppColors.secondaryContainer, letterSpacing: 0.5)),
                        ],
                      ),
                      Text('বান্দরবান ৪ দিনের অ্যাডভেঞ্চার', style: AppTextStyles.headlineSm.copyWith(color: Colors.white)),
                      Text('৫ জন · মধ্যম গতির', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Day timeline
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(days.length, (i) {
                final d = days[i];
                final isLast = i == days.length - 1;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline
                      Column(
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(
                              color: i == 0 ? AppColors.secondaryContainer : AppColors.outlineVariant,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
                            ),
                          ),
                          if (!isLast)
                            Expanded(child: Container(width: 1.5, color: AppColors.outlineVariant)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(d['day']!, style: AppTextStyles.titleMd.copyWith(color: AppColors.primary)),
                                  const Spacer(),
                                  Text(d['theme']!, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(d['desc']!, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Cost summary
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('বাজেট বিশ্লেষণ', style: AppTextStyles.titleMd.copyWith(color: AppColors.primary)),
                const SizedBox(height: 10),
                ...[
                  {'label': 'হোটেল (৩ রাত × ২ রুম)', 'amount': '৳৪,৮০০'},
                  {'label': 'পরিবহন (বাস, রাউন্ড ট্রিপ)', 'amount': '৳৩,৫০০'},
                  {'label': 'খাবার (আনুমানিক)', 'amount': '৳৪,০০০'},
                  {'label': 'প্রবেশ ফি ও কার্যক্রম', 'amount': '৳১,২০০'},
                ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item['label']!, style: AppTextStyles.bodyMd)),
                      Text(item['amount']!, style: AppTextStyles.labelLg.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
                const Divider(),
                Row(
                  children: [
                    Text('মোট', style: AppTextStyles.titleMd),
                    const Spacer(),
                    Text('৳১৩,৫০০', style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('বাজেটের মধ্যে ✅',
                          style: AppTextStyles.labelSm.copyWith(color: AppColors.successGreen, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('পরিবর্তন'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_rounded, size: 16),
                    label: const Text('প্ল্যান সেভ করুন'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
