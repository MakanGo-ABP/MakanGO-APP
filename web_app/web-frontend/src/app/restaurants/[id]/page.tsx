/* eslint-disable @typescript-eslint/no-explicit-any */
"use client";

import { useState, useEffect, use } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { MapPin, Star } from "lucide-react";
import MainLayout from "../../components/MainLayout";
import AuthLayout from "../../components/AuthLayout";
import { useAuth } from "../../utils/AuthContext";
import { getRestaurantById, Restaurant } from "../../services/restaurant";

export default function RestaurantDetail({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const { user } = useAuth();
  const router = useRouter();
  const [restaurant, setRestaurant] = useState<Restaurant | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchRestaurant = async () => {
      try {
        const data = await getRestaurantById(id);
        if (!data) {
          throw new Error("Restoran tidak ditemukan");
        }
        setRestaurant(data);
      } catch (err: any) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchRestaurant();
  }, [id]);

  const normalizeImagePath = (path: string | undefined): string => {
    if (!path || !path.startsWith("https://")) {
      return "/assets/placeholder.png";
    }
    return path;
  };

  if (loading) {
    return (
      <AuthLayout>
        <div className="text-center py-10">
          <p className="text-gray-600">Memuat...</p>
        </div>
      </AuthLayout>
    );
  }

  if (error || !restaurant) {
    return (
      <AuthLayout>
        <div className="text-center py-10">
          <p className="text-red-500">{error || "Restoran tidak ditemukan"}</p>
          <button
            onClick={() => router.push("/dashboard")}
            className="mt-4 text-red-600 hover:underline"
          >
            Kembali ke Dashboard
          </button>
        </div>
      </AuthLayout>
    );
  }

  return (
    <MainLayout
      title="MakanGo - Review Makanan & Restoran"
      description="Cari review makanan, restoran, kuliner populer dan menarik di MakanGo."
    >
      <div className="max-w-3xl mx-auto py-8">
        <div className="relative w-full h-64 mb-6">
          <Image
            src={normalizeImagePath(restaurant.imagePath)}
            alt={restaurant.name}
            fill
            className="object-cover rounded-lg"
            priority
          />
        </div>
        <h1 className="text-3xl font-bold text-gray-800 mb-4">
          {restaurant.name}
        </h1>
        <div className="flex items-center mb-4">
          <Star className="text-yellow-400 mr-1" size={20} />
          <span className="text-gray-600">
            {restaurant.rating.toFixed(1)} ({restaurant.reviews} ulasan)
          </span>
        </div>
        <div className="flex items-start mb-4">
          <MapPin className="text-gray-400 mr-2 mt-1" size={20} />
          <p className="text-gray-600">{restaurant.address}</p>
        </div>
        {user && (
          <button
            onClick={() => router.push(`/restaurants/${id}/review`)}
            className="bg-red-600 text-white py-2 px-4 rounded-lg hover:bg-red-700 transition duration-150"
          >
            Tulis Ulasan
          </button>
        )}
      </div>
    </MainLayout>
  );
}
