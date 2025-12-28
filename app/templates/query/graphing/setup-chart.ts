import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Colors,
  Legend,
  LinearScale,
  LineController,
  LineElement,
  PointElement,
  Tooltip,
} from 'chart.js';
import annotationPlugin from 'chartjs-plugin-annotation';

Chart.register(
  Colors,
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Legend,
  Tooltip,
  LineController,
  LineElement,
  PointElement,
  annotationPlugin
);

export { Chart };

export const colors = ['#8844cc', '#44cc88', '#cc8844', '#cc4488', '#88cc44', '#4488cc'];
