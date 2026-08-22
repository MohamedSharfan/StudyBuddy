import '../domain/chapter.dart';
import '../domain/flashcard.dart';
import '../domain/lesson_note.dart';
import '../domain/quiz_question.dart';

// Chapter 2: ஈமானும் அமலும்
final islamChapter2 = Chapter(
  id: 'chapter-2-imaan-amal',
  title: 'ஈமானும் அமலும்',
  progress: 0,
  notes: const [
    LessonNote(
      id: 'imaan-amal-learn',
      title: '📖 எளிய குறிப்புகள்',
      summary: 'ஈமானும் அமலும் - மலரும் நறுமணமும் போல் இணைந்தவை',
      body: '''**கேள்வி: ஈமான் என்றால் என்ன?**
• இஸ்லாம் கூறும் நம்பிக்கைகளை உள்ளத்தால் ஏற்று, நாவால் மொழிந்து, செயலால் உண்மைப்படுத்துவது

**கேள்வி: அமல் என்றால் என்ன?**
• ஈமானின் போதனைகளை நடைமுறையில் செயல்படுத்துவது (வழிபாடு, நற்செயல்கள்)

**கேள்வி: ஈமானுக்கும் அமலுக்கும் உள்ள தொடர்பு என்ன?**
• இரண்டும் பிரிக்கமுடியாதவை — மலரும் நறுமணமும் போல இணைந்தவை
• ஈமான் இல்லாத அமலோ, அமல் இல்லாத ஈமானோ முழுமையானதாக ஏற்கப்படாது

📌 குர்ஆனில் 70க்கும் மேற்பட்ட இடங்களில் ஈமானும் அமலும் சேர்த்துக் கூறப்பட்டுள்ளன

**கேள்வி: முஃமின் (உண்மை நம்பிக்கையாளர்) யார்?**
• இஸ்லாத்தின் நம்பிக்கைகளை ஏற்று, அதற்கேற்ப அமல் செய்பவர்

**கேள்வி: ஈமான் எத்தனை கிளைகளைக் கொண்டது?**
• 70க்கும் மேற்பட்டவை
• மிக உயர்ந்தது: லாயிலாஹ இல்லல்லாஹ் (கலிமா)
• மிகத் தாழ்ந்தது: வழியில் இடர் தரும் பொருட்களை அகற்றுதல்
• வெட்கமும் ஈமானின் ஒரு பகுதி

**கேள்வி: ஸாலிஹான அமல் (நல்ல செயல்) என்றால் என்ன?**
• உரிய நேரத்திற்குப் பொருத்தமான உரிய செயல்
• உலக-மறுமை, தனிநபர்-சமூக, ஆன்மீக-லௌகீக வாழ்விற்குப் பொருத்தமாக அமையும் செயல்

**கேள்வி: முஃமினுக்கும் காஃபிருக்கும் உள்ள முக்கிய வேறுபாடு என்ன?**
• தொழுகையை விடுவது முஃமினுக்கும் காஃபிருக்கும் இடையிலான வேறுபாடு (நபிமொழி)

**கேள்வி: அல்குர்ஆன் ஈமான் இல்லாத அமலை எதற்கு ஒப்பிடுகிறது?**
• வனாந்தரத்தில் தோன்றும் கானல் நீருக்கு (தூரத்தில் தண்ணீர் போல் தெரியும், நெருங்கும்போது ஒன்றுமில்லை)''',
      examTip: 'ஈமானும் அமலும் பிரிக்க முடியாதவை என்பதை நினைவில் வைத்திருங்கள்.',
      estimatedMinutes: 12,
    ),
  ],
  flashcards: const [
    Flashcard(id: 'im-f1', front: 'ஈமான் என்றால் என்ன?', back: 'உள்ளத்தால் ஏற்று, நாவால் மொழிந்து, செயலால் உண்மைப்படுத்துதல்'),
    Flashcard(id: 'im-f2', front: 'அமல் என்றால் என்ன?', back: 'ஈமானை நடைமுறையில் செயல்படுத்துதல்'),
    Flashcard(id: 'im-f3', front: 'ஈமானும் அமலும் எதற்கு ஒப்பிடப்படுகின்றன?', back: 'மலரும் நறுமணமும்'),
    Flashcard(id: 'im-f4', front: 'குர்ஆனில் எத்தனை இடங்களில் ஈமான்+அமல் சேர்த்துக் கூறப்பட்டுள்ளன?', back: '70க்கும் மேற்பட்ட இடங்களில்'),
    Flashcard(id: 'im-f5', front: 'முஃமின் யார்?', back: 'நம்பிக்கை ஏற்று, அதற்கேற்ப அமல் செய்பவர்'),
    Flashcard(id: 'im-f6', front: 'ஈமானின் மிக உயர்ந்த கிளை எது?', back: 'லாயிலாஹ இல்லல்லாஹ் (கலிமா)'),
    Flashcard(id: 'im-f7', front: 'ஈமானின் மிகத் தாழ்ந்த கிளை எது?', back: 'வழியில் இடர் தரும் பொருட்களை அகற்றுதல்'),
    Flashcard(id: 'im-f8', front: 'வெட்கம் என்பது என்ன?', back: 'ஈமானின் ஒரு பகுதி'),
    Flashcard(id: 'im-f9', front: 'ஸாலிஹான அமல் என்றால் என்ன?', back: 'உரிய நேரத்திற்குப் பொருத்தமான நல்ல செயல்'),
    Flashcard(id: 'im-f10', front: 'முஃமினுக்கும் காஃபிருக்கும் இடையேயான வேறுபாடு என்ன?', back: 'தொழுகையை விடுதல்'),
  ],
  quizQuestions: const [
    // MCQ
    QuizQuestion(
      id: 'im-mcq-1',
      type: QuizQuestionType.multipleChoice,
      prompt: 'ஈமான் என்றால்?',
      correctOptionId: 'im-mcq-1-b',
      explanation: 'உள்ளம், நாவு, செயல் மூன்றும் சேர்ந்ததே ஈமான்.',
      options: [
        QuizOption(id: 'im-mcq-1-a', label: 'செயல் மட்டும்'),
        QuizOption(id: 'im-mcq-1-b', label: 'உள்ளம், நாவு, செயல் மூன்றும்'),
        QuizOption(id: 'im-mcq-1-c', label: 'நாவு மட்டும்'),
        QuizOption(id: 'im-mcq-1-d', label: 'சிந்தனை மட்டும்'),
      ],
    ),
    QuizQuestion(
      id: 'im-mcq-2',
      type: QuizQuestionType.multipleChoice,
      prompt: 'ஈமானும் அமலும் எதைப் போன்றது?',
      correctOptionId: 'im-mcq-2-b',
      explanation: 'மலரும் நறுமணமும் பிரிக்க முடியாதது போல் ஈமானும் அமலும்.',
      options: [
        QuizOption(id: 'im-mcq-2-a', label: 'நெருப்பும் புகையும்'),
        QuizOption(id: 'im-mcq-2-b', label: 'மலரும் நறுமணமும்'),
        QuizOption(id: 'im-mcq-2-c', label: 'கல்லும் மணலும்'),
        QuizOption(id: 'im-mcq-2-d', label: 'நீரும் காற்றும்'),
      ],
    ),
    // True/False
    QuizQuestion(
      id: 'im-tf-1',
      type: QuizQuestionType.trueFalse,
      prompt: 'ஈமானும் அமலும் தனித்தனியாகச் செயல்படலாம்',
      correctOptionId: 'im-tf-1-false',
      explanation: 'தவறு. இரண்டும் பிரிக்க முடியாதவை.',
      options: [
        QuizOption(id: 'im-tf-1-true', label: 'சரி'),
        QuizOption(id: 'im-tf-1-false', label: 'தவறு'),
      ],
    ),
    QuizQuestion(
      id: 'im-tf-2',
      type: QuizQuestionType.trueFalse,
      prompt: 'வெட்கம் ஈமானின் ஒரு பகுதி',
      correctOptionId: 'im-tf-2-true',
      explanation: 'சரி. வெட்கம் ஈமானின் ஒரு பகுதி ஆகும்.',
      options: [
        QuizOption(id: 'im-tf-2-true', label: 'சரி'),
        QuizOption(id: 'im-tf-2-false', label: 'தவறு'),
      ],
    ),
    // Short Answer
    QuizQuestion(
      id: 'im-sa-1',
      type: QuizQuestionType.shortAnswer,
      prompt: 'ஈமான் என்றால் யாது?',
      explanation: 'இஸ்லாம் கூறும் நம்பிக்கைகளை உள்ளத்தால் ஏற்று, நாவால் மொழிந்து, செயலால் உண்மைப்படுத்துவது.',
    ),
    // Essay
    QuizQuestion(
      id: 'im-essay-1',
      type: QuizQuestionType.essay,
      prompt: 'ஈமானுக்கும் அமலுக்கும் உள்ள தொடர்பை குர்ஆன், ஹதீஸ் ஆதாரங்களுடன் விளக்குக.',
      explanation: '''• இரண்டும் மலரும் நறுமணமும் போல பிரிக்க முடியாதவை
• குர்ஆனில் 70+ இடங்களில் சேர்த்துக் கூறப்பட்டுள்ளன
• ஈமான் 70+ கிளைகளைக் கொண்டது
• அமல் இல்லாத ஈமான் கானல் நீர் போன்றது''',
    ),
  ],
);

// Chapter 3: ரிசாலத்தும் ஹிதாயத்தும்
final islamChapter3 = Chapter(
  id: 'chapter-3-risalath-hidayath',
  title: 'ரிசாலத்தும் ஹிதாயத்தும்',
  progress: 0,
  notes: const [
    LessonNote(
      id: 'risalath-learn',
      title: '📖 எளிய குறிப்புகள்',
      summary: 'இறைவழிகாட்டல் மற்றும் வேதங்கள் பற்றிய நம்பிக்கை',
      body: '''**கேள்வி: ரிசாலத் என்றால் என்ன?**
• அல்லாஹ்வினால் இறைதூதர்களுக்கு வழங்கப்பட்ட வழிகாட்டல்கள், போதனைகள்
• இதை மனிதன் தன் சொந்த முயற்சியால் அறிய முடியாது

**கேள்வி: இறைதூதர்கள் யார்?**
• அல்லாஹ்வினது வழிகாட்டலை உலகிற்கு எத்திவைக்கும் பணியை மேற்கொண்டவர்கள்

**கேள்வி: ஹிதாயத் என்றால் என்ன?**
• அல்லாஹ் நாடியவர்களுக்கு மட்டும் கிடைக்கும் நேர்வழி/மனோபக்குவம்
• ரிசாலத்தை ஏற்று வழிபடும் மனநிலை

**வேதங்கள் மற்றும் ஸுஹுஃபுகள்:**
• வேதங்களுக்கு முன் **100 ஸுஹுஃபுகள்** அருளப்பட்டன
  - ஆதம் (அலை): 10
  - ஷீத் (அலை): 50
  - இத்ரீஸ் (அலை): 30
  - இப்ராஹீம் (அலை): 10
  - மூஸா (அலை): 10

**4 முதன்மை வேதங்கள்:**
• மூஸா (அலை) - தவ்ராத்
• தாவூத் (அலை) - ஸபூர்
• ஈஸா (அலை) - இன்ஜீல்
• முஹம்மத் (ஸல்) - குர்ஆன் (இறுதி வேதம்)

🧠 நினைவு வைக்க: **மூ-தா-ஈ-மு → தவ்-ஸ-இன்-குர்**''',
      examTip: 'வேதங்களின் எண்ணிக்கை மற்றும் ஸுஹுஃபுகளின் எண்ணிக்கையை மனப்பாடம் செய்யுங்கள்.',
      estimatedMinutes: 14,
    ),
  ],
  flashcards: const [
    Flashcard(id: 'ris-f1', front: 'ரிசாலத் என்றால் என்ன?', back: 'அல்லாஹ்வினால் தூதர்களுக்கு வழங்கப்பட்ட வழிகாட்டல்'),
    Flashcard(id: 'ris-f2', front: 'ஹிதாயத் என்றால் என்ன?', back: 'அல்லாஹ் நாடியோருக்குக் கிடைக்கும் நேர்வழி'),
    Flashcard(id: 'ris-f3', front: 'மொத்த ஸுஹுஃபுகள் எண்ணிக்கை?', back: '100'),
    Flashcard(id: 'ris-f4', front: 'மூஸா (அலை) அவர்களுக்கு அருளப்பட்ட வேதம்?', back: 'தவ்ராத்'),
    Flashcard(id: 'ris-f5', front: 'ஈஸா (அலை) அவர்களுக்கு அருளப்பட்ட வேதம்?', back: 'இன்ஜீல்'),
    Flashcard(id: 'ris-f6', front: 'இறுதி வேதம் எது?', back: 'குர்ஆன்'),
  ],
  quizQuestions: const [
    QuizQuestion(
      id: 'ris-mcq-1',
      type: QuizQuestionType.multipleChoice,
      prompt: 'மொத்த ஸுஹுஃபுகள் எண்ணிக்கை?',
      correctOptionId: 'ris-mcq-1-b',
      explanation: 'மொத்தம் 100 ஸுஹுஃபுகள் அருளப்பட்டன.',
      options: [
        QuizOption(id: 'ris-mcq-1-a', label: '50'),
        QuizOption(id: 'ris-mcq-1-b', label: '100'),
        QuizOption(id: 'ris-mcq-1-c', label: '150'),
        QuizOption(id: 'ris-mcq-1-d', label: '200'),
      ],
    ),
    QuizQuestion(
      id: 'ris-tf-1',
      type: QuizQuestionType.trueFalse,
      prompt: 'குர்ஆன் இறுதி வேதம் ஆகும்',
      correctOptionId: 'ris-tf-1-true',
      explanation: 'சரி. குர்ஆன் இறுதி வேதம்.',
      options: [
        QuizOption(id: 'ris-tf-1-true', label: 'சரி'),
        QuizOption(id: 'ris-tf-1-false', label: 'தவறு'),
      ],
    ),
  ],
);

// Chapter 4: அத்தஹாரத் - சுத்தம்
final islamChapter4 = Chapter(
  id: 'chapter-4-taharath',
  title: 'அத்தஹாரத் - சுத்தம்',
  progress: 0,
  notes: const [
    LessonNote(
      id: 'taharath-learn',
      title: '📖 எளிய குறிப்புகள்',
      summary: 'சுத்தத்தின் முக்கியத்துவமும் நீரின் வகைகளும்',
      body: '''**சுத்தத்தின் முக்கியத்துவம்:**
• "சுத்தம் ஈமானின் பாதியாகும்" (முஸ்லிம் - ஹதீஸ்)
• சுத்தம் இல்லாமல் தொழுகை ஏற்கப்படாது
• புறச்சுத்தம் + அகச்சுத்தம் இரண்டும் முக்கியம்

**நீரின் 3 வகைகள்:**
1. **அல் மாஉத் தஹூர்** (மிகச் சுத்தமான நீர்)
   - தானும் சுத்தமானது; மற்றவற்றையும் சுத்தப்படுத்தும்
   - மழை, கடல், ஆறு, ஊற்று நீர்
   - 3 உட்பிரிவு: கஸீர், கலீல், முஸ்தஃமல்
   - குல்லதைன் = 210 லிட்டருக்கு மேல்

2. **அல் மாஉத் தாஹிர்** (சுத்தமான நீர்)
   - தானே சுத்தமாயினும் மற்றவற்றைச் சுத்தப்படுத்தாது
   - தேநீர், பழரசம், பஞ்சசாறு
   - மார்க்கக் கடமைகளுக்குப் பயன்படாது

3. **அல் மாஉல் முதனஜ்ஜிஸ்** (அசுத்த நீர்)
   - தானும் சுத்தமற்றது; மற்றவற்றையும் சுத்தப்படுத்தாது

**ஹதஸ் மற்றும் அதை அகற்றல்:**
• சிறு தொடக்கு → வுழூ
• பெரும் தொடக்கு → குளிப்பு (குஸ்ல்)
• நீர் இல்லாதபோது → தயம்மும் (மண்ணால்)
• ஜபிரத் = காயக்கட்டு''',
      examTip: 'குல்லதைன் அளவு (210 லிட்டர்) மற்றும் நீரின் 3 வகைகளை நினைவில் வைத்திருங்கள்.',
      estimatedMinutes: 16,
    ),
  ],
  flashcards: const [
    Flashcard(id: 'tah-f1', front: 'சுத்தம் ஈமானின் என்ன பகுதி?', back: 'பாதி'),
    Flashcard(id: 'tah-f2', front: 'நீரின் 3 வகைகள் யாவை?', back: 'தஹூர், தாஹிர், முதனஜ்ஜிஸ்'),
    Flashcard(id: 'tah-f3', front: 'குல்லதைன் அளவு என்ன?', back: '210 லிட்டருக்கு மேல்'),
    Flashcard(id: 'tah-f4', front: 'சிறு தொடக்கு நீங்க என்ன செய்ய வேண்டும்?', back: 'வுழூ'),
    Flashcard(id: 'tah-f5', front: 'தயம்மும் என்றால் என்ன?', back: 'நீருக்குப் பதில் மண்ணால் முகம், கைகளைத் தடவுதல்'),
  ],
  quizQuestions: const [
    QuizQuestion(
      id: 'tah-mcq-1',
      type: QuizQuestionType.multipleChoice,
      prompt: 'குல்லதைன் அளவு?',
      correctOptionId: 'tah-mcq-1-c',
      explanation: '210 லிட்டருக்கு மேல் குல்லதைன் அளவாகும்.',
      options: [
        QuizOption(id: 'tah-mcq-1-a', label: '100 லிட்டர்'),
        QuizOption(id: 'tah-mcq-1-b', label: '150 லிட்டர்'),
        QuizOption(id: 'tah-mcq-1-c', label: '210 லிட்டர்'),
        QuizOption(id: 'tah-mcq-1-d', label: '300 லிட்டர்'),
      ],
    ),
    QuizQuestion(
      id: 'tah-tf-1',
      type: QuizQuestionType.trueFalse,
      prompt: 'சுத்தம் இல்லாமல் தொழுகை ஏற்கப்படும்',
      correctOptionId: 'tah-tf-1-false',
      explanation: 'தவறு. சுத்தம் இல்லாமல் தொழுகை ஏற்கப்படாது.',
      options: [
        QuizOption(id: 'tah-tf-1-true', label: 'சரி'),
        QuizOption(id: 'tah-tf-1-false', label: 'தவறு'),
      ],
    ),
  ],
);

// Chapter 5: அந்நஜாஸத் - அசுத்தம்
final islamChapter5 = Chapter(
  id: 'chapter-5-najasath',
  title: 'அந்நஜாஸத் - அசுத்தம்',
  progress: 0,
  notes: const [
    LessonNote(
      id: 'najasath-learn',
      title: '📖 எளிய குறிப்புகள்',
      summary: 'நஜீஸின் வகைகளும் சுத்தம் செய்யும் முறைகளும்',
      body: '''**நஜீஸின் 3 வகைகள்:**

1. **சாதாரண நஜீஸ்**
   - மலம், சிறுநீர், இரத்தம், சீழ், மதுபானம்
   - சுத்தம்: நிறம், மணம், சுவை நீங்கும் வரை கழுவுதல்

2. **இலகுவான நஜீஸ்**
   - 2 வயதிற்குட்பட்ட, தாய்ப்பால் மட்டும் உண்ணும் ஆண் குழந்தையின் சிறுநீர்
   - சுத்தம்: நீர் தெளித்தால் போதும்

3. **கடுமையான நஜீஸ்**
   - நாய், பன்றி தொடர்பான அனைத்தும்
   - சுத்தம்: 7 தடவை கழுவுதல் + மண் கரைசல்
   - பரந்த நீரில்: 6 தடவை அசைத்தெடுத்தால் போதும்

**விதிவிலக்குகள் (நஜீஸ் அல்ல):**
• தாய்ப்பால்
• மீன், வெட்டுக்கிளி (தானாக இறந்தால்)
• சிறிய இரத்தத் துளி
• இரத்தம் சிந்தாத பிராணிகள் (எறும்பு, தேனீ)

**சுத்தம் செய்யக்கூடிய நஜீஸ்:**
• விலங்குத் தோலை பதனிட்டால் பயன்படுத்தலாம் (நாய்/பன்றி தவிர)
• கள் இயற்கையாக வினாகிரி ஆனால் பயன்படுத்தலாம்''',
      examTip: 'கடுமையான நஜீஸ் = 7 தடவை + மண் கரைசல் என்பதை நினைவில் வைத்திருங்கள்.',
      estimatedMinutes: 14,
    ),
  ],
  flashcards: const [
    Flashcard(id: 'naj-f1', front: 'நஜீஸின் 3 வகைகள்?', back: 'சாதாரண, இலகுவான, கடுமையான'),
    Flashcard(id: 'naj-f2', front: 'இலகுவான நஜீஸ் என்ன?', back: '2 வயதிற்குட்பட்ட, தாய்ப்பால் மட்டும் உண்ணும் ஆண் குழந்தையின் சிறுநீர்'),
    Flashcard(id: 'naj-f3', front: 'கடுமையான நஜீஸை எத்தனை தடவை கழுவ வேண்டும்?', back: '7 தடவைகள்'),
    Flashcard(id: 'naj-f4', front: 'தாய்ப்பால் நஜீஸா?', back: 'இல்லை'),
    Flashcard(id: 'naj-f5', front: 'கடுமையான நஜீஸுக்கு கூடுதலாக என்ன பயன்படுத்த வேண்டும்?', back: 'மண் கரைசல்'),
  ],
  quizQuestions: const [
    QuizQuestion(
      id: 'naj-mcq-1',
      type: QuizQuestionType.multipleChoice,
      prompt: 'கடுமையான நஜீஸை எத்தனை தடவை கழுவ வேண்டும்?',
      correctOptionId: 'naj-mcq-1-c',
      explanation: '7 தடவைகள் மற்றும் மண் கரைசல் தேவை.',
      options: [
        QuizOption(id: 'naj-mcq-1-a', label: '3'),
        QuizOption(id: 'naj-mcq-1-b', label: '5'),
        QuizOption(id: 'naj-mcq-1-c', label: '7'),
        QuizOption(id: 'naj-mcq-1-d', label: '10'),
      ],
    ),
    QuizQuestion(
      id: 'naj-tf-1',
      type: QuizQuestionType.trueFalse,
      prompt: 'தாய்ப்பால் நஜீஸ் ஆகும்',
      correctOptionId: 'naj-tf-1-false',
      explanation: 'தவறு. தாய்ப்பால் நஜீஸ் அல்ல.',
      options: [
        QuizOption(id: 'naj-tf-1-true', label: 'சரி'),
        QuizOption(id: 'naj-tf-1-false', label: 'தவறு'),
      ],
    ),
  ],
);

// Export all Islam chapters
final List<Chapter> islamOLChapters = [
  // Chapter 1 is in the main file
  islamChapter2,
  islamChapter3,
  islamChapter4,
  islamChapter5,
];
