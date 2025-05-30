#!/bin/bash

echo "🚀 Iniciando configuración del proyecto plantillaform..."

# Inicializar Vite + React
npm create vite@latest plantillaform -- --template react
cd plantillaform
npm install
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Configurar Tailwind en index.css
cat > src/index.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Agregar configuración a tailwind.config.js
sed -i '' 's/content: \[\]/content: \[".\/index.html", ".\/src\/\*\*\/\*.jsx"\]/' tailwind.config.js

# Crear SelectorCampos.jsx
cat > src/SelectorCampos.jsx <<EOF
import { useState } from "react";

const campos = [
  "Nombre del arrendador",
  "Nombre del arrendatario",
  "Dirección del inmueble",
  "Valor del arriendo",
  "Duración del contrato",
  "Fecha de inicio",
  "Cláusulas especiales"
];

export default function SelectorCampos({ onGenerar }) {
  const [seleccionados, setSeleccionados] = useState([]);

  const toggleCampo = (campo) => {
    setSeleccionados((prev) =>
      prev.includes(campo)
        ? prev.filter((c) => c !== campo)
        : [...prev, campo]
    );
  };

  return (
    <div className="p-4">
      <h2 className="text-xl font-bold mb-2">Selecciona los campos:</h2>
      {campos.map((campo) => (
        <label key={campo} className="block">
          <input
            type="checkbox"
            checked={seleccionados.includes(campo)}
            onChange={() => toggleCampo(campo)}
          />
          <span className="ml-2">{campo}</span>
        </label>
      ))}
      <button
        className="mt-4 p-2 bg-blue-500 text-white rounded"
        onClick={() => onGenerar(seleccionados)}
      >
        Generar Plantilla
      </button>
    </div>
  );
}
EOF

# Crear archivo de plantilla base
cat > src/PlantillaContrato.jsx <<EOF
export default function PlantillaContrato({ campos }) {
  return (
    <div className="p-4 border border-gray-300 rounded mt-4">
      <h1 className="text-2xl font-bold mb-4">Contrato de Arrendamiento</h1>
      <ul>
        {campos.map((campo, idx) => (
          <li key={idx} className="mb-2">
            <strong>{campo}:</strong> ____________________________
          </li>
        ))}
      </ul>
    </div>
  );
}
EOF

echo "✅ Proyecto listo. Ejecuta 'npm run dev' para iniciar el servidor."
