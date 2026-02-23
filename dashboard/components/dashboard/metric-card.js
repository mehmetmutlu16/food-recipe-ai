export default function MetricCard({ title, value, subtitle, valueClassName = '' }) {
  return (
    <article className="panel p-4">
      <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">{title}</p>
      <p className={`mt-2 text-2xl font-bold text-slate-900 ${valueClassName}`}>{value}</p>
      <p className="mt-1 text-xs text-slate-500">{subtitle}</p>
    </article>
  );
}
