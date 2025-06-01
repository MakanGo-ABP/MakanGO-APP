"use client";

import AuthLayout from "../../components/AuthLayout";
import Image from "next/image";
import { useState, useRef, KeyboardEvent, FormEvent } from "react";

export default function OtpPage() {
  const [otp, setOtp] = useState<string[]>(new Array(6).fill(""));
  const [error, setError] = useState<string>("");
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  const handleChange = (element: HTMLInputElement, index: number) => {
    if (isNaN(Number(element.value))) return;

    setOtp([...otp.map((d, idx) => (idx === index ? element.value : d))]);

    if (element.value !== "" && element.nextSibling && index < otp.length - 1) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>, index: number) => {
    if (
      e.key === "Backspace" &&
      otp[index] === "" &&
      e.currentTarget.previousSibling &&
      index > 0
    ) {
      inputRefs.current[index - 1]?.focus();
    }
  };

  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const enteredOtp = otp.join("");
    console.log("Verifying OTP:", enteredOtp);

    if (enteredOtp.length < 6) {
      setError("Kode OTP tidak lengkap.");
      return;
    }
    setError("");
    // Add your OTP verification logic here
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
        Kode verifikasi!
      </h3>
      <p className="text-gray-600 mb-6 text-left text-sm">
        Kode verifikasi telah terkirim melalui email ke <br />
        <span className="font-medium text-gray-700">
          c*********4@gmail.com
        </span>{" "}
        {/* Make this dynamic */}
      </p>

      {error && <p className="text-red-500 text-sm mb-4 text-left">{error}</p>}

      <form onSubmit={handleSubmit} className="w-full space-y-6">
        <div className="flex justify-between space-x-2 sm:space-x-3 md:space-x-4">
          {otp.map((data, index) => (
            <input
              key={index}
              type="text"
              name="otp"
              maxLength={1}
              className="w-12 h-12 sm:w-14 sm:h-14 md:w-16 md:h-16 text-center text-lg sm:text-xl md:text-2xl font-medium border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-red-500 outline-none text-gray-800"
              value={data}
              onChange={(e) => handleChange(e.target, index)}
              onFocus={(e) => e.target.select()}
              onKeyDown={(e) => handleKeyDown(e, index)}
              ref={(el) => {
                inputRefs.current[index] = el;
              }}
            />
          ))}
        </div>

        <button
          type="submit"
          className="w-full bg-red-600 text-white py-2.5 rounded-lg hover:bg-red-700 transition duration-150 font-medium text-sm"
        >
          Lanjutkan
        </button>
      </form>
      <p className="mt-6 text-center text-sm">
        <button className="text-red-600 hover:underline font-medium">
          Kirim ulang kode
        </button>
      </p>
    </AuthLayout>
  );
}
