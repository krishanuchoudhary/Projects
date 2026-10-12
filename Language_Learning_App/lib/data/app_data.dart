import '../models/learning_models.dart';

const languages = <LanguageOption>[
  LanguageOption(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
  LanguageOption(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
  LanguageOption(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
];

const Map<String, List<LessonWord>> lessonWords = {
  'es': [
    LessonWord(id: 'es-v1', category: 'Vocabulary', word: 'hola', translation: 'hello', pronunciation: 'OH-lah', example: '¡Hola! ¿Cómo estás?', grammarTip: 'Use “hola” for greetings at any time of day.'),
    LessonWord(id: 'es-v2', category: 'Vocabulary', word: 'gracias', translation: 'thank you', pronunciation: 'GRAH-syahs', example: 'Gracias por tu ayuda.', grammarTip: '“Gracias” stays the same regardless of who is speaking.'),
    LessonWord(id: 'es-v3', category: 'Vocabulary', word: 'comida', translation: 'food', pronunciation: 'koh-MEE-dah', example: 'La comida está deliciosa.', grammarTip: '“La” is the feminine singular article.'),
    LessonWord(id: 'es-v4', category: 'Vocabulary', word: 'amigo', translation: 'friend', pronunciation: 'ah-MEE-goh', example: 'Él es mi amigo.', grammarTip: 'The feminine form is “amiga”.'),
    LessonWord(id: 'es-v5', category: 'Vocabulary', word: 'agua', translation: 'water', pronunciation: 'AH-gwah', example: 'Quiero agua, por favor.', grammarTip: '“Agua” is feminine but uses “el” in the singular for pronunciation.'),
    LessonWord(id: 'es-g1', category: 'Grammar', word: 'Yo soy estudiante', translation: 'I am a student', pronunciation: 'yoh soy ehs-too-dee-AHN-teh', example: 'Yo soy estudiante de informática.', grammarTip: '“Soy” is the first-person singular form of “ser” (to be).'),
    LessonWord(id: 'es-g2', category: 'Grammar', word: 'Tengo veinte años', translation: 'I am twenty years old', pronunciation: 'TEHN-goh BAYN-teh AH-nyohs', example: 'Tengo veinte años.', grammarTip: 'Spanish expresses age with “tener” (to have), not “ser”.'),
  ],
  'fr': [
    LessonWord(id: 'fr-v1', category: 'Vocabulary', word: 'bonjour', translation: 'hello / good morning', pronunciation: 'bohn-ZHOOR', example: 'Bonjour, comment ça va ?', grammarTip: 'Use “bonjour” for polite daytime greetings.'),
    LessonWord(id: 'fr-v2', category: 'Vocabulary', word: 'merci', translation: 'thank you', pronunciation: 'mehr-SEE', example: 'Merci beaucoup !', grammarTip: '“Merci beaucoup” means “thank you very much”.'),
    LessonWord(id: 'fr-v3', category: 'Vocabulary', word: 'livre', translation: 'book', pronunciation: 'LEEVR', example: 'Je lis un livre.', grammarTip: '“Livre” is masculine, so “un livre” is used for a book.'),
    LessonWord(id: 'fr-v4', category: 'Vocabulary', word: 'ami', translation: 'friend', pronunciation: 'ah-MEE', example: 'C’est mon ami.', grammarTip: 'The feminine form is “amie”, with the same pronunciation.'),
    LessonWord(id: 'fr-v5', category: 'Vocabulary', word: 'eau', translation: 'water', pronunciation: 'OH', example: 'Je voudrais de l’eau.', grammarTip: '“Eau” is feminine: “de l’eau” means “some water”.'),
    LessonWord(id: 'fr-g1', category: 'Grammar', word: 'Je suis étudiant', translation: 'I am a student', pronunciation: 'zhuh swee ay-too-dee-AHN', example: 'Je suis étudiant en informatique.', grammarTip: '“Suis” is the first-person singular form of “être” (to be).'),
    LessonWord(id: 'fr-g2', category: 'Grammar', word: 'J’ai vingt ans', translation: 'I am twenty years old', pronunciation: 'zhay VAN-tahn', example: 'J’ai vingt ans.', grammarTip: 'French uses “avoir” (to have) to express age.'),
  ],
  'de': [
    LessonWord(id: 'de-v1', category: 'Vocabulary', word: 'hallo', translation: 'hello', pronunciation: 'HAH-loh', example: 'Hallo! Wie geht es dir?', grammarTip: '“Hallo” is an informal everyday greeting.'),
    LessonWord(id: 'de-v2', category: 'Vocabulary', word: 'danke', translation: 'thank you', pronunciation: 'DAHN-keh', example: 'Danke für deine Hilfe.', grammarTip: '“Danke” can be used alone or followed by a reason.'),
    LessonWord(id: 'de-v3', category: 'Vocabulary', word: 'Buch', translation: 'book', pronunciation: 'BOOKH', example: 'Das ist ein Buch.', grammarTip: '“Buch” is neuter, so the definite article is “das”.'),
    LessonWord(id: 'de-v4', category: 'Vocabulary', word: 'Freund', translation: 'friend', pronunciation: 'FROYNT', example: 'Er ist mein Freund.', grammarTip: '“Freund” is masculine; the feminine form is “Freundin”.'),
    LessonWord(id: 'de-v5', category: 'Vocabulary', word: 'Wasser', translation: 'water', pronunciation: 'VAH-ser', example: 'Ich trinke Wasser.', grammarTip: '“Wasser” is neuter and is usually used without an article for the general substance.'),
    LessonWord(id: 'de-g1', category: 'Grammar', word: 'Ich bin Student', translation: 'I am a student', pronunciation: 'ikh bin shtoo-DENT', example: 'Ich bin Informatikstudent.', grammarTip: '“Bin” is the first-person singular form of “sein” (to be).'),
    LessonWord(id: 'de-g2', category: 'Grammar', word: 'Ich bin zwanzig Jahre alt', translation: 'I am twenty years old', pronunciation: 'ikh bin TSVAN-tsikh YAH-reh alt', example: 'Ich bin zwanzig Jahre alt.', grammarTip: 'German expresses age with “sein” plus “Jahre alt”.'),
  ],
};

const Map<String, List<QuizQuestion>> quizQuestions = {
  'es': [
    QuizQuestion(prompt: 'What does “gracias” mean?', translation: 'gracias', options: ['Please', 'Thank you', 'Goodbye', 'Friend'], answerIndex: 1, explanation: '“Gracias” means “thank you” in Spanish.'),
    QuizQuestion(prompt: 'Choose the Spanish word for “water”.', translation: 'water', options: ['agua', 'libro', 'amigo', 'hola'], answerIndex: 0, explanation: '“Agua” means water.'),
    QuizQuestion(prompt: 'What does “Tengo veinte años” express?', translation: 'Tengo veinte años', options: ['I have a book', 'I am twenty years old', 'I am a student', 'I like water'], answerIndex: 1, explanation: 'Spanish literally uses “tener” (to have) to express age.'),
    QuizQuestion(prompt: 'Which phrase means “I am a student”?', translation: 'I am a student', options: ['Yo tengo estudiante', 'Yo soy estudiante', 'Yo estoy agua', 'Yo hago estudiante'], answerIndex: 1, explanation: '“Yo soy estudiante” uses “soy”, the first-person singular of “ser”.'),
    QuizQuestion(prompt: 'Choose the Spanish word for “friend”.', translation: 'friend', options: ['comida', 'amigo', 'agua', 'gracias'], answerIndex: 1, explanation: '“Amigo” means friend.'),
  ],
  'fr': [
    QuizQuestion(prompt: 'What does “merci” mean?', translation: 'merci', options: ['Thank you', 'Good night', 'Water', 'Book'], answerIndex: 0, explanation: '“Merci” means “thank you”.'),
    QuizQuestion(prompt: 'Choose the French word for “book”.', translation: 'book', options: ['ami', 'eau', 'livre', 'bonjour'], answerIndex: 2, explanation: '“Livre” means book.'),
    QuizQuestion(prompt: 'What does “J’ai vingt ans” express?', translation: 'J’ai vingt ans', options: ['I am twenty years old', 'I have twenty books', 'I am a teacher', 'I drink water'], answerIndex: 0, explanation: 'French uses “avoir” (to have) to express age.'),
    QuizQuestion(prompt: 'Which phrase means “I am a student”?', translation: 'I am a student', options: ['Je suis étudiant', 'J’ai étudiant', 'Je livre étudiant', 'Je fais eau'], answerIndex: 0, explanation: '“Je suis étudiant” means “I am a student”.'),
    QuizQuestion(prompt: 'Choose the French word for “water”.', translation: 'water', options: ['livre', 'ami', 'eau', 'merci'], answerIndex: 2, explanation: '“Eau” means water.'),
  ],
  'de': [
    QuizQuestion(prompt: 'What does “danke” mean?', translation: 'danke', options: ['Hello', 'Thank you', 'Book', 'Friend'], answerIndex: 1, explanation: '“Danke” means “thank you”.'),
    QuizQuestion(prompt: 'Choose the German word for “book”.', translation: 'book', options: ['Wasser', 'Buch', 'Freund', 'Hallo'], answerIndex: 1, explanation: '“Buch” means book.'),
    QuizQuestion(prompt: 'What does “Ich bin zwanzig Jahre alt” express?', translation: 'Ich bin zwanzig Jahre alt', options: ['I have a friend', 'I am twenty years old', 'I read a book', 'I drink water'], answerIndex: 1, explanation: 'This is the standard German pattern for saying your age.'),
    QuizQuestion(prompt: 'Which phrase means “I am a student”?', translation: 'I am a student', options: ['Ich habe Student', 'Ich bin Student', 'Ich mache Student', 'Ich bin Buch'], answerIndex: 1, explanation: '“Ich bin Student” means “I am a student”.'),
    QuizQuestion(prompt: 'Choose the German word for “water”.', translation: 'water', options: ['Hallo', 'Wasser', 'Danke', 'Buch'], answerIndex: 1, explanation: '“Wasser” means water.'),
  ],
};
