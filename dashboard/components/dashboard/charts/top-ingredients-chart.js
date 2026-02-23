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

export default function TopIngredientsChart({ data }) {
  return (
    <article className="panel p-4">
      <h2 className="panel-title">Most Used Ingredients</h2>
      <p className="mt-1 text-xs text-slate-500">recognizedIngredients alanindan top 10</p>
      <div className="h-72 pt-2">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={CHART_COLORS.grid} />
            <XAxis dataKey="name" stroke={CHART_COLORS.muted} />
            <YAxis allowDecimals={false} stroke={CHART_COLORS.muted} />
            <Tooltip />
            <Bar dataKey="count" fill={CHART_COLORS.accent} name="Count" />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </article>
  );
}
