import Link from "next/link";
import Image from "next/image"; // Assuming you have a logo image
import { Search } from "lucide-react"; // Icons

export default function Header() {
  return (
    <header className="bg-[#B80A00] shadow-md sticky top-0 z-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 md:h-20">
          {/* Logo */}
          <div className="flex-shrink-0">
            <Link href="/" legacyBehavior>
              <a className="flex items-center">
                <Image
                  src="/assets/Group-76-1.png"
                  alt="MakanGo Logo"
                  width={120}
                  height={35}
                  className="object-contain"
                />
              </a>
            </Link>
          </div>
          <div className="hidden md:flex flex-grow items-center justify-center px-4 lg:px-8">
            <div className="relative w-full max-w-lg">
              <input
                type="search"
                placeholder="Cari Makanan, Restoran, dll."
                className="w-full pl-5 pr-12 py-2.5 border  bg-white border-gray-300 rounded-full text-sm text-black focus:ring-2 focus:ring-red-500 focus:border-red-500 outline-none"
              />
              <button className="absolute right-0 top-0 bottom-0 bg-red-600 hover:bg-red-700 text-white px-4 rounded-r-full flex items-center justify-center">
                <Search size={20} />
              </button>
            </div>
          </div>

          <div className="flex items-center space-x-2 sm:space-x-3">
            <Link href="/auth/login" legacyBehavior>
              <a className="px-3 sm:px-4 py-2 text-sm font-medium border-b-white text-white hover:text-red-600 transition-colors">
                Masuk
              </a>
            </Link>
            <Link href="/auth/register" legacyBehavior>
              <a className="px-3 sm:px-4 py-2 text-sm font-medium text-white bg-red-600 hover:bg-red-700 rounded-full transition-colors">
                Register
              </a>
            </Link>
          </div>
        </div>
        {/* Search Bar - For smaller screens (mobile) */}
        <div className="md:hidden pb-3 px-1">
          <div className="relative w-full">
            <input
              type="search"
              placeholder="Cari Makanan..."
              className="w-full pl-5 pr-12 py-2.5 border border-gray-300 rounded-full text-sm text-gray-700 focus:ring-2 focus:ring-red-500 focus:border-red-500 outline-none"
            />
            <button className="absolute right-0 top-0 bottom-0 bg-red-600 hover:bg-red-700 text-white px-4 rounded-r-full flex items-center justify-center">
              <Search size={20} />
            </button>
          </div>
        </div>
      </div>
    </header>
  );
}
