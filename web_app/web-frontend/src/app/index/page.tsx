import MainLayout from "../components/MainLayout";
import Image from "next/image";
import { MapPin, Star, Edit3 } from "lucide-react";
import Link from "next/link";

function HeroSection() {
  return (
    <section className="relative bg-gradient-to-b from-[#B80A00] to-[#ffffff] text-white py-16 md:py-24 overflow-hidden">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid md:grid-cols-2 gap-8 items-center">
          {/* Left Text Content */}
          <div className="text-center md:text-left">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold mb-4 leading-tight">
              Bingung Mau <br className="hidden sm:block" />
              Makan Apa?
            </h1>
            <p className="text-lg sm:text-xl text-gray-200 mb-8">
              Lihat dulu review-nya di MakanGo! <br />
              Temukan rasa yang cocok, dan tinggalkan jejakmu lewat ulasan.
            </p>
            {/* Location Search */}
            <div className="bg-white p-3 sm:p-4 rounded-lg shadow-lg max-w-lg mx-auto md:mx-0">
              <div className="flex flex-col sm:flex-row items-center gap-2 sm:gap-3">
                <div className="relative w-full sm:flex-grow">
                  <MapPin
                    size={20}
                    className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"
                  />
                  <input
                    type="text"
                    placeholder="Ketik lokasi kamu"
                    className="w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-md text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-red-500"
                  />
                </div>
                <button className="w-full sm:w-auto bg-red-600 hover:bg-red-700 text-white px-6 py-2.5 rounded-md text-sm font-medium transition-colors whitespace-nowrap">
                  Jelajahi
                </button>
              </div>
            </div>
          </div>
          {/* Right Image Content */}
          <div className="hidden md:flex justify-center items-center">
            <Image
              src="/assets/Group8491-1.png"
              alt="Kuliner lezat"
              width={550}
              height={550}
              className="object-contain"
              priority
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function KulinerCategoriesSection() {
  const categories = [
    { name: "Terdekat", icon: "/assets/kategori_terdekat.png" },
    { name: "Nusantara", icon: "/assets/kategori_nusantara.png" },
    { name: "Bakmie", icon: "/assets/kategori_bakmie.png" },
    { name: "Jepanese", icon: "/assets/kategori_japanese.png" },
    { name: "Chinese", icon: "/assets/kategori_chinese.png" },
    { name: "Jajanan", icon: "/assets/kategori_jajanan.png" },
    { name: "Minuman", icon: "/assets/kategori_minuman.png" },
    { name: "Sarapan", icon: "/assets/kategori_sarapan.png" },
    { name: "Penutup", icon: "/assets/kategori_sweets.png" },
    { name: "Cepat saji", icon: "/assets/kategori_cepatsaji.png" },
    { name: "Seafood", icon: "/assets/kategori_seafoods.png" },
    { name: "Makanan sehat", icon: "/assets/kategori_makanansehat.png" },
  ];
  return (
    <section className="py-12 md:py-16 bg-gray-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-3xl font-bold text-center text-gray-800 mb-10 md:mb-12">
          Aneka Kuliner Menarik
        </h2>
        <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 gap-4 md:gap-6">
          {categories.map((category) => (
            <Link
              key={category.name}
              href={`/category/${category.name.toLowerCase()}`}
              legacyBehavior
            >
              <a className="flex flex-col items-center p-3 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow text-center">
                <Image
                  src={category.icon}
                  alt={category.name}
                  width={64}
                  height={64}
                  className="object-contain mb-2"
                />
                <span className="text-sm font-medium text-gray-700">
                  {category.name}
                </span>
              </a>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

function PopularPlacesSection() {
  const places = Array(8).fill({
    name: "McDonald's - Podomoro Park",
    rating: 4.8,
    reviews: 103,
    hours: "00:00 - 23:59",
    category: "Cepat saji",
    image: "/assets/restaurants/mcd.jpg",
  });
  return (
    <section className="py-12 md:py-16 bg-white">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-3xl font-bold text-center text-gray-800 mb-3">
          Apa Saja Tempat Populer Terdekat?
        </h2>
        <p className="text-center text-gray-600 mb-10 md:mb-12">
          Temukan koleksi hidangan populer, favorit lokal, dan penawaran terbaik
          di lingkungan Anda.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8">
          {places.map((place, index) => (
            <div
              key={index}
              className="bg-white rounded-xl shadow-lg overflow-hidden flex flex-col"
            >
              <Image
                src={place.image}
                alt={place.name}
                width={400}
                height={200}
                className="w-full h-40 object-cover"
              />
              <div className="p-4 flex flex-col flex-grow">
                <div className="flex items-center justify-between mb-1">
                  <span className="inline-flex items-center bg-yellow-400 text-white text-xs font-semibold px-2 py-0.5 rounded">
                    <Star size={12} className="mr-1 fill-current" />{" "}
                    {place.rating}
                  </span>
                  <span className="text-xs text-gray-500">
                    {place.reviews} Reviews
                  </span>
                </div>
                <h3 className="text-md font-semibold text-gray-800 mb-1 truncate">
                  {place.name}
                </h3>
                <p className="text-xs text-gray-500 mb-1">{place.hours}</p>
                <p className="text-xs text-gray-500 mb-3">{place.category}</p>
                <button className="mt-auto w-full bg-red-100 text-red-700 hover:bg-red-200 px-4 py-2 rounded-md text-xs font-medium transition-colors flex items-center justify-center">
                  <Edit3 size={14} className="mr-1.5" /> Tambah ulasan
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function WhyMakanGoSection() {
  const features = [
    {
      title: "Menemukan Tempat Makan",
      description:
        "Putuskan pilihan Anda dengan melihat apa yang dikatakan orang lain tentang restoran tersebut.",
      icon: "/assets/fitur-1.png",
    },
    {
      title: "Mengulas & Dapatkan XP",
      description:
        "Bagikan pemikiran Anda dan dapatkan XP untuk setiap ulasan. Berbagi berarti peduli!",
      icon: "/assets/fitur-2.png",
    },
    {
      title: "Naik Level, Dapatkan Keuntungan!",
      description: "Naik level untuk membuka hadiah dan fasilitas khusus.",
      icon: "/assets/fitur-3.png",
    },
  ];
  return (
    <section className="py-12 md:py-16 bg-gray-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-3xl font-bold text-center text-gray-800 mb-10 md:mb-12">
          Mengapa Menggunakan MakanGo?
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 md:gap-8">
          {features.map((feature) => (
            <div
              key={feature.title}
              className="bg-[#B80A00] text-white p-4 rounded-xl shadow-lg text-center flex flex-col items-center"
            >
              <Image
                src={feature.icon}
                alt={feature.title}
                width={400}
                height={300}
                className="object-contain mb-4"
              />
              <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
              <p className="text-sm text-gray-200 leading-relaxed">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default function HomePage() {
  return (
    <MainLayout
      title="MakanGo - Review Makanan & Restoran"
      description="Cari review makanan, restoran, kuliner populer dan menarik di MakanGo."
    >
      <HeroSection />
      <KulinerCategoriesSection />
      <PopularPlacesSection />
      <WhyMakanGoSection />
      {/* Add more sections here as needed */}
    </MainLayout>
  );
}
