<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Weather App</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <div class="rotate">
    
  <style>

  
    .weather-bg.sunny { background-image: url('41d0026b-0f05-4773-a886-b2aac116b1fd.jpeg?sunny'); }
    .weather-bg.cloudy { background-image: url('f58199b6-249c-47dd-9dfc-c73a08f3d5e3.jpeg?clouds'); }
    .weather-bg.rainy { background-image: url('Enjoy the peace and tranquility of the evening!.jpeg?rain'); }
    .weather-bg.clear { background-image: url('f2e6fa4c-f8b3-4ed9-bf3b-4d8ecb95c3da.jpeg?clear'); }
    .weather-bg.sunny { background-image: url('1ee27ba2-7981-4d32-b0ec-57bf4c3f7879.jpeg?sunny'); }
    .weather-bg.default { background-image: url('DSC_0260.jpeg?weather'); }
    .weather-bg.default { background-image: url('Nature için 900+ fikir _ doğa, manzara, fotoğraf.jpeg?weather'); }
    .weather-bg.snowy { background-image: url('Alessandro ⚓️ NO DM on X.jpeg?weather'); }

    .fade-in { animation: fadeIn 0.6s ease-in-out; }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
  </style>
  </div>

</head>
<body class="min-h-screen weather-bg default bg-cover bg-center text-gray-900 transition-colors duration-300">
  <div class="container mx-auto px-4 py-8 max-w-xl">
    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-xl p-6 text-center">
      <h1 class="text-3xl font-bold mb-4 text-blue-700">🌍 Full Weather App</h1>
      <div class="mb-4">
        <input id="cityInput" type="text" placeholder="Enter city name" class="w-full px-4 py-2 border rounded-xl mb-2" onkeydown="handleKey(event)" />
        <button onclick="getWeather()" class="bg-blue-600 text-white px-4 py-2 rounded-xl hover:bg-blue-700">Get Weather</button>
        <button onclick="getLocationWeather()" class="bg-green-500 text-white px-4 py-2 rounded-xl hover:bg-green-600 ml-2">Use My Location</button>
      </div>
      <div class="flex justify-between mb-4">
        <button onclick="toggleUnit()" class="text-sm text-blue-500 underline">Toggle °C/°F</button>
        <button onclick="toggleTheme()" class="text-sm text-blue-500 underline">Toggle Dark Mode</button>
      </div>
      <div id="weatherResult" class="mt-4 fade-in text-lg"></div>
      <h2 class="text-xl font-semibold mt-6">5-Day Forecast</h2>
      <div id="forecast" class="grid grid-cols-2 md:grid-cols-5 gap-2 mt-2 text-sm"></div>
      <h2 class="text-lg font-semibold mt-6">Search History</h2>
      <ul id="history" class="mt-2 space-y-1 text-left text-blue-600 cursor-pointer"></ul>
      <div class="mt-6">
        <h2 class="text-xl font-semibold">Calendar</h2>
        <div id="calendar" class="mt-2 text-sm text-gray-800"></div>
      </div>
    </div>
  </div>

  <script>
    const apiKey = "9ac63f24bad41f3d3514becd75527939"; // Replace with your real API key
    let isCelsius = true;
    let darkMode = false;

    function handleKey(e) {
      if (e.key === "Enter") getWeather();
    }

    function toggleUnit() {
      isCelsius = !isCelsius;
      getWeather();
    }

    function toggleTheme() {
      darkMode = !darkMode;
      document.body.classList.toggle("dark", darkMode);
      document.body.classList.toggle("text-white", darkMode);
    }

    function setBackground(condition) {
      const map = {
        Clear: "clear",
        Clouds: "cloudy",
        Rain: "rainy",
        Drizzle: "rainy",
        Thunderstorm: "rainy",
        Snow: "cloudy",
        Mist: "cloudy",
        default: "default"
      };
      const type = map[condition] || "default";
      document.body.className = `min-h-screen weather-bg ${type} bg-cover bg-center transition-colors`;
    }

    function getWeather(city = null) {
      const query = city || document.getElementById("cityInput").value.trim();
      if (!query) return;

      const units = isCelsius ? "metric" : "imperial";
      const unitSymbol = isCelsius ? "°C" : "°F";
      const url = `https://api.openweathermap.org/data/2.5/weather?q=${query}&appid=${apiKey}&units=${units}`;

      fetch(url)
        .then(res => res.json())
        .then(data => {
          if (data.cod !== 200) throw new Error(data.message);
          setBackground(data.weather[0].main);
          const html = `
            <h2 class="text-xl font-semibold">${data.name}, ${data.sys.country}</h2>
            <img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" alt="${data.weather[0].description}" class="mx-auto" />
            <p>🌡 Temp: <strong>${data.main.temp}${unitSymbol}</strong></p>
            <p>💧 Humidity: <strong>${data.main.humidity}%</strong></p>
            <p>💨 Wind: <strong>${data.wind.speed} ${units === 'metric' ? 'm/s' : 'mph'}</strong></p>
            <p>🌥 Condition: <strong>${data.weather[0].description}</strong></p>
          `;
          document.getElementById("weatherResult").innerHTML = html;
          saveToHistory(query);
          getForecast(data.coord.lat, data.coord.lon);
        })
        .catch(err => {
          document.getElementById("weatherResult").innerHTML = `<p class='text-red-500'>${err.message}</p>`;
        });
    }

    function getLocationWeather() {
      if (!navigator.geolocation) {
        alert("Geolocation not supported.");
        return;
      }
      navigator.geolocation.getCurrentPosition(pos => {
        const lat = pos.coords.latitude;
        const lon = pos.coords.longitude;
        const units = isCelsius ? "metric" : "imperial";
        const unitSymbol = isCelsius ? "°C" : "°F";

        fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=${units}`)
          .then(res => res.json())
          .then(data => {
            setBackground(data.weather[0].main);
            const html = `
              <h2 class="text-xl font-semibold">${data.name}, ${data.sys.country}</h2>
              <img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" alt="${data.weather[0].description}" class="mx-auto" />
              <p>🌡 Temp: <strong>${data.main.temp}${unitSymbol}</strong></p>
              <p>💧 Humidity: <strong>${data.main.humidity}%</strong></p>
              <p>💨 Wind: <strong>${data.wind.speed} ${units === 'metric' ? 'm/s' : 'mph'}</strong></p>
              <p>🌥 Condition: <strong>${data.weather[0].description}</strong></p>
            `;
            document.getElementById("weatherResult").innerHTML = html;
            getForecast(lat, lon);
          });
      });
    }

    function getForecast(lat, lon) {
      const units = isCelsius ? "metric" : "imperial";
      const url = `https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=${apiKey}&units=${units}`;
      fetch(url)
        .then(res => res.json())
        .then(data => {
          const days = {};
          data.list.forEach(item => {
            const date = item.dt_txt.split(" ")[0];
            if (!days[date]) days[date] = item;
          });

          document.getElementById("forecast").innerHTML = Object.values(days).slice(0, 5).map(day => {
            return `
              <div class="bg-blue-100 rounded-xl p-2 text-center">
                <p>${day.dt_txt.split(" ")[0]}</p>
                <img src="https://openweathermap.org/img/wn/${day.weather[0].icon}.png" class="mx-auto">
                <p><strong>${day.main.temp}${isCelsius ? '°C' : '°F'}</strong></p>
              </div>
            `;
          }).join("");
        });
    }

    function saveToHistory(city) {
      let history = JSON.parse(localStorage.getItem("weatherHistory")) || [];
      if (!history.includes(city)) {
        history.unshift(city);
        if (history.length > 5) history.pop();
        localStorage.setItem("weatherHistory", JSON.stringify(history));
      }
      renderHistory();
    }

    function renderHistory() {
      let history = JSON.parse(localStorage.getItem("weatherHistory")) || [];
      const list = document.getElementById("history");
      list.innerHTML = history.map(city => `<li onclick="getWeather('${city}')">🔁 ${city}</li>`).join("");
    }

    renderHistory();
   
  </script>
   <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1947408071605280"
   crossorigin="anonymous"></script>
   <!-- Google AdSense -->
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1947408071605280"
crossorigin="anonymous"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-XXXXXXX" 
     data-ad-slot="XXXXXXX" 
     data-ad-format="auto"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

</body>
</html>
