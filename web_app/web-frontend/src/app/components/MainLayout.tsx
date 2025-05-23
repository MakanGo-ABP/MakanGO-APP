import Header from "./header";
import Footer from "./footer";
import Head from "next/head";
import React from "react";

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
  return (
    <div className="flex flex-col min-h-screen">
      <Head>
        <title>{title}</title>
        <meta name="description" content={description} />
        <link rel="icon" href="/favicon.ico" />{" "}
      </Head>

      <Header />

      <main className="flex-grow">{children}</main>

      <Footer />
    </div>
  );
}
