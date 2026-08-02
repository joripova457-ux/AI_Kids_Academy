/// 160+ Kengaytaytirilgan Lug'at Ma'lumotlar Bazasi (English & Uzbek)
class VocabularyItem {
  final String english;
  final String uzbek;
  final String category;
  final String emoji;
  final String description;

  const VocabularyItem({
    required this.english,
    required this.uzbek,
    required this.category,
    required this.emoji,
    required this.description,
  });

  String get englishWithEmoji => '$english $emoji';
}

class VocabularyDataset {
  static const List<VocabularyItem> items = [
    // ==================== 1. HAYVONLAR (ANIMALS - 25) ====================
    VocabularyItem(english: "Cat", uzbek: "Mushuk", category: "Hayvonlar", emoji: "🐱", description: "Miyovlaydigan yumshoq uy hayvoni"),
    VocabularyItem(english: "Dog", uzbek: "It", category: "Hayvonlar", emoji: "🐶", description: "Insonning eng sadoqatli do'sti"),
    VocabularyItem(english: "Lion", uzbek: "Arslon", category: "Hayvonlar", emoji: "🦁", description: "O'rmonlar qiroli va kuchli yirtqich"),
    VocabularyItem(english: "Tiger", uzbek: "Yo'lbars", category: "Hayvonlar", emoji: "🐯", description: "Yo'l-yo'l terili epchil hayvon"),
    VocabularyItem(english: "Elephant", uzbek: "Fil", category: "Hayvonlar", emoji: "🐘", description: "Xartumi uzun ulkan hayvon"),
    VocabularyItem(english: "Giraffe", uzbek: "Jirafa", category: "Hayvonlar", emoji: "🦒", description: "Baland bo'yinli eng baland jonzot"),
    VocabularyItem(english: "Bear", uzbek: "Ayiq", category: "Hayvonlar", emoji: "🐻", description: "Asalni yaxshi ko'radigan polvon hayvon"),
    VocabularyItem(english: "Rabbit", uzbek: "Quyon", category: "Hayvonlar", emoji: "🐰", description: "Sabzi yeydigan uzun quloqli hayvon"),
    VocabularyItem(english: "Fox", uzbek: "Tulki", category: "Hayvonlar", emoji: "🦊", description: "Zukko va ayyor o'rmon hayvoni"),
    VocabularyItem(english: "Wolf", uzbek: "Bo'ri", category: "Hayvonlar", emoji: "🐺", description: "To'dalashib yashaydigan o'rmon jonzoti"),
    VocabularyItem(english: "Monkey", uzbek: "Maymun", category: "Hayvonlar", emoji: "🐒", description: "Daraxtlarda sakraydigan sho'x hayvon"),
    VocabularyItem(english: "Panda", uzbek: "Panda", category: "Hayvonlar", emoji: "🐼", description: "Bambuk yeydigan oq-qora ayiqcha"),
    VocabularyItem(english: "Horse", uzbek: "Ot", category: "Hayvonlar", emoji: "🐴", description: "Tez chopadigan va insonlarga yordam beradigan hayvon"),
    VocabularyItem(english: "Cow", uzbek: "Sigir", category: "Hayvonlar", emoji: "🐮", description: "Bizga toza va shirin sut beradigan hayvon"),
    VocabularyItem(english: "Sheep", uzbek: "Qo'y", category: "Hayvonlar", emoji: "🐑", description: "Yumshoq junli va ma'raydigan hayvon"),
    VocabularyItem(english: "Goat", uzbek: "Echki", category: "Hayvonlar", emoji: "🐐", description: "Shoxli va epchil uy hayvoni"),
    VocabularyItem(english: "Dolphin", uzbek: "Delfin", category: "Hayvonlar", emoji: "🐬", description: "Dengizdagi eng aqlli va do'stona jonzot"),
    VocabularyItem(english: "Whale", uzbek: "Kit", category: "Hayvonlar", emoji: "🐋", description: "Ummonlardagi eng ulkan suv jonzoti"),
    VocabularyItem(english: "Frog", uzbek: "Qurbaqa", category: "Hayvonlar", emoji: "🐸", description: "Suvda va quruqlikda sakraydigan jonzot"),
    VocabularyItem(english: "Duck", uzbek: "O'rdak", category: "Hayvonlar", emoji: "🦆", description: "Suzishni yaxshi ko'radigan parrak uy qushi"),
    VocabularyItem(english: "Chicken", uzbek: "Tovuq", category: "Hayvonlar", emoji: "🐔", description: "Bizga har kuni tuxum beradigan qush"),
    VocabularyItem(english: "Eagle", uzbek: "Lochin", category: "Hayvonlar", emoji: "🦅", description: "Osmonda baland uchadigan mag'rur qush"),
    VocabularyItem(english: "Owl", uzbek: "Bayg'ush", category: "Hayvonlar", emoji: "🦉", description: "Tunda yaxshi ko'radigan dono qush"),
    VocabularyItem(english: "Butterfly", uzbek: "Kapalak", category: "Hayvonlar", emoji: "🦋", description: "Rang-barang qanotli nafis qushcha"),
    VocabularyItem(english: "Bee", uzbek: "Ari", category: "Hayvonlar", emoji: "🐝", description: "Gullardan bol yig'adigan mehnatsevar jonzot"),

    // ==================== 2. MEVALAR VA SABZAVOTLAR (FRUITS - 20) ====================
    VocabularyItem(english: "Apple", uzbek: "Olma", category: "Mevalar", emoji: "🍎", description: "Mazali va vitaminlarga boy qizil meva"),
    VocabularyItem(english: "Banana", uzbek: "Banan", category: "Mevalar", emoji: "🍌", description: "Sariq rangli shirin meva"),
    VocabularyItem(english: "Orange", uzbek: "Apelsin", category: "Mevalar", emoji: "🍊", description: "C vitaminiga boy apelsin rangli meva"),
    VocabularyItem(english: "Strawberry", uzbek: "Qulupnay", category: "Mevalar", emoji: "🍓", description: "Xushbo'y qizil bahoriy meva"),
    VocabularyItem(english: "Watermelon", uzbek: "Tarvuz", category: "Mevalar", emoji: "🍉", description: "Yozda chanqoqni bosuvchi suvli meva"),
    VocabularyItem(english: "Grape", uzbek: "Uzum", category: "Mevalar", emoji: "🍇", description: "Shingil-shingil bo'lib osadigan shirin meva"),
    VocabularyItem(english: "Peach", uzbek: "Shaftoli", category: "Mevalar", emoji: "🍑", description: "Yumshoq tukli mazali meva"),
    VocabularyItem(english: "Cherry", uzbek: "Gilos", category: "Mevalar", emoji: "🍒", description: "Juft bo'lib osadigan qizil meva"),
    VocabularyItem(english: "Pear", uzbek: "Nok", category: "Mevalar", emoji: "🍐", description: "Shirin va sersuv meva"),
    VocabularyItem(english: "Pineapple", uzbek: "Ananas", category: "Mevalar", emoji: "🍍", description: "Boshida tojisi bor tropik meva"),
    VocabularyItem(english: "Lemon", uzbek: "Limon", category: "Mevalar", emoji: "🍋", description: "Choyga solinadigan nordon sariq meva"),
    VocabularyItem(english: "Carrot", uzbek: "Sabzi", category: "Sabzavotlar", emoji: "🥕", description: "Ko'z uchun foydali sariq va qizil sabzavot"),
    VocabularyItem(english: "Tomato", uzbek: "Pomidor", category: "Sabzavotlar", emoji: "🍅", description: "Salatlarga solinadigan qizil sabzavot"),
    VocabularyItem(english: "Cucumber", uzbek: "Bodring", category: "Sabzavotlar", emoji: "🥒", description: "Yashil va nordon salat sabzavoti"),
    VocabularyItem(english: "Potato", uzbek: "Kartoshka", category: "Sabzavotlar", emoji: "🥔", description: "Qovurma va taomlar uchun eng asosiy sabzavot"),
    VocabularyItem(english: "Corn", uzbek: "Makkajo'xori", category: "Sabzavotlar", emoji: "🌽", description: "Donalari sariq va mazali don"),
    VocabularyItem(english: "Broccoli", uzbek: "Brokkoli", category: "Sabzavotlar", emoji: "🥦", description: "Kichik daraxtga o'xshash yashil sabzavot"),
    VocabularyItem(english: "Onion", uzbek: "Piyoz", category: "Sabzavotlar", emoji: "🧅", description: "Taomlarga maz beruvchi o'tkir sabzavot"),
    VocabularyItem(english: "Garlic", uzbek: "Sarimsoq", category: "Sabzavotlar", emoji: "🧄", description: "Mikroblarga qarshi kurashuvchi shifobaxsh sabzavot"),
    VocabularyItem(english: "Pumpkin", uzbek: "Oshqovoq", category: "Sabzavotlar", emoji: "🎃", description: "Somsa va taomlarga solinadigan ulkan sabzavot"),

    // ==================== 3. RANGLAR (COLORS - 15) ====================
    VocabularyItem(english: "Red", uzbek: "Qizil", category: "Ranglar", emoji: "🔴", description: "Lola va qulupnay rangi"),
    VocabularyItem(english: "Blue", uzbek: "Ko'k", category: "Ranglar", emoji: "🔵", description: "Musaffo osmon va dengiz rangi"),
    VocabularyItem(english: "Green", uzbek: "Yashil", category: "Ranglar", emoji: "🟢", description: "Daraxt barglari va o'tlar rangi"),
    VocabularyItem(english: "Yellow", uzbek: "Sariq", category: "Ranglar", emoji: "🟡", description: "Quyosh va banan rangi"),
    VocabularyItem(english: "Orange", uzbek: "Olovrang", category: "Ranglar", emoji: "🟠", description: "Apelsin va sabzi rangi"),
    VocabularyItem(english: "Purple", uzbek: "Binafsharang", category: "Ranglar", emoji: "🟣", description: "Binafsha gul va uzum rangi"),
    VocabularyItem(english: "Pink", uzbek: "Pushti", category: "Ranglar", emoji: "🩷", description: "Chiroyli atirgul rangi"),
    VocabularyItem(english: "White", uzbek: "Oq", category: "Ranglar", emoji: "⚪", description: "Qor va sut rangi"),
    VocabularyItem(english: "Black", uzbek: "Qora", category: "Ranglar", emoji: "⚫", description: "Tungi osmon rangi"),
    VocabularyItem(english: "Brown", uzbek: "Jigarrang", category: "Ranglar", emoji: "🟤", description: "Daraxt tanasi va shokolad rangi"),
    VocabularyItem(english: "Grey", uzbek: "Kulrang", category: "Ranglar", emoji: "🩶", description: "Bulutlar va fil rangi"),
    VocabularyItem(english: "Gold", uzbek: "Oltin rang", category: "Ranglar", emoji: "🟡", description: "Porloq oltin va yulduzlar rangi"),
    VocabularyItem(english: "Silver", uzbek: "Kumush rang", category: "Ranglar", emoji: "⚪", description: "Porloq kumush rangi"),
    VocabularyItem(english: "Rainbow", uzbek: "Kamalak rang", category: "Ranglar", emoji: "🌈", description: "Yomg'irdan keyin chiqadigan 7 xil rang"),
    VocabularyItem(english: "Cyan", uzbek: "Havo rang", category: "Ranglar", emoji: "🩵", description: "Tiniq bulutli osmon rangi"),

    // ==================== 4. RAQAMLAR (NUMBERS - 15) ====================
    VocabularyItem(english: "One", uzbek: "Bir", category: "Raqamlar", emoji: "1️⃣", description: "Birinchi son"),
    VocabularyItem(english: "Two", uzbek: "Ikki", category: "Raqamlar", emoji: "2️⃣", description: "Ikkita narsa soni"),
    VocabularyItem(english: "Three", uzbek: "Uch", category: "Raqamlar", emoji: "3️⃣", description: "Uchta son"),
    VocabularyItem(english: "Four", uzbek: "To'rt", category: "Raqamlar", emoji: "4️⃣", description: "To'rt burchak soni"),
    VocabularyItem(english: "Five", uzbek: "Besh", category: "Raqamlar", emoji: "5️⃣", description: "Bir qo'ldagi barmoqlar soni"),
    VocabularyItem(english: "Six", uzbek: "Olti", category: "Raqamlar", emoji: "6️⃣", description: "Oltita son"),
    VocabularyItem(english: "Seven", uzbek: "Yetti", category: "Raqamlar", emoji: "7️⃣", description: "Haftadagi kunlar soni"),
    VocabularyItem(english: "Eight", uzbek: "Sakkiz", category: "Raqamlar", emoji: "8️⃣", description: "Sakkizta son"),
    VocabularyItem(english: "Nine", uzbek: "To'qqiz", category: "Raqamlar", emoji: "9️⃣", description: "To'qqizta son"),
    VocabularyItem(english: "Ten", uzbek: "O'n", category: "Raqamlar", emoji: "🔟", description: "Ikkala qo'ldagi barmoqlar soni"),
    VocabularyItem(english: "Hundred", uzbek: "Yuz", category: "Raqamlar", emoji: "💯", description: "Eng oliy baho va yuz soni"),
    VocabularyItem(english: "First", uzbek: "Birinchi", category: "Raqamlar", emoji: "🥇", description: "G'oliblik o'rni"),
    VocabularyItem(english: "Second", uzbek: "Ikkinchi", category: "Raqamlar", emoji: "🥈", description: "Ikkinchi o'rin"),
    VocabularyItem(english: "Third", uzbek: "Uchinchi", category: "Raqamlar", emoji: "🥉", description: "Uchinchi o'rin"),
    VocabularyItem(english: "Zero", uzbek: "Nol", category: "Raqamlar", emoji: "0️⃣", description: "Boshlanish soni"),

    // ==================== 5. TRANSPORT (VEHICLES - 15) ====================
    VocabularyItem(english: "Car", uzbek: "Mashina", category: "Transport", emoji: "🚗", description: "Yo'llarda yuradigan yengil avtomobil"),
    VocabularyItem(english: "Bus", uzbek: "Avtobus", category: "Transport", emoji: "🚌", description: "Ko'p yo'lovchilarni tashiydigan katta transport"),
    VocabularyItem(english: "Train", uzbek: "Poyezd", category: "Transport", emoji: "🚂", description: "Temir yo'lda yuradigan poyezd"),
    VocabularyItem(english: "Airplane", uzbek: "Samolyot", category: "Transport", emoji: "✈️", description: "Osmonda baland uchadigan havo transporti"),
    VocabularyItem(english: "Helicopter", uzbek: "Vertolyot", category: "Transport", emoji: "🚁", description: "Tepasida parragi bor uchqich"),
    VocabularyItem(english: "Bicycle", uzbek: "Velosiped", category: "Transport", emoji: "🚲", description: "Tepkili ikki g'ildirakli transport"),
    VocabularyItem(english: "Motorcycle", uzbek: "Mototsikl", category: "Transport", emoji: "🏍️", description: "Tez yuradigan motorli ikki g'ildirak"),
    VocabularyItem(english: "Ship", uzbek: "Kema", category: "Transport", emoji: "🚢", description: "Dengiz va ummonda suzadigan katta kema"),
    VocabularyItem(english: "Boat", uzbek: "Qayiq", category: "Transport", emoji: "🚣", description: "Kichik suzish vositasi"),
    VocabularyItem(english: "Rocket", uzbek: "Raketa", category: "Transport", emoji: "🚀", description: "Koinotga uchadigan super tez transport"),
    VocabularyItem(english: "Tractor", uzbek: "Traktor", category: "Transport", emoji: "🚜", description: "Dala ishlarida yordam beradigan texnika"),
    VocabularyItem(english: "Ambulance", uzbek: "Tez Yordam", category: "Transport", emoji: "🚑", description: "Bemorlarni shifoxonaga eltuvchi mashina"),
    VocabularyItem(english: "Fire Truck", uzbek: "O't o'chirish", category: "Transport", emoji: "🚒", description: "Yong'inlarni o'chiruvchi qizil mashina"),
    VocabularyItem(english: "Taxi", uzbek: "Taksi", category: "Transport", emoji: "🚕", description: "Shahar bo'ylab eltuvchi sariq mashina"),
    VocabularyItem(english: "Subway", uzbek: "Metro", category: "Transport", emoji: "🚇", description: "Yer ostida yuradigan tezkor poyezd"),

    // ==================== 6. OILA (FAMILY - 12) ====================
    VocabularyItem(english: "Father", uzbek: "Dada / Ota", category: "Oila", emoji: "👨", description: "Oilamizning suyanchi va mehribon otamiz"),
    VocabularyItem(english: "Mother", uzbek: "Ona / Oyi", category: "Oila", emoji: "👩", description: "Eng mehribon va aziz onajonimiz"),
    VocabularyItem(english: "Brother", uzbek: "Aka / Uka", category: "Oila", emoji: "👦", description: "Oila a'zomiz bo'lgan o'g'il bola qarindosh"),
    VocabularyItem(english: "Sister", uzbek: "Opa / Singil", category: "Oila", emoji: "👧", description: "Oila a'zomiz bo'lgan qiz bola qarindosh"),
    VocabularyItem(english: "Grandfather", uzbek: "Bobo", category: "Oila", emoji: "👴", description: "Dadamiz va onamizning otasi"),
    VocabularyItem(english: "Grandmother", uzbek: "Buvi", category: "Oila", emoji: "👵", description: "Dadamiz va onamizning onasi"),
    VocabularyItem(english: "Baby", uzbek: "Chaqaloq", category: "Oila", emoji: "👶", description: "Kichkina va shirin kichkintoy"),
    VocabularyItem(english: "Family", uzbek: "Oila", category: "Oila", emoji: "👨‍👩‍👧‍👦", description: "Ahil va inoq yashaydigan oilamiz"),
    VocabularyItem(english: "Friend", uzbek: "Do'st", category: "Oila", emoji: "🤝", description: "Birga o'ynaydigan va sirdosh do'st"),
    VocabularyItem(english: "Uncle", uzbek: "Tog'a / Amaki", category: "Oila", emoji: "👨‍💼", description: "Ota yoki onamizning akasi/ukasi"),
    VocabularyItem(english: "Aunt", uzbek: "Xola / Amma", category: "Oila", emoji: "👩‍💼", description: "Ota yoki onamizning opasi/singlisi"),
    VocabularyItem(english: "Child", uzbek: "Farzand / Bola", category: "Oila", emoji: "🧒", description: "Oilaning quvonchi bo'lgan bolajon"),

    // ==================== 7. MAKTAB VA O'QUV QUROLLARI (SCHOOL - 15) ====================
    VocabularyItem(english: "Book", uzbek: "Kitob", category: "Maktab", emoji: "📖", description: "Zukko bolalar o'qiydigan bilim manbai"),
    VocabularyItem(english: "Pencil", uzbek: "Qalam", category: "Maktab", emoji: "✏️", description: "Rasm va harflarni chizadigan o'quv quroli"),
    VocabularyItem(english: "Pen", uzbek: "Ruchka", category: "Maktab", emoji: "🖊️", description: "Daftarga chiroyli yozadigan qurol"),
    VocabularyItem(english: "Ruler", uzbek: "Chizg'ich", category: "Maktab", emoji: "📏", description: "To'g'ri chiziqlar chizuvchi asbob"),
    VocabularyItem(english: "Backpack", uzbek: "Portfel", category: "Maktab", emoji: "🎒", description: "Kitob va daftarlarni soladigan sumka"),
    VocabularyItem(english: "Teacher", uzbek: "O'qituvchi", category: "Maktab", emoji: "👩‍🏫", description: "Bizga bilim beruvchi mehribon ustoz"),
    VocabularyItem(english: "Student", uzbek: "O'quvchi", category: "Maktab", emoji: "🧑‍🎓", description: "Maktabda bilim oladigan bolajon"),
    VocabularyItem(english: "School", uzbek: "Maktab", category: "Maktab", emoji: "🏫", description: "Bilimlar maskani bo'lgan bino"),
    VocabularyItem(english: "Eraser", uzbek: "O'chirg'ich", category: "Maktab", emoji: "🧹", description: "Qalam yozuvini o'chiradigan rezinka"),
    VocabularyItem(english: "Scissors", uzbek: "Qaychi", category: "Maktab", emoji: "✂️", description: "Qog'ozlarni kesuvchi asbob"),
    VocabularyItem(english: "Globe", uzbek: "Globus", category: "Maktab", emoji: "🌐", description: "Yer sharining kichik modeli"),
    VocabularyItem(english: "Computer", uzbek: "Kompyuter", category: "Maktab", emoji: "💻", description: "Zamonaviy bilim va dasturlar qurilmasi"),
    VocabularyItem(english: "Clock", uzbek: "Soat", category: "Maktab", emoji: "⏰", description: "Vaqtni ko'rsatadigan asbob"),
    VocabularyItem(english: "Board", uzbek: "Doshka", category: "Maktab", emoji: "📋", description: "Sinfdagi yozuv doskasi"),
    VocabularyItem(english: "Notebook", uzbek: "Daftar", category: "Maktab", emoji: "📓", description: "Vazifalarni yozadigan daftar"),

    // ==================== 8. TABIAT VA OB-HAVO (NATURE - 15) ====================
    VocabularyItem(english: "Sun", uzbek: "Quyosh", category: "Tabiat", emoji: "☀️", description: "Er yuzini yorituvchi va isituvchi yulduz"),
    VocabularyItem(english: "Moon", uzbek: "Oy", category: "Tabiat", emoji: "🌙", description: "Tungi osmonda porlayotgan yo'ldosh"),
    VocabularyItem(english: "Star", uzbek: "Yulduz", category: "Tabiat", emoji: "⭐", description: "Osmondagi porloq yulduzcha"),
    VocabularyItem(english: "Cloud", uzbek: "Bulut", category: "Tabiat", emoji: "☁️", description: "Osmonda suzib yuruvchi oppoq bulut"),
    VocabularyItem(english: "Rain", uzbek: "Yomg'ir", category: "Tabiat", emoji: "🌧️", description: "Osmondan yog'adigan toza suv tomchilari"),
    VocabularyItem(english: "Snow", uzbek: "Qor", category: "Tabiat", emoji: "❄️", description: "Qishda yog'adigan oppoq va sovuq qor"),
    VocabularyItem(english: "Wind", uzbek: "Shamol", category: "Tabiat", emoji: "🌬️", description: "Esadigan salqin havo oqimi"),
    VocabularyItem(english: "Tree", uzbek: "Daraxt", category: "Tabiat", emoji: "🌳", description: "Toza havo beruvchi yashil daraxt"),
    VocabularyItem(english: "Flower", uzbek: "Gul", category: "Tabiat", emoji: "🌺", description: "Rang-barang va xushbo'y tabiat ne'mati"),
    VocabularyItem(english: "Mountain", uzbek: "Tog'", category: "Tabiat", emoji: "🏔️", description: "Baland va ulkan toshli tog'lar"),
    VocabularyItem(english: "River", uzbek: "Daryo", category: "Tabiat", emoji: "🌊", description: "Shildirab oqadigan toza suv daryosi"),
    VocabularyItem(english: "Sea", uzbek: "Dengiz", category: "Tabiat", emoji: "🏖️", description: "Cheksiz va moviy mo'jizakor dengiz"),
    VocabularyItem(english: "Forest", uzbek: "O'rmon", category: "Tabiat", emoji: "🌲", description: "Daraxtlar va hayvonlar yashaydigan makon"),
    VocabularyItem(english: "Sky", uzbek: "Osmon", category: "Tabiat", emoji: "🌌", description: "Tepaimizdagi musaffo ko'k osmon"),
    VocabularyItem(english: "Garden", uzbek: "Bog'", category: "Tabiat", emoji: "🏡", description: "Mevali daraxtlar va gullar bog'i"),

    // ==================== 9. KIYIMLAR (CLOTHES - 15) ====================
    VocabularyItem(english: "Shirt", uzbek: "Ko'ylak", category: "Kiyimlar", emoji: "👕", description: "Ustga kiyiladigan yengil ko'ylak"),
    VocabularyItem(english: "Pants", uzbek: "Shim", category: "Kiyimlar", emoji: "👖", description: "Oyoqqa kiyiladigan shim"),
    VocabularyItem(english: "Shoes", uzbek: "Oyoq kiyim", category: "Kiyimlar", emoji: "👟", description: "Yurganda oyoqni asraydigan kiyim"),
    VocabularyItem(english: "Hat", uzbek: "Shapka / Shlyapa", category: "Kiyimlar", emoji: "👒", description: "Boshga kiyiladigan shapka"),
    VocabularyItem(english: "Dress", uzbek: "Ko'ylak (qizlar)", category: "Kiyimlar", emoji: "👗", description: "Qiz bolalarning chiroyli ko'ylagi"),
    VocabularyItem(english: "Socks", uzbek: "Paypoq", category: "Kiyimlar", emoji: "🧦", description: "Oyoq kiyim ichidan kiyiladigan paypoq"),
    VocabularyItem(english: "Jacket", uzbek: "Kurtka", category: "Kiyimlar", emoji: "🧥", description: "Qishda va kuzda kiyiladigan issiq kurtka"),
    VocabularyItem(english: "Gloves", uzbek: "Qo'lqop", category: "Kiyimlar", emoji: "🧤", description: "Qo'llarni sovuqdan asraydigan qo'lqop"),
    VocabularyItem(english: "Glasses", uzbek: "Ko'zoynak", category: "Kiyimlar", emoji: "👓", description: "Ko'zlar uchun quyoshdan asrovchi kiyim"),
    VocabularyItem(english: "Crown", uzbek: "Toj", category: "Kiyimlar", emoji: "👑", description: "Qirollar kiyadigan oltin toj"),
    VocabularyItem(english: "Ring", uzbek: "Uzuk", category: "Kiyimlar", emoji: "💍", description: "Barmoqqa kiyiladigan taqinchoq"),
    VocabularyItem(english: "Watch", uzbek: "Qo'l soati", category: "Kiyimlar", emoji: "⌚", description: "Qo'lga taqiladigan soat"),
    VocabularyItem(english: "Boot", uzbek: "Etik", category: "Kiyimlar", emoji: "🥾", description: "Qor va loyda kiyiladigan baland etik"),
    VocabularyItem(english: "Scarf", uzbek: "Sharf", category: "Kiyimlar", emoji: "🧣", description: "Bo'yinga oraladigan issiq sharf"),
    VocabularyItem(english: "Bag", uzbek: "Sumka", category: "Kiyimlar", emoji: "👜", description: "Narsalarni solib yuruvchi sumka"),

    // ==================== 10. OVQATLAR VA MASHG'ULOTLAR (FOOD & FUN - 15) ====================
    VocabularyItem(english: "Water", uzbek: "Suv", category: "Ovqatlar", emoji: "💧", description: "Chanqoqni bosuvchi eng obihayot ne'mat"),
    VocabularyItem(english: "Milk", uzbek: "Sut", category: "Ovqatlar", emoji: "🥛", description: "Suyaklarni mustahkamlovchi oq sut"),
    VocabularyItem(english: "Bread", uzbek: "Non", category: "Ovqatlar", emoji: "🍞", description: "Dasturxonimiz ko'rki bo'lgan muqaddas non"),
    VocabularyItem(english: "Soup", uzbek: "Sho'rva", category: "Ovqatlar", emoji: "🍲", description: "Issiq va mazali suyuq taom"),
    VocabularyItem(english: "Juice", uzbek: "Sharbat", category: "Ovqatlar", emoji: "🧃", description: "Mevalardan tayyorlanadigan shirin sharbat"),
    VocabularyItem(english: "Cake", uzbek: "Tort", category: "Ovqatlar", emoji: "🎂", description: "Tug'ilgan kunda kesiladigan shirinlik"),
    VocabularyItem(english: "Ice Cream", uzbek: "Muzqaymoq", category: "Ovqatlar", emoji: "🍦", description: "Yozda yeyiladigan muzday shirinlik"),
    VocabularyItem(english: "Honey", uzbek: "Bol", category: "Ovqatlar", emoji: "🍯", description: "Arilar yig'adigan eng shirin va shifobaxsh ne'mat"),
    VocabularyItem(english: "Tea", uzbek: "Choy", category: "Ovqatlar", emoji: "🍵", description: "Piyolada ichiladigan issiq choy"),
    VocabularyItem(english: "Ball", uzbek: "Koptok", category: "O'yinchoqlar", emoji: "⚽", description: "Futbol va o'yinlar uchun koptok"),
    VocabularyItem(english: "Doll", uzbek: "Qo'g'irchoq", category: "O'yinchoqlar", emoji: "🧸", description: "Qizbolalarning sevimli o'yinchog'i"),
    VocabularyItem(english: "Robot", uzbek: "Robot", category: "O'yinchoqlar", emoji: "🤖", description: "Aqlli va harakatlanuvchi robot o'yinchoq"),
    VocabularyItem(english: "Kite", uzbek: "Varrak", category: "O'yinchoqlar", emoji: "🪁", description: "Osmonga uchiriladigan shamol varragi"),
    VocabularyItem(english: "Music", uzbek: "Musiqa", category: "O'yinchoqlar", emoji: "🎵", description: "Quvnoq va chiroyli kuy"),
    VocabularyItem(english: "Gift", uzbek: "Sovg'a", category: "O'yinchoqlar", emoji: "🎁", description: "Bayramda beriladigan quvonchli sovg'a"),
  ];

  /// Kategoriyalar ro'yxati
  static List<String> get categories {
    final set = <String>{"Barchasi"};
    for (final item in items) {
      set.add(item.category);
    }
    return set.toList();
  }
}
