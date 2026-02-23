export default function TopFailureCodesCard({ topErrorCodes }) {
  return (
    <article className="panel p-4">
      <h2 className="panel-title">Top Failure Codes</h2>
      <p className="mt-1 text-xs text-slate-500">errorCode alanindan ilk 6</p>
      <div className="mt-3 space-y-2">
        {topErrorCodes.length === 0 ? (
          <p className="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-500">
            Failed request bulunamadi.
          </p>
        ) : (
          topErrorCodes.map((item) => (
            <div
              key={item.code}
              className="flex items-center justify-between rounded-lg border border-slate-200 px-3 py-2"
            >
              <span className="truncate pr-3 text-xs font-medium text-slate-700">{item.code}</span>
              <span className="rounded-full bg-red-100 px-2 py-0.5 text-xs font-semibold text-red-700">
                {item.count}
              </span>
            </div>
          ))
        )}
      </div>
    </article>
  );
}
