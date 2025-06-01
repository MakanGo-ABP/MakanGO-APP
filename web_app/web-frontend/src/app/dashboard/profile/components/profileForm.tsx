"use client";

import React, { useState } from "react";
import Image from "next/image";
import { FaEdit } from "react-icons/fa";

const ProfileForm = () => {
  const [formData, setFormData] = useState({
    name: "Yesi Sukmawati",
    username: "@Seyik",
    phone: "+6281381227188",
    email: "yesisukmawati2506@gmail.com",
    gender: "Perempuan",
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  return (
    <div className="bg-white rounded-lg shadow p-10 flex gap-12 items-start">
      {/* Avatar Section */}
      <div className="flex flex-col items-center">
        <div className="w-32 h-32 rounded-full border-2 border-red-300 flex items-center justify-center overflow-hidden">
          <Image
            width={128}
            height={128}
            src="/avatar.png"
            alt="Avatar"
            className="w-full h-full object-cover"
          />
        </div>
        <button className="text-sm text-red-600 mt-3 font-semibold">
          Ubah Foto Profil
        </button>
      </div>

      {/* Form Section */}
      <div className="flex-1 space-y-6">
        <section>
          <h3 className="font-semibold text-gray-700 mb-2">
            Info Profil <span title="Informasi profil pengguna">ⓘ</span>
          </h3>
          <InputField
            name="name"
            label="Nama"
            value={formData.name}
            onChange={handleChange}
          />
          <InputField
            name="username"
            label="Username"
            value={formData.username}
            onChange={handleChange}
          />
        </section>

        <section>
          <h3 className="font-semibold text-red-600 mb-2">
            Info Pribadi <span title="Informasi pribadi pengguna">ⓘ</span>
          </h3>
          <InputField
            name="phone"
            label="Nomor Hp"
            value={formData.phone}
            onChange={handleChange}
          />
          <InputField
            name="email"
            label="Email"
            value={formData.email}
            onChange={handleChange}
          />
          <InputField
            name="gender"
            label="Jenis Kelamin"
            value={formData.gender}
            onChange={handleChange}
          />
        </section>

        <button className="bg-gradient-to-r from-red-500 to-red-600 text-white font-bold py-2 px-6 rounded-lg">
          Simpan
        </button>
      </div>
    </div>
  );
};

type InputProps = {
  name: string;
  label: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
};

const InputField: React.FC<InputProps> = ({ name, label, value, onChange }) => (
  <div className="mb-4">
    <label className="text-sm text-gray-600 block mb-1">{label}</label>
    <div className="relative">
      <input
        type="text"
        name={name}
        value={value}
        onChange={onChange}
        className="w-full border rounded-full px-4 py-2 pr-10 focus:outline-none focus:ring-2 focus:ring-red-300"
      />
      <FaEdit className="absolute right-3 top-2.5 text-gray-400" />
    </div>
  </div>
);

export default ProfileForm;
