// Script to seed coffee collection in Firebase Firestore using REST API
const apiKey = 'AIzaSyCA3VjHchNxwiXdt8mDqTaLyDY-P6mjQy8';
const projectId = 'fir-learning-e0772';
const baseUrl = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/coffees?key=${apiKey}`;

const coffees = [
  {
    id: 'caramel_macchiato',
    name: 'Caramel Macchiato',
    category: 'Machiato',
    subtitle: 'With Salted Drizzle',
    description: 'Freshly steamed milk with vanilla-flavored syrup marked with espresso and topped with a decadent caramel drizzle for a sweet finish.',
    price: 4.53,
    rating: 4.9,
    reviewCount: 420,
    image: 'assets/images/img_cappuccino_1.png',
    roastLevel: 'Arabica Blend',
    isPopular: true,
    sizes: ['S', 'M', 'L'],
    sizePriceOffsets: { S: -0.40, M: 0.0, L: 0.60 },
    stock: 50,
    calories: 210,
    createdAt: new Date().toISOString()
  },
  {
    id: 'classic_cappuccino',
    name: 'Classic Cappuccino',
    category: 'Cappuccino',
    subtitle: 'Velvety Thick Foam',
    description: 'Dark, rich espresso lies in wait under a smoothed and stretched layer of thick milk foam. An artisanal classic crafted by our master baristas.',
    price: 4.20,
    rating: 4.8,
    reviewCount: 382,
    image: 'assets/images/img_cappuccino_2.png',
    roastLevel: 'Dark Roast',
    isPopular: true,
    sizes: ['S', 'M', 'L'],
    sizePriceOffsets: { S: -0.40, M: 0.0, L: 0.60 },
    stock: 45,
    calories: 140,
    createdAt: new Date().toISOString()
  },
  {
    id: 'caffe_latte',
    name: 'Caffe Latte',
    category: 'Latte',
    subtitle: 'Delicate Micro-foam',
    description: 'Our dark, rich espresso balanced with steamed milk and a light layer of foam. A perfect, soothing morning companion with smooth notes.',
    price: 4.10,
    rating: 4.7,
    reviewCount: 295,
    image: 'assets/images/img_cappuccino_3.png',
    roastLevel: 'Medium Roast',
    isPopular: true,
    sizes: ['S', 'M', 'L'],
    sizePriceOffsets: { S: -0.40, M: 0.0, L: 0.60 },
    stock: 60,
    calories: 190,
    createdAt: new Date().toISOString()
  },
  {
    id: 'double_espresso',
    name: 'Double Espresso',
    category: 'Espresso',
    subtitle: 'Pure Italian Crema',
    description: 'Two full shots of our signature deep roast espresso. Intense, aromatic, and crowned with a thick golden-hazel crema.',
    price: 3.50,
    rating: 4.9,
    reviewCount: 198,
    image: 'assets/images/img_cappuccino_4.png',
    roastLevel: 'Single Origin',
    isPopular: false,
    sizes: ['S', 'M'],
    sizePriceOffsets: { S: -0.30, M: 0.0 },
    stock: 80,
    calories: 10,
    createdAt: new Date().toISOString()
  },
  {
    id: 'choco_mocha',
    name: 'Choco Mocha',
    category: 'Latte',
    subtitle: 'Bittersweet Cocoa',
    description: 'Espresso with chocolate sauce, creamy steamed milk, and whipped chocolate froth on top. Rich, velvety, and deeply satisfying.',
    price: 4.80,
    rating: 4.8,
    reviewCount: 512,
    image: 'assets/images/img_cappuccino_5.png',
    roastLevel: 'Dark Cocoa Blend',
    isPopular: true,
    sizes: ['S', 'M', 'L'],
    sizePriceOffsets: { S: -0.40, M: 0.0, L: 0.60 },
    stock: 35,
    calories: 320,
    createdAt: new Date().toISOString()
  },
  {
    id: 'flat_white',
    name: 'Flat White',
    category: 'Cappuccino',
    subtitle: 'Silky Velvety Milk',
    description: 'Smooth ristretto shots of espresso paired with the ideal amount of steamed whole milk for an expertly crafted, bold beverage.',
    price: 4.40,
    rating: 4.8,
    reviewCount: 230,
    image: 'assets/images/img_cappuccino_6.png',
    roastLevel: 'Medium Roast',
    isPopular: false,
    sizes: ['S', 'M', 'L'],
    sizePriceOffsets: { S: -0.40, M: 0.0, L: 0.60 },
    stock: 40,
    calories: 160,
    createdAt: new Date().toISOString()
  },
  {
    id: 'cold_brew',
    name: 'Cold Brew Reserve',
    category: 'Cold Brew',
    subtitle: '20hr Slow Steeped',
    description: 'Handcrafted in small batches daily, slow-steeped in cool filtered water for 20 hours, with a smooth, naturally sweet profile.',
    price: 4.75,
    rating: 4.9,
    reviewCount: 340,
    image: 'assets/images/img_cappuccino_1.png',
    roastLevel: 'Cold Extraction',
    isPopular: true,
    sizes: ['M', 'L'],
    sizePriceOffsets: { M: 0.0, L: 0.60 },
    stock: 55,
    calories: 15,
    createdAt: new Date().toISOString()
  },
  {
    id: 'french_croissant',
    name: 'Butter Croissant',
    category: 'Bakery',
    subtitle: 'Bakery Special',
    description: 'Classic French pastry made with 100% pure Normandy butter, baked fresh every morning until flaky, golden, and heavenly.',
    price: 3.25,
    rating: 4.7,
    reviewCount: 165,
    image: 'assets/images/img_cappuccino_2.png',
    roastLevel: 'Artisan Bakery',
    isPopular: false,
    sizes: ['Single', 'Pair (+1.80)'],
    sizePriceOffsets: { Single: 0.0, 'Pair (+1.80)': 1.80 },
    stock: 25,
    calories: 260,
    createdAt: new Date().toISOString()
  }
];

function toFirestoreFields(obj) {
  const fields = {};
  for (const [key, val] of Object.entries(obj)) {
    if (typeof val === 'string') {
      fields[key] = { stringValue: val };
    } else if (typeof val === 'number') {
      if (Number.isInteger(val)) {
        fields[key] = { integerValue: val.toString() };
      } else {
        fields[key] = { doubleValue: val };
      }
    } else if (typeof val === 'boolean') {
      fields[key] = { booleanValue: val };
    } else if (Array.isArray(val)) {
      fields[key] = {
        arrayValue: {
          values: val.map(item => ({ stringValue: String(item) }))
        }
      };
    } else if (val && typeof val === 'object') {
      const mapFields = {};
      for (const [mk, mv] of Object.entries(val)) {
        mapFields[mk] = typeof mv === 'number'
          ? (Number.isInteger(mv) ? { integerValue: mv.toString() } : { doubleValue: mv })
          : { stringValue: String(mv) };
      }
      fields[key] = {
        mapValue: {
          fields: mapFields
        }
      };
    }
  }
  return fields;
}

async function seed() {
  console.log(`Starting to seed ${coffees.length} documents into Firestore...`);
  for (const coffee of coffees) {
    const docId = coffee.id;
    const url = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/coffees/${docId}?key=${apiKey}`;
    const body = {
      fields: toFirestoreFields(coffee)
    };

    const res = await fetch(url, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });

    if (res.ok) {
      console.log(`Successfully stored document: ${docId}`);
    } else {
      const errorText = await res.text();
      console.error(`Failed to store ${docId}:`, errorText);
    }
  }
  console.log('Seeding completed!');
}

seed().catch(console.error);
