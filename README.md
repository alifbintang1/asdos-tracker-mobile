# Tugas 8
## Perbedaan Navigator.push() dan Navigator.pushReplacement()
__Navigator.push()__: Digunakan untuk menambahkan halaman baru ke dalam tumpukan halaman (page stack). Misalnya, jika kita memiliki tumpukan halaman A -> B, dan menggunakan Navigator.push() dari halaman B, maka halaman C ditambahkan ke tumpukan, sehingga tumpukan menjadi A -> B -> C. Contohnya dipakai ketika ingin dari page Homepage ke page LihatDaftarItem, maka logikanya kita bisa back ke page Homepage lagi.

Contohnya:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => HalamanBaru()),
);
```

__Navigator.pushReplacement()__: Digunakan ketika kita ingin menggantikan halaman saat ini dengan halaman baru. Misalnya, jika kita berada di halaman A -> B, dan menggunakan Navigator.pushReplacement() dari halaman B, maka halaman B akan digantikan dengan halaman C, sehingga tumpukan menjadi A -> C. Contohnya dipakai ketika ingin dari page Login ke page Homepage (logikanya kita tidak bisa kembali ke page login dengan tombol back).

Contohnya:
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HalamanBaru()),
);
```

## Layout Widget
Beberapa widget layout umum dalam Flutter memiliki fungsi-fungsi khusus, antara lain:

### Container
Berfungsi sebagai wadah untuk menyimpan widget lainnya dan memberikan properti seperti padding, margin, dan sebagainya.

### Row dan Column
Berperan dalam menyusun widget secara horizontal (Row) atau vertikal (Column), memungkinkan penataan yang fleksibel.

### Stack
Mengizinkan penumpukan widget di atas satu sama lain, memungkinkan pembuatan tumpukan yang kompleks dari elemen-elemen UI.

### ListView dan GridView
Berperan dalam menampilkan daftar atau grid widget, memfasilitasi tampilan yang terorganisir untuk data yang dinamis.

### Scaffold
Berfungsi sebagai struktur utama suatu halaman, menyediakan kerangka kerja dengan komponen-komponen seperti AppBar, Body, dan lainnya, untuk mempermudah pembuatan tata letak halaman yang lengkap.

## Elemen Input
Dalam tugas formulir ini, kita hanya menggunakan kolom input `TextFormField`. Widget input `TextFormField` pada Flutter difungsikan untuk menerima masukan teks dari pengguna. Widget ini merupakan bagian dari widget Form yang mempermudah validasi, penyimpanan nilai, dan manajemen keadaan (state management) formulir.

Berikut adalah beberapa alasan penggunaan TextFormField secara ringkas:

1. Validasi Otomatis
TextFormField menyajikan properti seperti validator yang memungkinkan kita menetapkan aturan validasi secara otomatis. Hal ini membantu memastikan bahwa data yang dimasukkan sesuai dengan persyaratan yang diinginkan.

2. Kontrol Keadaan
Dengan menggunakan TextFormField, Flutter secara otomatis mengelola keadaan (state) input. Ini mempermudah dalam mendapatkan atau mengatur nilai input.

3. Penanganan Perubahan
Perubahan nilai input dapat diatasi dengan mudah menggunakan properti onChanged, yang memungkinkan kita untuk menjalankan tindakan tertentu setiap kali nilai berubah.

Dengan memanfaatkan TextFormField, Flutter memberikan cara efektif untuk mengelola masukan teks dalam formulir dengan dukungan pengelolaan keadaan yang sederhana dan validasi bawaan.

## Clean Architecture pada Aplikasi Flutter
Clean architecture pada Flutter melibatkan pembagian aplikasi menjadi tiga lapisan utama: Presentation, Domain, dan Data. Flutter menggunakan konsep ini untuk memisahkan logika bisnis dari tampilan dan akses data. Presenter (presentation layer) bertanggung jawab untuk berkomunikasi dengan use case (domain layer), yang kemudian berinteraksi dengan repository (data layer) untuk mendapatkan atau menyimpan data.

## Implementasi
### 1. Membuat Drawer
Dengan kode ini, kita menampilkan drawer di sebelah kiri page dengan isi header dan list bar yang dituliskan.
```dart
import 'package:flutter/material.dart';
import 'package:asdos_tracker_mobile/screens/add_item_form.dart';
import 'package:asdos_tracker_mobile/screens/item_list_page.dart';
import 'package:asdos_tracker_mobile/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                Text(
                  "Asdos Tracker",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Tambahkan log asdos di sini!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),

            //Ketika diklik akan ke homepage
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text("Tambah Item"),

            // ketika diklik akan ke forms add_item
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddItemForm()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Lihat Item"),

            // ketika diklik akan ke list item
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ItemListPage()));
            },
          ),
        ],
      ),
    );
  }
}
```

### 2. Membuat Form Page Add Item
Dengan kode ini, kita dapat menampilkan input form (TextFormField) dan tombol save untuk menampilkan pop up form yang diisi dan penanda validator juga.
```dart
import 'package:flutter/material.dart';
import 'package:asdos_tracker_mobile/screens/item_list_page.dart';
import 'package:asdos_tracker_mobile/screens/menu.dart';
import 'package:asdos_tracker_mobile/widgets/left_drawer.dart';
import 'package:asdos_tracker_mobile/model/Item.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemState();
}

class _AddItemState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _amount = 0;
  String _description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TAMBAH ITEM",
          ),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      // tempat drawer
      drawer: const LeftDrawer(),

      //nampilin body page
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Nama Matkul",
                      labelText: "Nama Matkul",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  // isi dari formnya
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Lama Waktu",
                    labelText: "Lama Waktu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),

                  // ketika disi formnya, variabelnya akan selalu diisi
                  onChanged: (String? value) {
                    setState(() {
                      _amount = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Jumlah item tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Jumlah item harus berupa integer!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black87),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //masukin item ke listitem
                        Item isi = Item(_name, _amount, _description);
                        Item.listItem.add(isi);
                        // print(Item.listItem);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Item Berhasil Disimpan!"),
                                content: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Nama: $_name'),
                                        Text('Jumlah Item: $_amount'),
                                        Text('Deskripsi: $_description'),
                                      ]),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                        _formKey.currentState!.reset();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3. Menambahkan button untuk menampilkan drawer
Di `menu.dart` kita menambahkan drawer dalam widget Scaffold (di sebelah kiri app bar).
```dart
...
return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Asdos Tracker',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(), // Tambahkan drawer
...
```

### 4. Memberikan fungsionalitas dari button tambah Item
Dengan kode diatas kita dari Navigator.push berarti ketika tombol Tambah Item di tekan maka akan menampilam AddItem Form Page.
```dart
...
 Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Tambah Item") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddItemForm()));
          }
        },
...
```

### 5. BONUS
1. Membuat model Item beserta list Itemnya di `Item.dart`
2. Menambahkan Objek dari Item di form nya ke list Itemnya
3. Membuat tampilan data nya di `item_list_page.dart` dari itemlist yang ada di class model-nya.
```dart
import 'package:flutter/material.dart';
import 'package:asdos_tracker_mobile/model/Item.dart'; // Pastikan import model item
import 'package:asdos_tracker_mobile/widgets/left_drawer.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: Item.listItem.length,
        itemBuilder: (context, index) {
          Item currentItem = Item.listItem[index];
          return ListTile(
            title: Text(currentItem.name),
            subtitle: Text(
                'Jumlah: ${currentItem.amount}\nDeskripsi: ${currentItem.description}'),
            isThreeLine: true,
            onTap: () {
              // Implementasi logika untuk menangani ketika item di-tap
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Detail Item'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${currentItem.name}'),
                          Text('Jumlah Item: ${currentItem.amount}'),
                          Text('Deskripsi: ${currentItem.description}'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tutup'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```
Lalu, kita juga perlu menambahkan navigator push di button 'Lihat Item'.
```dart
...
else if (item.name == "Lihat Item") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ItemListPage()));
          }
...
```

# Tugas 7
## Perbedaan Stateless dan Stateful Widget
Dalam pengembangan aplikasi Flutter, perbedaan utama antara stateless widget dan stateful widget adalah cara mereka mengelola perubahan data dan perilaku komponen UI. Berikut adalah perbedaan utama antara keduanya:

Stateless widget adalah komponen UI yang tidak memiliki keadaan internal (state). Ini berarti bahwa setelah dibuat, widget ini tidak dapat berubah atau diperbarui.
Stateless widget berguna ketika kita memiliki elemen UI yang tidak memerlukan perubahan atau interaksi selama siklus hidup aplikasi.
Contoh penggunaan stateless widget termasuk teks statis, ikon, gambar, atau elemen UI yang tidak perlu berubah sepanjang waktu.

Stateful widget adalah komponen UI yang dapat memiliki keadaan internal (state) yang dapat berubah selama siklus hidup aplikasi. Keadaan ini dapat berisi data atau informasi yang diperlukan untuk mengubah tampilan atau perilaku widget.
Stateful widget berguna ketika kita perlu mengganti tampilan atau perilaku komponen UI berdasarkan perubahan data atau input pengguna.
Untuk mengelola keadaan dalam stateful widget, kita perlu menggunakan objek "State" yang terkait dengan widget tersebut. Objek State ini dapat diubah selama aplikasi berjalan, dan perubahan ini akan memicu pembaruan tampilan widget.

## Widget-Widget di Tugas Ini dan Fungsinya
1. `MaterialApp`: Widget utama yang digunakan untuk menginisialisasi aplikasi. Biasanya merupakan parent utama dari widget kita. Biasanya digunakan untuk mengatur tema dan color palette dari applikasi kita..

2. `Scaffold`: Scaffold adalah template dasar yang digunakan untuk membuat tampilan seperti applikasi pada umumnya. Scaffold memiliki parameter `appbar`, dan `drawer` sebagai navigasi utama pada applikasi kita.

3. `AppBar`: Widget yang digunakan untuk membuat AppBar (Panel yang ada di atas applikasi).

4. `SingleChildScrollView`: Widget yang memungkinkan childnya dapat discroll. Digunakan untuk membungkus konten utama.

5. `Padding`: Digunakan untuk memberikan padding pada childnya.

6. `Column`: Widget yang menampilkan elemen-elemen secara vertikal, child dari widget ini adalah list of widget / kumpulan dari widget yang akan disusun secara vertikal.

7. `Text`: Widget untuk menampilkan teks. Dapat pula diatur font, warna, dan styling text disini.

8. `Center`: Digunakan untuk mengatur childnya pada posisi ke tengah secara horizontal dan vertikal.

9. `GridView.count`: Digunakan untuk membuat grid layout dengan jumlah kolom yang diberikan.

10. `InkWell`: Digunakan untuk memberikan efek sentuhan. Ini memungkinkan untuk menangani interaksi pengguna. Biasanya diterapkan pada button.

11. `Icon`: Digunakan untuk menampilkan ikon.

12. `SnackBar`: Ini adalah widget yang digunakan untuk menampilkan pesan singkat di bagian bawah layar.

## Implementasi
### 1. Membuat Proyek Flutter Baru
```sh
flutter create trading_inventory_mobile
```

### 2. Membuat File `menu.dart`
Kita perlu memodifikasi `main.dart` agar dapat mereturn widget yang ada di `menu.dart`
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
```

### 3. Memodifikasi File `menu.dart`
Kita sekarang tinggal perlu menyusun apa yang mau ditampilkan di `menu.dart`.
```dart
import 'package:flutter/material.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final Color color;

  ShopItem(this.name, this.icon, this.color);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final List<ShopItem> items = [
    ShopItem("Lihat Produk", Icons.checklist, const Color(0xFF1A46BD)),
    ShopItem("Tambah Produk", Icons.add_shopping_cart, const Color(0xFF0F286B)),
    ShopItem("Logout", Icons.logout, const Color(0xFF091840)),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping List',
        ),
      ),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'PBP Shop', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ShopItem item) {
                  // Iterasi untuk setiap item
                  return ShopCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```