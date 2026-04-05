export const stops = [
  { id: 'S1', name: 'Maharaj Bada', lat: 26.2018, lng: 78.1644, city: 'Gwalior', landmark: 'City Center' },
  { id: 'S2', name: 'Hazira Square', lat: 26.2348, lng: 78.1844, city: 'Gwalior', landmark: 'Hazira Chauraha' },
  { id: 'S3', name: 'Thatipur Circle', lat: 26.2232, lng: 78.198, city: 'Gwalior', landmark: 'Thatipur Chauraha' },
  { id: 'S4', name: 'Morar Enclave', lat: 26.2392, lng: 78.2165, city: 'Gwalior', landmark: 'Morar Side' },
  { id: 'S5', name: 'Gwalior Railway Station', lat: 26.2183, lng: 78.1828, city: 'Gwalior', landmark: 'Main Entrance' },
  { id: 'S6', name: 'Gwalior Fort (Man Singh Palace)', lat: 26.2295, lng: 78.1734, city: 'Gwalior', landmark: 'Fort Entry' },
  { id: 'S7', name: 'Gola ka Mandir', lat: 26.2508, lng: 78.1775, city: 'Gwalior', landmark: 'Gola ka Mandir Square' },
  { id: 'S8', name: 'Phool Bagh', lat: 26.2122, lng: 78.1806, city: 'Gwalior', landmark: 'Garden Gate' },
];

export const routes = [
  { route_id: 'E1', vehicle: 'Vikram (Tempo)', stops: ['S1', 'S2'], legs: [{ from: 'S1', to: 'S2', fare: 15, durationMinutes: 32, distanceKm: 4.69 }] },
  { route_id: 'E2', vehicle: 'Tata Magic', stops: ['S1', 'S3'], legs: [{ from: 'S1', to: 'S3', fare: 20, durationMinutes: 41, distanceKm: 5.71 }] },
  { route_id: 'E3', vehicle: 'Vikram (Tempo)', stops: ['S1', 'S4'], legs: [{ from: 'S1', to: 'S4', fare: 15, durationMinutes: 45, distanceKm: 7.79 }] },
  { route_id: 'E4', vehicle: 'City Bus (Sutrasewa)', stops: ['S5', 'S6'], legs: [{ from: 'S5', to: 'S6', fare: 10, durationMinutes: 35, distanceKm: 2.56 }] },
  { route_id: 'E5', vehicle: 'Auto-Rickshaw', stops: ['S5', 'S8'], legs: [{ from: 'S5', to: 'S8', fare: 50, durationMinutes: 15, distanceKm: 1.55 }] },
  { route_id: 'E6', vehicle: 'Tata Magic', stops: ['S5', 'S1'], legs: [{ from: 'S5', to: 'S1', fare: 20, durationMinutes: 31, distanceKm: 3.52 }] },
  { route_id: 'E7', vehicle: 'Auto-Rickshaw', stops: ['S6', 'S7'], legs: [{ from: 'S6', to: 'S7', fare: 55, durationMinutes: 27, distanceKm: 4.54 }] },
  { route_id: 'E8', vehicle: 'Tata Magic', stops: ['S6', 'S8'], legs: [{ from: 'S6', to: 'S8', fare: 15, durationMinutes: 19, distanceKm: 1.42 }] },
  { route_id: 'E9', vehicle: 'Auto-Rickshaw', stops: ['S6', 'S4'], legs: [{ from: 'S6', to: 'S4', fare: 55, durationMinutes: 35, distanceKm: 6.23 }] },
  { route_id: 'E10', vehicle: 'City Bus (Sutrasewa)', stops: ['S2', 'S4'], legs: [{ from: 'S2', to: 'S4', fare: 15, durationMinutes: 42, distanceKm: 5.27 }] },
  { route_id: 'E11', vehicle: 'Vikram (Tempo)', stops: ['S2', 'S1'], legs: [{ from: 'S2', to: 'S1', fare: 15, durationMinutes: 30, distanceKm: 4.69 }] },
  { route_id: 'E12', vehicle: 'City Bus (Sutrasewa)', stops: ['S2', 'S5'], legs: [{ from: 'S2', to: 'S5', fare: 10, durationMinutes: 30, distanceKm: 2.75 }] },
  { route_id: 'E13', vehicle: 'Tata Magic', stops: ['S3', 'S8'], legs: [{ from: 'S3', to: 'S8', fare: 20, durationMinutes: 35, distanceKm: 3.92 }] },
  { route_id: 'E14', vehicle: 'Vikram (Tempo)', stops: ['S3', 'S1'], legs: [{ from: 'S3', to: 'S1', fare: 15, durationMinutes: 35, distanceKm: 5.71 }] },
  { route_id: 'E15', vehicle: 'Auto-Rickshaw', stops: ['S3', 'S5'], legs: [{ from: 'S3', to: 'S5', fare: 50, durationMinutes: 16, distanceKm: 2.37 }] },
  { route_id: 'E16', vehicle: 'City Bus (Sutrasewa)', stops: ['S7', 'S3'], legs: [{ from: 'S7', to: 'S3', fare: 10, durationMinutes: 37, distanceKm: 2.72 }] },
  { route_id: 'E17', vehicle: 'City Bus (Sutrasewa)', stops: ['S7', 'S4'], legs: [{ from: 'S7', to: 'S4', fare: 10, durationMinutes: 30, distanceKm: 2.31 }] },
  { route_id: 'E18', vehicle: 'Vikram (Tempo)', stops: ['S7', 'S2'], legs: [{ from: 'S7', to: 'S2', fare: 15, durationMinutes: 26, distanceKm: 3.25 }] },
  { route_id: 'E19', vehicle: 'Auto-Rickshaw', stops: ['S8', 'S5'], legs: [{ from: 'S8', to: 'S5', fare: 50, durationMinutes: 14, distanceKm: 1.55 }] },
  { route_id: 'E20', vehicle: 'Vikram (Tempo)', stops: ['S8', 'S7'], legs: [{ from: 'S8', to: 'S7', fare: 15, durationMinutes: 26, distanceKm: 4.54 }] },
  { route_id: 'E21', vehicle: 'City Bus (Sutrasewa)', stops: ['S8', 'S2'], legs: [{ from: 'S8', to: 'S2', fare: 10, durationMinutes: 31, distanceKm: 2.49 }] },
  { route_id: 'E22', vehicle: 'Auto-Rickshaw', stops: ['S4', 'S2'], legs: [{ from: 'S4', to: 'S2', fare: 55, durationMinutes: 28, distanceKm: 5.27 }] },
  { route_id: 'E23', vehicle: 'Vikram (Tempo)', stops: ['S4', 'S8'], legs: [{ from: 'S4', to: 'S8', fare: 15, durationMinutes: 31, distanceKm: 5.76 }] },
  { route_id: 'E24', vehicle: 'Auto-Rickshaw', stops: ['S4', 'S7'], legs: [{ from: 'S4', to: 'S7', fare: 50, durationMinutes: 23, distanceKm: 2.31 }] },
];

export const analytics = {
  heatmap: [
    { stop_id: 'S2', searchCount: 250, timeSlot: '18:00' },
    { stop_id: 'S4', searchCount: 189, timeSlot: '09:00' },
    { stop_id: 'S1', searchCount: 120, timeSlot: '08:30' },
  ],
  peakHours: [
    { hour: '08:00', demandScore: 0.72 },
    { hour: '18:00', demandScore: 0.89 },
    { hour: '19:00', demandScore: 0.81 },
  ],
};

export const crowdReports = [];

