"use client";

import AuthLayout from "../../components/AuthLayout";
import Image from "next/image";
import Link from "next/link";
import { FormEvent, useState } from "react";
import { Mail } from "lucide-react";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState<string | null>(null);

  const handleLogin = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!email.trim()) {
      setError("Email is required");
      return;
    }
    console.log("Logging in with email:", email);
    // Add your login logic here
    // Example: setError("Login failed") to test error display
  };

  const handleGoogleLogin = () => {
    console.log("Logging in with Google");
    // Add your Google login logic here
  };

  return (
    <AuthLayout>
      <div className="flex justify-start items-center mb-6">
        <Image
          src="/assets/Group76.png"
          alt="MakanGo Logo"
          width={100}
          height={30}
          className="object-contain"
        />
      </div>
      <h3 className="text-2xl text-left text-gray-800 font-bold mb-1">
        Hi! Selamat datang di MakanGo
      </h3>
      <p className="text-gray-600 mb-6 text-left text-sm">
        Masukkan email anda untuk menggunakan aplikasi
      </p>

      {error && <p className="text-red-500 text-sm mb-4 text-left">{error}</p>}

      <form onSubmit={handleLogin} className="w-full space-y-4">
        <div>
          <label className="block text-gray-700 text-sm font-medium mb-1">
            Akun Email Anda <span className="text-red-600">*</span>{" "}
          </label>
          <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-red-500 focus-within:border-red-500">
            <Mail className="mr-2 text-gray-400" />
            <input
              type="text"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Masukkan Email Anda"
              className="w-full outline-none text-gray-800 placeholder-gray-400 text-sm"
              required
            />
          </div>
        </div>
        <button
          type="submit"
          className="w-full bg-red-600 text-white py-2.5 rounded-lg hover:bg-red-700 transition duration-150 font-medium text-sm"
        >
          Kirim
        </button>
      </form>

      <p className="mt-6 text-gray-600 text-center text-sm">
        Anda tidak memiliki akun?{" "}
        <Link
          href="/auth/register"
          className="text-red-600 hover:underline font-medium"
        >
          Register
        </Link>
      </p>
      <div className="my-6 flex items-center">
        <hr className="flex-grow border-t border-gray-300" />
        <span className="mx-3 text-gray-500 text-sm">Atau</span>
        <hr className="flex-grow border-t border-gray-300" />
      </div>

      <button
        onClick={handleGoogleLogin}
        className="w-full flex items-center justify-center py-2.5 border border-gray-300 rounded-lg hover:bg-gray-50 transition duration-150 font-medium text-sm text-gray-700"
      >
        <svg
          className="w-5 h-5 mr-2"
          viewBox="0 0 24 24"
          fill="currentColor"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M22.56 12.25C22.56 11.47 22.49 10.72 22.36 10H12V14.25H17.91C17.64 15.91 16.75 17.31 15.25 18.25V21H19.13C21.33 19.03 22.56 15.94 22.56 12.25Z"
            fill="#4285F4"
          />
          <path
            d="M12 22.5C14.44 22.5 16.57 21.69 18.16 20.25L15.25 18.25C14.38 18.88 13.25 19.25 12 19.25C9.5 19.25 7.38 17.63 6.59 15.38L2.63 15.38V18.31C4.38 20.88 7.88 22.5 12 22.5Z"
            fill="#34A853"
          />
          <path
            d="M6.59 15.38C6.38 14.75 6.25 14.06 6.25 13.38C6.25 12.69 6.38 12 6.59 11.38V8.44H2.63C1.88 9.88 1.5 11.56 1.5 13.38C1.5 15.19 1.88 16.88 2.63 18.31L6.59 15.38Z"
            fill="#FBBC05"
          />
          <path
            d="M12 6.25C13.38 6.25 14.56 6.75 15.5 7.63L18.25 5C16.5 3.38 14.38 2.5 12 2.5C7.88 2.5 4.38 4.13 2.63 6.69L6.59 8.44C7.38 6.13 9.5 4.5 12 4.5V6.25Z"
            fill="#EA4335"
          />
        </svg>{" "}
        Lanjut dengan Google
      </button>

      <p className="mt-6 text-gray-600 text-center text-sm">
        Anda tidak memiliki akun?{" "}
        <Link
          href="/register"
          className="text-red-600 hover:underline font-medium"
        >
          Register
        </Link>
      </p>
    </AuthLayout>
  );
}
