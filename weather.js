const apiKey = "abc123def456gh789ijk"; // Replace with your real API key

function handleKey(event) {
  if (event.key === "Enter") {
    getWeather();
  }
}

function getWeather() {
  const city = document.getElementById("cityInput").value.trim();
  if (!city) return;

  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric`;

  fetch(url)
    .then((response) => {
      if (!response.ok) {
        throw new Error("City not found");
      }
      return response.json();
    })
    .then((data) => {
      const { name, sys, main, weather, wind } = data;
      const icon = weather[0].icon;
      const description = weather[0].description;

      const weatherHTML = `
        <h2 class="text-2xl font-semibold">${name}, ${sys.country}</h2>
        <img src="https://openweathermap.org/img/wn/${icon}@2x.png" alt="${description}" class="mx-auto" />
        <p>🌡 Temperature: <strong>${main.temp}°C</strong></p>
        <p>💧 Humidity: <strong>${main.humidity}%</strong></p>
        <p>💨 Wind Speed: <strong>${wind.speed} m/s</strong></p>
        <p>🌥 Condition: <strong>${description}</strong></p>
      `;
      document.getElementById("weatherResult").innerHTML = weatherHTML;
    })
    .catch((error) => {
      document.getElementById("weatherResult").innerHTML = `<p class="text-red-600">${error.message}</p>`;
    });
}
