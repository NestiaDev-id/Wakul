class Toko {
  String name;
  String description;
  String address;
  List<String> imageAsset;
  List<String> imageUrls;

  Toko({
    required this.name,
    required this.description,
    required this.address,
    required this.imageAsset,
    required this.imageUrls,
  });
}

var tokoList = [
  Toko(
    name: 'Pizza House',
    address: 'Yogyakarta',
    description:
        'Selamat datang di Pizza House, destinasi kuliner terbaik bagi para pencinta pizza di Yogyakarta! Terletak di jantung kota Yogyakarta, Pizza House adalah tempat yang sempurna untuk menikmati beragam pizza lezat dan hidangan Italia lainnya.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-asia',
    ],
  ),
  Toko(
    name: 'Madhang Medan',
    address: 'Medan',
    description:
        'Selamat datang di Madhang Medan, destinasi kuliner yang memukau di tengah kota Medan. Kami mengundang Anda untuk mengeksplorasi kelezatan hidangan khas Medan yang otentik dan memikat yang tersedia di restoran kami.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-eropa',
    ],
  ),
  Toko(
    name: 'Warung Bambu',
    address: ' Ubud, Bali',
    description:
        'Nikmati kelezatan hidangan tradisional Bali di Warung Bambu di Ubud, Bali. Warung ini memadukan rasa autentik dengan suasana yang tenang. Sajikan diri Anda dengan nasi campur, ayam betutu, dan hidangan lezat lainnya, sambil menikmati pemandangan hijau alami Ubud.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-australia',
    ],
  ),
  Toko(
    name: 'Seafood Paradise',
    address: 'Jimbaran, Bali',
    description:
        'Seafood Paradise di Jimbaran, Bali, adalah surga bagi pecinta makanan laut. Alami hidangan laut segar seperti ikan bakar, udang saus mentega, dan kerang bakar dengan pemandangan matahari terbenam di pantai Jimbaran.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-amerika',
    ],
  ),
  Toko(
    name: 'Sederhana Padang',
    address: 'Jakarta',
    description:
        'Sederhana Padang di Jakarta adalah tempat terbaik untuk mencicipi hidangan Padang yang kaya rasa. Nikmati rendang, sate Padang, dan gulai otak di restoran ini. Hidangan disajikan dalam gaya Padang yang khas.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-afrika',
    ],
  ),
  Toko(
    name: 'Teras Padi',
    address: 'Yogyakarta',
    description:
        'Teras Padi adalah restoran eksotis di Yogyakarta yang menawarkan hidangan khas Indonesia dan internasional. Nikmati hidangan seperti bebek goreng, sate kuda, dan mie ayam di tengah suasana yang asri dengan sawah sebagai latar belakang.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-antartika',
    ],
  ),
  Toko(
    name: 'Sari Rasa',
    address: 'Bandung',
    description:
        'Sari Rasa di Bandung menghadirkan hidangan Indonesia yang lezat dan beragam. Cobalah nasi timbel, soto Bandung, dan makanan tradisional lainnya. Restoran ini menggabungkan cita rasa otentik dengan pelayanan yang ramah.',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?restaurant-from-indonesia',
    ],
  ),
];
