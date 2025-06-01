"use client";

import Head from "next/head";
import React, { useState, useEffect } from "react"; // Added useState and useEffect for a mock auth state

// Import both header components
import HeaderNonAuth from "./headerNonAuth"; // Assuming this is the correct path
import AuthenticatedHeader from "./headerAuth"; // Assuming this is the correct path and filename for the auth header
import Footer from "./footer"; // Assuming this is the correct path

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
  // --- Mock Authentication State ---
  // In a real app, this would come from your auth provider (e.g., a hook, context)
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // Simulate checking auth status on mount (e.g., from localStorage, an API call)
  useEffect(() => {
    // Replace this with your actual auth checking logic
    const checkAuthStatus = () => {
      // Example: check if a token exists in localStorage
      // const token = localStorage.getItem('authToken');
      // setIsAuthenticated(!!token);

      // For demonstration, let's toggle it after a delay
      // In a real app, you wouldn't randomly toggle it like this.
      // This is just to show both headers.
      console.log("Current auth status (mock):", isAuthenticated);
      // setTimeout(() => {
      //   setIsAuthenticated(prev => !prev);
      //   console.log("Auth status (mock) updated to:", !isAuthenticated);
      // }, 5000); // Toggles after 5 seconds for demo
    };

    checkAuthStatus();
  }, []); // Empty dependency array means this runs once on mount

  // --- End Mock Authentication State ---

  return (
    <div className="flex flex-col min-h-screen">
      <Head>
        <title>{title}</title>
        <meta name="description" content={description} />
        {/* Ensure your favicon.ico is in the public folder */}
        <link rel="icon" href="/favicon.ico" />
      </Head>

      {/* Conditionally render the header */}
      {isAuthenticated ? <AuthenticatedHeader /> : <HeaderNonAuth />}

      <main>{children}</main>

      <Footer />

      {/* TEMPORARY: Button to toggle auth status for testing */}
      <div
        style={{
          position: "fixed",
          bottom: "10px",
          right: "10px",
          zIndex: 100,
        }}
      >
        <button
          onClick={() => setIsAuthenticated((prev) => !prev)}
          style={{
            padding: "10px 20px",
            backgroundColor: isAuthenticated ? "#4CAF50" : "#f44336",
            color: "white",
            border: "none",
            borderRadius: "5px",
            cursor: "pointer",
            fontSize: "16px",
          }}
        >
          Toggle Auth (Is {isAuthenticated ? "On" : "Off"})
        </button>
      </div>
    </div>
  );
}
