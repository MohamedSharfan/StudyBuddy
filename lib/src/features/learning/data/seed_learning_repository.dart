import '../domain/chapter.dart';
import '../domain/flashcard.dart';
import '../domain/lesson_note.dart';
import '../domain/quiz_question.dart';
import '../domain/subject.dart';
import 'islam_ol_chapters.dart';

class SeedLearningRepository {
  const SeedLearningRepository();

  List<StudySubject> getSubjects() => _subjects;

  StudySubject subjectById(String id) {
    return _subjects.firstWhere((subject) => subject.id == id);
  }

  LessonNote noteById(String subjectId, String noteId) {
    final subject = subjectById(subjectId);
    return subject.chapters
        .expand((chapter) => chapter.notes)
        .firstWhere((note) => note.id == noteId);
  }

  List<QuizQuestion> quizForSubject(String subjectId) {
    return subjectById(subjectId)
        .chapters
        .expand((chapter) => chapter.quizQuestions)
        .toList();
  }

  List<String> knowledgeSnippets(String query) {
    final normalizedQuery = query.toLowerCase();
    final notes = _subjects
        .expand((subject) => subject.chapters)
        .expand((chapter) => chapter.notes);

    final matches = notes.where((note) {
      final haystack = '${note.title} ${note.summary} ${note.body}'.toLowerCase();
      return normalizedQuery
          .split(' ')
          .where((term) => term.trim().length > 3)
          .any(haystack.contains);
    }).toList();

    final selected = matches.isEmpty ? notes.take(2).toList() : matches.take(3);
    return selected.map((note) => '${note.title}: ${note.summary}').toList();
  }
}

const _photosynthesisBody = '''
Photosynthesis is the process green plants use to prepare food. The leaf absorbs sunlight using chlorophyll. Carbon dioxide enters through stomata and water comes from the roots.

The plant produces glucose and releases oxygen. In exams, always connect sunlight, chlorophyll, carbon dioxide, water, glucose, and oxygen in one clear explanation.
''';

const _humanBodyBody = '''
The human body is made of systems that work together. The digestive system breaks food into nutrients, the respiratory system brings oxygen, and the circulatory system transports substances through blood.

When answering structured questions, name the system first, explain its main organs, and then describe the function in simple steps.
''';

final _subjects = <StudySubject>[
  StudySubject(
    id: 'science',
    name: 'Science',
    icon: 'atom',
    progress: 0,
    colorValue: 0xFF6C3BFF,
    chapters: [
      Chapter(
        id: 'biology-basics',
        title: 'Biology Basics',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'photosynthesis',
            title: 'Photosynthesis',
            summary: 'How plants prepare food using sunlight.',
            body: _photosynthesisBody,
            examTip: 'Write the word equation and mention chlorophyll.',
            estimatedMinutes: 8,
          ),
          LessonNote(
            id: 'human-body',
            title: 'Human Body Systems',
            summary: 'Digestive, respiratory, and circulatory systems.',
            body: _humanBodyBody,
            examTip: 'Use organ names accurately in diagram questions.',
            estimatedMinutes: 10,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'photo-1',
            front: 'What pigment absorbs sunlight in leaves?',
            back: 'Chlorophyll.',
          ),
          Flashcard(
            id: 'photo-2',
            front: 'What gas is released during photosynthesis?',
            back: 'Oxygen.',
          ),
          Flashcard(
            id: 'body-1',
            front: 'Which system transports oxygen and nutrients?',
            back: 'The circulatory system.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'science-q1',
            prompt: 'Which pigment helps leaves absorb sunlight?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'science-q1-a',
            explanation:
                'Chlorophyll is the green pigment that absorbs sunlight for photosynthesis.',
            options: [
              QuizOption(id: 'science-q1-a', label: 'Chlorophyll'),
              QuizOption(id: 'science-q1-b', label: 'Oxygen'),
              QuizOption(id: 'science-q1-c', label: 'Glucose'),
              QuizOption(id: 'science-q1-d', label: 'Starch'),
            ],
          ),
          QuizQuestion(
            id: 'science-q2',
            prompt: 'Which body system transports nutrients through blood?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'science-q2-c',
            explanation:
                'The circulatory system transports oxygen and nutrients around the body.',
            options: [
              QuizOption(id: 'science-q2-a', label: 'Digestive system'),
              QuizOption(id: 'science-q2-b', label: 'Respiratory system'),
              QuizOption(id: 'science-q2-c', label: 'Circulatory system'),
              QuizOption(id: 'science-q2-d', label: 'Skeletal system'),
            ],
          ),
        ],
      ),
    ],
  ),
  StudySubject(
    id: 'maths',
    name: 'Maths',
    icon: 'calculate',
    progress: 0,
    colorValue: 0xFF0EA5E9,
    chapters: [
      Chapter(
        id: 'algebra',
        title: 'Algebra',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'linear-equations',
            title: 'Linear Equations',
            summary: 'Solve equations by balancing both sides.',
            body:
                'A linear equation has the unknown variable with power one. Keep the equation balanced by doing the same operation to both sides. Simplify step by step before writing the final value.',
            examTip: 'Show every balancing step to earn method marks.',
            estimatedMinutes: 9,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'alg-1',
            front: 'What is the first rule when solving equations?',
            back: 'Do the same operation to both sides.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'maths-q1',
            prompt: 'When solving x + 5 = 12, what should you do first?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'maths-q1-b',
            explanation:
                'Subtract 5 from both sides to keep the equation balanced.',
            options: [
              QuizOption(id: 'maths-q1-a', label: 'Add 5 to both sides'),
              QuizOption(id: 'maths-q1-b', label: 'Subtract 5 from both sides'),
              QuizOption(id: 'maths-q1-c', label: 'Multiply both sides by 5'),
              QuizOption(id: 'maths-q1-d', label: 'Divide both sides by 12'),
            ],
          ),
        ],
      ),
    ],
  ),
  StudySubject(
    id: 'english',
    name: 'English',
    icon: 'menu_book',
    progress: 0,
    colorValue: 0xFF22C55E,
    chapters: [
      Chapter(
        id: 'grammar',
        title: 'Grammar Foundations',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'tenses',
            title: 'Tenses',
            summary: 'Use time clues to choose the correct verb form.',
            body:
                'Tenses show when an action happens. Present tense describes now or habits. Past tense describes completed actions. Future tense describes actions that will happen later.',
            examTip: 'Underline time words before choosing a tense.',
            estimatedMinutes: 7,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'tense-1',
            front: 'Which tense describes completed actions?',
            back: 'Past tense.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'english-q1',
            prompt: 'Which tense describes a completed action?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'english-q1-b',
            explanation:
                'Past tense is used for actions that already happened.',
            options: [
              QuizOption(id: 'english-q1-a', label: 'Present tense'),
              QuizOption(id: 'english-q1-b', label: 'Past tense'),
              QuizOption(id: 'english-q1-c', label: 'Future tense'),
              QuizOption(id: 'english-q1-d', label: 'Continuous tense'),
            ],
          ),
        ],
      ),
    ],
  ),
  StudySubject(
    id: 'tamil',
    name: 'Tamil',
    icon: 'translate',
    progress: 0,
    colorValue: 0xFFF97316,
    chapters: [
      Chapter(
        id: 'writing',
        title: 'Writing Skills',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'essay-plan',
            title: 'Essay Planning',
            summary: 'Plan introduction, body, and conclusion.',
            body:
                'A strong essay has a clear introduction, organized ideas, and a short conclusion. Before writing, list the main points and arrange them in a logical order.',
            examTip: 'Spend a few minutes planning before the final answer.',
            estimatedMinutes: 6,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'essay-1',
            front: 'What are the three main parts of an essay?',
            back: 'Introduction, body, and conclusion.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'tamil-q1',
            prompt: 'What should you prepare before writing an essay?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'tamil-q1-a',
            explanation:
                'A short plan helps organize the introduction, body, and conclusion.',
            options: [
              QuizOption(id: 'tamil-q1-a', label: 'A clear plan'),
              QuizOption(id: 'tamil-q1-b', label: 'Only the conclusion'),
              QuizOption(id: 'tamil-q1-c', label: 'Random examples'),
              QuizOption(id: 'tamil-q1-d', label: 'No structure'),
            ],
          ),
        ],
      ),
    ],
  ),
  StudySubject(
    id: 'history',
    name: 'History',
    icon: 'history_edu',
    progress: 0,
    colorValue: 0xFFB45309,
    chapters: [
      Chapter(
        id: 'ancient-lanka',
        title: 'Ancient Sri Lanka',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'kingdoms',
            title: 'Early Kingdoms',
            summary: 'Important kingdoms and their contributions.',
            body:
                'Sri Lankan history includes kingdoms that developed irrigation, trade, religion, and culture. Focus on rulers, locations, and major achievements.',
            examTip: 'Create a timeline for rulers and events.',
            estimatedMinutes: 8,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'hist-1',
            front: 'What helps remember historical events in order?',
            back: 'A timeline.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'history-q1',
            prompt: 'What tool helps arrange historical events in order?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'history-q1-c',
            explanation:
                'A timeline shows events in chronological order.',
            options: [
              QuizOption(id: 'history-q1-a', label: 'A table of marks'),
              QuizOption(id: 'history-q1-b', label: 'A grammar chart'),
              QuizOption(id: 'history-q1-c', label: 'A timeline'),
              QuizOption(id: 'history-q1-d', label: 'A formula sheet'),
            ],
          ),
        ],
      ),
    ],
  ),
  StudySubject(
    id: 'ict',
    name: 'ICT',
    icon: 'devices',
    progress: 0,
    colorValue: 0xFF14B8A6,
    chapters: [
      Chapter(
        id: 'computer-systems',
        title: 'Computer Systems',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'hardware-software',
            title: 'Hardware and Software',
            summary: 'The physical and program parts of a computer.',
            body:
                'Hardware means the physical parts of a computer. Software means instructions and programs that tell hardware what to do. Both are needed for a working computer system.',
            examTip: 'Give two examples for hardware and software.',
            estimatedMinutes: 5,
          ),
        ],
        flashcards: const [
          Flashcard(
            id: 'ict-1',
            front: 'Is a keyboard hardware or software?',
            back: 'Hardware.',
          ),
        ],
        quizQuestions: const [
          QuizQuestion(
            id: 'ict-q1',
            prompt: 'Which one is computer hardware?',
            type: QuizQuestionType.multipleChoice,
            correctOptionId: 'ict-q1-d',
            explanation:
                'A keyboard is a physical component, so it is hardware.',
            options: [
              QuizOption(id: 'ict-q1-a', label: 'Operating system'),
              QuizOption(id: 'ict-q1-b', label: 'Web browser'),
              QuizOption(id: 'ict-q1-c', label: 'Spreadsheet app'),
              QuizOption(id: 'ict-q1-d', label: 'Keyboard'),
            ],
          ),
        ],
      ),
    ],
  ),
  // Islam O/L Subject
  StudySubject(
    id: 'islam-ol',
    name: 'Islam (O/L)',
    icon: 'menu_book',
    progress: 0,
    colorValue: 0xFF059669, // Emerald green
    chapters: [
      // Chapter 1: அகீதா (நம்பிக்கைக் கோட்பாடு)
      Chapter(
        id: 'chapter-1-aqeedah',
        title: 'அகீதா (நம்பிக்கைக் கோட்பாடு)',
        progress: 0,
        notes: const [
          LessonNote(
            id: 'aqeedah-learn',
            title: '📖 எளிய குறிப்புகள்',
            summary: 'அகீதாவின் அடிப்படைகள் மற்றும் 6 நம்பிக்கைகள்',
            body: '''**கேள்வி: அகீதா என்றால் என்ன?**
• உறுதியான ஆதாரங்களின் அடிப்படையில் அமைந்த நம்பிக்கை

**கேள்வி: அகீதாவின் மூலாதாரங்கள் யாவை?**
• அல்குர்ஆன்
• ஸுன்னாஹ் (நபிமொழி)

**கேள்வி: ஹதீஸ் ஜிப்ரீல் என்றால் என்ன?**
• ஜிப்ரீல் (அலை) நபி (ஸல்) அவர்களிடம் ஈமான் பற்றி வினவிய போது கிடைத்த பதில்
• இதில் 6 அடிப்படை நம்பிக்கைகள் கூறப்பட்டுள்ளன

**கேள்வி: அந்த 6 நம்பிக்கைகள் யாவை?**
1. அல்லாஹ்
2. மலக்குகள்
3. வேதங்கள்
4. நபிமார்கள் / ரஸூல்மார்கள்
5. மறுமை நாள்
6. கழா கத்ர் (இறை நாட்டம்)

🧠 நினைவு வைக்க: **அ-ம-வே-ந-ம-க**

**கேள்வி: மறுமை நாளுடன் தொடர்புடைய சொற்கள் யாவை?**
• கப்று, பஃஸ், ஹிஸாப், மீஸான், ஸிராத், ஜன்னா, நார்

**கேள்வி: அகீதா எத்தனை பிரிவுகளாக வகைப்படுத்தப்படுகிறது?**
• நான்கு (4)

**பிரிவுகள்:**
• இலாஹிய்யாத்: அல்லாஹ் + கழாகத்ர்
• நுபுவ்வாத்: நபிமார் + வேதங்கள்
• ரூஹானிய்யாத்: மலக்கு, ஜின், ஷைத்தான், ரூஹ்
• ஸம்இய்யாத்: மறுமை தொடர்பான அனைத்தும்

**கேள்வி: வழிதவறிய குழுக்கள் யாவை?**
• ஜபரிய்யா, கதரிய்யா, முர்ஜிஆ, முஃதஸிலா

**கேள்வி: சரியான வழியில் இருப்பவர்கள் யார்?**
• அஹ்லுஸ் ஸுன்னா வல் ஜமாஆ (நபியும் ஸஹாபாக்களும் நடந்த வழி)

**கேள்வி: அகீதாவைப் பாதுகாத்த அறிஞர்கள் யாவர்?**
• இமாம் அஹ்மத் பின் ஹம்பல்
• அபுல் ஹஸன் அல் அஷ்அரி
• அபூ மன்சூர் அல்மாதுரீதி

**கேள்வி: அகீதா மாறாதது என்பதற்கு ஆதாரம்?**
• குர்ஆன் 42:13 — நூஹ், இப்ராஹீம், மூஸா, ஈஸா அனைவருக்கும் ஒரே அகீதாவே கொடுக்கப்பட்டது''',
            examTip: '6 நம்பிக்கைகளை மனப்பாடம் செய்யுங்கள். குர்ஆன் 42:13 வசனத்தை நினைவில் வைத்திருங்கள்.',
            estimatedMinutes: 15,
          ),
        ],
        flashcards: const [
          Flashcard(id: 'aq-f1', front: 'அகீதா என்றால் என்ன?', back: 'உறுதியான ஆதாரங்களின் அடிப்படையிலான நம்பிக்கை'),
          Flashcard(id: 'aq-f2', front: 'அகீதாவின் மூலாதாரங்கள்?', back: 'குர்ஆன் + ஸுன்னாஹ்'),
          Flashcard(id: 'aq-f3', front: 'ஹதீஸ் ஜிப்ரீலில் எத்தனை நம்பிக்கைகள்?', back: 'ஆறு (6)'),
          Flashcard(id: 'aq-f4', front: '6 நம்பிக்கைகளைச் சொல்லுக', back: 'அல்லாஹ், மலக்கு, வேதம், நபிமார், மறுமை, கழாகத்ர்'),
          Flashcard(id: 'aq-f5', front: 'கழா கத்ர் என்றால் என்ன?', back: 'இறைவனின் நாட்டம்'),
          Flashcard(id: 'aq-f6', front: 'அகீதா எத்தனை பிரிவுகள்?', back: 'நான்கு (4)'),
          Flashcard(id: 'aq-f7', front: 'இலாஹிய்யாத்தில் என்ன அடங்கும்?', back: 'அல்லாஹ் + கழாகத்ர்'),
          Flashcard(id: 'aq-f8', front: 'நுபுவ்வாத்தில் என்ன அடங்கும்?', back: 'நபிமார் + வேதங்கள்'),
          Flashcard(id: 'aq-f9', front: 'ரூஹானிய்யாத்தில் என்ன அடங்கும்?', back: 'மலக்கு, ஜின், ஷைத்தான், ரூஹ்'),
          Flashcard(id: 'aq-f10', front: 'ஸம்இய்யாத்தில் என்ன அடங்கும்?', back: 'மறுமை தொடர்பான அனைத்தும்'),
          Flashcard(id: 'aq-f11', front: 'வழிதவறிய 4 குழுக்கள்?', back: 'ஜபரிய்யா, கதரிய்யா, முர்ஜிஆ, முஃதஸிலா'),
          Flashcard(id: 'aq-f12', front: 'சரியான வழியின் பெயர்?', back: 'அஹ்லுஸ் ஸுன்னா வல் ஜமாஆ'),
          Flashcard(id: 'aq-f13', front: 'அகீதாவைப் பாதுகாத்த 3 அறிஞர்கள்?', back: 'அஹ்மத் பின் ஹம்பல், அஷ்அரி, மாதுரீதி'),
          Flashcard(id: 'aq-f14', front: 'அகீதா மாறாதது என்பதற்கு ஆதார வசனம்?', back: '42:13'),
          Flashcard(id: 'aq-f15', front: 'அந்த வசனத்தில் யாருடைய பெயர்கள் உள்ளன?', back: 'நூஹ், இப்ராஹீம், மூஸா, ஈஸா'),
        ],
        quizQuestions: const [
          // MCQ Questions
          QuizQuestion(
            id: 'aq-mcq-1',
            type: QuizQuestionType.multipleChoice,
            prompt: 'அகீதாவின் மூலாதாரங்கள்?',
            correctOptionId: 'aq-mcq-1-b',
            explanation: 'குர்ஆன் மற்றும் ஸுன்னாஹ் (நபிமொழி) அகீதாவின் மூலாதாரங்கள்.',
            options: [
              QuizOption(id: 'aq-mcq-1-a', label: 'கவிதை'),
              QuizOption(id: 'aq-mcq-1-b', label: 'குர்ஆன் + ஸுன்னாஹ்'),
              QuizOption(id: 'aq-mcq-1-c', label: 'வரலாறு'),
              QuizOption(id: 'aq-mcq-1-d', label: 'அறிவியல்'),
            ],
          ),
          QuizQuestion(
            id: 'aq-mcq-2',
            type: QuizQuestionType.multipleChoice,
            prompt: 'ஹதீஸ் ஜிப்ரீலில் எத்தனை நம்பிக்கைகள்?',
            correctOptionId: 'aq-mcq-2-c',
            explanation: 'ஹதீஸ் ஜிப்ரீலில் 6 அடிப்படை நம்பிக்கைகள் கூறப்பட்டுள்ளன.',
            options: [
              QuizOption(id: 'aq-mcq-2-a', label: '4'),
              QuizOption(id: 'aq-mcq-2-b', label: '5'),
              QuizOption(id: 'aq-mcq-2-c', label: '6'),
              QuizOption(id: 'aq-mcq-2-d', label: '7'),
            ],
          ),
          QuizQuestion(
            id: 'aq-mcq-3',
            type: QuizQuestionType.multipleChoice,
            prompt: 'கழா கத்ர் என்றால்?',
            correctOptionId: 'aq-mcq-3-a',
            explanation: 'கழா கத்ர் என்பது இறைவனின் நாட்டம் என்று பொருள்.',
            options: [
              QuizOption(id: 'aq-mcq-3-a', label: 'இறை நாட்டம்'),
              QuizOption(id: 'aq-mcq-3-b', label: 'மனித விருப்பம்'),
              QuizOption(id: 'aq-mcq-3-c', label: 'இயற்கை சட்டம்'),
              QuizOption(id: 'aq-mcq-3-d', label: 'மனித சட்டம்'),
            ],
          ),
          QuizQuestion(
            id: 'aq-mcq-4',
            type: QuizQuestionType.multipleChoice,
            prompt: 'அகீதா எத்தனை பிரிவுகள்?',
            correctOptionId: 'aq-mcq-4-c',
            explanation: 'அகீதா நான்கு பிரிவுகளாக வகைப்படுத்தப்படுகிறது.',
            options: [
              QuizOption(id: 'aq-mcq-4-a', label: '2'),
              QuizOption(id: 'aq-mcq-4-b', label: '3'),
              QuizOption(id: 'aq-mcq-4-c', label: '4'),
              QuizOption(id: 'aq-mcq-4-d', label: '5'),
            ],
          ),
          QuizQuestion(
            id: 'aq-mcq-5',
            type: QuizQuestionType.multipleChoice,
            prompt: 'அஹ்லுஸ் ஸுன்னா வல் ஜமாஆ யார்?',
            correctOptionId: 'aq-mcq-5-b',
            explanation: 'நபி மற்றும் ஸஹாபாக்களின் வழியைப் பின்பற்றுவோர்.',
            options: [
              QuizOption(id: 'aq-mcq-5-a', label: 'வழிதவறியோர்'),
              QuizOption(id: 'aq-mcq-5-b', label: 'நபி & ஸஹாபா வழி பின்பற்றுவோர்'),
              QuizOption(id: 'aq-mcq-5-c', label: 'புதிய குழு'),
              QuizOption(id: 'aq-mcq-5-d', label: 'அரசியல்வாதிகள்'),
            ],
          ),
          // True/False Questions
          QuizQuestion(
            id: 'aq-tf-1',
            type: QuizQuestionType.trueFalse,
            prompt: 'அகீதா யூகத்தின் அடிப்படையில் அமைந்தது',
            correctOptionId: 'aq-tf-1-false',
            explanation: 'தவறு. அகீதா உறுதியான ஆதாரங்களின் அடிப்படையில் அமைந்தது.',
            options: [
              QuizOption(id: 'aq-tf-1-true', label: 'சரி'),
              QuizOption(id: 'aq-tf-1-false', label: 'தவறு'),
            ],
          ),
          QuizQuestion(
            id: 'aq-tf-2',
            type: QuizQuestionType.trueFalse,
            prompt: 'குர்ஆன் + ஸுன்னாஹ் அகீதாவின் மூலாதாரங்கள்',
            correctOptionId: 'aq-tf-2-true',
            explanation: 'சரி. குர்ஆனும் ஸுன்னாஹும் அகீதாவின் மூலாதாரங்கள்.',
            options: [
              QuizOption(id: 'aq-tf-2-true', label: 'சரி'),
              QuizOption(id: 'aq-tf-2-false', label: 'தவறு'),
            ],
          ),
          QuizQuestion(
            id: 'aq-tf-3',
            type: QuizQuestionType.trueFalse,
            prompt: 'முஃதஸிலா அஹ்லுஸ் ஸுன்னாவின் மறுபெயர்',
            correctOptionId: 'aq-tf-3-false',
            explanation: 'தவறு. முஃதஸிலா வழிதவறிய குழுக்களில் ஒன்று.',
            options: [
              QuizOption(id: 'aq-tf-3-true', label: 'சரி'),
              QuizOption(id: 'aq-tf-3-false', label: 'தவறு'),
            ],
          ),
          QuizQuestion(
            id: 'aq-tf-4',
            type: QuizQuestionType.trueFalse,
            prompt: 'அகீதா 4 பிரிவுகளாக வகைப்படுத்தப்படுகிறது',
            correctOptionId: 'aq-tf-4-true',
            explanation: 'சரி. இலாஹிய்யாத், நுபுவ்வாத், ரூஹானிய்யாத், ஸம்இய்யாத்.',
            options: [
              QuizOption(id: 'aq-tf-4-true', label: 'சரி'),
              QuizOption(id: 'aq-tf-4-false', label: 'தவறு'),
            ],
          ),
          QuizQuestion(
            id: 'aq-tf-5',
            type: QuizQuestionType.trueFalse,
            prompt: '42:13 வசனம் அகீதா மாறும் எனக் கூறுகிறது',
            correctOptionId: 'aq-tf-5-false',
            explanation: 'தவறு. 42:13 வசனம் அகீதா மாறாதது என்று நிரூபிக்கிறது.',
            options: [
              QuizOption(id: 'aq-tf-5-true', label: 'சரி'),
              QuizOption(id: 'aq-tf-5-false', label: 'தவறு'),
            ],
          ),
          // Short Answer Questions
          QuizQuestion(
            id: 'aq-sa-1',
            type: QuizQuestionType.shortAnswer,
            prompt: 'அகீதா என்றால் யாது?',
            explanation: 'உறுதியான ஆதாரங்களின் அடிப்படையில் அமைந்த நம்பிக்கை.',
            correctAnswer: 'உறுதியான ஆதாரங்களின் அடிப்படையில் அமைந்த நம்பிக்கை',
          ),
          QuizQuestion(
            id: 'aq-sa-2',
            type: QuizQuestionType.shortAnswer,
            prompt: 'ஹதீஸ் ஜிப்ரீலின் 6 நம்பிக்கைகளைத் தருக.',
            explanation: 'அல்லாஹ், மலக்குகள், வேதங்கள், நபிமார்கள், மறுமை நாள், கழா கத்ர்.',
            correctAnswer: 'அல்லாஹ், மலக்குகள், வேதங்கள், நபிமார்கள், மறுமை நாள், கழா கத்ர்',
          ),
          QuizQuestion(
            id: 'aq-sa-3',
            type: QuizQuestionType.shortAnswer,
            prompt: 'அகீதாவின் 4 பிரிவுகளைக் குறிப்பிடுக.',
            explanation: 'இலாஹிய்யாத், நுபுவ்வாத், ரூஹானிய்யாத், ஸம்இய்யாத்.',
            correctAnswer: 'இலாஹிய்யாத், நுபுவ்வாத், ரூஹானிய்யாத், ஸம்இய்யாத்',
          ),
          QuizQuestion(
            id: 'aq-sa-4',
            type: QuizQuestionType.shortAnswer,
            prompt: 'வழிதவறிய குழுக்கள் நான்கினைப் பட்டியலிடுக.',
            explanation: 'ஜபரிய்யா, கதரிய்யா, முர்ஜிஆ, முஃதஸிலா.',
            correctAnswer: 'ஜபரிய்யா, கதரிய்யா, முர்ஜிஆ, முஃதஸிலா',
          ),
          QuizQuestion(
            id: 'aq-sa-5',
            type: QuizQuestionType.shortAnswer,
            prompt: 'அகீதாவைப் பாதுகாத்த மூன்று அறிஞர்களைத் தருக.',
            explanation: 'அஹ்மத் பின் ஹம்பல், அபுல் ஹஸன் அல் அஷ்அரி, அபூ மன்சூர் அல்மாதுரீதி.',
            correctAnswer: 'அஹ்மத் பின் ஹம்பல், அபுல் ஹஸன் அல் அஷ்அரி, அபூ மன்சூர் அல்மாதுரீதி',
          ),
          // Essay Questions
          QuizQuestion(
            id: 'aq-essay-1',
            type: QuizQuestionType.essay,
            prompt: 'அகீதா என்றால் என்ன? அதன் மூலாதாரங்களையும் 6 நம்பிக்கைகளையும் விளக்குக.',
            explanation: '''• அகீதா = உறுதியான ஆதாரங்களின் அடிப்படையிலான நம்பிக்கை
• மூலாதாரங்கள்: குர்ஆன், ஸுன்னாஹ்
• 6 நம்பிக்கைகள்: அல்லாஹ், மலக்குகள், வேதங்கள், நபிமார்கள், மறுமை நாள், கழா கத்ர்
• ஹதீஸ் ஜிப்ரீலில் இவை தெளிவாக கூறப்பட்டுள்ளன''',
          ),
          QuizQuestion(
            id: 'aq-essay-2',
            type: QuizQuestionType.essay,
            prompt: 'அகீதா காலமாற்றத்திற்கு உட்படாதது என்பதை குர்ஆன் ஆதாரத்துடன் நிரூபிக்க.',
            explanation: '''• குர்ஆன் 42:13 வசனம் இதற்கு ஆதாரம்
• நூஹ், இப்ராஹீம், மூஸா, ஈஸா அனைவருக்கும் ஒரே அகீதாவே
• நம்பிக்கைக் கோட்பாடு காலம் மாறினாலும் மாறாதது
• முஹம்மத் (ஸல்) அவர்களுக்கும் அதே அகீதாவே''',
          ),
        ],
      ),
      // Chapters 2-5 from islam_ol_chapters.dart
      ...islamOLChapters,
    ],
  ),
];
