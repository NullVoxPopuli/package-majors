import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Colors,
  Legend,
  LinearScale,
  Tooltip,
} from 'chart.js';

Chart.register(Colors, BarController, BarElement, CategoryScale, LinearScale, Legend, Tooltip);

export { Chart };
