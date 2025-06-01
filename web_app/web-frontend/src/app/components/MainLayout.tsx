// app/components/MainLayout.tsx
"use client";

import Head from "next/head";
import { useAuth } from "../utils/AuthContext";
import HeaderAuth from "./headerAuth";
import HeaderNonAuth from "./headerNonAuth";
import Footer from "./footer";

interface MainLayoutProps {
  children: React.ReactNode;
  title?: string;
  description?: string;
}

export default function MainLayout({
  children,
  title = "MakanGo",
  description = "Temukan review makanan terbaik!",
}: MainLayoutProps) {
  const { user, loading } = useAuth();

  return (
    <div className="flex flex-col min-h-screen">
      <Head>
        <title>{title}</title>
        <meta name="description" content={description} />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      {loading ? (
        <div className="flex justify-center items-center h-16 bg-white shadow">
          <p className="text-gray-600">Loading...</p>
        </div>
      ) : user ? (
        <HeaderAuth />
      ) : (
        <HeaderNonAuth />
      )}

      <main className="flex-grow">{children}</main>

      <Footer />
    </div>
  );
}
