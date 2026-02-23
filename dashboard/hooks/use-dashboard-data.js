'use client';

import { useEffect, useState } from 'react';

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001/api';

export function useDashboardData({ days, statusFilter, inputTypeFilter }) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [summary, setSummary] = useState(null);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    let isMounted = true;
    const controller = new AbortController();

    async function loadData() {
      setLoading(true);
      setError('');

      try {
        const historyParams = new URLSearchParams({
          limit: '120',
          includeRecipe: 'true'
        });

        if (statusFilter !== 'all') {
          historyParams.set('status', statusFilter);
        }

        if (inputTypeFilter !== 'all') {
          historyParams.set('inputType', inputTypeFilter);
        }

        const [summaryRes, historyRes] = await Promise.all([
          fetch(`${API_BASE_URL}/analytics/summary?days=${days}`, {
            signal: controller.signal
          }),
          fetch(`${API_BASE_URL}/requests/history?${historyParams.toString()}`, {
            signal: controller.signal
          })
        ]);

        if (!summaryRes.ok || !historyRes.ok) {
          throw new Error('Failed to fetch dashboard data');
        }

        const [summaryJson, historyJson] = await Promise.all([
          summaryRes.json(),
          historyRes.json()
        ]);

        if (!isMounted) {
          return;
        }

        setSummary(summaryJson);
        setHistory(Array.isArray(historyJson.requests) ? historyJson.requests : []);
      } catch (error) {
        if (!isMounted || error?.name === 'AbortError') {
          return;
        }

        setError('Dashboard verisi alinamadi. Backend ve .env ayarlarini kontrol et.');
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    }

    loadData();

    return () => {
      isMounted = false;
      controller.abort();
    };
  }, [days, inputTypeFilter, statusFilter]);

  return {
    loading,
    error,
    summary,
    history
  };
}
