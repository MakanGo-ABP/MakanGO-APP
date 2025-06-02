"use client";

import Link from "next/link";
import Image from "next/image";
import { Search, Bell, User } from "lucide-react";
import { useAuth } from "../utils/AuthContext";
import { useRouter } from "next/navigation";

export default function HeaderAuth() {
  const { logOut } = useAuth();
  const router = useRouter();
  const notificationCount = 2;

  const handleLogout = async () => {
    try {
      await logOut();
      router.push("/auth/login");
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };

  return (
    <header className="bg-[#B80A00] shadow-md sticky top-0 z-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 md:h-20">
          {/* Logo */}
          <div className="flex-shrink-0">
            <Link href="/dashboard">
              <Image
                src="/assets/Group-76-1.png"
                alt="MakanGo Logo"
                width={180}
                height={50}
                className="object-contain"
                onError={(e) => {
                  e.currentTarget.src =
                    "https://placehold.co/180x50/B80A00/FFFFFF?text=MakanGo";
                  e.currentTarget.alt = "MakanGo Placeholder Logo";
                }}
              />
            </Link>
          </div>

          {/* Navigation Links - Centered for medium and larger screens */}
          <nav className="hidden md:flex flex-grow items-center justify-center space-x-6 lg:space-x-8 px-4">
            <Link
              href="/dashboard"
              className="text-sm font-medium text-white hover:text-gray-200 transition-colors border-b-2 border-white pb-1"
            >
              Beranda
            </Link>
            <Link
              href="/reviews"
              className="text-sm font-medium text-white hover:text-gray-200 transition-colors"
            >
              Ulasan
            </Link>
            <Link
              href="/places"
              className="text-sm font-medium text-white hover:text-gray-200 transition-colors"
            >
              Daftar Tempat
            </Link>
          </nav>

          {/* Icons - Right side */}
          <div className="flex items-center space-x-3 sm:space-x-4">
            {/* Search Icon */}
            <button
              aria-label="Search"
              className="p-2 text-white hover:bg-red-700 rounded-full transition-colors"
              onClick={() => console.log("Search icon clicked")} // Replace with search functionality
            >
              <Search size={24} />
            </button>

            {/* Notification Icon with Badge */}
            <button
              aria-label="Notifications"
              className="relative p-2 text-white hover:bg-red-700 rounded-full transition-colors"
              onClick={() => console.log("Notification icon clicked")} // Replace with notification logic
            >
              <Bell size={24} />
              {notificationCount > 0 && (
                <span className="absolute top-0 right-0 block h-4 w-4 transform -translate-y-1/2 translate-x-1/2">
                  <span className="absolute inline-flex h-full w-full rounded-full bg-yellow-400 opacity-75 animate-ping"></span>
                  <span className="relative inline-flex rounded-full h-4 w-4 bg-yellow-500 text-red-700 text-xs font-bold items-center justify-center">
                    {notificationCount}
                  </span>
                </span>
              )}
            </button>

            <div className="relative group">
              <button
                aria-label="User Profile"
                className="p-2 text-white hover:bg-red-700 rounded-full transition-colors duration-300"
              >
                <User size={24} />
              </button>

              {/* Dropdown Menu */}
              <div
                className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-10"
                onMouseEnter={() => {}}
                onMouseLeave={() => {}}
              >
                <Link
                  href="/dashboard/profile/detail"
                  className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                >
                  Profil
                </Link>
                <button
                  onClick={handleLogout}
                  className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                >
                  Keluar
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Navigation Links - For smaller screens (mobile) */}
        <div className="md:hidden flex justify-center space-x-4 py-2 border-t border-red-700">
          <Link
            href="/dashboard"
            className="text-sm font-medium text-white hover:text-gray-200 transition-colors"
          >
            Beranda
          </Link>
          <Link
            href="/reviews"
            className="text-sm font-medium text-white hover:text-gray-200 transition-colors"
          >
            Ulasan
          </Link>
          <Link
            href="/places"
            className="text-sm font-medium text-white hover:text-gray-200 transition-colors"
          >
            Daftar Tempat
          </Link>
        </div>
      </div>
    </header>
  );
}
