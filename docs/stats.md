---
title: Dataset Statistics
layout: default
nav_order: 5
permalink: /stats/
---

<style>
  :root {
    --stats-surface: #ffffff;
    --stats-surface-2: #f8fafc;
    --stats-surface-3: #f1f5f9;
    --stats-border: #e2e8f0;
    --stats-border-strong: #cbd5e1;
    --stats-ink: #0f172a;
    --stats-ink-soft: #334155;
    --stats-ink-muted: #64748b;
    --stats-ink-faint: #94a3b8;
    --stats-accent: #0ea5e9;
    --cat-0: #0ea5e9;
    --cat-1: #8b5cf6;
    --cat-2: #f59e0b;
    --cat-3: #10b981;
    --cat-4: #ef4444;
    --cat-5: #6366f1;
    --cat-6: #14b8a6;
    --cat-7: #f97316;
    --cat-8: #ec4899;
    --cat-9: #84cc16;
    --shadow-sm: 0 1px 2px rgb(15 23 42 / 0.04), 0 1px 3px rgb(15 23 42 / 0.06);
    --shadow-md: 0 4px 6px -1px rgb(15 23 42 / 0.06), 0 2px 4px -2px rgb(15 23 42 / 0.06);
    --radius: 14px;
    --radius-sm: 8px;
    --ease: cubic-bezier(0.16, 1, 0.3, 1);
    --dur: 240ms;
  }

  .oopsie-stats {
    color: var(--stats-ink);
    font-feature-settings: "tnum", "ss01";
  }

  .oopsie-stats *,
  .oopsie-stats *::before,
  .oopsie-stats *::after {
    box-sizing: border-box;
  }

  .stats-skeleton {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    margin: 0.5rem 0;
  }
  .stats-skel-row {
    height: 64px;
    border-radius: var(--radius);
    border: 1px solid var(--stats-border);
    background:
      linear-gradient(90deg,
        rgba(241,245,249,0) 0%,
        rgba(226,232,240,0.65) 45%,
        rgba(241,245,249,0) 100%),
      var(--stats-surface);
    background-size: 200% 100%, 100% 100%;
    background-repeat: no-repeat, no-repeat;
    background-position: -150% 0, 0 0;
    animation: stats-shimmer 1.4s linear infinite;
  }
  @keyframes stats-shimmer {
    0%   { background-position: -150% 0, 0 0; }
    100% { background-position: 150% 0, 0 0; }
  }
  @media (prefers-reduced-motion: reduce) {
    .stats-skel-row { animation: none; }
  }

  #stats-error {
    margin: 0.5rem 0;
    padding: 0.85rem 1rem;
    border-radius: var(--radius-sm);
    border: 1px solid #fecaca;
    background: #fef2f2;
    color: #991b1b;
    font-size: 0.9rem;
  }

  #stats-dashboard {
    opacity: 0;
    transition: opacity 320ms var(--ease);
  }
  #stats-dashboard.is-ready { opacity: 1; }

  .stats-fold {
    position: relative;
    background: var(--stats-surface);
    border: 1px solid var(--stats-border);
    border-radius: var(--radius);
    margin-bottom: 0.75rem;
    box-shadow: var(--shadow-sm);
    transition:
      box-shadow var(--dur) var(--ease),
      border-color var(--dur) var(--ease);
    overflow: hidden;
  }
  .stats-fold:hover {
    border-color: var(--stats-border-strong);
  }
  .stats-fold[data-open="true"] {
    box-shadow: var(--shadow-md);
  }
  .stats-fold::before {
    content: "";
    position: absolute;
    inset: 0 auto 0 0;
    width: 3px;
    background: var(--accent, var(--stats-accent));
    opacity: 0;
    transition: opacity var(--dur) var(--ease);
    pointer-events: none;
  }
  .stats-fold[data-open="true"]::before { opacity: 1; }

  .stats-fold-contribution { --accent: var(--cat-0); }
  .stats-fold-dataset      { --accent: var(--cat-1); }
  .stats-fold-annotation   { --accent: var(--cat-2); }

  .stats-fold-summary {
    display: flex;
    align-items: center;
    gap: 0.9rem;
    width: 100%;
    margin: 0;
    padding: 1rem 1.1rem;
    background: transparent;
    border: 0;
    border-radius: 0;
    cursor: pointer;
    text-align: left;
    color: inherit;
    font: inherit;
    transition: background var(--dur) var(--ease);
  }
  .stats-fold-summary:hover { background: var(--stats-surface-2); }
  .stats-fold-summary:focus-visible {
    outline: 2px solid var(--stats-accent);
    outline-offset: -2px;
  }

  .stats-fold-chevron {
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    color: var(--stats-ink-muted);
    transition: transform var(--dur) var(--ease), color var(--dur) var(--ease);
  }
  .stats-fold[data-open="true"] .stats-fold-chevron {
    transform: rotate(90deg);
    color: var(--stats-ink);
  }

  .stats-fold-meta {
    display: flex;
    flex-direction: column;
    flex: 1 1 auto;
    min-width: 0;
    gap: 0.15rem;
  }
  .stats-fold-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    font-size: 0.68rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: var(--stats-ink-faint);
  }
  .stats-fold-eyebrow-num {
    font-family: ui-monospace, "SFMono-Regular", "JetBrains Mono", Menlo, monospace;
    font-size: 0.68rem;
    font-weight: 500;
    color: var(--accent, var(--stats-ink-faint));
    opacity: 0.85;
  }
  .stats-fold-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--stats-ink);
    line-height: 1.25;
  }
  .stats-fold-hint {
    font-size: 0.85rem;
    color: var(--stats-ink-muted);
    line-height: 1.35;
  }

  .stats-fold-body-wrap {
    display: grid;
    grid-template-rows: 0fr;
    transition: grid-template-rows var(--dur) var(--ease);
  }
  .stats-fold[data-open="true"] .stats-fold-body-wrap {
    grid-template-rows: 1fr;
  }
  .stats-fold-body {
    overflow: hidden;
    min-height: 0;
  }
  .stats-fold-body-inner {
    padding: 0.25rem 1.25rem 1.5rem;
    border-top: 1px solid var(--stats-border);
  }
  @media (prefers-reduced-motion: reduce) {
    .stats-fold-body-wrap { transition: none; }
    .stats-fold-chevron { transition: none; }
  }

  .stats-fold-body-inner h3 {
    position: sticky;
    top: 0;
    margin: 1.25rem -1.25rem 0.65rem;
    padding: 0.65rem 1.25rem 0.5rem;
    background: linear-gradient(180deg, rgb(255 255 255 / 0.96) 70%, rgb(255 255 255 / 0.7));
    backdrop-filter: saturate(180%) blur(6px);
    z-index: 4;
    font-size: 0.72rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: var(--stats-ink-soft);
    border-bottom: 1px solid var(--stats-border);
  }
  .stats-fold-body-inner h3:first-child {
    margin-top: 0.25rem;
  }
  .stats-fold-body-inner h4 {
    margin: 0 0 0.5rem;
    font-size: 0.92rem;
    font-weight: 600;
    color: var(--stats-ink);
    letter-spacing: -0.005em;
  }

  .oopsie-grid-2 {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1.5rem;
    align-items: start;
  }
  .stats-dataset-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.25rem 2rem;
    align-items: start;
  }
  @media (max-width: 720px) {
    .stats-dataset-grid { grid-template-columns: 1fr; }
  }
  .stats-dataset-pie-cell {
    min-width: 0;
  }
  .stats-dataset-actions-band {
    grid-column: 1 / -1;
    margin-top: 0.15rem;
    padding-top: 1.35rem;
    border-top: 1px solid var(--stats-border);
  }
  .stats-dataset-actions-inner {
    max-width: min(460px, 100%);
    margin-left: auto;
    margin-right: auto;
  }
  .oopsie-kpi-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 0.75rem;
    margin-top: 0.5rem;
  }
  .oopsie-kpi-card {
    position: relative;
    padding: 0.95rem 1rem 0.85rem;
    background: var(--stats-surface);
    border: 1px solid var(--stats-border);
    border-radius: var(--radius-sm);
    overflow: hidden;
    transition: border-color var(--dur) var(--ease), box-shadow var(--dur) var(--ease);
  }
  .oopsie-kpi-card:hover {
    border-color: var(--stats-border-strong);
    box-shadow: var(--shadow-sm);
  }
  .oopsie-kpi-card::after {
    content: "";
    position: absolute;
    inset: auto 0 0 0;
    height: 2px;
    background: var(--accent, var(--stats-accent));
    opacity: 0.85;
  }
  .oopsie-kpi-card .kpi-label {
    font-size: 0.66rem;
    color: var(--stats-ink-muted);
    text-transform: uppercase;
    letter-spacing: 0.08em;
    font-weight: 600;
  }
  .oopsie-kpi-card .kpi-value {
    margin-top: 0.2rem;
    font-size: 1.7rem;
    font-weight: 600;
    line-height: 1.15;
    color: var(--stats-ink);
    font-variant-numeric: tabular-nums;
    letter-spacing: -0.015em;
  }
  .oopsie-kpi-card .kpi-sub {
    margin-top: 0.15rem;
    font-size: 0.75rem;
    color: var(--stats-ink-faint);
    font-variant-numeric: tabular-nums;
    min-height: 1em;
  }

  .stats-lab-charts { margin-top: 0.25rem; }
  .stats-lab-pie-col {
    text-align: center;
  }
  .stats-lab-pie-col .stats-pie-total {
    margin: 0 0 0.5rem;
    font-size: 0.78rem;
    color: var(--stats-ink-muted);
    font-variant-numeric: tabular-nums;
  }
  .stats-lab-pie-col canvas {
    display: block;
    margin: 0 auto;
    max-width: 100%;
  }
  .stats-lab-legend-wrap {
    margin-top: 0.85rem;
    padding-top: 0.85rem;
    border-top: 1px dashed var(--stats-border);
  }
  .stats-lab-legend-eyebrow {
    font-size: 0.66rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: var(--stats-ink-faint);
    margin-bottom: 0.45rem;
    text-align: center;
  }
  .stats-lab-legend {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.4rem 0.5rem;
  }
  .stats-lab-legend-item {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.25rem 0.6rem 0.25rem 0.45rem;
    background: var(--stats-surface);
    border: 1px solid var(--stats-border);
    border-radius: 999px;
    font-size: 0.78rem;
    color: var(--stats-ink-soft);
    font-variant-numeric: tabular-nums;
    transition: border-color var(--dur) var(--ease), background var(--dur) var(--ease);
  }
  .stats-lab-legend-item:hover {
    border-color: var(--stats-border-strong);
    background: var(--stats-surface-2);
  }
  .stats-lab-legend-swatch {
    width: 8px;
    height: 8px;
    border-radius: 2px;
    flex-shrink: 0;
  }

  .stats-time-wrap { margin-top: 0.25rem; }
  .stats-time-controls {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    margin-bottom: 0.85rem;
  }
  .stats-time-controls-label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    font-weight: 600;
    color: var(--stats-ink-faint);
  }
  .stats-seg {
    position: relative;
    display: inline-flex;
    background: var(--stats-surface-3);
    border: 1px solid var(--stats-border);
    border-radius: 999px;
    padding: 3px;
    isolation: isolate;
  }
  .stats-seg-opt {
    position: relative;
    z-index: 1;
    border: 0;
    background: transparent;
    padding: 0.4rem 0.95rem;
    font-size: 0.82rem;
    font-weight: 500;
    color: var(--stats-ink-muted);
    cursor: pointer;
    border-radius: 999px;
    transition: color var(--dur) var(--ease);
    font-family: inherit;
  }
  .stats-seg-opt:hover { color: var(--stats-ink-soft); }
  .stats-seg-opt[aria-selected="true"] {
    color: var(--stats-ink);
    font-weight: 600;
  }
  .stats-seg-opt:focus-visible {
    outline: 2px solid var(--stats-accent);
    outline-offset: -2px;
  }
  .stats-seg-indicator {
    position: absolute;
    top: 3px;
    bottom: 3px;
    left: var(--seg-x, 3px);
    width: var(--seg-w, 0);
    background: var(--stats-surface);
    border-radius: 999px;
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.08), 0 1px 3px rgb(15 23 42 / 0.06);
    transition: left var(--dur) var(--ease), width var(--dur) var(--ease);
    z-index: 0;
  }
  @media (prefers-reduced-motion: reduce) {
    .stats-seg-indicator { transition: none; }
  }

  .stats-time-panel { margin-top: 0.25rem; }
  .stats-time-panel-title {
    margin: 0 0 0.4rem;
    font-size: 0.95rem;
    font-weight: 600;
    color: var(--stats-ink);
    letter-spacing: -0.005em;
  }
  .stats-time-panel-desc {
    margin: 0 0 0.85rem;
    font-size: 0.82rem;
    color: var(--stats-ink-muted);
    line-height: 1.45;
    max-width: 44rem;
  }
  .stats-annot-lab-desc {
    margin: 0.2rem 0 0.85rem;
    font-size: 0.82rem;
    color: var(--stats-ink-muted);
    line-height: 1.45;
    max-width: 44rem;
  }

  .stats-failures-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.5rem 1.75rem;
    align-items: stretch;
  }
  @media (max-width: 720px) {
    .stats-failures-grid { grid-template-columns: 1fr; }
  }
  .stats-failures-grid .stats-pie-card {
    min-width: 0;
    display: flex;
    flex-direction: column;
    background: var(--stats-surface);
    border: 1px solid var(--stats-border);
    border-radius: 12px;
    padding: 1rem 1rem 1.1rem;
    box-shadow: 0 1px 2px rgb(15 23 42 / 0.04);
  }
  .stats-pie-card h4 {
    margin: 0 0 0.85rem;
    font-size: 0.92rem;
    font-weight: 600;
    color: var(--stats-ink);
    letter-spacing: -0.005em;
    text-align: center;
  }
  .stats-pie-canvas-wrap {
    position: relative;
    width: 100%;
    min-height: 260px;
  }
  .stats-failure-pie-split {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.95rem;
    min-width: 0;
    width: 100%;
    flex: 1;
  }
  .stats-failure-pie-plot {
    position: relative;
    box-sizing: border-box;
    width: min(300px, 100%);
    max-width: 100%;
    aspect-ratio: 1 / 1;
    height: auto;
    flex-shrink: 0;
    overflow: hidden;
  }
  .stats-failure-pie-plot canvas {
    display: block;
    width: 100% !important;
    height: 100% !important;
    max-width: 100% !important;
    max-height: 100% !important;
    box-sizing: border-box;
  }
  .stats-failure-pie-legend {
    width: 100%;
    max-width: 100%;
    min-width: 0;
    box-sizing: border-box;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr));
    gap: 0.4rem 0.75rem;
    align-items: start;
    font-size: 0.72rem;
    line-height: 1.35;
    color: var(--stats-ink-soft);
    max-height: min(240px, 38vh);
    overflow-y: auto;
    overflow-x: hidden;
    padding: 0.85rem 0.15rem 0.1rem;
    margin: 0;
    border-top: 1px solid var(--stats-border);
    scrollbar-gutter: stable;
  }
  .stats-failure-pie-legend-item {
    display: flex;
    align-items: flex-start;
    gap: 0.45rem;
    min-width: 0;
  }
  .stats-failure-pie-legend-swatch {
    width: 7px;
    height: 7px;
    border-radius: 2px;
    flex-shrink: 0;
    margin-top: 0.28em;
    box-shadow: inset 0 0 0 1px rgb(15 23 42 / 0.06);
  }
  .stats-failure-pie-legend-label {
    flex: 1;
    min-width: 0;
    word-break: break-word;
    hyphens: auto;
  }
  .stats-failure-pie-legend-count {
    font-variant-numeric: tabular-nums;
    color: var(--stats-ink-muted);
    flex-shrink: 0;
    font-size: 0.68rem;
  }
</style>

<div id="stats-root" class="oopsie-stats">
  <div id="stats-skeleton" class="stats-skeleton" aria-hidden="true">
    <div class="stats-skel-row"></div>
    <div class="stats-skel-row"></div>
    <div class="stats-skel-row"></div>
  </div>
  <p id="stats-error" style="display:none;"></p>

  <div id="stats-dashboard" hidden>
    <section class="stats-fold stats-fold-contribution" data-key="contribution" data-open="false">
      <button type="button" class="stats-fold-summary" aria-expanded="false" aria-controls="stats-body-contribution">
        <svg class="stats-fold-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <polyline points="9 6 15 12 9 18"></polyline>
        </svg>
        <span class="stats-fold-meta">
          <span class="stats-fold-eyebrow">
            <span class="stats-fold-eyebrow-num">01</span>
            <span>Contribution</span>
          </span>
          <span class="stats-fold-title">Where the data comes from</span>
          <span class="stats-fold-hint">Labs, hours, and how submissions grow over time.</span>
        </span>
      </button>
      <div class="stats-fold-body-wrap">
        <div class="stats-fold-body" id="stats-body-contribution" role="region" aria-label="Contribution statistics">
          <div class="stats-fold-body-inner">
            <h3>By lab</h3>
            <div class="stats-lab-charts">
              <div class="oopsie-grid-2">
                <div class="stats-lab-pie-col">
                  <h4>Episodes per lab</h4>
                  <p class="stats-pie-total" id="stats-pie-eps-total">&nbsp;</p>
                  <canvas id="chart-lab-episodes" height="280"></canvas>
                </div>
                <div class="stats-lab-pie-col">
                  <h4>Hours per lab</h4>
                  <p class="stats-pie-total" id="stats-pie-hours-total">&nbsp;</p>
                  <canvas id="chart-lab-hours" height="280"></canvas>
                </div>
              </div>
              <div class="stats-lab-legend-wrap">
                <div class="stats-lab-legend-eyebrow">Labs</div>
                <div id="stats-lab-legend" class="stats-lab-legend" role="list" aria-label="Labs (colors match both charts)"></div>
              </div>
            </div>

            <h3>Over time</h3>
            <div class="stats-time-wrap">
              <div class="stats-time-controls">
                <span class="stats-time-controls-label">View</span>
                <div class="stats-seg" role="tablist" id="stats-time-seg">
                  <button type="button" class="stats-seg-opt" role="tab" aria-selected="true" data-view="cumulative">Cumulative</button>
                  <button type="button" class="stats-seg-opt" role="tab" aria-selected="false" data-view="perday">Per day</button>
                  <span class="stats-seg-indicator" aria-hidden="true"></span>
                </div>
              </div>
              <div class="stats-time-panel" data-time-view="cumulative" id="stats-time-panel-cumulative">
                <h4 class="stats-time-panel-title">Cumulative episodes</h4>
                <canvas id="chart-time-cumulative" height="160"></canvas>
              </div>
              <div class="stats-time-panel" data-time-view="perday" id="stats-time-panel-perday" hidden>
                <h4 class="stats-time-panel-title">Episodes per day</h4>
                <p class="stats-time-panel-desc">Each bar is total episodes submitted that day; colored segments show how much each lab contributed (same lab colors as the pie charts above).</p>
                <canvas id="chart-time-perday" height="220"></canvas>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="stats-fold stats-fold-dataset" data-key="dataset" data-open="false">
      <button type="button" class="stats-fold-summary" aria-expanded="false" aria-controls="stats-body-dataset">
        <svg class="stats-fold-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <polyline points="9 6 15 12 9 18"></polyline>
        </svg>
        <span class="stats-fold-meta">
          <span class="stats-fold-eyebrow">
            <span class="stats-fold-eyebrow-num">02</span>
            <span>Dataset</span>
          </span>
          <span class="stats-fold-title">What the data looks like</span>
          <span class="stats-fold-hint">Robots, policies, and action-space composition.</span>
        </span>
      </button>
      <div class="stats-fold-body-wrap">
        <div class="stats-fold-body" id="stats-body-dataset" role="region" aria-label="Dataset statistics">
          <div class="stats-fold-body-inner">
            <h3>Composition</h3>
            <div class="stats-dataset-grid">
              <div class="stats-lab-pie-col stats-dataset-pie-cell">
                <h4>Robot type</h4>
                <canvas id="chart-robot" height="260"></canvas>
              </div>
              <div class="stats-lab-pie-col stats-dataset-pie-cell">
                <h4>Policy type</h4>
                <canvas id="chart-policy" height="260"></canvas>
              </div>
              <div class="stats-dataset-actions-band">
                <div class="stats-lab-pie-col stats-dataset-actions-inner">
                  <h4>Action space</h4>
                  <canvas id="chart-actions" height="260"></canvas>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="stats-fold stats-fold-annotation" data-key="annotation" data-open="false">
      <button type="button" class="stats-fold-summary" aria-expanded="false" aria-controls="stats-body-annotation">
        <svg class="stats-fold-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <polyline points="9 6 15 12 9 18"></polyline>
        </svg>
        <span class="stats-fold-meta">
          <span class="stats-fold-eyebrow">
            <span class="stats-fold-eyebrow-num">03</span>
            <span>Annotation</span>
          </span>
          <span class="stats-fold-title">How the data is labeled</span>
          <span class="stats-fold-hint">S/F coverage, failure descriptions, taxonomy.</span>
        </span>
      </button>
      <div class="stats-fold-body-wrap">
        <div class="stats-fold-body" id="stats-body-annotation" role="region" aria-label="Annotation statistics">
          <div class="stats-fold-body-inner">
            <h3>At a glance</h3>
            <div class="oopsie-kpi-grid">
              <div class="oopsie-kpi-card">
                <div class="kpi-label">Annotated S/F</div>
                <div class="kpi-value" id="kpi-annot-pct">0%</div>
                <div class="kpi-sub" id="kpi-annot-sub">&nbsp;</div>
              </div>
              <div class="oopsie-kpi-card">
                <div class="kpi-label">Successes</div>
                <div class="kpi-value" id="kpi-succ">0</div>
                <div class="kpi-sub" id="kpi-succ-sub">&nbsp;</div>
              </div>
              <div class="oopsie-kpi-card">
                <div class="kpi-label">Failures</div>
                <div class="kpi-value" id="kpi-fail">0</div>
                <div class="kpi-sub" id="kpi-fail-sub">&nbsp;</div>
              </div>
              <div class="oopsie-kpi-card">
                <div class="kpi-label">Annotated failure description</div>
                <div class="kpi-value" id="kpi-desc-pct">0%</div>
                <div class="kpi-sub" id="kpi-desc-sub">&nbsp;</div>
              </div>
            </div>

            <h3>Coverage</h3>
            <div class="oopsie-grid-2">
              <div class="stats-lab-pie-col">
                <h4>S/F annotation coverage</h4>
                <canvas id="chart-annot-donut" height="240"></canvas>
              </div>
              <div class="stats-lab-pie-col">
                <h4>Failure description coverage (of failures)</h4>
                <canvas id="chart-desc-donut" height="240"></canvas>
              </div>
            </div>

            <h3>Per lab: failure-description share of collected episodes</h3>
            <p class="stats-annot-lab-desc">Height of each bar is the percentage of that lab's collected episodes that include a failure-description annotation. Hover a bar for the exact episode counts.</p>
            <div>
              <canvas id="chart-annot-lab" height="280"></canvas>
            </div>

            <h3>Failures, by category and severity</h3>
            <p class="stats-annot-lab-desc">Slices are shares among <strong>annotated failure</strong> episodes only.</p>
            <div class="stats-failures-grid">
              <div class="stats-pie-card">
                <h4>Failure categories</h4>
                <div class="stats-failure-pie-split">
                  <div class="stats-failure-pie-plot">
                    <canvas id="chart-failcat" width="300" height="300"></canvas>
                  </div>
                  <div id="legend-failcat" class="stats-failure-pie-legend" role="list" aria-label="Failure category counts"></div>
                </div>
              </div>
              <div class="stats-pie-card">
                <h4>Severity</h4>
                <div class="stats-failure-pie-split">
                  <div class="stats-failure-pie-plot">
                    <canvas id="chart-severity" width="300" height="300"></canvas>
                  </div>
                  <div id="legend-severity" class="stats-failure-pie-legend" role="list" aria-label="Severity counts"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js" crossorigin="anonymous"></script>
<script>
(function () {
  const STATS_URL = "{{ '/assets/data/stats.json' | relative_url }}";

  /*
   * Robot type pie: merge raw per_robot keys into display groups.
   * Rules run top to bottom; the first rule where ANY keyword is a substring of
   * the raw id (case-insensitive) wins. Add rows here as new hardware shows up.
   */
  var ROBOT_GROUP_RULES = [
    { label: 'Franka Panda', keys: ['franka', 'panda'] },
    { label: 'UR5', keys: ['ur5', 'ur_5'] },
  ];

  /*
   * Full failure-category taxonomy (checkbox labels). Keep in sync with:
   * oopsie-tools/oopsie_tools/annotation_tool/templates/questionnaire.yaml
   * plus sweep fallback label for missing / non-matching keys.
   */
  var FAILURE_TAXONOMY_CATEGORIES = [
    'Reaching failure (pre contact)',
    'Grasp failure (at contact)',
    'Manipulation failure (post contact)',
    'Sequencing or semantic failure',
    'Collision failure',
    'Hardware/mechanical issue',
    'Task not attempted',
    'unknown',
  ];

  /*
   * Severity: three radio options from questionnaire.yaml, plus not specified.
   * Keep full strings in sync with:
   * oopsie-tools/oopsie_tools/annotation_tool/templates/questionnaire.yaml
   */
  var SEVERITY_QUESTIONNAIRE_FULL = [
    'Low severity - no damage, can be reset and reattempted',
    'Medium severity - some damage or risk of damage or significant reset required, but can be reattempted',
    'Catastrophic - significant damage or risk of damage, cannot be reattempted without repair',
  ];
  var SEVERITY_CHART_LABELS = ['Low', 'Medium', 'Catastrophic', 'Not specified'];

  const skeletonEl = document.getElementById('stats-skeleton');
  const errorEl = document.getElementById('stats-error');
  const dashEl = document.getElementById('stats-dashboard');

  /* Categorical palette (replaces HSL rainbow). */
  const CAT = ['#0ea5e9', '#8b5cf6', '#f59e0b', '#10b981', '#ef4444',
               '#6366f1', '#14b8a6', '#f97316', '#ec4899', '#84cc16'];
  function hue(i) { return CAT[((i % CAT.length) + CAT.length) % CAT.length]; }

  const palette = {
    accent:  '#0ea5e9',
    success: '#16a34a',
    failure: '#ef4444',
    neutral: '#475569',
    muted:   '#cbd5e1',
    grid:    '#eef2f7',
  };

  /* Shared Chart.js defaults. */
  if (typeof Chart !== 'undefined') {
    Chart.defaults.font.family = "ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial";
    Chart.defaults.font.size = 12;
    Chart.defaults.color = '#475569';
    Chart.defaults.borderColor = '#e2e8f0';
    Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15,23,42,0.92)';
    Chart.defaults.plugins.tooltip.padding = 10;
    Chart.defaults.plugins.tooltip.cornerRadius = 8;
    Chart.defaults.plugins.tooltip.titleColor = '#f8fafc';
    Chart.defaults.plugins.tooltip.bodyColor = '#e2e8f0';
    Chart.defaults.plugins.tooltip.boxPadding = 4;
    Chart.defaults.plugins.tooltip.titleFont = { weight: '600', size: 12 };
    Chart.defaults.plugins.tooltip.bodyFont = { size: 12 };
    Chart.defaults.plugins.tooltip.displayColors = true;
    Chart.defaults.plugins.legend.labels.boxWidth = 8;
    Chart.defaults.plugins.legend.labels.boxHeight = 8;
    Chart.defaults.plugins.legend.labels.usePointStyle = true;
    Chart.defaults.plugins.legend.labels.padding = 12;
    Chart.defaults.plugins.legend.labels.color = '#475569';
    Chart.defaults.elements.arc.borderWidth = 0;
  }

  function formatTimelineDateLabel(d) {
    return d === 'unrecorded' ? 'No timestamp' : d;
  }

  function showError(html) {
    if (skeletonEl) skeletonEl.style.display = 'none';
    errorEl.innerHTML = html;
    errorEl.style.display = 'block';
  }

  function parseFailureCategoryAggregateKey(key) {
    var s = String(key).trim();
    if (s.charAt(0) === '[') {
      try {
        var arr = JSON.parse(s.replace(/'/g, '"'));
        if (Array.isArray(arr)) {
          return arr.map(function (x) { return String(x).trim(); }).filter(Boolean);
        }
      } catch (e) { /* fall through */ }
    }
    return [s];
  }

  function canonicalFailureCategory(part, canonicalOrder) {
    var pl = String(part).trim().toLowerCase();
    if (!pl) return null;
    for (var i = 0; i < canonicalOrder.length; i++) {
      var c = canonicalOrder[i];
      if (c === 'unknown') continue;
      if (c.toLowerCase() === pl) return c;
    }
    var nonUnknown = canonicalOrder.filter(function (c) { return c !== 'unknown'; });
    nonUnknown.sort(function (a, b) { return b.length - a.length; });
    for (var j = 0; j < nonUnknown.length; j++) {
      var c2 = nonUnknown[j];
      if (pl.indexOf(c2.toLowerCase()) !== -1) return c2;
    }
    return null;
  }

  function failureCategoryFullPieSeries(raw, canonicalOrder) {
    var counts = {};
    canonicalOrder.forEach(function (c) { counts[c] = 0; });
    Object.keys(raw || {}).forEach(function (key) {
      var v = Number(raw[key]);
      if (!v || isNaN(v)) return;
      var parts = parseFailureCategoryAggregateKey(key);
      var targets = {};
      if (parts.length === 0) {
        targets.unknown = true;
      } else {
        parts.forEach(function (part) {
          var canon = canonicalFailureCategory(part, canonicalOrder) || 'unknown';
          targets[canon] = true;
        });
      }
      Object.keys(targets).forEach(function (canon) {
        counts[canon] = (counts[canon] || 0) + v;
      });
    });
    var labels = canonicalOrder.slice();
    var values = labels.map(function (l) { return counts[l] || 0; });
    return { labels: labels, values: values };
  }

  function mapRawSeverityToBucket(rawKey) {
    var s = String(rawKey || '').trim();
    var low = s.toLowerCase();
    if (!low || low === 'unknown') return 3;
    var three = SEVERITY_QUESTIONNAIRE_FULL;
    for (var i = 0; i < three.length; i++) {
      if (three[i].toLowerCase() === low) return i;
    }
    if (low.indexOf('catastrophic') !== -1) return 2;
    if (low.indexOf('medium severity') !== -1) return 1;
    if (low.indexOf('low severity') !== -1) return 0;
    return 3;
  }

  function severityThreePieSeries(raw) {
    var n = SEVERITY_CHART_LABELS.length;
    var values = [];
    for (var k = 0; k < n; k++) values[k] = 0;
    Object.keys(raw || {}).forEach(function (key) {
      var v = Number(raw[key]);
      if (!v || isNaN(v)) return;
      var idx = mapRawSeverityToBucket(key);
      values[idx] += v;
    });
    var tip = SEVERITY_QUESTIONNAIRE_FULL.slice();
    tip.push('No severity in taxonomy, or label did not match the questionnaire.');
    return {
      labels: SEVERITY_CHART_LABELS.slice(),
      values: values,
      tooltipAfterLabel: tip,
    };
  }

  function pct(num, den) {
    if (!den) return '0%';
    return Math.round((num / den) * 100) + '%';
  }

  function fmt(n) {
    if (n == null || isNaN(n)) return '0';
    return Number(n).toLocaleString();
  }

  function prettifyRobotKey(raw) {
    var s = String(raw).replace(/_/g, ' ');
    return s.replace(/\b\w/g, function (ch) { return ch.toUpperCase(); });
  }

  function robotGroupLabel(raw) {
    var lower = String(raw).toLowerCase();
    for (var i = 0; i < ROBOT_GROUP_RULES.length; i++) {
      var rule = ROBOT_GROUP_RULES[i];
      var keys = rule.keys || [];
      for (var j = 0; j < keys.length; j++) {
        if (lower.indexOf(String(keys[j]).toLowerCase()) !== -1) {
          return rule.label;
        }
      }
    }
    return prettifyRobotKey(raw);
  }

  function aggregateRobotEpisodesByGroup(perRobot) {
    var agg = {};
    Object.keys(perRobot || {}).forEach(function (raw) {
      var row = perRobot[raw];
      var ep = row && row.episodes ? row.episodes : 0;
      var lab = robotGroupLabel(raw);
      agg[lab] = (agg[lab] || 0) + ep;
    });
    return agg;
  }

  const charts = {};
  var statsData = null;
  var rendered = { contribution: false, dataset: false, annotation: false };
  var timeViewState = { wired: false, data: null, built: { cumulative: false, perday: false }, current: 'cumulative' };

  function destroy(name) {
    if (charts[name]) { charts[name].destroy(); delete charts[name]; }
  }

  function resizeChartsIn(root) {
    if (!root || !root.querySelectorAll) return;
    root.querySelectorAll('canvas').forEach(function (cnv) {
      var ch = typeof Chart !== 'undefined' && Chart.getChart ? Chart.getChart(cnv) : null;
      if (ch && typeof ch.resize === 'function') ch.resize();
    });
  }

  /* Y-axis scale shared by bar/line charts. */
  function yScale() {
    return {
      beginAtZero: true,
      grid: { color: palette.grid, drawBorder: false, borderDash: [3, 3] },
      border: { display: false },
      ticks: { color: '#64748b', font: { size: 11 }, padding: 6 },
    };
  }
  function xScale(extra) {
    return Object.assign({
      grid: { display: false },
      border: { display: false },
      ticks: { color: '#64748b', font: { size: 11 }, padding: 4 },
    }, extra || {});
  }

  function pie(canvasId, labels, values, pieOpts) {
    pieOpts = pieOpts || {};
    var showLegend = pieOpts.legend !== false;
    destroy(canvasId);
    var el = document.getElementById(canvasId);
    if (!el) return;
    if (!labels || labels.length === 0) return;
    var leg = {
      display: showLegend,
      position: 'bottom',
      align: 'center',
      labels: {
        boxWidth: 8,
        boxHeight: 8,
        padding: 10,
        font: { size: 11 },
        usePointStyle: true,
      },
    };
    if (pieOpts.legend && typeof pieOpts.legend === 'object') {
      Object.keys(pieOpts.legend).forEach(function (key) {
        if (key === 'labels' && pieOpts.legend.labels && typeof pieOpts.legend.labels === 'object') {
          leg.labels = Object.assign({}, leg.labels, pieOpts.legend.labels);
        } else {
          leg[key] = pieOpts.legend[key];
        }
      });
    }
    var plugins = { legend: leg };
    var ttCallbacks = {};
    if (pieOpts.failureContext && pieOpts.failureContext.total != null) {
      var tf = pieOpts.failureContext.total;
      var vals = values || [];
      var mmNote = pieOpts.failureContext.sliceMismatchNote;
      ttCallbacks.footer = function () {
        var sum = vals.reduce(function (a, b) { return a + (Number(b) || 0); }, 0);
        var out = 'Annotated failures in dataset: ' + fmt(tf) + ' (slice counts sum to ' + fmt(sum) + ').';
        if (sum !== tf && mmNote !== false) {
          out += (typeof mmNote === 'string' ? mmNote
            : ' Sums can differ when a failure is tagged with multiple categories.');
        }
        return out;
      };
    }
    if (pieOpts.tooltipAfterLabel && pieOpts.tooltipAfterLabel.length === labels.length) {
      ttCallbacks.afterLabel = function (ctx) {
        var line = pieOpts.tooltipAfterLabel[ctx.dataIndex];
        return line || '';
      };
    }
    if (Object.keys(ttCallbacks).length) {
      plugins.tooltip = { callbacks: ttCallbacks };
    }
    var chartOpts = {
      responsive: true,
      plugins: plugins,
    };
    if (pieOpts.maintainAspectRatio === false) {
      chartOpts.maintainAspectRatio = false;
    } else if (pieOpts.aspectRatio != null && !isNaN(pieOpts.aspectRatio)) {
      chartOpts.maintainAspectRatio = true;
      chartOpts.aspectRatio = pieOpts.aspectRatio;
    }
    charts[canvasId] = new Chart(el, {
      type: 'pie',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: labels.map(function (_, i) { return hue(i); }),
          borderColor: '#ffffff',
          borderWidth: 1,
          hoverOffset: 4,
        }],
      },
      options: chartOpts,
    });
  }

  function clearFailurePieLegend(elId) {
    var root = document.getElementById(elId);
    if (!root) return;
    while (root.firstChild) root.removeChild(root.firstChild);
  }

  function renderFailurePieLegend(elId, labels, values) {
    var root = document.getElementById(elId);
    if (!root) return;
    while (root.firstChild) root.removeChild(root.firstChild);
    (labels || []).forEach(function (lab, i) {
      var n = values && values[i] != null ? Number(values[i]) : 0;
      var row = document.createElement('div');
      row.className = 'stats-failure-pie-legend-item';
      row.setAttribute('role', 'listitem');
      var sw = document.createElement('span');
      sw.className = 'stats-failure-pie-legend-swatch';
      sw.style.backgroundColor = hue(i);
      sw.setAttribute('aria-hidden', 'true');
      var label = document.createElement('span');
      label.className = 'stats-failure-pie-legend-label';
      label.textContent = lab;
      var cnt = document.createElement('span');
      cnt.className = 'stats-failure-pie-legend-count';
      cnt.textContent = fmt(n);
      row.appendChild(sw);
      row.appendChild(label);
      row.appendChild(cnt);
      root.appendChild(row);
    });
  }

  function renderLabSharedLegend(containerId, labels) {
    var root = document.getElementById(containerId);
    if (!root) return;
    while (root.firstChild) root.removeChild(root.firstChild);
    labels.forEach(function (lab, i) {
      var item = document.createElement('span');
      item.className = 'stats-lab-legend-item';
      item.setAttribute('role', 'listitem');
      var sw = document.createElement('span');
      sw.className = 'stats-lab-legend-swatch';
      sw.setAttribute('aria-hidden', 'true');
      sw.style.backgroundColor = hue(i);
      item.appendChild(sw);
      item.appendChild(document.createTextNode(lab));
      root.appendChild(item);
    });
  }

  function donut(canvasId, labels, values, colors) {
    destroy(canvasId);
    charts[canvasId] = new Chart(document.getElementById(canvasId), {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: colors,
          borderWidth: 0,
          hoverOffset: 4,
        }],
      },
      options: {
        responsive: true,
        plugins: { legend: { position: 'bottom' } },
        cutout: '72%',
      },
    });
  }

  function buildTimeCumulativeChart(data) {
    const tl = data.submission_timeline || [];
    const dates = tl.map(function (r) { return r.date; });
    const cum = tl.map(function (r) { return r.cumulative; });
    destroy('chart-time-cumulative');

    function gradientFill(ctx) {
      var chart = ctx.chart;
      var area = chart.chartArea;
      if (!area) return 'rgba(14,165,233,0.18)';
      var g = chart.ctx.createLinearGradient(0, area.top, 0, area.bottom);
      g.addColorStop(0, 'rgba(14,165,233,0.22)');
      g.addColorStop(1, 'rgba(14,165,233,0)');
      return g;
    }

    charts['chart-time-cumulative'] = new Chart(document.getElementById('chart-time-cumulative'), {
      type: 'line',
      data: {
        labels: dates.map(formatTimelineDateLabel),
        datasets: [{
          label: 'Cumulative episodes',
          data: cum,
          borderColor: palette.accent,
          backgroundColor: gradientFill,
          fill: true,
          tension: 0.25,
          borderWidth: 2,
          pointRadius: 0,
          pointHoverRadius: 4,
          pointHoverBackgroundColor: palette.accent,
          pointHoverBorderColor: '#ffffff',
          pointHoverBorderWidth: 2,
        }],
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        plugins: { legend: { display: false } },
        scales: { x: xScale(), y: yScale() },
      },
    });
  }

  function buildTimePerDayChart(data) {
    const perLab = data.per_lab || {};
    const perLabTl = data.submission_timeline_per_lab || [];
    const canvasId = 'chart-time-perday';
    destroy(canvasId);
    var el = document.getElementById(canvasId);
    if (!el) return;

    if (!perLabTl.length) {
      const tl = data.submission_timeline || [];
      const dates = tl.map(function (r) { return r.date; });
      const perDay = tl.map(function (r) { return r.episodes; });
      charts[canvasId] = new Chart(el, {
        type: 'bar',
        data: {
          labels: dates.map(formatTimelineDateLabel),
          datasets: [{
            label: 'Episodes',
            data: perDay,
            backgroundColor: palette.accent,
            borderRadius: 4,
            borderSkipped: false,
            categoryPercentage: 0.85,
            barPercentage: 0.9,
          }],
        },
        options: {
          responsive: true,
          plugins: { legend: { display: false } },
          scales: {
            x: xScale({ ticks: { maxRotation: 45, minRotation: 0, color: '#64748b', font: { size: 11 } } }),
            y: yScale(),
          },
        },
      });
      return;
    }

    const dateSet = new Set();
    const labSet = new Set();
    perLabTl.forEach(function (r) { dateSet.add(r.date); labSet.add(r.lab_id); });
    const datesSorted = Array.from(dateSet).sort();
    const labsPieOrder = Object.keys(perLab).sort(function (a, b) {
      return ((perLab[b] && perLab[b].episodes) || 0) - ((perLab[a] && perLab[a].episodes) || 0);
    });
    var labHueIdx = new Map();
    labsPieOrder.forEach(function (lab, i) { labHueIdx.set(lab, i); });
    var labsSorted = Array.from(labSet).sort(function (a, b) {
      return ((perLab[b] && perLab[b].episodes) || 0) - ((perLab[a] && perLab[a].episodes) || 0);
    });
    const dateIdx = new Map(datesSorted.map(function (d, i) { return [d, i]; }));
    const series = labsSorted.map(function (lab, i) {
      const arr = new Array(datesSorted.length).fill(0);
      perLabTl.filter(function (r) { return r.lab_id === lab; })
              .forEach(function (r) { arr[dateIdx.get(r.date)] = r.episodes; });
      var hi = labHueIdx.has(lab) ? labHueIdx.get(lab) : labsPieOrder.length + i;
      return {
        label: lab,
        data: arr,
        backgroundColor: hue(hi),
        stack: 's',
        borderRadius: 4,
        borderSkipped: false,
        categoryPercentage: 0.85,
        barPercentage: 0.9,
      };
    });

    charts[canvasId] = new Chart(el, {
      type: 'bar',
      data: { labels: datesSorted.map(formatTimelineDateLabel), datasets: series },
      options: {
        responsive: true,
        plugins: { legend: { position: 'bottom' } },
        scales: {
          x: xScale({ stacked: true, ticks: { maxRotation: 45, minRotation: 0, color: '#64748b', font: { size: 11 } } }),
          y: Object.assign(yScale(), { stacked: true }),
        },
      },
    });
  }

  function ensureTimeChartsForView(view) {
    var data = timeViewState.data;
    if (!data) return;
    if (view === 'cumulative' && !timeViewState.built.cumulative) {
      buildTimeCumulativeChart(data);
      timeViewState.built.cumulative = true;
    } else if (view === 'perday' && !timeViewState.built.perday) {
      buildTimePerDayChart(data);
      timeViewState.built.perday = true;
    }
    var panel = document.querySelector('.stats-time-panel[data-time-view="' + view + '"]');
    if (panel) resizeChartsIn(panel);
  }

  function updateSegIndicator(segEl) {
    if (!segEl) return;
    var active = segEl.querySelector('.stats-seg-opt[aria-selected="true"]');
    if (!active) return;
    if (active.offsetWidth === 0) return;
    segEl.style.setProperty('--seg-x', active.offsetLeft + 'px');
    segEl.style.setProperty('--seg-w', active.offsetWidth + 'px');
  }

  function showTimeView(view) {
    timeViewState.current = view;
    document.querySelectorAll('.stats-time-panel').forEach(function (p) {
      var match = p.getAttribute('data-time-view') === view;
      if (match) p.removeAttribute('hidden'); else p.setAttribute('hidden', '');
    });
    var seg = document.getElementById('stats-time-seg');
    if (seg) {
      seg.querySelectorAll('.stats-seg-opt').forEach(function (b) {
        b.setAttribute('aria-selected', b.getAttribute('data-view') === view ? 'true' : 'false');
      });
      updateSegIndicator(seg);
    }
    ensureTimeChartsForView(view);
  }

  function wireTimeViewToggleOnce() {
    if (timeViewState.wired) return;
    timeViewState.wired = true;
    var seg = document.getElementById('stats-time-seg');
    if (!seg) return;
    seg.addEventListener('click', function (e) {
      var btn = e.target.closest('.stats-seg-opt');
      if (!btn) return;
      var view = btn.getAttribute('data-view');
      if (!view) return;
      showTimeView(view);
    });
    window.addEventListener('resize', function () { updateSegIndicator(seg); });
  }

  function renderContribution(data) {
    const perLab = data.per_lab || {};
    const labs = Object.keys(perLab).sort(function (a, b) {
      return (perLab[b].episodes || 0) - (perLab[a].episodes || 0);
    });

    pie('chart-lab-episodes', labs, labs.map(function (l) { return perLab[l].episodes || 0; }), { legend: false });
    pie('chart-lab-hours', labs, labs.map(function (l) { return perLab[l].duration_hours || 0; }), { legend: false });
    renderLabSharedLegend('stats-lab-legend', labs);

    var totalEps = labs.reduce(function (a, l) { return a + (perLab[l].episodes || 0); }, 0);
    var totalHours = labs.reduce(function (a, l) { return a + (perLab[l].duration_hours || 0); }, 0);
    var epsTotalEl = document.getElementById('stats-pie-eps-total');
    var hrsTotalEl = document.getElementById('stats-pie-hours-total');
    if (epsTotalEl) epsTotalEl.textContent = fmt(totalEps) + ' episodes total';
    if (hrsTotalEl) hrsTotalEl.textContent = totalHours.toFixed(2) + ' hours total';

    timeViewState.data = data;
    timeViewState.built = { cumulative: false, perday: false };
    wireTimeViewToggleOnce();
    showTimeView(timeViewState.current || 'cumulative');
  }

  function renderDataset(data) {
    const perRobot = data.per_robot || {};
    const groupedRobots = aggregateRobotEpisodesByGroup(perRobot);
    const robotLabels = Object.keys(groupedRobots).sort(function (a, b) {
      return (groupedRobots[b] || 0) - (groupedRobots[a] || 0);
    });
    pie('chart-robot', robotLabels, robotLabels.map(function (r) { return groupedRobots[r] || 0; }));

    const perPolicy = data.per_policy || {};
    const policyLabels = Object.keys(perPolicy).sort(function (a, b) {
      return (perPolicy[b].episodes || 0) - (perPolicy[a].episodes || 0);
    });
    pie('chart-policy', policyLabels, policyLabels.map(function (p) { return perPolicy[p].episodes || 0; }));

    const canonical = ['joint_position', 'joint_velocity', 'cartesian_position', 'cartesian_velocity'];
    const actionsRaw = data.action_spaces || {};
    const actionLabels = canonical.slice();
    const actionValues = canonical.map(function (k) { return actionsRaw[k] || 0; });
    var other = 0;
    Object.keys(actionsRaw).forEach(function (k) { if (canonical.indexOf(k) === -1) other += actionsRaw[k]; });
    if (other > 0) { actionLabels.push('other'); actionValues.push(other); }
    pie('chart-actions', actionLabels, actionValues);
  }

  function renderAnnotation(data) {
    const t = data.totals || {};
    const episodes = t.episodes || 0;
    const annotated = t.annotated_episodes || 0;
    const unannotated = Math.max(0, episodes - annotated);
    const successes = t.successes || 0;
    const failures = t.failures || 0;
    const descs = t.failure_descriptions || 0;
    const failuresWithoutDesc = Math.max(0, failures - descs);

    document.getElementById('kpi-annot-pct').textContent = pct(annotated, episodes);
    document.getElementById('kpi-succ').textContent = fmt(successes);
    document.getElementById('kpi-fail').textContent = fmt(failures);
    document.getElementById('kpi-desc-pct').textContent = pct(descs, failures);

    document.getElementById('kpi-annot-sub').textContent = fmt(annotated) + ' of ' + fmt(episodes) + ' episodes';
    document.getElementById('kpi-succ-sub').textContent = annotated ? (pct(successes, annotated) + ' of annotated') : 'none yet';
    document.getElementById('kpi-fail-sub').textContent = annotated ? (pct(failures, annotated) + ' of annotated') : 'none yet';
    document.getElementById('kpi-desc-sub').textContent = failures ? (fmt(descs) + ' of ' + fmt(failures) + ' failures') : 'no failures yet';

    donut('chart-annot-donut',
      ['Annotated', 'Unannotated'],
      [annotated, unannotated],
      [palette.accent, palette.muted]);

    donut('chart-desc-donut',
      ['With description', 'Missing description'],
      [descs, failuresWithoutDesc],
      [palette.success, palette.muted]);

    const perLab = data.per_lab || {};
    const labs = Object.keys(perLab).sort(function (a, b) {
      return (perLab[b].episodes || 0) - (perLab[a].episodes || 0);
    });
    const episodesPerLab = labs.map(function (l) { return perLab[l].episodes || 0; });
    const withDescPerLab = labs.map(function (l) {
      return perLab[l].failure_descriptions != null ? perLab[l].failure_descriptions : 0;
    });
    const pctDescPerLab = labs.map(function (l, i) {
      var ep = episodesPerLab[i];
      if (!ep) return 0;
      var p = (100 * withDescPerLab[i]) / ep;
      return p > 100 ? 100 : p;
    });

    destroy('chart-annot-lab');
    charts['chart-annot-lab'] = new Chart(document.getElementById('chart-annot-lab'), {
      type: 'bar',
      data: {
        labels: labs,
        datasets: [{
          label: 'Failure description rate',
          data: pctDescPerLab,
          backgroundColor: palette.accent,
          borderRadius: 4,
          borderSkipped: false,
          categoryPercentage: 0.72,
          barPercentage: 0.88,
        }],
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function (ctx) {
                var i = ctx.dataIndex;
                var pct = Math.round(pctDescPerLab[i] * 10) / 10;
                var w = withDescPerLab[i];
                var ep = episodesPerLab[i];
                return [
                  pct + '% of collected episodes have a failure description',
                  fmt(w) + ' with description — ' + fmt(ep) + ' episodes collected',
                ];
              },
            },
          },
        },
        scales: {
          x: xScale({ ticks: { maxRotation: 45, minRotation: 0, color: '#475569', font: { size: 11 } } }),
          y: Object.assign(yScale(), {
            max: 100,
            title: { display: true, text: '% of episodes', color: '#64748b', font: { size: 11 } },
            ticks: {
              color: '#64748b',
              font: { size: 11 },
              padding: 6,
              callback: function (v) { return v + '%'; },
            },
          }),
        },
      },
    });

    var failPieCtx = { failureContext: { total: failures } };
    var failPieLayout = {
      legend: false,
      maintainAspectRatio: false,
    };
    var failCatPieOpts = Object.assign({}, failPieCtx, failPieLayout);
    var sevSeries = severityThreePieSeries(data.severity_distribution || {});
    var sevPieOpts = Object.assign({}, failPieCtx, failPieLayout, {
      failureContext: { total: failures, sliceMismatchNote: false },
      tooltipAfterLabel: sevSeries.tooltipAfterLabel,
    });
    var fcFull = failureCategoryFullPieSeries(data.failure_categories, FAILURE_TAXONOMY_CATEGORIES);
    var fcSum = fcFull.values.reduce(function (a, b) { return a + (Number(b) || 0); }, 0);
    if (fcSum > 0) {
      pie('chart-failcat', fcFull.labels, fcFull.values, failCatPieOpts);
      renderFailurePieLegend('legend-failcat', fcFull.labels, fcFull.values);
    } else {
      destroy('chart-failcat');
      clearFailurePieLegend('legend-failcat');
    }

    var sevSum = sevSeries.values.reduce(function (a, b) { return a + (Number(b) || 0); }, 0);
    if (sevSum > 0) {
      pie('chart-severity', sevSeries.labels, sevSeries.values, sevPieOpts);
      renderFailurePieLegend('legend-severity', sevSeries.labels, sevSeries.values);
    } else {
      destroy('chart-severity');
      clearFailurePieLegend('legend-severity');
    }
  }

  /* Animated open/close. Custom <section><button> instead of native <details>
     so we can animate via grid-template-rows: 0fr -> 1fr. */
  function setupPanel(sectionEl) {
    var summary = sectionEl.querySelector(':scope > .stats-fold-summary');
    var bodyWrap = sectionEl.querySelector(':scope > .stats-fold-body-wrap');
    var key = sectionEl.getAttribute('data-key');
    var renderMap = {
      contribution: renderContribution,
      dataset: renderDataset,
      annotation: renderAnnotation,
    };
    var renderFn = renderMap[key];
    if (!summary || !bodyWrap || !renderFn) return;

    function setOpen(open) {
      sectionEl.setAttribute('data-open', open ? 'true' : 'false');
      summary.setAttribute('aria-expanded', open ? 'true' : 'false');
    }

    summary.addEventListener('click', function () {
      var isOpen = sectionEl.getAttribute('data-open') === 'true';
      var willOpen = !isOpen;

      if (willOpen) {
        if (statsData && !rendered[key]) {
          renderFn(statsData);
          rendered[key] = true;
        }
        setOpen(true);
        /* Render charts after the open transition so canvases get correct dims. */
        requestAnimationFrame(function () {
          requestAnimationFrame(function () { resizeChartsIn(sectionEl); });
        });
        var dur = 280;
        setTimeout(function () {
          resizeChartsIn(sectionEl);
          var seg = sectionEl.querySelector('.stats-seg');
          if (seg) updateSegIndicator(seg);
        }, dur);
      } else {
        setOpen(false);
      }
    });
  }

  function wireFolds() {
    document.querySelectorAll('.stats-fold').forEach(setupPanel);
  }

  fetch(STATS_URL)
    .then(function (r) {
      if (!r.ok) throw new Error('HTTP ' + r.status + ' loading stats.json');
      return r.json();
    })
    .then(function (data) {
      const totals = data.totals || {};
      if (!totals.episodes) {
        showError('No sweep data yet. Run <code>oopsie-tools-internal/sweep_dataset.py</code> and commit <code>docs/assets/data/stats.json</code>.');
        return;
      }
      statsData = data;
      if (skeletonEl) skeletonEl.style.display = 'none';
      dashEl.removeAttribute('hidden');
      requestAnimationFrame(function () { dashEl.classList.add('is-ready'); });
    })
    .catch(function (err) {
      showError('Could not load statistics: ' + (err && err.message ? err.message : String(err)));
    });

  wireFolds();
})();
</script>
