const API_BASE_URL = "http://localhost:8000/api";

export async function fetchWithAuth(
  endpoint: string,
  options: RequestInit = {}
) {
  const token = localStorage.getItem("auth_token");

  const headers = {
    "Content-Type": "application/json",
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
    ...options.headers,
  };

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers,
  });

  return response;
}

export async function logout() {
  const token = localStorage.getItem("auth_token");

  if (token) {
    try {
      await fetchWithAuth("/logout", { method: "POST" });
    } catch (error) {
      console.error("Logout error:", error);
    }
  }

  localStorage.removeItem("auth_token");
  window.location.href = "/auth/login";
}
