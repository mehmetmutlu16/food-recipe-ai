import {
  formatDateTime,
  formatIngredientText,
  formatStatusLabel
} from '../../lib/dashboard-formatters';

export default function RecentRequestsTable({ history, loading }) {
  return (
    <section className="panel mt-4 p-4">
      <div className="mb-3 flex items-center justify-between">
        <h2 className="panel-title">Recent Requests</h2>
        <span className="text-xs text-slate-500">
          {loading ? 'Yukleniyor...' : `${history.length} kayit`}
        </span>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[760px] border-collapse text-left text-xs">
          <thead>
            <tr className="border-b border-slate-200 text-slate-500">
              <th className="px-2 py-2 font-semibold">Date</th>
              <th className="px-2 py-2 font-semibold">Input Type</th>
              <th className="px-2 py-2 font-semibold">Status</th>
              <th className="px-2 py-2 font-semibold">Ingredients</th>
              <th className="px-2 py-2 font-semibold">Recipe</th>
            </tr>
          </thead>
          <tbody>
            {history.length === 0 ? (
              <tr>
                <td className="px-2 py-4 text-slate-500" colSpan={5}>
                  Kayit bulunamadi.
                </td>
              </tr>
            ) : (
              history.slice(0, 12).map((item) => (
                <tr key={item.id} className="border-b border-slate-100 align-top">
                  <td className="px-2 py-2 text-slate-700">{formatDateTime(item.createdAt)}</td>
                  <td className="px-2 py-2">
                    <span className="rounded-full bg-slate-100 px-2 py-0.5 font-semibold text-slate-700">
                      {item.inputType || '-'}
                    </span>
                  </td>
                  <td className="px-2 py-2">
                    <span
                      className={`rounded-full px-2 py-0.5 font-semibold ${
                        item.status === 'success'
                          ? 'bg-green-100 text-green-700'
                          : item.status === 'failed'
                            ? 'bg-red-100 text-red-700'
                            : 'bg-slate-100 text-slate-700'
                      }`}
                    >
                      {formatStatusLabel(item.status)}
                    </span>
                  </td>
                  <td className="max-w-[320px] px-2 py-2 text-slate-700">
                    {formatIngredientText(item)}
                  </td>
                  <td className="px-2 py-2 text-slate-700">
                    {item.recipe?.name ? item.recipe.name : '-'}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  );
}
