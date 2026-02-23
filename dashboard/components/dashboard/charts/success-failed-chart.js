import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip, Legend } from 'recharts';
import { CHART_COLORS } from '../../../constants/chart-colors';

export default function SuccessFailedChart({ data }) {
  return (
    <article className="panel p-4">
      <h2 className="panel-title">Success vs Failed</h2>
      <p className="mt-1 text-xs text-slate-500">Request status dagilimi</p>
      <div className="h-72 pt-2">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie data={data} dataKey="value" nameKey="name" outerRadius={90} label>
              {data.map((entry) => (
                <Cell
                  key={entry.name}
                  fill={entry.name === 'Success' ? CHART_COLORS.success : CHART_COLORS.failed}
                />
              ))}
            </Pie>
            <Tooltip />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </div>
    </article>
  );
}
