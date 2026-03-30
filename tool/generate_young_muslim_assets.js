const fs = require('fs');
const path = require('path');

const root = process.cwd();
const legacyDir = path.join(root, 'assets', 'json', 'quran_stories');
const outputDir = path.join(root, 'assets', 'json', 'young_muslim');
const playlistsDir = path.join(outputDir, 'playlists');
const DATA_VERSION = 2;

const playlistConfigs = [
  {
    oldFile:
      'Human_Stories_In_Qur_an__HSQ_____قصص_الإنسان_في_القرآن__flat.json',
    newFile: 'human_stories_from_quran.json',
    categoryId: 'human_stories',
    seriesId: 'human_stories_ar',
    titleAr: 'قصص الإنسان في القرآن',
    titleEn: "Human Stories From Quran",
    descriptionAr:
      'سلسلة قصصية تربط الطفل بمواقف البشر في القرآن الكريم بطريقة مرئية سهلة.',
    descriptionEn:
      'A story collection that introduces children to people-centered Quran stories.',
    language: 'ar',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 1,
    accentStart: '#FF9B71',
    accentEnd: '#FFD166',
    tags: ['قصص', 'القرآن', 'الإنسان', 'تعلم'],
  },
  {
    oldFile:
      'قصص_الحيوان_في_القرآن___Animal_Stories_from_Qur_an__flat.json',
    newFile: 'animal_stories_from_quran_ar.json',
    categoryId: 'animal_stories',
    seriesId: 'animal_stories_ar',
    titleAr: 'قصص الحيوان في القرآن',
    titleEn: 'Animal Stories From Quran',
    descriptionAr:
      'رحلة مرئية ممتعة مع الحيوانات المذكورة في القرآن بأسلوب قريب من الأطفال.',
    descriptionEn:
      'A child-friendly visual journey through Quran stories involving animals.',
    language: 'ar',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 2,
    accentStart: '#39A96B',
    accentEnd: '#8FE388',
    tags: ['قصص', 'حيوانات', 'القرآن', 'أطفال'],
  },
  {
    oldFile:
      'Histoires_Du_Coran_Raconté_par_les_Animaux__Francais__-_قصص_الحيوان_في_القرآن__flat.json',
    newFile: 'animal_stories_from_quran_fr.json',
    categoryId: 'animal_stories',
    seriesId: 'animal_stories_fr',
    titleAr: 'قصص الحيوان في القرآن - فرنسي',
    titleEn: 'Animal Stories From Quran - French',
    descriptionAr:
      'نسخة فرنسية من قصص الحيوان في القرآن لتوسيع التجربة التعليمية داخل التطبيق.',
    descriptionEn:
      'French edition of the animal stories series for multilingual learning.',
    language: 'fr',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 3,
    accentStart: '#3FA7D6',
    accentEnd: '#6DD3CE',
    tags: ['قصص', 'حيوانات', 'فرنسي', 'القرآن'],
  },
  {
    oldFile:
      'قصص_النساء_في_القرآن___Women_Stories_from_Qur_an__flat.json',
    newFile: 'women_stories_from_quran.json',
    categoryId: 'women_stories',
    seriesId: 'women_stories_ar',
    titleAr: 'قصص النساء في القرآن',
    titleEn: 'Women Stories From Quran',
    descriptionAr:
      'سلسلة تربط الأطفال بقصص النساء الواردة في القرآن بقيم تربوية واضحة.',
    descriptionEn:
      'A series focused on Quran stories of women with gentle educational themes.',
    language: 'ar',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 4,
    accentStart: '#E76F51',
    accentEnd: '#F4A261',
    tags: ['قصص', 'نساء', 'القرآن', 'قيم'],
  },
  {
    oldFile:
      'Verses_Stories_from_Qur_an__VSQ_____مسلسل__قصص_الآيات_في_القرآن__flat.json',
    newFile: 'verses_stories_from_quran.json',
    categoryId: 'verses_stories',
    seriesId: 'verses_stories_ar',
    titleAr: 'قصص الآيات في القرآن',
    titleEn: 'Verses Stories From Quran',
    descriptionAr:
      'سلسلة تربط الطفل بسبب نزول بعض الآيات والمواقف التي ارتبطت بها.',
    descriptionEn:
      'A series that introduces the stories and situations behind selected Quran verses.',
    language: 'ar',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 5,
    accentStart: '#6C63FF',
    accentEnd: '#8E9BFF',
    tags: ['قصص', 'آيات', 'القرآن', 'تعلم'],
  },
  {
    oldFile:
      'قصص_العجائب_في_القرآن___Marvellous_stories_from_Qur_an__flat.json',
    newFile: 'marvellous_stories_from_quran.json',
    categoryId: 'marvellous_stories',
    seriesId: 'marvellous_stories_ar',
    titleAr: 'قصص العجائب في القرآن',
    titleEn: 'Marvellous Stories From Quran',
    descriptionAr:
      'سلسلة تقدم المواقف العجيبة والعبر المؤثرة في القرآن بأسلوب سهل ومرح.',
    descriptionEn:
      'A visual series about remarkable Quran stories and memorable life lessons.',
    language: 'ar',
    contentType: 'story_series',
    audience: 'kids',
    sortOrder: 6,
    accentStart: '#A44CD3',
    accentEnd: '#F4B393',
    tags: ['قصص', 'عجائب', 'القرآن', 'أطفال'],
  },
  {
    oldFile:
      'كواليس_قصص_الآيات_في_القرآن___Versies_Stories_from_Quran__BTS__flat.json',
    newFile: 'verses_stories_from_quran_bts.json',
    categoryId: 'behind_the_scenes',
    seriesId: 'verses_stories_bts',
    titleAr: 'كواليس قصص الآيات في القرآن',
    titleEn: 'Verses Stories Behind The Scenes',
    descriptionAr:
      'مشاهد قصيرة من كواليس إنتاج قصص الآيات في القرآن بطريقة بسيطة وآمنة للأطفال.',
    descriptionEn:
      'Short behind-the-scenes clips from the production of the verses stories series.',
    language: 'mixed',
    contentType: 'behind_the_scenes',
    audience: 'general',
    sortOrder: 7,
    accentStart: '#355C7D',
    accentEnd: '#6C5B7B',
    tags: ['كواليس', 'آيات', 'إنتاج', 'قصص'],
  },
  {
    oldFile:
      'كواليس_قصص_العجائب_في_القرآن___Marvelous_Stories_from_Qur_an__BTS__flat.json',
    newFile: 'marvellous_stories_from_quran_bts.json',
    categoryId: 'behind_the_scenes',
    seriesId: 'marvellous_stories_bts',
    titleAr: 'كواليس قصص العجائب في القرآن',
    titleEn: 'Marvellous Stories Behind The Scenes',
    descriptionAr:
      'مقاطع كواليس قصيرة تعرّف الطفل بكيفية صنع الحلقات بطريقة مرئية خفيفة.',
    descriptionEn:
      'Short backstage clips that show how the marvellous stories episodes are produced.',
    language: 'mixed',
    contentType: 'behind_the_scenes',
    audience: 'general',
    sortOrder: 8,
    accentStart: '#264653',
    accentEnd: '#2A9D8F',
    tags: ['كواليس', 'عجائب', 'إنتاج', 'قصص'],
  },
];

const categories = [
  {
    id: 'human_stories',
    title_ar: 'قصص الإنسان في القرآن',
    title_en: 'Human Stories',
    description:
      'قصص بشرية من القرآن تساعد الطفل على فهم المواقف والقيم من خلال الحكاية.',
    order: 1,
    audience: 'kids',
    language: 'ar',
    content_type: 'story_series',
    tags: ['قصص', 'الإنسان', 'القرآن'],
    source_key: 'human_stories',
    accent_start: '#FF9B71',
    accent_end: '#FFD166',
  },
  {
    id: 'animal_stories',
    title_ar: 'قصص الحيوان في القرآن',
    title_en: 'Animal Stories',
    description:
      'قصص الحيوانات المذكورة في القرآن بنسختين عربية وفرنسية داخل تجربة واحدة.',
    order: 2,
    audience: 'kids',
    language: 'multi',
    content_type: 'story_series',
    tags: ['قصص', 'حيوانات', 'القرآن'],
    source_key: 'animal_stories',
    accent_start: '#39A96B',
    accent_end: '#8FE388',
  },
  {
    id: 'women_stories',
    title_ar: 'قصص النساء في القرآن',
    title_en: 'Women Stories',
    description:
      'قصص النساء الواردة في القرآن بقيم تربوية واضحة تناسب الأطفال واليافعين.',
    order: 3,
    audience: 'kids',
    language: 'ar',
    content_type: 'story_series',
    tags: ['قصص', 'نساء', 'القرآن'],
    source_key: 'women_stories',
    accent_start: '#E76F51',
    accent_end: '#F4A261',
  },
  {
    id: 'verses_stories',
    title_ar: 'قصص الآيات في القرآن',
    title_en: 'Verses Stories',
    description:
      'حكايات توضح مواقف بعض الآيات وتربط الطفل بمعانيها في سياق قصصي مبسط.',
    order: 4,
    audience: 'kids',
    language: 'ar',
    content_type: 'story_series',
    tags: ['قصص', 'آيات', 'القرآن'],
    source_key: 'verses_stories',
    accent_start: '#6C63FF',
    accent_end: '#8E9BFF',
  },
  {
    id: 'marvellous_stories',
    title_ar: 'قصص العجائب في القرآن',
    title_en: 'Marvellous Stories',
    description:
      'قصص عجيبة مليئة بالعبر والمواقف المؤثرة من القرآن بأسلوب مرئي جذاب.',
    order: 5,
    audience: 'kids',
    language: 'ar',
    content_type: 'story_series',
    tags: ['قصص', 'عجائب', 'القرآن'],
    source_key: 'marvellous_stories',
    accent_start: '#A44CD3',
    accent_end: '#F4B393',
  },
  {
    id: 'behind_the_scenes',
    title_ar: 'كواليس السلاسل',
    title_en: 'Behind The Scenes',
    description:
      'مقاطع قصيرة تكشف كواليس إنتاج بعض السلاسل بطريقة مناسبة وآمنة داخل التطبيق.',
    order: 6,
    audience: 'general',
    language: 'mixed',
    content_type: 'behind_the_scenes',
    tags: ['كواليس', 'إنتاج', 'قصص'],
    source_key: 'behind_the_scenes',
    accent_start: '#355C7D',
    accent_end: '#6C5B7B',
  },
];

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function normalizeWhitespace(value = '') {
  return value
    .replace(/[\u200e\u200f]/g, '')
    .replace(/[“”"]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function normalizeDelimiters(value = '') {
  return normalizeWhitespace(
    value.replace(/[⎜¦]/g, '|').replace(/\s*\|\s*/g, ' | '),
  );
}

function toSlug(value = '') {
  return normalizeWhitespace(value)
    .toLowerCase()
    .replace(/[^a-z0-9\u0600-\u06FF]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function parseEpisodeNumber(title) {
  const match = normalizeWhitespace(title).match(
    /(?:الحلقة|حلقة|episode|ep|ép)\s*(\d+)/i,
  );
  return match ? Number(match[1]) : null;
}

function parsePartNumber(title) {
  const normalized = normalizeWhitespace(title);
  const partMatch =
    normalized.match(/(?:جزء|ج)\s*(\d+)/i) ||
    normalized.match(/\((\d+)\)\s*$/) ||
    normalized.match(/part\s*(\d+)/i);
  return partMatch ? Number(partMatch[1]) : null;
}

function isIntroTitle(title) {
  return /intro|تتر البداية/i.test(title);
}

function isOutroTitle(title) {
  return /outro|تتر النهاية/i.test(title);
}

function stripSeriesName(topic) {
  return normalizeWhitespace(
    topic
      .replace(
        /-\s*(قصص(?:\s+\S+){1,5}\s+في\s+القرآن|Human Stories from Qur'an|Animal Stories from Qur'an|Women Stories from Qur'an|Verses Stories from Qur'an|Marvellous Stories from Qur'an)$/i,
        '',
      )
      .replace(/^stories of verses from the quran\s*\(bts\)\s*-?/i, '')
      .replace(/^verses stories from quran\s*\(?\s*bts\s*\)?\s*-?/i, '')
      .replace(/^marvellous stories from quran\s*\(?\s*bts\s*\)?\s*-?/i, '')
      .replace(/-\s*قصص\s+الآيات\s+في\s+القرآن$/i, '')
      .replace(/-\s*قصص\s+العجائب\s+في\s+القرآن$/i, '')
      .replace(/\(\d+\)\s*$/g, '')
      .replace(/-\s*(?:ج|جزء)\s*\d+\s*$/i, ''),
  );
}

function parseTopic(videoTitle, config) {
  const normalized = normalizeDelimiters(videoTitle);

  if (isIntroTitle(normalized)) {
    return config.language === 'fr' ? 'Introduction' : 'تتر البداية';
  }

  if (isOutroTitle(normalized)) {
    return config.language === 'fr' ? 'Finale' : 'تتر النهاية';
  }

  if (config.contentType === 'behind_the_scenes') {
    const episode = parseEpisodeNumber(normalized);
    if (episode != null) {
      return `كواليس الحلقة ${episode}`;
    }
    return 'كواليس السلسلة';
  }

  const segments = normalized.split('|').map((item) => item.trim()).filter(Boolean);
  let candidate = '';

  if (segments.length >= 3) {
    candidate = segments[2];
  }

  if (!candidate && segments.length >= 2) {
    candidate = segments[1];
  }

  if (!candidate) {
    candidate = normalized;
  }

  candidate = stripSeriesName(candidate);
  if (!candidate) {
    candidate = config.titleAr;
  }

  return candidate;
}

function buildVideoDescription(config, topic, video) {
  if (isIntroTitle(video.title)) {
    return 'حلقة تمهيدية قصيرة تهيئ الطفل للدخول إلى أجواء السلسلة ومضامينها.';
  }

  if (isOutroTitle(video.title)) {
    return 'حلقة ختامية تلخص نهاية السلسلة وتمنح الطفل فرصة لتذكر أبرز المعاني.';
  }

  if (config.contentType === 'behind_the_scenes') {
    return 'لقطة قصيرة من الكواليس تعرض كيف صُنعت الحلقة بأسلوب مبسط وممتع.';
  }

  return `حلقة من ${config.titleAr} تتناول قصة ${topic} بأسلوب مرئي بسيط مناسب للأطفال.`;
}

function pickThumbnail(video, playlist) {
  return (
    video.thumbnail ||
    (video.thumbnails && video.thumbnails[video.thumbnails.length - 1]?.url) ||
    (playlist.thumbnails && playlist.thumbnails[playlist.thumbnails.length - 1]?.url) ||
    ''
  );
}

function createChoiceOptions(correctTopic, distractorPool, language) {
  const unique = [];
  for (const item of [correctTopic, ...distractorPool]) {
    const value = normalizeWhitespace(item);
    if (!value || unique.includes(value)) {
      continue;
    }
    unique.push(value);
    if (unique.length === 4) {
      break;
    }
  }

  while (unique.length < 4) {
    unique.push(language === 'fr' ? `Choix ${unique.length + 1}` : `اختيار ${unique.length + 1}`);
  }

  return unique.map((text, index) => ({
    id: String.fromCharCode(97 + index),
    text,
  }));
}

function buildVideoQuiz(config, normalizedVideo, seriesTopics) {
  const distractors = seriesTopics.filter((item) => item !== normalizedVideo.topic_title);
  const options = createChoiceOptions(
    normalizedVideo.topic_title,
    distractors,
    config.language,
  );
  const correctOption = options.find(
    (option) => option.text === normalizedVideo.topic_title,
  );
  const isStructuredClip =
    normalizedVideo.is_intro ||
    normalizedVideo.is_outro ||
    normalizedVideo.is_bts;

  return {
    id: `quiz_video_${normalizedVideo.video_key}`,
    category_id: config.categoryId,
    series_id: config.seriesId,
    video_id: normalizedVideo.video_key,
    level: 'video',
    title: `سؤال الحلقة ${normalizedVideo.episode_number ?? normalizedVideo.index}`,
    xp_reward: 10,
    passing_score: 1,
    questions: [
      {
        id: `question_video_${normalizedVideo.video_key}`,
        type: 'multiple_choice',
        prompt:
          config.contentType === 'behind_the_scenes'
            ? 'ما نوع المحتوى الذي شاهدته في هذا المقطع؟'
            : 'ما القصة الرئيسية التي تناولتها هذه الحلقة؟',
        options,
        correct_option_id: correctOption ? correctOption.id : 'a',
        correct_answer_text: normalizedVideo.topic_title,
        explanation:
          config.contentType === 'behind_the_scenes'
            ? 'أحسنت. هذا المقطع من كواليس السلسلة وليس حلقة قصة كاملة.'
            : `أحسنت. الحلقة ركزت على قصة ${normalizedVideo.topic_title}.`,
      },
      isStructuredClip
        ? {
            id: `question_video_${normalizedVideo.video_key}_follow_up`,
            type: 'true_false',
            prompt:
              config.contentType === 'behind_the_scenes'
                ? 'صح أم خطأ: هذا المقطع يعرض جزءًا من كواليس الإنتاج.'
                : normalizedVideo.is_intro
                  ? 'صح أم خطأ: هذه الحلقة تمهيدية لتعريف الطفل بالسلسلة.'
                  : 'صح أم خطأ: هذه الحلقة ختامية وتساعد على تذكر نهاية السلسلة.',
            options: [
              { id: 'true', text: 'صح' },
              { id: 'false', text: 'خطأ' },
            ],
            correct_option_id: 'true',
            correct_answer_text: 'صح',
            explanation:
              config.contentType === 'behind_the_scenes'
                ? 'صحيح. هذا المحتوى يعرّف الطفل بما يحدث خلف صناعة الحلقات.'
                : normalizedVideo.is_intro
                  ? 'صحيح. هذه الحلقة تهيّئ الطفل قبل الدخول في القصص الأساسية.'
                  : 'صحيح. هذه الحلقة تساعد الطفل على تذكّر ختام السلسلة.',
          }
        : {
            id: `question_video_${normalizedVideo.video_key}_follow_up`,
            type: 'direct',
            prompt: 'اكتب اسم القصة أو الشخصية الرئيسية التي تتذكرها من هذه الحلقة.',
            options: [],
            correct_option_id: null,
            correct_answer_text: normalizedVideo.topic_title,
            explanation: `الإجابة الأقرب هي ${normalizedVideo.topic_title}. يكفي أن يتذكر الطفل اسم القصة بشكل واضح.`,
          },
    ],
  };
}

function buildSeriesQuiz(config, seriesRecord, normalizedVideos, seriesTopics) {
  const playableTopics = seriesTopics.filter(
    (topic) => !/تتر البداية|تتر النهاية|introduction|finale/i.test(topic),
  );
  const firstTopic = playableTopics[0] || seriesRecord.title_ar;
  const secondTopic = playableTopics[1] || firstTopic;
  const wrongTopic =
    categories
      .flatMap((category) => category.id === config.categoryId ? [] : category.tags)
      .find(Boolean) || 'الطقس';

  return {
    id: `quiz_series_${config.seriesId}`,
    category_id: config.categoryId,
    series_id: config.seriesId,
    video_id: null,
    level: 'series',
    title: `تحدي سلسلة ${seriesRecord.title_ar}`,
    xp_reward: 25,
    passing_score: 2,
    questions: [
      {
        id: `question_series_${config.seriesId}_1`,
        type: 'multiple_choice',
        prompt: 'أي عنوان من التالي ينتمي إلى هذه السلسلة؟',
        options: createChoiceOptions(
          firstTopic,
          [
            secondTopic,
            'التجارب العلمية',
            config.contentType === 'behind_the_scenes'
              ? 'أحداث خارج موضوع الكواليس'
              : 'قصص من قسم مختلف',
          ],
          config.language,
        ),
        correct_answer_text: firstTopic,
        correct_option_id: 'a',
        explanation: `هذا العنوان من القصص أو المقاطع المرتبطة بسلسلة ${seriesRecord.title_ar}.`,
      },
      {
        id: `question_series_${config.seriesId}_2`,
        type: 'true_false',
        prompt:
          config.contentType === 'behind_the_scenes'
            ? 'صح أم خطأ: هذه السلسلة تعرض كواليس الإنتاج وليس حلقات القصة الأصلية.'
            : `صح أم خطأ: سلسلة ${seriesRecord.title_ar} مناسبة للتعرف إلى ${seriesRecord.title_ar}.`,
        options: [
          { id: 'true', text: 'صح' },
          { id: 'false', text: 'خطأ' },
        ],
        correct_option_id: 'true',
        correct_answer_text: 'صح',
        explanation:
          config.contentType === 'behind_the_scenes'
            ? 'صحيح. المقاطع هنا قصيرة وتكشف جزءًا من خلفية صناعة العمل.'
            : 'صحيح. السلسلة صممت لتقريب هذا النوع من القصص للأطفال.',
      },
      {
        id: `question_series_${config.seriesId}_3`,
        type: 'direct',
        prompt:
          config.contentType === 'behind_the_scenes'
            ? 'اكتب اسم السلسلة التي شاهدت كواليسها.'
            : 'اكتب اسم السلسلة التي أنهيتها أو نوعها القصصي.',
        options: [],
        correct_option_id: null,
        correct_answer_text: seriesRecord.title_ar,
        explanation: `اسم السلسلة هو ${seriesRecord.title_ar}، وهذا يساعد الطفل على ربط الحلقات بعنوانها العام.`,
      },
    ],
  };
}

function buildRewardsPayload() {
  return {
    version: DATA_VERSION,
    generated_at: new Date().toISOString(),
    xp_rules: {
      video_completed: 20,
      correct_video_quiz: 10,
      correct_series_quiz: 15,
      perfect_quiz_bonus: 10,
    },
    achievements: [
      {
        id: 'first_video_completed',
        title_ar: 'أكملت أول فيديو',
        title_en: 'First Video Completed',
        description: 'أنهِ أول فيديو داخل المسلم الصغير.',
        type: 'completed_videos',
        threshold: 1,
        xp_reward: 20,
        icon: 'play_circle',
      },
      {
        id: 'five_videos_completed',
        title_ar: 'مشاهد نشيط',
        title_en: 'Active Viewer',
        description: 'أكمل 5 فيديوهات داخل المسلم الصغير.',
        type: 'completed_videos',
        threshold: 5,
        xp_reward: 30,
        icon: 'movie_filter',
      },
      {
        id: 'series_completed',
        title_ar: 'أنهيت سلسلة كاملة',
        title_en: 'Series Finisher',
        description: 'أتم جميع حلقات أي سلسلة كاملة.',
        type: 'completed_series',
        threshold: 1,
        xp_reward: 40,
        icon: 'auto_awesome',
      },
      {
        id: 'ten_correct_answers',
        title_ar: 'بطل الأسئلة',
        title_en: 'Quiz Hero',
        description: 'أجب إجابة صحيحة عن 10 أسئلة.',
        type: 'correct_answers',
        threshold: 10,
        xp_reward: 35,
        icon: 'emoji_events',
      },
      {
        id: 'watch_later_collector',
        title_ar: 'خطط لمشاهدتك',
        title_en: 'Watch Later Planner',
        description: 'أضف 3 فيديوهات إلى سأشاهد لاحقًا.',
        type: 'watch_later_items',
        threshold: 3,
        xp_reward: 15,
        icon: 'bookmark_added',
      },
    ],
  };
}

function createCatalogPayload(seriesRecords, categoryRecords) {
  return {
    version: DATA_VERSION,
    generated_at: new Date().toISOString(),
    categories: categoryRecords,
    series: seriesRecords,
  };
}

function main() {
  ensureDir(outputDir);
  ensureDir(playlistsDir);

  const seriesRecords = [];
  const categoryEnrichment = new Map();
  const quizSets = [];

  for (const config of playlistConfigs) {
    const normalizedPath = path.join(playlistsDir, config.newFile);
    const sourcePath = fs.existsSync(normalizedPath)
      ? normalizedPath
      : path.join(legacyDir, config.oldFile);
    const raw = JSON.parse(fs.readFileSync(sourcePath, 'utf8'));
    const playlist = raw.playlist || {};
    const normalizedVideos = (raw.videos || []).map((video) => {
      const normalizedTitle = normalizeDelimiters(video.title);
      const topic = parseTopic(normalizedTitle, config);
      const episodeNumber = parseEpisodeNumber(normalizedTitle);
      const partNumber = parsePartNumber(normalizedTitle);
      const isIntro = isIntroTitle(normalizedTitle);
      const isOutro = isOutroTitle(normalizedTitle);
      const videoKey = `${config.seriesId}__${video.id}`;
      return {
        index: video.index,
        video_key: videoKey,
        id: video.id,
        title: video.title,
        normalized_title: normalizedTitle,
        title_slug: toSlug(video.title),
        topic_title: topic,
        topic_slug: toSlug(topic),
        url: video.url,
        channel: video.channel,
        channel_id: video.channel_id,
        uploader: video.uploader,
        uploader_id: video.uploader_id,
        duration: video.duration,
        duration_human: video.duration_human,
        description: buildVideoDescription(config, topic, video),
        upload_date: video.upload_date,
        timestamp: video.timestamp,
        release_timestamp: video.release_timestamp,
        view_count: video.view_count,
        like_count: video.like_count,
        comment_count: video.comment_count,
        availability: video.availability,
        live_status: video.live_status,
        tags: video.tags,
        thumbnail: video.thumbnail,
        thumbnails: video.thumbnails,
        category_id: config.categoryId,
        series_id: config.seriesId,
        episode_number: episodeNumber,
        part_number: partNumber,
        language: config.language,
        content_type: config.contentType,
        is_intro: isIntro,
        is_outro: isOutro,
        is_bts: config.contentType === 'behind_the_scenes',
        raw: video.raw,
      };
    });

    const targetPath = path.join(playlistsDir, config.newFile);
    const normalizedPayload = {
      generated_at: raw.generated_at,
      source_key: config.categoryId,
      series_id: config.seriesId,
      category_id: config.categoryId,
      language: config.language,
      content_type: config.contentType,
      playlist: {
        ...playlist,
        title_ar: config.titleAr,
        title_en: config.titleEn,
        description_ar: config.descriptionAr,
        description_en: config.descriptionEn,
        banner_url:
          (playlist.thumbnails && playlist.thumbnails[playlist.thumbnails.length - 1]?.url) ||
          pickThumbnail(normalizedVideos[0] || {}, playlist),
      },
      stats: raw.stats,
      issues: raw.issues,
      warnings: raw.warnings,
      videos: normalizedVideos,
    };
    fs.writeFileSync(targetPath, JSON.stringify(normalizedPayload, null, 2));

    const bannerUrl = normalizedPayload.playlist.banner_url;
    const thumbnailUrl = pickThumbnail(normalizedVideos[0] || {}, playlist);
    const seriesRecord = {
      id: config.seriesId,
      category_id: config.categoryId,
      title_ar: config.titleAr,
      title_en: config.titleEn,
      description: config.descriptionAr,
      banner_image: bannerUrl,
      thumbnail: thumbnailUrl,
      file_name: `assets/json/young_muslim/playlists/${config.newFile}`,
      source_key: config.categoryId,
      tags: config.tags,
      order: config.sortOrder,
      audience: config.audience,
      language: config.language,
      content_type: config.contentType,
      accent_start: config.accentStart,
      accent_end: config.accentEnd,
      playlist_id: playlist.id,
      playlist_url: playlist.resolved_url || playlist.requested_url,
      total_videos: normalizedVideos.length,
      total_duration_seconds: normalizedVideos.reduce(
        (sum, video) => sum + (video.duration || 0),
        0,
      ),
      is_featured: config.sortOrder <= 4,
    };
    seriesRecords.push(seriesRecord);

    const enrichment = categoryEnrichment.get(config.categoryId) || {
      series_ids: [],
      banner_image: bannerUrl,
      thumbnail: thumbnailUrl,
    };
    enrichment.series_ids.push(config.seriesId);
    if (!enrichment.banner_image) {
      enrichment.banner_image = bannerUrl;
    }
    if (!enrichment.thumbnail) {
      enrichment.thumbnail = thumbnailUrl;
    }
    categoryEnrichment.set(config.categoryId, enrichment);

    const seriesTopics = Array.from(
      new Set(
        normalizedVideos
          .map((video) => video.topic_title)
          .filter(Boolean)
          .map((value) => normalizeWhitespace(value)),
      ),
    );

    for (const video of normalizedVideos) {
      quizSets.push(buildVideoQuiz(config, video, seriesTopics));
    }

    quizSets.push(
      buildSeriesQuiz(config, seriesRecord, normalizedVideos, seriesTopics),
    );
  }

  const categoryRecords = categories.map((category) => {
    const enrichment = categoryEnrichment.get(category.id) || {};
    return {
      ...category,
      series_ids: enrichment.series_ids || [],
      banner_image: enrichment.banner_image || '',
      thumbnail: enrichment.thumbnail || '',
      file_name: null,
    };
  });

  fs.writeFileSync(
    path.join(outputDir, 'catalog.json'),
    JSON.stringify(createCatalogPayload(seriesRecords, categoryRecords), null, 2),
  );
    fs.writeFileSync(
      path.join(outputDir, 'quizzes.json'),
      JSON.stringify(
        {
          version: DATA_VERSION,
          generated_at: new Date().toISOString(),
          quiz_sets: quizSets,
        },
        null,
        2,
    ),
  );
  fs.writeFileSync(
    path.join(outputDir, 'rewards.json'),
    JSON.stringify(buildRewardsPayload(), null, 2),
  );
}

main();
