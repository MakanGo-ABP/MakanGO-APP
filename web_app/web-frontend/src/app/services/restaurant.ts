// services/restaurant.ts
import { db } from "@/lib/firebase";
import { doc, getDoc } from "firebase/firestore";

export interface Restaurant {
  id: string;
  address: string;
  category: string;
  imagePath: string;
  latitude: number;
  longitude: number;
  name: string;
  rating: number;
  reviews: number;
  time: string;
}

export async function getRestaurantById(
  id: string
): Promise<Restaurant | null> {
  try {
    const restaurantDoc = await getDoc(doc(db, "Restaurant", id));
    if (!restaurantDoc.exists()) {
      return null;
    }
    return { id: restaurantDoc.id, ...restaurantDoc.data() } as Restaurant;
  } catch (error) {
    console.error("Error fetching restaurant:", error);
    throw error;
  }
}
