export default function DashboardHeader({
  days,
  onDaysChange,
  statusFilter,
  onStatusFilterChange,
  inputTypeFilter,
  onInputTypeFilterChange
}) {
  return (
    <section className="panel overflow-hidden p-6">
      <div className="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p className="text-xs font-bold uppercase tracking-[0.22em] text-brand-700">
            Ancienda
          </p>
          <h1 className="mt-2 font-[var(--font-bitter)] text-3xl font-semibold text-slate-900 sm:text-4xl">
            AI Recipe Assistant Dashboard
          </h1>
          <p className="mt-3 max-w-3xl text-sm text-slate-600">
            Firestore kayitlarindan anlik recipe request, basari ve ingredient trendlerini
            izler.
          </p>
        </div>

        <div className="grid grid-cols-2 gap-2 sm:flex sm:flex-wrap sm:items-center sm:justify-end">
          <div className="col-span-2 flex gap-2 sm:col-span-1">
            <button
              type="button"
              className={days === 7 ? 'chip chip-active' : 'chip'}
              onClick={() => onDaysChange(7)}
            >
              Son 7 gun
            </button>
            <button
              type="button"
              className={days === 30 ? 'chip chip-active' : 'chip'}
              onClick={() => onDaysChange(30)}
            >
              Son 30 gun
            </button>
          </div>

          <select
            value={statusFilter}
            onChange={(event) => onStatusFilterChange(event.target.value)}
            className="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-700 focus:border-brand-500 focus:outline-none"
          >
            <option value="all">Tum status</option>
            <option value="success">Sadece success</option>
            <option value="failed">Sadece failed</option>
          </select>

          <select
            value={inputTypeFilter}
            onChange={(event) => onInputTypeFilterChange(event.target.value)}
            className="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-700 focus:border-brand-500 focus:outline-none"
          >
            <option value="all">Tum input type</option>
            <option value="text">Text</option>
            <option value="image">Image</option>
            <option value="mixed">Mixed</option>
          </select>
        </div>
      </div>
    </section>
  );
}
