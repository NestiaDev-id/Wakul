import 'package:cloud_firestore/cloud_firestore.dart';

class Makanan {
  String name;
  int price;
  String description;
  int sold;
  List<String> imageAsset;
  List<String> imageUrls;

  Makanan({
    required this.name,
    required this.price,
    required this.description,
    required this.sold,
    required this.imageAsset,
    required this.imageUrls,
  });
  Makanan.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'] ?? '',
        price = snapshot['price'] ?? 0,
        description = snapshot['description'] ?? '',
        sold = snapshot['sold'] ?? 0,
        imageUrls = List<String>.from(snapshot['imageUrls'] ?? []),
        imageAsset = List<String>.from(snapshot['imageAsset'] ?? []);
}

var makananlaceList = [
  Makanan(
    name: 'Rendang',
    price: 12000,
    description:
        'Nikmati hidangan tradisional Indonesia yang kaya akan rempah-rempah. Rendang adalah masakan daging sapi yang dimasak dalam santan dan bumbu rempah khas, yang menghasilkan rasa yang lezat dan gurih.',
    sold: 31,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-asia',
    ],
  ),
  Makanan(
    name: 'Sup Nanas',
    price: 30000,
    description:
        'Sup Nanas adalah hidangan segar yang sempurna untuk memulai hidangan Anda. Sup ini menyajikan cita rasa manis dan asam dari nanas, dengan tekstur lembut yang meleleh di mulut.',
    sold: 18,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-eropa',
    ],
  ),
  Makanan(
    name: 'Nanas',
    price: 30000,
    description:
        'Nanas segar adalah camilan ringan yang nikmat di cuaca panas. Anda dapat menikmati potongan nanas yang manis dan menyegarkan',
    sold: 29,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-afrika',
    ],
  ),
  Makanan(
    name: 'Markisa',
    price: 10000,
    description:
        '"Markisa adalah buah yang lezat dan menyegarkan yang bisa menjadi pencuci mulut yang sempurna.',
    sold: 11,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-amerika',
    ],
  ),
  Makanan(
    name: 'Rendang',
    price: 12000,
    description:
        'Nikmati hidangan tradisional Indonesia yang kaya akan rempah-rempah. Rendang adalah masakan daging sapi yang dimasak dalam santan dan bumbu rempah khas, yang menghasilkan rasa yang lezat dan gurih.',
    sold: 353,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-asia',
    ],
  ),
  Makanan(
    name: 'Sup Nanas',
    price: 30000,
    description:
        'Sup Nanas adalah hidangan segar yang sempurna untuk memulai hidangan Anda. Sup ini menyajikan cita rasa manis dan asam dari nanas, dengan tekstur lembut yang meleleh di mulut.',
    sold: 311,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-eropa',
    ],
  ),
  Makanan(
    name: 'Nanas',
    price: 30000,
    description:
        'Nanas segar adalah camilan ringan yang nikmat di cuaca panas. Anda dapat menikmati potongan nanas yang manis dan menyegarkan',
    sold: 221,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-afrika',
    ],
  ),
  Makanan(
    name: 'Markisa',
    price: 10000,
    description:
        '"Markisa adalah buah yang lezat dan menyegarkan yang bisa menjadi pencuci mulut yang sempurna.',
    sold: 334,
    imageAsset: [
      'images/banner3 1.png',
      'images/banner3 2.png',
      'images/banner3 3.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food-from-amerika',
    ],
  ),
];
