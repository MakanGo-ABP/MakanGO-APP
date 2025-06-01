import React from "react";
import Sidebar from "../components/sidebar";
import ReviewEmptyState from "../components/reviewEmptyState";

const ReviewPage = () => {
  return (
    <div className="flex min-h-screen">
      <Sidebar active="ulasan" />
      <main className="flex-1 bg-gray-50 p-10">
        <h2 className="text-2xl font-bold text-red-600 mb-6">Ulasan</h2>
        <ReviewEmptyState />
      </main>
    </div>
  );
};

export default ReviewPage;
