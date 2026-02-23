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

export default function InputTypeChart({ data }) {
  return (
    <article className="panel p-4 xl:col-span-2">
      <h2 className="panel-title">Input Type Distribution</h2>
      <p className="mt-1 text-xs text-slate-500">text / image / mixed dagilimi</p>
      <div className="h-64 pt-2">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={CHART_COLORS.grid} />
            <XAxis dataKey="type" stroke={CHART_COLORS.muted} />
            <YAxis allowDecimals={false} stroke={CHART_COLORS.muted} />
            <Tooltip />
            <Bar dataKey="count" fill={CHART_COLORS.primary} name="Count" />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </article>
  );
}
