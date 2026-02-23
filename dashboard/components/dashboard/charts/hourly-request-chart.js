import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis
} from 'recharts';
import { CHART_COLORS } from '../../../constants/chart-colors';

export default function HourlyRequestChart({ data }) {
  return (
    <article className="panel p-4">
      <h2 className="panel-title">Hourly Request Trend</h2>
      <p className="mt-1 text-xs text-slate-500">createdAt saatine gore dagilim</p>
      <div className="h-72 pt-2">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={CHART_COLORS.grid} />
            <XAxis dataKey="hour" stroke={CHART_COLORS.muted} minTickGap={18} />
            <YAxis allowDecimals={false} stroke={CHART_COLORS.muted} />
            <Tooltip />
            <Bar dataKey="count" fill={CHART_COLORS.secondary} name="Count" />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </article>
  );
}
