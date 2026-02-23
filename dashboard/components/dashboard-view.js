'use client';

import { useMemo, useState } from 'react';
import { useDashboardData } from '../hooks/use-dashboard-data';
import {
  computeAverageIngredientCount,
  computeHourlyTrend,
  computeInputTypeData,
  computeSuccessFailureData,
  computeSuccessRate,
  computeTopErrorCodes,
  getTotals
} from '../lib/dashboard-analytics';
import { formatDateTime } from '../lib/dashboard-formatters';
import DashboardHeader from './dashboard/dashboard-header';
import MetricCard from './dashboard/metric-card';
import GenerationTrendChart from './dashboard/charts/generation-trend-chart';
import TopIngredientsChart from './dashboard/charts/top-ingredients-chart';
import SuccessFailedChart from './dashboard/charts/success-failed-chart';
import HourlyRequestChart from './dashboard/charts/hourly-request-chart';
import InputTypeChart from './dashboard/charts/input-type-chart';
import TopFailureCodesCard from './dashboard/top-failure-codes-card';
import RecentRequestsTable from './dashboard/recent-requests-table';

export default function DashboardView() {
  const [days, setDays] = useState(7);
  const [statusFilter, setStatusFilter] = useState('all');
  const [inputTypeFilter, setInputTypeFilter] = useState('all');

  const { loading, error, summary, history } = useDashboardData({
    days,
    statusFilter,
    inputTypeFilter
  });

  const totals = useMemo(() => getTotals(summary), [summary]);
  const successRate = useMemo(() => computeSuccessRate(totals), [totals]);
  const successFailureData = useMemo(
    () => computeSuccessFailureData(totals),
    [totals]
  );
  const inputTypeData = useMemo(() => computeInputTypeData(history), [history]);
  const averageIngredientCount = useMemo(
    () => computeAverageIngredientCount(history),
    [history]
  );
  const topErrorCodes = useMemo(() => computeTopErrorCodes(history), [history]);
  const hourlyTrend = useMemo(() => computeHourlyTrend(history), [history]);
  const generationCount = summary?.generationCount ?? [];
  const topIngredients = summary?.topIngredients ?? [];
  const lastRequestAt = history[0]?.createdAt ?? null;

  return (
    <main className="mx-auto min-h-screen w-full max-w-7xl px-4 pb-10 pt-7 sm:px-6 lg:px-8">
      <DashboardHeader
        days={days}
        onDaysChange={setDays}
        statusFilter={statusFilter}
        onStatusFilterChange={setStatusFilter}
        inputTypeFilter={inputTypeFilter}
        onInputTypeFilterChange={setInputTypeFilter}
      />

      {error ? (
        <div className="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-700">
          {error}
        </div>
      ) : null}

      <section className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-5">
        <MetricCard
          title="Total Requests"
          value={loading ? '...' : String(totals.all)}
          subtitle={`Aralik: son ${days} gun`}
        />
        <MetricCard
          title="Success"
          value={loading ? '...' : String(totals.success)}
          valueClassName="text-green-600"
          subtitle={`Basari orani: ${loading ? '...' : `${successRate}%`}`}
        />
        <MetricCard
          title="Failed"
          value={loading ? '...' : String(totals.failed)}
          valueClassName="text-red-600"
          subtitle="Model/API/validation kaynakli"
        />
        <MetricCard
          title="Avg Ingredients"
          value={loading ? '...' : String(averageIngredientCount)}
          subtitle="Request basina ortalama"
        />
        <MetricCard
          title="Last Request"
          value={loading ? '...' : formatDateTime(lastRequestAt)}
          subtitle="History listesine gore"
        />
      </section>

      <section className="mt-4 grid grid-cols-1 gap-4 xl:grid-cols-2">
        <GenerationTrendChart data={generationCount} />
        <TopIngredientsChart data={topIngredients} />
        <SuccessFailedChart data={successFailureData} />
        <HourlyRequestChart data={hourlyTrend} />
      </section>

      <section className="mt-4 grid grid-cols-1 gap-4 xl:grid-cols-3">
        <InputTypeChart data={inputTypeData} />
        <TopFailureCodesCard topErrorCodes={topErrorCodes} />
      </section>

      <RecentRequestsTable history={history} loading={loading} />
    </main>
  );
}
