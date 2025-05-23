"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { auth, createUserWithEmailAndPassword } from "@/lib/firebase";
import Image from "next/image";
import OtpInput from "react-otp-input";
import { User, Mail, Lock } from "lucide-react";
import AuthLayout from "../../components/AuthLayout";

export default function Register() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [error, setError] = useState("");
  const [step, setStep] = useState(() => {
    return parseInt(localStorage.getItem("registerStep") || "1");
  });
  const [otp, setOtp] = useState("");
  const [uid, setUid] = useState(() => {
    return localStorage.getItem("registerUid") || "";
  });
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    localStorage.setItem("registerStep", step.toString());
    localStorage.setItem("registerUid", uid);
  }, [step, uid]);

  const handleRegister = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError("");
    try {
      const userCredential = await createUserWithEmailAndPassword(
        auth,
        email,
        password
      );
      const idToken = await userCredential.user.getIdToken();
      localStorage.setItem("idToken", idToken);

      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/auth/register`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ email, password, name }),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Registration failed");
      }

      const data = await response.json();
      setUid(data.uid);
      setStep(2);
    } catch (error) {
      if (error instanceof Error) {
        setError(error.message || "An error occurred during registration");
      } else {
        setError("An unexpected error occurred");
      }
    } finally {
      setLoading(false);
    }
  };

  const handleOtpSubmit = async () => {
    setLoading(true);
    setError("");
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/auth/otp/verify`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ uid, otp }),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "OTP verification failed");
      }

      const data = await response.json();
      console.log("OTP verified:", data);
      localStorage.removeItem("registerStep");
      localStorage.removeItem("registerUid");
      router.push("/"); // Redirect to homepage
    } catch (error) {
      if (error instanceof Error) {
        setError(error.message || "An error occurred during OTP verification");
      } else {
        setError("An unexpected error occurred");
      }
    } finally {
      setLoading(false);
    }
  };

  const handleBackToRegister = () => {
    setStep(1);
    setOtp("");
    setError("");
    setUid("");
    localStorage.removeItem("registerStep");
    localStorage.removeItem("registerUid");
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
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

      {step === 1 && (
        <>
          <h3 className="text-2xl text-left text-gray-800 font-bold mb-1">
            Registrasi akun!
          </h3>
          <p className="text-gray-600 mb-6 text-left text-sm">
            Email yang Anda masukkan belum terdaftar.
          </p>

          {error && (
            <p className="text-red-500 text-sm mb-4 text-left">{error}</p>
          )}

          <form onSubmit={handleRegister} className="w-full space-y-4">
            <div>
              <label className="block text-gray-700 text-sm font-medium mb-1">
                Nama lengkap <span className="text-red-600">*</span>
              </label>
              <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-red-500 focus-within:border-red-500">
                <User className="mr-2 text-gray-400" />
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Masukkan nama Anda"
                  className="w-full outline-none text-gray-800 placeholder-gray-400 text-sm"
                  required
                />
              </div>
            </div>
            <div>
              <label className="block text-gray-700 text-sm font-medium mb-1">
                Email <span className="text-red-600">*</span>
              </label>
              <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-red-500 focus-within:border-red-500">
                <Mail className="mr-2 text-gray-400" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Masukkan email Anda"
                  className="w-full outline-none text-gray-800 placeholder-gray-400 text-sm"
                  required
                />
              </div>
            </div>
            <div>
              <label className="block text-gray-700 text-sm font-medium mb-1">
                Kata sandi <span className="text-red-600">*</span>
              </label>
              <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-red-500 focus-within:border-red-500">
                <Lock className="mr-2 text-gray-400" />
                <input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Masukkan kata sandi Anda"
                  className="w-full outline-none text-gray-800 placeholder-gray-400 text-sm"
                  required
                />
                <button
                  type="button"
                  onClick={togglePasswordVisibility}
                  className="ml-2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? "🙈" : "👁️"}
                </button>
              </div>
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-red-600 text-white py-2.5 rounded-lg hover:bg-red-700 transition duration-150 font-medium text-sm disabled:bg-red-400"
            >
              {loading ? "Mendaftar..." : "Daftar"}
            </button>
          </form>

          <p className="mt-6 text-gray-600 text-center text-sm">
            Anda telah memiliki akun?{" "}
            <Link
              href="/auth/login"
              className="text-red-600 hover:underline font-medium"
            >
              Masuk
            </Link>
          </p>
        </>
      )}

      {step === 2 && (
        <>
          <h3 className="text-2xl text-left text-gray-800 font-bold mb-1">
            Masukkan OTP
          </h3>
          <p className="text-gray-600 mb-6 text-left text-sm">
            Kami telah mengirimkan OTP ke {email}
          </p>

          {error && (
            <p className="text-red-500 text-sm mb-4 text-left">{error}</p>
          )}

          <div className="w-full space-y-4">
            <OtpInput
              value={otp}
              onChange={setOtp}
              numInputs={6}
              renderSeparator={<span className="mx-1">-</span>}
              renderInput={(props) => (
                <input
                  {...props}
                  className="w-12 h-12 text-center border border-gray-300 rounded-lg mx-1 focus:ring-2 focus:ring-red-500 focus:border-red-500 text-gray-800"
                />
              )}
            />

            <button
              onClick={handleOtpSubmit}
              disabled={loading}
              className="w-full bg-red-600 text-white py-2.5 rounded-lg hover:bg-red-700 transition duration-150 font-medium text-sm disabled:bg-red-400"
            >
              {loading ? "Memverifikasi..." : "Verifikasi OTP"}
            </button>

            <p className="mt-6 text-gray-600 text-center text-sm">
              Salah email atau ingin kembali?{" "}
              <button
                onClick={handleBackToRegister}
                className="text-red-600 hover:underline font-medium"
              >
                Kembali
              </button>
            </p>
          </div>
        </>
      )}
    </AuthLayout>
  );
}
