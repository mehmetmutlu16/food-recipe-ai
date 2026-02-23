import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis
} from 'recharts';
import { CHART_COLORS } from '../../../constants/chart-colors';

export default function GenerationTrendChart({ data }) {
  return (
    <article className="panel p-4">
      <h2 className="panel-title">Recipe Generation Count</h2>
      <p className="mt-1 text-xs text-slate-500">Gun bazli request yogunlugu</p>
      <div className="h-72 pt-2">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={CHART_COLORS.grid} />
            <XAxis dataKey="date" stroke={CHART_COLORS.muted} />
            <YAxis allowDecimals={false} stroke={CHART_COLORS.muted} />
            <Tooltip />
            <Line
              type="monotone"
              dataKey="count"
              stroke={CHART_COLORS.primary}
              strokeWidth={3}
              dot={{ r: 3 }}
              name="Requests"
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </article>
  );
}
