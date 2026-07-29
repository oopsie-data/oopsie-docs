---
title: Dataset Statistics
layout: default
nav_order: 5
permalink: /stats/
---

<style>
  /* Widen the Just the Docs shell on the stats page only. */
  @media (min-width: 50rem) {
    body:has(#stats-root) .main {
      max-width: var(--stats-content-max);
    }
  }
  @media (min-width: 66.5rem) {
    body:has(#stats-root) .side-bar {
      width: max(16.5rem, calc((100% - var(--stats-layout-max)) / 2 + 16.5rem));
    }
    body:has(#stats-root) .side-bar + .main {
      margin-left: max(16.5rem, calc((100% - var(--stats-layout-max)) / 2 + 16.5rem));
    }
  }
</style>

<script>
  window.__OOPSIE_STATS_URL__ = "{{ '/assets/data/stats.json' | relative_url }}?v=3";
</script>

{% include stats-dashboard.html %}
